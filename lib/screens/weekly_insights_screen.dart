import 'package:flutter/material.dart';

import '../models/daily_log.dart';
import '../services/life_score_service.dart';
import '../services/mock_lifeos_service.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';
import '../widgets/trend_chart.dart';

class WeeklyInsightsScreen extends StatelessWidget {
  const WeeklyInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const demo = MockLifeOsService();
    const scoreService = LifeScoreService();

    final logs = demo.weeklyLogs();
    final summary = _WeeklyInsightsSummary.fromLogs(
      logs: logs,
      scoreService: scoreService,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Weekly insights',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Now tracking trend lines, not just one-day snapshots.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Life Score trend',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TrendChart(values: summary.scores, labels: summary.labels),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Metric(
                  label: 'Average Life Score',
                  value: '${summary.averageScore.round()}/100',
                ),
                const SizedBox(height: 16),
                _Metric(
                  label: 'Avg work hours',
                  value: '${summary.avgWork.toStringAsFixed(1)} h',
                ),
                const SizedBox(height: 16),
                _Metric(
                  label: 'Avg commute',
                  value: '${summary.avgCommute.round()} min',
                ),
                const SizedBox(height: 16),
                _Metric(
                  label: 'Avg hydration',
                  value: '${summary.avgHydration.toStringAsFixed(1)} L',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Truth',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'Stress and low hydration are hurting your score more than commute this week.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'Your best score happened on the day with 7.6 hours of sleep and 36 minutes of movement.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(label: 'Improve Next Week', onPressed: () {}),
        ],
      ),
    );
  }
}

class _WeeklyInsightsSummary {
  const _WeeklyInsightsSummary({
    required this.scores,
    required this.labels,
    required this.averageScore,
    required this.avgWork,
    required this.avgCommute,
    required this.avgHydration,
  });

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  final List<int> scores;
  final List<String> labels;
  final double averageScore;
  final double avgWork;
  final double avgCommute;
  final double avgHydration;

  factory _WeeklyInsightsSummary.fromLogs({
    required List<DailyLog> logs,
    required LifeScoreService scoreService,
  }) {
    var totalWork = 0.0;
    var totalCommute = 0;
    var totalHydration = 0.0;
    final scores = <int>[];
    final labels = <String>[];

    for (final log in logs) {
      scores.add(scoreService.calculate(log));
      labels.add(_weekdayLabels[log.weekday - 1]);
      totalWork += log.workHours;
      totalCommute += log.commuteMinutes;
      totalHydration += log.hydrationLiters;
    }

    final count = logs.length;
    return _WeeklyInsightsSummary(
      scores: scores,
      labels: labels,
      averageScore: scoreService.average(scores),
      avgWork: totalWork / count,
      avgCommute: totalCommute / count,
      avgHydration: totalHydration / count,
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
