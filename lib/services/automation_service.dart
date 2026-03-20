import 'dart:async';

import '../models/daily_log.dart';
import '../models/place.dart';
import '../models/user_profile.dart';
import 'daily_log_service.dart';
import 'life_score_service.dart';
import 'location_service.dart';
import 'notification_service.dart';
import 'suggestion_service.dart';

/// Orchestrates live automation:
/// - geofence events (home vs office)
/// - commute detection
/// - sleep detection fallback
/// - real-time score refresh
/// - smart notification queueing
class AutomationService {
  AutomationService({
    LocationService? locationService,
    DailyLogService? dailyLogService,
    LifeScoreService? lifeScoreService,
    SuggestionService? suggestionService,
    NotificationService? notificationService,
  })  : _locationService = locationService ?? const LocationService(),
        _dailyLogService = dailyLogService ?? DailyLogService(),
        _lifeScoreService = lifeScoreService ?? const LifeScoreService(),
        _suggestionService = suggestionService ?? const SuggestionService(),
        _notificationService = notificationService ?? NotificationService();

  final LocationService _locationService;
  final DailyLogService _dailyLogService;
  final LifeScoreService _lifeScoreService;
  final SuggestionService _suggestionService;
  final NotificationService _notificationService;

  StreamSubscription<LocationSnapshot>? _locationSubscription;
  GeofenceZone? _lastZone;

  Stream<DailyLog> watchDailyLog(String userId, {DailyLog? fallback}) {
    return _dailyLogService.watchTodayLog(userId, fallback: fallback);
  }

  Future<void> startTracking({
    required String userId,
    required UserProfile profile,
    required DailyLog fallback,
    required List<Place> nearbyPlaces,
  }) async {
    await _notificationService.initialize();
    _locationSubscription?.cancel();

    final permissionGranted = await _locationService.ensurePermission();
    if (!permissionGranted) {
      final enriched = _lifeScoreService.withScore(
        await _enrichSleepOnly(fallback),
      );
      await _dailyLogService.saveLog(userId, enriched);
      return;
    }

    await _dailyLogService.getOrCreateTodayLog(userId, fallback: fallback);

    _locationSubscription = _locationService.watchUserLocation(profile).listen(
      (snapshot) async {
        final current = await _dailyLogService.getOrCreateTodayLog(
          userId,
          fallback: fallback,
        );
        final updated = _applyLocationEvent(current, snapshot.zone);
        final scored = _lifeScoreService.withScore(await _enrichSleepOnly(updated));
        await _dailyLogService.saveLog(userId, scored);
        final suggestions = _suggestionService.generateSuggestions(
          log: scored,
          nearbyPlaces: nearbyPlaces,
        );
        await _notificationService.queueSmartNotifications(
          userId: userId,
          log: scored,
          suggestions: suggestions,
        );
        _lastZone = snapshot.zone;
      },
      onError: (_) async {
        final fallbackLog = _lifeScoreService.withScore(fallback);
        await _dailyLogService.saveLog(userId, fallbackLog);
      },
    );
  }

  Future<void> stopTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  DailyLog _applyLocationEvent(DailyLog log, GeofenceZone zone) {
    final now = DateTime.now();

    if (_lastZone != zone && zone == GeofenceZone.office) {
      return log.copyWith(
        workStartAt: log.workStartAt ?? now,
        commuteEndAt: now,
        automatedCommuteMinutes: log.commuteStartAt == null
            ? log.automatedCommuteMinutes
            : now.difference(log.commuteStartAt!).inMinutes,
      );
    }

    if (_lastZone != zone && zone == GeofenceZone.home) {
      return log.copyWith(
        workEndAt: now,
        automatedWorkHours: log.workStartAt == null
            ? log.automatedWorkHours
            : now.difference(log.workStartAt!).inMinutes / 60,
      );
    }

    if (zone == GeofenceZone.transit && _lastZone != GeofenceZone.transit) {
      return log.copyWith(commuteStartAt: log.commuteStartAt ?? now);
    }

    return log;
  }

  Future<DailyLog> _enrichSleepOnly(DailyLog log) async {
    // Placeholder for Google Fit / HealthKit inactivity detection.
    return log.copyWith(
      automatedSleepHours: log.automatedSleepHours ?? 7.2,
      sleepStartAt: log.sleepStartAt,
      sleepEndAt: log.sleepEndAt,
    );
  }
}
