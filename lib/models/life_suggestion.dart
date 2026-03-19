import 'place.dart';

enum SuggestionCategory { rest, hydration, movement, food, focus, nearby }

class LifeSuggestion {
  const LifeSuggestion({
    required this.title,
    required this.description,
    required this.cta,
    required this.category,
    required this.priority,
    this.place,
  });

  final String title;
  final String description;
  final String cta;
  final SuggestionCategory category;
  final int priority;
  final Place? place;
}
