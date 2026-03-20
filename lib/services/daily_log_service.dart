import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/daily_log.dart';

/// Firestore data access for daily logs.
/// Stored under: daily_logs/{userId}/entries/{yyyy-MM-dd}
class DailyLogService {
  DailyLogService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String userId, DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    return _firestore
        .collection('daily_logs')
        .doc(userId)
        .collection('entries')
        .doc(key);
  }

  Future<DailyLog> getOrCreateTodayLog(String userId, {DailyLog? fallback}) async {
    final today = DateTime.now();
    final doc = await _doc(userId, today).get();
    if (doc.exists && doc.data() != null) {
      return DailyLog.fromMap(today, doc.data()!);
    }

    final log = fallback ??
        DailyLog(
          date: today,
          mood: MoodLevel.neutral,
          workHours: 0,
          sleepHours: 0,
          commuteMinutes: 0,
          stressLevel: 5,
          hydrationLiters: 0,
          mealsCount: 0,
          exerciseMinutes: 0,
        );
    await saveLog(userId, log);
    return log;
  }

  Future<void> saveLog(String userId, DailyLog log) async {
    await _doc(userId, log.date).set(log.toMap(), SetOptions(merge: true));
  }

  Stream<DailyLog> watchTodayLog(String userId, {DailyLog? fallback}) {
    final today = DateTime.now();
    return _doc(userId, today).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return DailyLog.fromMap(today, snapshot.data()!);
      }
      return fallback ??
          DailyLog(
            date: today,
            mood: MoodLevel.neutral,
            workHours: 0,
            sleepHours: 0,
            commuteMinutes: 0,
            stressLevel: 5,
            hydrationLiters: 0,
            mealsCount: 0,
            exerciseMinutes: 0,
          );
    });
  }
}
