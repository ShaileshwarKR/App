import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum MoodLevel { happy, neutral, low }

class DailyLog {
  const DailyLog({
    required this.date,
    required this.mood,
    required this.workHours,
    required this.sleepHours,
    required this.commuteMinutes,
    required this.stressLevel,
    required this.hydrationLiters,
    required this.mealsCount,
    required this.exerciseMinutes,
    this.lifeScore,
    this.automatedWorkHours,
    this.automatedSleepHours,
    this.automatedCommuteMinutes,
    this.workStartAt,
    this.workEndAt,
    this.commuteStartAt,
    this.commuteEndAt,
    this.sleepStartAt,
    this.sleepEndAt,
  });

  final DateTime date;
  final MoodLevel mood;
  final double workHours;
  final double sleepHours;
  final int commuteMinutes;
  final int stressLevel;
  final double hydrationLiters;
  final int mealsCount;
  final int exerciseMinutes;
  final int? lifeScore;
  final double? automatedWorkHours;
  final double? automatedSleepHours;
  final int? automatedCommuteMinutes;
  final DateTime? workStartAt;
  final DateTime? workEndAt;
  final DateTime? commuteStartAt;
  final DateTime? commuteEndAt;
  final DateTime? sleepStartAt;
  final DateTime? sleepEndAt;

  String get moodLabel => switch (mood) {
        MoodLevel.happy => 'Happy',
        MoodLevel.neutral => 'Neutral',
        MoodLevel.low => 'Low',
      };

  IconData get moodIcon => switch (mood) {
        MoodLevel.happy => Icons.sentiment_very_satisfied_rounded,
        MoodLevel.neutral => Icons.sentiment_neutral_rounded,
        MoodLevel.low => Icons.sentiment_dissatisfied_rounded,
      };

  double get effectiveWorkHours => automatedWorkHours ?? workHours;
  double get effectiveSleepHours => automatedSleepHours ?? sleepHours;
  int get effectiveCommuteMinutes => automatedCommuteMinutes ?? commuteMinutes;

  bool get hasAutomatedWorkHours => automatedWorkHours != null;
  bool get hasAutomatedSleepHours => automatedSleepHours != null;
  bool get hasAutomatedCommute => automatedCommuteMinutes != null;

  Map<String, dynamic> toMap() {
    return {
      'date': _dateKey(date),
      'work_hours': effectiveWorkHours,
      'commute_time': effectiveCommuteMinutes,
      'sleep_hours': effectiveSleepHours,
      'mood': mood.name,
      'life_score': lifeScore,
      'stress_level': stressLevel,
      'hydration_liters': hydrationLiters,
      'meals_count': mealsCount,
      'exercise_minutes': exerciseMinutes,
      'timestamps': {
        'work_start': workStartAt == null ? null : Timestamp.fromDate(workStartAt!),
        'work_end': workEndAt == null ? null : Timestamp.fromDate(workEndAt!),
        'commute_start': commuteStartAt == null ? null : Timestamp.fromDate(commuteStartAt!),
        'commute_end': commuteEndAt == null ? null : Timestamp.fromDate(commuteEndAt!),
        'sleep_start': sleepStartAt == null ? null : Timestamp.fromDate(sleepStartAt!),
        'sleep_end': sleepEndAt == null ? null : Timestamp.fromDate(sleepEndAt!),
      },
    };
  }

  factory DailyLog.fromMap(DateTime date, Map<String, dynamic> map) {
    final timestamps = Map<String, dynamic>.from(map['timestamps'] as Map? ?? const {});
    return DailyLog(
      date: date,
      mood: MoodLevel.values.byName(map['mood'] as String? ?? 'neutral'),
      workHours: (map['work_hours'] as num?)?.toDouble() ?? 0,
      sleepHours: (map['sleep_hours'] as num?)?.toDouble() ?? 0,
      commuteMinutes: (map['commute_time'] as num?)?.toInt() ?? 0,
      stressLevel: (map['stress_level'] as num?)?.toInt() ?? 5,
      hydrationLiters: (map['hydration_liters'] as num?)?.toDouble() ?? 0,
      mealsCount: (map['meals_count'] as num?)?.toInt() ?? 0,
      exerciseMinutes: (map['exercise_minutes'] as num?)?.toInt() ?? 0,
      lifeScore: (map['life_score'] as num?)?.toInt(),
      workStartAt: _fromTimestamp(timestamps['work_start']),
      workEndAt: _fromTimestamp(timestamps['work_end']),
      commuteStartAt: _fromTimestamp(timestamps['commute_start']),
      commuteEndAt: _fromTimestamp(timestamps['commute_end']),
      sleepStartAt: _fromTimestamp(timestamps['sleep_start']),
      sleepEndAt: _fromTimestamp(timestamps['sleep_end']),
    );
  }

  DailyLog copyWith({
    DateTime? date,
    MoodLevel? mood,
    double? workHours,
    double? sleepHours,
    int? commuteMinutes,
    int? stressLevel,
    double? hydrationLiters,
    int? mealsCount,
    int? exerciseMinutes,
    int? lifeScore,
    double? automatedWorkHours,
    double? automatedSleepHours,
    int? automatedCommuteMinutes,
    DateTime? workStartAt,
    DateTime? workEndAt,
    DateTime? commuteStartAt,
    DateTime? commuteEndAt,
    DateTime? sleepStartAt,
    DateTime? sleepEndAt,
  }) {
    return DailyLog(
      date: date ?? this.date,
      mood: mood ?? this.mood,
      workHours: workHours ?? this.workHours,
      sleepHours: sleepHours ?? this.sleepHours,
      commuteMinutes: commuteMinutes ?? this.commuteMinutes,
      stressLevel: stressLevel ?? this.stressLevel,
      hydrationLiters: hydrationLiters ?? this.hydrationLiters,
      mealsCount: mealsCount ?? this.mealsCount,
      exerciseMinutes: exerciseMinutes ?? this.exerciseMinutes,
      lifeScore: lifeScore ?? this.lifeScore,
      automatedWorkHours: automatedWorkHours ?? this.automatedWorkHours,
      automatedSleepHours: automatedSleepHours ?? this.automatedSleepHours,
      automatedCommuteMinutes:
          automatedCommuteMinutes ?? this.automatedCommuteMinutes,
      workStartAt: workStartAt ?? this.workStartAt,
      workEndAt: workEndAt ?? this.workEndAt,
      commuteStartAt: commuteStartAt ?? this.commuteStartAt,
      commuteEndAt: commuteEndAt ?? this.commuteEndAt,
      sleepStartAt: sleepStartAt ?? this.sleepStartAt,
      sleepEndAt: sleepEndAt ?? this.sleepEndAt,
    );
  }

  static DateTime? _fromTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return null;
  }

  static String _dateKey(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }
}
