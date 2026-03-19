import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';
import '../services/maps_service.dart';
import '../theme.dart';
import '../widgets/lifeos_scaffold.dart';
import '../widgets/place_tile.dart';

class MapPlacesScreen extends StatefulWidget {
  const MapPlacesScreen({super.key});

  @override
  State<MapPlacesScreen> createState() => _MapPlacesScreenState();
}

class _MapPlacesScreenState extends State<MapPlacesScreen> {
  final mapsService = const MapsService();
  PlaceEnergy? selectedFilter;
  final Map<String, String> userTags = {};

  @override
  Widget build(BuildContext context) {
    final places = mapsService.nearbyPlaces(filter: selectedFilter);
    final markers = places
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
          const SizedBox(height: 8),
          Text(
            'Using your current area: Near Civic Center',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: selectedFilter == null,
                onSelected: (_) => setState(() => selectedFilter = null),
              ),
              ...PlaceEnergy.values.map(
                (energy) => ChoiceChip(
                  label: Text(energy.name),
                  selected: selectedFilter == energy,
                  onSelected: (_) => setState(() => selectedFilter = energy),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SizedBox(
              height: 220,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: places.first.position,
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
              itemCount: places.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final place = places[index];
                return Column(
                  children: [
                    PlaceTile(
                      place: place,
                      onTap: () {},
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(label: Text(place.tagLabel)),
                          if (userTags.containsKey(place.name))
                            Text(
                              userTags[place.name]!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        children: mapsService.availableUserTags().map((tag) {
                          return ActionChip(
                            label: Text(tag),
                            onPressed: () => setState(() => userTags[place.name] = tag),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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
