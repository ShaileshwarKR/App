import 'package:flutter/material.dart';

import '../models/life_suggestion.dart';
import '../services/life_score_service.dart';
import '../services/mock_lifeos_service.dart';
import '../services/notifications_service.dart';
import '../services/suggestions_service.dart';
import '../widgets/place_tile.dart';
import '../widgets/score_badge.dart';
import '../widgets/section_card.dart';
import '../widgets/suggestion_card.dart';
import 'map_places_screen.dart';
import 'suggestion_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const demo = MockLifeOsService();
    const scoreService = LifeScoreService();
    const suggestionsService = SuggestionsService();
    const notificationsService = NotificationsService();

    final log = demo.todayLog();
    final places = demo.nearbyPlaces();
    final score = scoreService.calculate(log);
    final status = scoreService.statusFor(score);
    final suggestions = suggestionsService.buildSuggestions(
      log: log,
      nearbyPlaces: places,
    );
    final nudges = notificationsService.buildNudges(log, suggestions);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Good Evening, ${demo.userName}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Your score now reflects stress, hydration, meals, and movement too.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          SectionCard(
            child: ScoreBadge(score: score, status: status),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today summary', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _SummaryRow(label: 'Work', value: '${log.workHours.toStringAsFixed(1)} h'),
                const Divider(height: 22),
                _SummaryRow(label: 'Sleep', value: '${log.sleepHours.toStringAsFixed(1)} h'),
                const Divider(height: 22),
                _SummaryRow(label: 'Commute', value: '${log.commuteMinutes} min'),
                const Divider(height: 22),
                _SummaryRow(label: 'Stress', value: '${log.stressLevel}/10'),
                const Divider(height: 22),
                _SummaryRow(label: 'Hydration', value: '${log.hydrationLiters.toStringAsFixed(1)} L'),
                const Divider(height: 22),
                _SummaryRow(label: 'Meals', value: '${log.mealsCount}'),
                const Divider(height: 22),
                _SummaryRow(label: 'Exercise', value: '${log.exerciseMinutes} min'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contextual nudge', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(
                  nudges.first,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'This copy can be sent through your Firebase notification setup.',
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
                    Text('Suggestions', style: Theme.of(context).textTheme.titleLarge),
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
                Text(
                  'Nearby now • ${places.first.area}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                ...suggestions.take(3).map(
                  (suggestion) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SuggestionCard(
                      suggestion: suggestion,
                      onTap: () => _openSuggestion(context, suggestion),
                    ),
                  ),
                ),
                PlaceTile(
                  place: places.first,
                  onTap: () => Navigator.pushNamed(
                    context,
                    SuggestionDetailScreen.routeName,
                    arguments: places.first,
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

  void _openSuggestion(BuildContext context, LifeSuggestion suggestion) {
    if (suggestion.place != null) {
      Navigator.pushNamed(
        context,
        SuggestionDetailScreen.routeName,
        arguments: suggestion.place,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(suggestion.cta)),
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
