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
    this.automatedWorkHours,
    this.automatedSleepHours,
    this.automatedCommuteMinutes,
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
  final double? automatedWorkHours;
  final double? automatedSleepHours;
  final int? automatedCommuteMinutes;

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
    double? automatedWorkHours,
    double? automatedSleepHours,
    int? automatedCommuteMinutes,
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
      automatedWorkHours: automatedWorkHours ?? this.automatedWorkHours,
      automatedSleepHours: automatedSleepHours ?? this.automatedSleepHours,
      automatedCommuteMinutes:
          automatedCommuteMinutes ?? this.automatedCommuteMinutes,
    );
  }
}
