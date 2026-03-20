import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/daily_log.dart';
import '../models/life_suggestion.dart';

/// Queues notification intents in Firestore for a backend/Cloud Function to fan out
/// through Firebase Cloud Messaging. Also requests device permission/token locally.
class NotificationService {
  NotificationService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  Future<void> initialize() async {
    await _messaging.requestPermission();
    await _messaging.getToken();
  }

  Future<void> queueSmartNotifications({
    required String userId,
    required DailyLog log,
    required List<LifeSuggestion> suggestions,
  }) async {
    final payloads = <Map<String, dynamic>>[];

    if (log.effectiveWorkHours >= 2 && log.workStartAt != null && log.workEndAt == null) {
      payloads.add(_payload(userId, 'Time for a break', 'You have been working for 2+ hours. Step away for a few minutes.'));
    }

    if (log.effectiveSleepHours < 6.5) {
      payloads.add(_payload(userId, 'Lighter day suggested', 'Low sleep was detected. Consider lowering the intensity today.'));
    }

    if (payloads.isEmpty && suggestions.isNotEmpty) {
      payloads.add(_payload(userId, suggestions.first.title, suggestions.first.description));
    }

    for (final payload in payloads) {
      await _firestore.collection('users').doc(userId).collection('notification_queue').add(payload);
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
