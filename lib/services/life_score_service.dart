import '../models/daily_log.dart';

/// Combines energy, stress, recovery, and wellbeing signals into
/// a simple 0-100 Life Score. Automated values take precedence when present.
class LifeScoreService {
  const LifeScoreService();

  int calculate(DailyLog log) {
    final sleepScore = _clamp((log.effectiveSleepHours / 8) * 22, 0, 22);
    final workScore = _clamp((10 - (log.effectiveWorkHours - 8).abs()) * 2.2, 0, 18);
    final commuteScore = _clamp(14 - (log.effectiveCommuteMinutes / 6), 0, 14);
    final stressScore = _clamp((11 - log.stressLevel) * 2, 0, 20);
    final hydrationScore = _clamp((log.hydrationLiters / 2.5) * 10, 0, 10);
    final mealsScore = _clamp((log.mealsCount / 3) * 8, 0, 8);
    final exerciseScore = _clamp((log.exerciseMinutes / 30) * 8, 0, 8);
    final moodScore = switch (log.mood) {
      MoodLevel.happy => 10.0,
      MoodLevel.neutral => 7.0,
      MoodLevel.low => 3.0,
    };

    return (sleepScore +
            workScore +
            commuteScore +
            stressScore +
            hydrationScore +
            mealsScore +
            exerciseScore +
            moodScore)
        .round();
  }

  String statusFor(int score) {
    if (score >= 75) return 'Balanced';
    if (score >= 50) return 'Slight imbalance';
    return 'High imbalance';
  }

  double average(Iterable<int> scores) {
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}
