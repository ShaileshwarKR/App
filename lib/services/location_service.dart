import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../models/location_point.dart';
import '../models/user_profile.dart';

enum GeofenceZone { home, office, transit, unknown }

class LocationSnapshot {
  const LocationSnapshot({
    required this.position,
    required this.zone,
  });

  final Position position;
  final GeofenceZone zone;
}

/// Wraps geolocator and translates raw GPS into app-friendly geofence events.
class LocationService {
  const LocationService();

  Future<bool> ensurePermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Stream<LocationSnapshot> watchUserLocation(UserProfile profile) async* {
    final granted = await ensurePermission();
    if (!granted) return;

    yield* Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 30,
      ),
    ).map((position) {
      return LocationSnapshot(
        position: position,
        zone: detectZone(
          latitude: position.latitude,
          longitude: position.longitude,
          profile: profile,
        ),
      );
    });
  }

  GeofenceZone detectZone({
    required double latitude,
    required double longitude,
    required UserProfile profile,
  }) {
    final home = profile.homeLocation;
    final office = profile.officeLocation;

    if (home != null && _isInside(latitude, longitude, home)) {
      return GeofenceZone.home;
    }
    if (office != null && _isInside(latitude, longitude, office)) {
      return GeofenceZone.office;
    }
    if (home != null && office != null) {
      return GeofenceZone.transit;
    }
    return GeofenceZone.unknown;
  }

  bool _isInside(double latitude, double longitude, LocationPoint center) {
    final distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      center.latitude,
      center.longitude,
    );
    return distance <= 120;
  }
}
