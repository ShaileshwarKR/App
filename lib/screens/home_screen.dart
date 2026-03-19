import 'package:flutter/material.dart';

import '../models/place.dart';
import '../theme.dart';
import '../widgets/place_tile.dart';
import '../widgets/score_badge.dart';
import '../widgets/section_card.dart';
import 'map_places_screen.dart';
import 'suggestion_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Good Evening, Maya',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Take a gentle read on today before it gets too loud.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const SectionCard(
            child: ScoreBadge(score: 62, status: 'Slight imbalance'),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today summary', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                const _SummaryRow(label: 'Work', value: '9.2 h'),
                const Divider(height: 22),
                const _SummaryRow(label: 'Sleep', value: '6.1 h'),
                const Divider(height: 22),
                const _SummaryRow(label: 'Commute', value: '55 min'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Insight', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(
                  'You are overworking today.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your work block is longer than your usual baseline, and sleep was lighter than normal.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Suggestions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const MapPlacesScreen(),
                        ),
                      ),
                      child: const Text('See nearby'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _SuggestionChip(
                  label: 'Take a 10 min walk',
                  onTap: () => Navigator.pushNamed(
                    context,
                    SuggestionDetailScreen.routeName,
                    arguments: suggestedPlaces.first,
                  ),
                ),
                const SizedBox(height: 10),
                _SuggestionChip(
                  label: 'Visit nearby park',
                  onTap: () => Navigator.pushNamed(
                    context,
                    SuggestionDetailScreen.routeName,
                    arguments: suggestedPlaces.first,
                  ),
                ),
                const SizedBox(height: 10),
                _SuggestionChip(
                  label: 'Stop work after 8 PM',
                  onTap: () {},
                ),
                const SizedBox(height: 18),
                PlaceTile(
                  place: suggestedPlaces.first,
                  onTap: () => Navigator.pushNamed(
                    context,
                    SuggestionDetailScreen.routeName,
                    arguments: suggestedPlaces.first,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LifeOsColors.primarySoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.self_improvement_rounded),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
