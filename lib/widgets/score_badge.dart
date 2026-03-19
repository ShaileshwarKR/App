import 'package:flutter/material.dart';

import '../theme.dart';

class ScoreBadge extends StatelessWidget {
  const ScoreBadge({
    super.key,
    required this.score,
    required this.status,
  });

  final int score;
  final String status;

  @override
  Widget build(BuildContext context) {
    final tone = score >= 75
        ? LifeOsColors.primary
        : score >= 50
            ? LifeOsColors.warning
            : LifeOsColors.danger;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [tone.withOpacity(0.18), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$score/100',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 42,
                  color: LifeOsColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: tone),
          ),
        ],
      ),
    );
  }
}
