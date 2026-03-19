import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../theme.dart';

enum PlaceEnergy { calm, energetic, relax }

class Place {
  const Place({
    required this.name,
    required this.tag,
    required this.distance,
    required this.time,
    required this.description,
    required this.area,
    required this.position,
  });

  final String name;
  final PlaceEnergy tag;
  final String distance;
  final String time;
  final String description;
  final String area;
  final LatLng position;

  String get tagLabel => switch (tag) {
        PlaceEnergy.calm => 'calm',
        PlaceEnergy.energetic => 'energetic',
        PlaceEnergy.relax => 'relax',
      };

  Color get tagColor => switch (tag) {
        PlaceEnergy.calm => LifeOsColors.primarySoft,
        PlaceEnergy.energetic => const Color(0xFFF8ECD0),
        PlaceEnergy.relax => const Color(0xFFF2D9DC),
      };
}

const suggestedPlaces = <Place>[
  Place(
    name: 'Greenway Park',
    tag: PlaceEnergy.calm,
    distance: '0.8 mi',
    time: '12 min',
    description: 'A quiet loop with trees, shade, and room to breathe.',
    area: 'Near Civic Center',
    position: LatLng(37.7749, -122.4194),
  ),
  Place(
    name: 'River Market',
    tag: PlaceEnergy.energetic,
    distance: '1.4 mi',
    time: '18 min',
    description: 'A lively spot for a short reset and quick snack.',
    area: 'Market Street',
    position: LatLng(37.7799, -122.4149),
  ),
  Place(
    name: 'Still Corner Library',
    tag: PlaceEnergy.relax,
    distance: '0.6 mi',
    time: '9 min',
    description: 'Soft seating, low noise, and a calm indoor pause.',
    area: 'Hayes Valley',
    position: LatLng(37.7712, -122.4230),
  ),
];
