import 'package:flutter/material.dart';

import '../models/daily_log.dart';
import '../models/habit_badge.dart';
import '../models/place.dart';

class MockLifeOsService {
  const MockLifeOsService();

  String get userName => 'Maya';

  DailyLog todayLog() {
    return DailyLog(
      date: DateTime.now(),
      mood: MoodLevel.neutral,
      workHours: 9.2,
      sleepHours: 6.1,
      commuteMinutes: 55,
      stressLevel: 8,
      hydrationLiters: 1.3,
      mealsCount: 2,
      exerciseMinutes: 12,
    );
  }

  List<DailyLog> weeklyLogs() {
    final now = DateTime.now();
    return [
      DailyLog(
        date: now.subtract(const Duration(days: 6)),
        mood: MoodLevel.happy,
        workHours: 8.0,
        sleepHours: 7.8,
        commuteMinutes: 40,
        stressLevel: 4,
        hydrationLiters: 2.4,
        mealsCount: 3,
        exerciseMinutes: 32,
      ),
      DailyLog(
        date: now.subtract(const Duration(days: 5)),
        mood: MoodLevel.neutral,
        workHours: 8.5,
        sleepHours: 7.1,
        commuteMinutes: 42,
        stressLevel: 5,
        hydrationLiters: 2.1,
        mealsCount: 3,
        exerciseMinutes: 20,
      ),
      DailyLog(
        date: now.subtract(const Duration(days: 4)),
        mood: MoodLevel.low,
        workHours: 9.4,
        sleepHours: 6.4,
        commuteMinutes: 50,
        stressLevel: 8,
        hydrationLiters: 1.4,
        mealsCount: 2,
        exerciseMinutes: 10,
      ),
      DailyLog(
        date: now.subtract(const Duration(days: 3)),
        mood: MoodLevel.neutral,
        workHours: 8.8,
        sleepHours: 6.9,
        commuteMinutes: 47,
        stressLevel: 6,
        hydrationLiters: 1.9,
        mealsCount: 3,
        exerciseMinutes: 22,
      ),
      DailyLog(
        date: now.subtract(const Duration(days: 2)),
        mood: MoodLevel.happy,
        workHours: 7.9,
        sleepHours: 7.6,
        commuteMinutes: 35,
        stressLevel: 3,
        hydrationLiters: 2.5,
        mealsCount: 3,
        exerciseMinutes: 36,
      ),
      DailyLog(
        date: now.subtract(const Duration(days: 1)),
        mood: MoodLevel.neutral,
        workHours: 8.7,
        sleepHours: 6.8,
        commuteMinutes: 44,
        stressLevel: 6,
        hydrationLiters: 1.7,
        mealsCount: 2,
        exerciseMinutes: 18,
      ),
      todayLog(),
    ];
  }

  List<HabitStreak> habitStreaks() {
    return const [
      HabitStreak(
        label: 'Hydration',
        currentStreak: 4,
        bestStreak: 9,
        icon: Icons.water_drop_rounded,
      ),
      HabitStreak(
        label: 'Sleep target',
        currentStreak: 3,
        bestStreak: 6,
        icon: Icons.nightlight_round,
      ),
      HabitStreak(
        label: 'Movement',
        currentStreak: 5,
        bestStreak: 12,
        icon: Icons.directions_walk_rounded,
      ),
    ];
  }

  List<HabitBadge> habitBadges() {
    return const [
      HabitBadge(
        title: 'Water Keeper',
        description: 'Hit your hydration target 5 days this week.',
        progress: 4,
        target: 5,
        icon: Icons.local_drink_rounded,
      ),
      HabitBadge(
        title: 'Mood Guardian',
        description: 'Log your mood every day this week.',
        progress: 7,
        target: 7,
        icon: Icons.favorite_rounded,
      ),
      HabitBadge(
        title: 'Move Daily',
        description: 'Do 20+ minutes of exercise on 4 days.',
        progress: 3,
        target: 4,
        icon: Icons.fitness_center_rounded,
      ),
    ];
  }

  List<Place> nearbyPlaces() => suggestedPlaces;
}
