import '../models/daily_log.dart';
import '../models/user_profile.dart';

/// Centralizes auto-detected data flows. Replace the mocked return values
/// with Google Maps Distance Matrix, Calendar APIs, Google Fit, or HealthKit.
class AutomationService {
  const AutomationService();

  Future<DailyLog> enrichLog({
    required DailyLog log,
    required UserProfile? profile,
  }) async {
    if (profile == null) return log;

    final commute = await detectCommuteMinutes(profile);
    final workHours = await detectWorkHours(profile);
    final sleepHours = await detectSleepHours();

    return log.copyWith(
      automatedCommuteMinutes: commute,
      automatedWorkHours: workHours,
      automatedSleepHours: sleepHours,
    );
  }

  Future<int?> detectCommuteMinutes(UserProfile profile) async {
    if (profile.isWfh) {
      return 0;
    }

    // TODO: Replace with Google Maps API / device location distance matrix.
    return 32;
  }

  Future<double?> detectWorkHours(UserProfile profile) async {
    // TODO: Replace with Google Calendar / Outlook / device activity integration.
    final startHour = (profile.workSchedule['start_hour'] as int?) ?? 9;
    final endHour = (profile.workSchedule['end_hour'] as int?) ?? 18;
    return (endHour - startHour).toDouble();
  }

  Future<double?> detectSleepHours() async {
    // TODO: Replace with Google Fit / HealthKit / platform sleep data.
    return 7.4;
  }
}
