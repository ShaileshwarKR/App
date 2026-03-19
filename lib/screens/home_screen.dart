import 'package:flutter/material.dart';

import '../models/daily_log.dart';
import '../models/life_suggestion.dart';
import '../models/place.dart';
import '../models/user_profile.dart';
import '../services/automation_service.dart';
import '../services/life_score_service.dart';
import '../services/mock_lifeos_service.dart';
import '../services/notifications_service.dart';
import '../services/profile_service.dart';
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
    return FutureBuilder<_HomeData>(
      future: _loadHomeData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Good Evening, ${data.profile?.name ?? data.userName}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Life Score now blends your manual entries with automated commute, work, and sleep signals.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SectionCard(
                child: ScoreBadge(score: data.score, status: data.status),
              ),
              const SizedBox(height: 18),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today summary', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    _SummaryRow(
                      label: 'Work',
                      value: '${data.log.effectiveWorkHours.toStringAsFixed(1)} h${data.log.hasAutomatedWorkHours ? ' • auto' : ''}',
                    ),
                    const Divider(height: 22),
                    _SummaryRow(
                      label: 'Sleep',
                      value: '${data.log.effectiveSleepHours.toStringAsFixed(1)} h${data.log.hasAutomatedSleepHours ? ' • auto' : ''}',
                    ),
                    const Divider(height: 22),
                    _SummaryRow(
                      label: 'Commute',
                      value: '${data.log.effectiveCommuteMinutes} min${data.log.hasAutomatedCommute ? ' • auto' : ''}',
                    ),
                    const Divider(height: 22),
                    _SummaryRow(label: 'Stress', value: '${data.log.stressLevel}/10'),
                    const Divider(height: 22),
                    _SummaryRow(label: 'Hydration', value: '${data.log.hydrationLiters.toStringAsFixed(1)} L'),
                    const Divider(height: 22),
                    _SummaryRow(label: 'Meals', value: '${data.log.mealsCount}'),
                    const Divider(height: 22),
                    _SummaryRow(label: 'Exercise', value: '${data.log.exerciseMinutes} min'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (data.profile != null)
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Automation', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text(
                        data.profile!.isWfh
                            ? 'WFH is enabled, so commute is skipped automatically.'
                            : 'Commute uses saved home and company addresses.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Calendar and health integrations can replace manual work/sleep values when connected.',
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
                    Text('Contextual nudge', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Text(
                      data.nudges.first,
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
                      'Nearby now • ${data.places.first.area}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    ...data.suggestions.take(3).map(
                      (suggestion) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SuggestionCard(
                          suggestion: suggestion,
                          onTap: () => _openSuggestion(context, suggestion),
                        ),
                      ),
                    ),
                    PlaceTile(
                      place: data.places.first,
                      onTap: () => Navigator.pushNamed(
                        context,
                        SuggestionDetailScreen.routeName,
                        arguments: data.places.first,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
        );
      },
    );
  }

  Future<_HomeData> _loadHomeData() async {
    const demo = MockLifeOsService();
    const scoreService = LifeScoreService();
    const suggestionsService = SuggestionsService();
    const notificationsService = NotificationsService();
    const automationService = AutomationService();
    final profileService = ProfileService();

    final profile = await profileService.getCachedProfile();
    final baseLog = demo.todayLog();
    final enrichedLog = await automationService.enrichLog(
      log: baseLog,
      profile: profile,
    );
    final places = demo.nearbyPlaces();
    final suggestions = suggestionsService.buildSuggestions(
      log: enrichedLog,
      nearbyPlaces: places,
    );
    final nudges = notificationsService.buildNudges(enrichedLog, suggestions);
    final score = scoreService.calculate(enrichedLog);

    return _HomeData(
      userName: demo.userName,
      profile: profile,
      log: enrichedLog,
      places: places,
      suggestions: suggestions,
      nudges: nudges,
      score: score,
      status: scoreService.statusFor(score),
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

class _HomeData {
  const _HomeData({
    required this.userName,
    required this.profile,
    required this.log,
    required this.places,
    required this.suggestions,
    required this.nudges,
    required this.score,
    required this.status,
  });

  final String userName;
  final UserProfile? profile;
  final DailyLog log;
  final List<Place> places;
  final List<LifeSuggestion> suggestions;
  final List<String> nudges;
  final int score;
  final String status;
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
