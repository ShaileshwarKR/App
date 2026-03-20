import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

import '../models/daily_log.dart';

/// Firestore data access for daily logs.
/// Stored under: daily_logs/{userId}/entries/{yyyy-MM-dd}
class DailyLogService {
  DailyLogService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? _defaultFirestore;

  static FirebaseFirestore? get _defaultFirestore =>
      Firebase.apps.isEmpty ? null : FirebaseFirestore.instance;

  final FirebaseFirestore? _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String userId, DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    return _firestore!
        .collection('daily_logs')
        .doc(userId)
        .collection('entries')
        .doc(key);
  }

  Future<DailyLog> getOrCreateTodayLog(String userId, {DailyLog? fallback}) async {
    final today = DateTime.now();
    final docRef = _safeDoc(userId, today);
    if (docRef == null) return fallback ?? _emptyLog(today);

    try {
      final doc = await docRef.get();
      if (doc.exists && doc.data() != null) {
        return DailyLog.fromMap(today, doc.data()!);
      }
    } catch (_) {
      return fallback ?? _emptyLog(today);
    }

    final log = fallback ?? _emptyLog(today);
    await saveLog(userId, log);
    return log;
  }

  Future<void> saveLog(String userId, DailyLog log) async {
    final docRef = _safeDoc(userId, log.date);
    if (docRef == null) return;
    try {
      await docRef.set(log.toMap(), SetOptions(merge: true));
    } catch (_) {
      // Ignore remote persistence failures in offline/demo mode.
    }
  }

  Stream<DailyLog> watchTodayLog(String userId, {DailyLog? fallback}) {
    final today = DateTime.now();
    final docRef = _safeDoc(userId, today);
    if (docRef == null) return Stream.value(fallback ?? _emptyLog(today));

    return docRef.snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return DailyLog.fromMap(today, snapshot.data()!);
      }
      return fallback ?? _emptyLog(today);
    }).handleError((_) => fallback ?? _emptyLog(today));
  }

  DocumentReference<Map<String, dynamic>>? _safeDoc(String userId, DateTime date) {
    final firestore = _firestore;
    if (firestore == null) return null;
    return _doc(userId, date);
  }

  DailyLog _emptyLog(DateTime date) {
    return DailyLog(
      date: date,
      mood: MoodLevel.neutral,
      workHours: 0,
      sleepHours: 0,
      commuteMinutes: 0,
      stressLevel: 5,
      hydrationLiters: 0,
      mealsCount: 0,
      exerciseMinutes: 0,
    );
  }
}
