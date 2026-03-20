import '../models/place.dart';

/// Placeholder map service. In production this can be backed by
/// Google Places / Firestore user tags / location permissions.
class MapsService {
  const MapsService();

  List<Place> nearbyPlaces({PlaceEnergy? filter}) {
    if (filter == null) return suggestedPlaces;
    return suggestedPlaces.where((place) => place.tag == filter).toList();
  }

  List<String> availableUserTags() {
    return const ['Favorite', 'Visited', 'Need this week'];
  }
}
