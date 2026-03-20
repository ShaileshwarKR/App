import 'package:flutter/material.dart';

import '../models/habit_badge.dart';
import '../theme.dart';

class HabitStreakCard extends StatelessWidget {
  const HabitStreakCard({
    super.key,
    required this.streak,
  });

  final HabitStreak streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LifeOsColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: LifeOsColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(streak.icon, color: LifeOsColors.primary),
          ),
          const SizedBox(height: 16),
          Text(streak.label, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text('${streak.currentStreak} day streak'),
          const SizedBox(height: 4),
          Text(
            'Best: ${streak.bestStreak} days',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
