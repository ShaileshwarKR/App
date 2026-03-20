import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/daily_log.dart';
import '../models/life_suggestion.dart';

/// Queues notification intents in Firestore for a backend/Cloud Function to fan out
/// through Firebase Cloud Messaging. Also requests device permission/token locally.
class NotificationService {
  NotificationService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? _defaultMessaging,
        _firestore = firestore ?? _defaultFirestore;

  static FirebaseMessaging? get _defaultMessaging =>
      Firebase.apps.isEmpty ? null : FirebaseMessaging.instance;
  static FirebaseFirestore? get _defaultFirestore =>
      Firebase.apps.isEmpty ? null : FirebaseFirestore.instance;

  final FirebaseMessaging? _messaging;
  final FirebaseFirestore? _firestore;

  Future<void> initialize() async {
    final messaging = _messaging;
    if (messaging == null) return;
    try {
      await messaging.requestPermission();
      await messaging.getToken();
    } catch (_) {
      // Notifications stay disabled when Firebase Messaging is unavailable.
    }
  }

  Future<void> queueSmartNotifications({
    required String userId,
    required DailyLog log,
    required List<LifeSuggestion> suggestions,
  }) async {
    final firestore = _firestore;
    if (firestore == null) return;

    final payloads = <Map<String, dynamic>>[];

    if (log.effectiveWorkHours >= 2 && log.workStartAt != null && log.workEndAt == null) {
      payloads.add(
        _payload(
          userId,
          'Time for a break',
          'You have been working for 2+ hours. Step away for a few minutes.',
        ),
      );
    }

    if (log.effectiveSleepHours < 6.5) {
      payloads.add(
        _payload(
          userId,
          'Lighter day suggested',
          'Low sleep was detected. Consider lowering the intensity today.',
        ),
      );
    }

    if (payloads.isEmpty && suggestions.isNotEmpty) {
      payloads.add(_payload(userId, suggestions.first.title, suggestions.first.description));
    }

    for (final payload in payloads) {
      try {
        await firestore
            .collection('users')
            .doc(userId)
            .collection('notification_queue')
            .add(payload);
      } catch (_) {
        // Skip remote queueing when Firestore is unavailable.
      }
    }
  }

  Map<String, dynamic> _payload(String userId, String title, String body) {
    return {
      'user_id': userId,
      'title': title,
      'body': body,
      'created_at': FieldValue.serverTimestamp(),
    };
  }
}
