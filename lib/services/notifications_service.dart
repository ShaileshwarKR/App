import '../models/daily_log.dart';
import '../models/life_suggestion.dart';

/// Returns contextual notification copy. Hook these strings into
/// Firebase Messaging / local notifications in the real app.
class NotificationsService {
  const NotificationsService();

  List<String> buildNudges(DailyLog log, List<LifeSuggestion> suggestions) {
    final nudges = <String>[];

    if (log.hydrationLiters < 1.8) {
      nudges.add('Hydration check: pause for a glass of water.');
    }
    if (log.exerciseMinutes < 20) {
      nudges.add('Your body may need a quick stretch or walk.');
    }
    if (log.mood == MoodLevel.low) {
      nudges.add('You seem low today. Try one small kind action for yourself.');
    }
    if (log.stressLevel >= 7) {
      nudges.add('Stress is elevated. A 10 minute reset may help right now.');
    }

    if (nudges.isEmpty && suggestions.isNotEmpty) {
      nudges.add(suggestions.first.description);
    }

    return nudges;
  }
}
