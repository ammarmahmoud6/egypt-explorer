/// Data model classes for the Egypt Explorer app.
///
/// This file contains ONLY class definitions (shape, no data values).
/// All real data — place names, coordinates, capacities, city profiles,
/// earthquake event definitions — is served by the Python Flask backend
/// (`backend/data.py`) and fetched at runtime via `backend_service.dart`
/// from `/api/places`, `/api/cities`, and `/api/earthquake-events`.
library;

/// A tourist place in Egypt.
class TouristPlace {
  final String name;
  final double lat;
  final double lon;
  final int capacity;
  final int crowd; // live/simulated crowd count
  final List<String> imagePaths; // asset paths (may be empty → placeholder)
  final String? description;

  const TouristPlace({
    required this.name,
    required this.lat,
    required this.lon,
    required this.capacity,
    required this.crowd,
    required this.imagePaths,
    this.description,
  });

  /// Crowd ratio (0.0 - 1.0+) used for color coding.
  double get crowdRatio => capacity == 0 ? 0 : crowd / capacity;

  /// Returns a copy of this place with the given fields replaced.
  TouristPlace copyWith({int? crowd}) {
    return TouristPlace(
      name: name,
      lat: lat,
      lon: lon,
      capacity: capacity,
      crowd: crowd ?? this.crowd,
      imagePaths: imagePaths,
      description: description,
    );
  }
}

/// A city in Egypt.
class City {
  final String name;
  final double lon;
  final double lat;
  final String? profile; // long-form description text

  const City({
    required this.name,
    required this.lon,
    required this.lat,
    this.profile,
  });
}

/// An earthquake event.
class EarthquakeEvent {
  final String id; // 'cairo' or 'suez'
  final String label; // 'Cairo 1992' / 'Suez 2026'
  final double magnitude;
  final double epicenterLon;
  final double epicenterLat;
  final String story; // long descriptive text
  final String
  shortTag; // e.g. "I was near the surface so I killed many civilians"

  const EarthquakeEvent({
    required this.id,
    required this.label,
    required this.magnitude,
    required this.epicenterLon,
    required this.epicenterLat,
    required this.story,
    required this.shortTag,
  });
}

/// Lookup helper: find a city by name in an arbitrary list.
City? cityByName(List<City> cities, String name) {
  for (final city in cities) {
    if (city.name == name) return city;
  }
  return null;
}

/// Lookup helper: find a tourist place by name in an arbitrary list.
TouristPlace? touristPlaceByName(List<TouristPlace> places, String name) {
  for (final place in places) {
    if (place.name == name) return place;
  }
  return null;
}
