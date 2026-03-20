import 'package:flutter/material.dart';

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
    final scores = logs.map(scoreService.calculate).toList();
    final averageScore = scoreService.average(scores);
    final avgWork = logs.map((log) => log.workHours).reduce((a, b) => a + b) / logs.length;
    final avgCommute = logs.map((log) => log.commuteMinutes).reduce((a, b) => a + b) / logs.length;
    final avgHydration = logs.map((log) => log.hydrationLiters).reduce((a, b) => a + b) / logs.length;
    final labels = logs
        .map((log) => ['M', 'T', 'W', 'T', 'F', 'S', 'S'][log.weekday - 1])
        .toList();

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
                Text('Life Score trend', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TrendChart(values: scores, labels: labels),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Metric(label: 'Average Life Score', value: '${averageScore.round()}/100'),
                const SizedBox(height: 16),
                _Metric(label: 'Avg work hours', value: '${avgWork.toStringAsFixed(1)} h'),
                const SizedBox(height: 16),
                _Metric(label: 'Avg commute', value: '${avgCommute.round()} min'),
                const SizedBox(height: 16),
                _Metric(label: 'Avg hydration', value: '${avgHydration.toStringAsFixed(1)} L'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Truth', style: Theme.of(context).textTheme.titleLarge),
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
