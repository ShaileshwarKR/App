import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';
import '../theme.dart';
import '../widgets/lifeos_scaffold.dart';
import '../widgets/place_tile.dart';

class MapPlacesScreen extends StatelessWidget {
  const MapPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final markers = suggestedPlaces
        .map(
          (place) => Marker(
            markerId: MarkerId(place.name),
            position: place.position,
            infoWindow: InfoWindow(title: place.name, snippet: place.tagLabel),
          ),
        )
        .toSet();

    return LifeOsScaffold(
      appBar: AppBar(title: const Text('Nearby places')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a place that matches what you need right now.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SizedBox(
              height: 220,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: suggestedPlaces.first.position,
                  zoom: 13.2,
                ),
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                markers: markers,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Places', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: suggestedPlaces.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final place = suggestedPlaces[index];
                return PlaceTile(
                  place: place,
                  onTap: () {},
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tip: add your Google Maps API key on Android to enable the live map tiles.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LifeOsColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
