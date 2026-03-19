import 'package:flutter/material.dart';

import '../theme.dart';

class MoodOption {
  const MoodOption(this.label, this.icon);

  final String label;
  final IconData icon;
}

class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const moods = <MoodOption>[
    MoodOption('Happy', Icons.sentiment_very_satisfied_rounded),
    MoodOption('Neutral', Icons.sentiment_neutral_rounded),
    MoodOption('Low', Icons.sentiment_dissatisfied_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(moods.length, (index) {
        final mood = moods[index];
        final selected = index == selectedIndex;

        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(right: index == moods.length - 1 ? 0 : 10),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: selected ? LifeOsColors.primarySoft : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected ? LifeOsColors.primary : LifeOsColors.border,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    mood.icon,
                    color: selected
                        ? LifeOsColors.primary
                        : LifeOsColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(mood.label),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
