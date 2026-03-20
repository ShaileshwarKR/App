import 'dart:async';

import 'package:flutter/material.dart';

import '../models/daily_log.dart';
import '../models/life_suggestion.dart';
import '../models/place.dart';
import '../models/user_profile.dart';
import '../services/automation_service.dart';
import '../services/life_score_service.dart';
import '../services/mock_lifeos_service.dart';
import '../services/profile_service.dart';
import '../services/suggestion_service.dart';
import '../widgets/place_tile.dart';
import '../widgets/score_badge.dart';
import '../widgets/section_card.dart';
import '../widgets/suggestion_card.dart';
import 'map_places_screen.dart';
import 'suggestion_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final demo = const MockLifeOsService();
  final profileService = ProfileService();
  final automationService = AutomationService();
  final lifeScoreService = const LifeScoreService();
  final suggestionService = const SuggestionService();

  UserProfile? profile;
  late final String userId;
  late final DailyLog fallbackLog;
  late final Stream<DailyLog> dailyLogStream;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userId = profileService.currentUserId;
    fallbackLog = lifeScoreService.withScore(demo.todayLog());
    dailyLogStream = automationService.watchDailyLog(userId, fallback: fallbackLog);
    _bootstrapAutomation();
  }

  Future<void> _bootstrapAutomation() async {
    final loadedProfile = await profileService.loadProfile(userId);
    if (loadedProfile != null) {
      await automationService.startTracking(
        userId: userId,
        profile: loadedProfile,
        fallback: fallbackLog,
        nearbyPlaces: demo.nearbyPlaces(),
      );
    }

    if (mounted) {
      setState(() {
        profile = loadedProfile;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    unawaited(automationService.stopTracking());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<DailyLog>(
      stream: dailyLogStream,
      initialData: fallbackLog,
      builder: (context, snapshot) {
        final log = snapshot.data ?? fallbackLog;
        final score = log.lifeScore ?? lifeScoreService.calculate(log);
        final status = lifeScoreService.statusFor(score);
        final places = demo.nearbyPlaces();
        final suggestions = suggestionService.generateSuggestions(
          log: log,
          nearbyPlaces: places,
        );

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Good Evening, ${profile?.name ?? demo.userName}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                profile == null
                    ? 'Automation is unavailable right now, so manual values remain active.'
                    : 'Live automation is tracking location, work boundaries, commute, and sleep signals.',
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
                    _SummaryRow(
                      label: 'Work',
                      value: '${log.effectiveWorkHours.toStringAsFixed(1)} h${log.hasAutomatedWorkHours ? ' • auto' : ' • manual'}',
                    ),
                    const Divider(height: 22),
                    _SummaryRow(
                      label: 'Sleep',
                      value: '${log.effectiveSleepHours.toStringAsFixed(1)} h${log.hasAutomatedSleepHours ? ' • auto' : ' • manual'}',
                    ),
                    const Divider(height: 22),
                    _SummaryRow(
                      label: 'Commute',
                      value: '${log.effectiveCommuteMinutes} min${log.hasAutomatedCommute ? ' • auto' : ' • manual'}',
                    ),
                    const Divider(height: 22),
                    _SummaryRow(label: 'Activity', value: '${log.exerciseMinutes} min'),
                    const Divider(height: 22),
                    _SummaryRow(label: 'Life Score', value: '$score/100'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (profile != null)
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Automation engine', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text(
                        profile!.isWfh
                            ? 'WFH is enabled, so office commute is skipped automatically.'
                            : 'Home vs office geofences are used to infer work start/end and commute.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'If location or health permissions fail, the app falls back to manual values without crashing.',
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
      },
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
