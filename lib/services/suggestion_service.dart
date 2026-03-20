import '../models/daily_log.dart';
import '../models/life_suggestion.dart';
import '../models/place.dart';

/// Suggestion engine driven by long work hours, low sleep, and commute burden.
class SuggestionService {
  const SuggestionService();

  List<LifeSuggestion> generateSuggestions({
    required DailyLog log,
    required List<Place> nearbyPlaces,
  }) {
    final suggestions = <LifeSuggestion>[];

    if (log.effectiveWorkHours >= 10) {
      suggestions.add(
        const LifeSuggestion(
          title: 'Take a work break',
          description: 'You have been in work mode for a long stretch.',
          cta: 'Step away for 10 minutes',
          category: SuggestionCategory.focus,
          priority: 10,
        ),
      );
    }

    if (log.effectiveSleepHours < 6.5) {
      suggestions.add(
        LifeSuggestion(
          title: 'Low sleep detected',
          description: 'Your recovery looks light. Aim for a softer day if possible.',
          cta: 'Choose a calmer nearby reset',
          category: SuggestionCategory.rest,
          priority: 9,
          place: nearbyPlaces.firstWhere(
            (place) => place.tag == PlaceEnergy.calm,
            orElse: () => nearbyPlaces.first,
          ),
        ),
      );
    }

    if (log.effectiveCommuteMinutes >= 45) {
      suggestions.add(
        LifeSuggestion(
          title: 'Long commute strain',
          description: 'Transit time is pulling down today\'s energy.',
          cta: 'Relax before your next task',
          category: SuggestionCategory.nearby,
          priority: 8,
          place: nearbyPlaces.firstWhere(
            (place) => place.tag == PlaceEnergy.quiet,
            orElse: () => nearbyPlaces.first,
          ),
        ),
      );
    }

    if (suggestions.isEmpty) {
      suggestions.add(
        LifeSuggestion(
          title: 'You are in a steady rhythm',
          description: 'A short walk or quiet break can help you hold the balance.',
          cta: 'Visit ${nearbyPlaces.first.name}',
          category: SuggestionCategory.nearby,
          priority: 5,
          place: nearbyPlaces.first,
        ),
      );
    }

    suggestions.sort((a, b) => b.priority.compareTo(a.priority));
    return suggestions;
  }
}
