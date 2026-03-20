import '../models/daily_log.dart';

/// Real-time weighted Life Score engine.
/// sleep (30%), work (30%), commute (20%), activity (20%)
class LifeScoreService {
  const LifeScoreService();

  DailyLog withScore(DailyLog log) {
    return log.copyWith(lifeScore: calculate(log));
  }

  int calculate(DailyLog log) {
    final sleepScore = _normalized(log.effectiveSleepHours, ideal: 8, max: 10) * 30;
    final workScore = _workBalance(log.effectiveWorkHours) * 30;
    final commuteScore = _inverse(log.effectiveCommuteMinutes.toDouble(), ideal: 20, worst: 120) * 20;
    final activityScore = _normalized(log.exerciseMinutes.toDouble(), ideal: 30, max: 60) * 20;
    return (sleepScore + workScore + commuteScore + activityScore).round();
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

  double _normalized(double value, {required double ideal, required double max}) {
    if (value <= 0) return 0;
    return (value / ideal).clamp(0, 1.0);
  }

  double _inverse(double value, {required double ideal, required double worst}) {
    if (value <= ideal) return 1;
    final normalized = 1 - ((value - ideal) / (worst - ideal));
    return normalized.clamp(0, 1.0);
  }

  double _workBalance(double hours) {
    final delta = (hours - 8).abs();
    final score = 1 - (delta / 4);
    return score.clamp(0, 1.0);
  }
}
