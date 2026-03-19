import 'package:flutter/material.dart';

class HabitStreak {
  const HabitStreak({
    required this.label,
    required this.currentStreak,
    required this.bestStreak,
    required this.icon,
  });

  final String label;
  final int currentStreak;
  final int bestStreak;
  final IconData icon;
}

class HabitBadge {
  const HabitBadge({
    required this.title,
    required this.description,
    required this.progress,
    required this.target,
    required this.icon,
  });

  final String title;
  final String description;
  final int progress;
  final int target;
  final IconData icon;

  double get completion => target == 0 ? 0 : progress / target;
}
