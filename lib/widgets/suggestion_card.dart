import 'package:flutter/material.dart';

import '../models/life_suggestion.dart';
import '../theme.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.onTap,
  });

  final LifeSuggestion suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: LifeOsColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: LifeOsColors.primarySoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(suggestion.category.name),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              suggestion.title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 6),
            Text(
              suggestion.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            Text(
              suggestion.cta,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: LifeOsColors.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
