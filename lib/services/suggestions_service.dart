import '../models/daily_log.dart';
import '../models/life_suggestion.dart';
import '../models/place.dart';

/// Builds a lightweight, explainable suggestion list from daily inputs.
/// Suggestions use automated commute/work/sleep values whenever available.
class SuggestionsService {
  const SuggestionsService();

  List<LifeSuggestion> buildSuggestions({
    required DailyLog log,
    required List<Place> nearbyPlaces,
  }) {
    final suggestions = <LifeSuggestion>[];

    if (log.stressLevel >= 7 || log.effectiveSleepHours < 6.5) {
      suggestions.add(
        LifeSuggestion(
          title: 'You seem tense',
          description: 'A quiet reset could lower today\'s stress before it builds.',
          cta: 'Take a 10 min walk',
          category: SuggestionCategory.rest,
          priority: 10,
          place: nearbyPlaces.firstWhere(
            (place) => place.tag == PlaceEnergy.calm,
            orElse: () => nearbyPlaces.first,
          ),
        ),
      );
    }

    if (log.hydrationLiters < 1.8) {
      suggestions.add(
        const LifeSuggestion(
          title: 'Hydrate before your next task',
          description: 'A quick water break may help your focus and energy.',
          cta: 'Drink 300 ml now',
          category: SuggestionCategory.hydration,
          priority: 9,
        ),
      );
    }

    if (log.exerciseMinutes < 20) {
      suggestions.add(
        LifeSuggestion(
          title: 'Move a little today',
          description: 'Even 10 minutes can improve energy and mood.',
          cta: 'Try a short stretch or walk',
          category: SuggestionCategory.movement,
          priority: 8,
          place: nearbyPlaces.firstWhere(
            (place) => place.tag != PlaceEnergy.quiet,
            orElse: () => nearbyPlaces.first,
          ),
        ),
      );
    }

    if (log.mealsCount < 3) {
      suggestions.add(
        const LifeSuggestion(
          title: 'Refuel soon',
          description: 'A proper meal can soften stress and stop the energy dip.',
          cta: 'Make time for food',
          category: SuggestionCategory.food,
          priority: 7,
        ),
      );
    }

    if (log.effectiveWorkHours >= 9) {
      suggestions.add(
        const LifeSuggestion(
          title: 'Protect your evening',
          description: 'Long work blocks are pulling your score down today.',
          cta: 'Stop work after 8 PM',
          category: SuggestionCategory.focus,
          priority: 8,
        ),
      );
    }

    if (suggestions.isEmpty) {
      suggestions.add(
        LifeSuggestion(
          title: 'Keep the rhythm going',
          description: 'You\'re in a good place today. A calm reset helps you stay there.',
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
