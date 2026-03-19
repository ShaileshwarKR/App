import 'package:flutter/material.dart';

import '../services/mock_lifeos_service.dart';
import '../widgets/habit_streak_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const demo = MockLifeOsService();
    final streaks = demo.habitStreaks();
    final badges = demo.habitBadges();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Habits & streaks',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Gentle motivation, not guilt. Keep small wins visible.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: streaks.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (_, index) => HabitStreakCard(streak: streaks[index]),
          ),
          const SizedBox(height: 18),
          Text('Badges in progress', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...badges.map(
            (badge) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(badge.icon),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            badge.title,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Text('${badge.progress}/${badge.target}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(badge.description),
                    const SizedBox(height: 14),
                    LinearProgressIndicator(
                      value: badge.completion.clamp(0, 1),
                      minHeight: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          PrimaryButton(label: 'Log a habit win', onPressed: () {}),
        ],
      ),
    );
  }
}
