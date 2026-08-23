/// HTTP client for the Python Flask backend.
///
/// The earthquake math and crowd simulation run in Python
/// (`backend/earthquake_logic.py`, `backend/simulation.py`) — this service
/// calls them over REST instead of using any Dart-side port.
///
/// The base URL is read from a compile-time constant so it is never hardcoded:
///
/// ```
/// flutter run --dart-define=BACKEND_URL=https://your-app.onrender.com
/// flutter build web --dart-define=BACKEND_URL=https://your-app.onrender.com
/// ```
///
/// Defaults to `http://localhost:5000` for local development (run the Flask
/// app with `python app.py` inside `backend/`).
library;

import 'dart:convert';

import 'package:final_project/data/egypt_data.dart';
import 'package:final_project/data/place_images.dart';
import 'package:http/http.dart' as http;

const String _kDefaultBaseUrl = 'http://localhost:5000';

String get backendBaseUrl =>
    const String.fromEnvironment('BACKEND_URL', defaultValue: _kDefaultBaseUrl);

/// A lon/lat point returned by `/api/map-coordinates`.
class GeoPoint {
  final double lon;
  final double lat;

  const GeoPoint({required this.lon, required this.lat});

  factory GeoPoint.fromJson(List<dynamic> pair) => GeoPoint(
    lon: (pair[0] as num).toDouble(),
    lat: (pair[1] as num).toDouble(),
  );
}

/// Map geometry fetched from `/api/map-coordinates`
/// (originally lifted from `draw_map()` in `Egypt_manually_drawn.py`).
class MapCoordinates {
  final List<GeoPoint> egyptOutline;
  final List<GeoPoint> nileMain;
  final List<GeoPoint> nileRosetta;
  final List<GeoPoint> nileDamietta;
  final List<GeoPoint> lakeNasser;
  final List<String> importantCities;

  const MapCoordinates({
    required this.egyptOutline,
    required this.nileMain,
    required this.nileRosetta,
    required this.nileDamietta,
    required this.lakeNasser,
    required this.importantCities,
  });

  static MapCoordinates fromJson(Map<String, dynamic> json) => MapCoordinates(
    egyptOutline: _points(json['egypt_outline']),
    nileMain: _points(json['nile_main']),
    nileRosetta: _points(json['nile_rosetta']),
    nileDamietta: _points(json['nile_damietta']),
    lakeNasser: _points(json['lake_nasser']),
    importantCities: (json['important_cities'] as List).cast<String>().toList(),
  );

  static List<GeoPoint> _points(dynamic list) => [
    for (final pair in list as List) GeoPoint.fromJson(pair as List<dynamic>),
  ];
}

/// Result of `/api/earthquake` (Python `one_call()`).
class EarthquakeAnalysis {
  final double magnitude;
  final double distance;
  final double? timeGap;
  final double? attenuation;

  const EarthquakeAnalysis({
    required this.magnitude,
    required this.distance,
    required this.timeGap,
    required this.attenuation,
  });

  static EarthquakeAnalysis fromJson(Map<String, dynamic> json) =>
      EarthquakeAnalysis(
        magnitude: (json['magnitude'] as num).toDouble(),
        distance: (json['distance'] as num).toDouble(),
        timeGap: json['time gap'] == null
            ? null
            : (json['time gap'] as num).toDouble(),
        attenuation: json['attenuation'] == null
            ? null
            : (json['attenuation'] as num).toDouble(),
      );
}

/// One place with simulated crowd data from `/api/crowd/simulate`.
class SimulatedPlace {
  final String name;
  final double lat;
  final double lon;
  final int capacity;
  final int crowd;

  const SimulatedPlace({
    required this.name,
    required this.lat,
    required this.lon,
    required this.capacity,
    required this.crowd,
  });

  static SimulatedPlace fromJson(String name, Map<String, dynamic> json) =>
      SimulatedPlace(
        name: name,
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
        capacity: (json['capacity'] as num).toInt(),
        crowd: (json['crowd'] as num).toInt(),
      );
}

/// Thrown when the backend returns an error status or is unreachable.
class BackendException implements Exception {
  final String message;
  BackendException(this.message);

  @override
  String toString() => message;
}

http.Client _client = http.Client();

/// Overridable for tests.
void setBackendClientForTesting(http.Client client) {
  _client = client;
}

Future<Map<String, dynamic>> _getJson(
  String path, [
  Map<String, String>? query,
]) async {
  final uri = Uri.parse(
    backendBaseUrl,
  ).replace(path: path, queryParameters: query);
  late http.Response response;
  try {
    response = await _client.get(uri);
  } catch (e) {
    throw BackendException('Could not reach the backend at $uri');
  }
  if (response.statusCode != 200) {
    throw BackendException('Backend error ${response.statusCode} for $path');
  }
  return jsonDecode(response.body) as Map<String, dynamic>;
}

/// GET /api/places — tourist places from Python `data.py`.
Future<List<TouristPlace>> fetchPlaces() async {
  final json = await _getJson('/api/places');
  final places = json['places'] as Map<String, dynamic>;
  return [
    for (final entry in places.entries)
      TouristPlace(
        name: entry.key,
        lat: (entry.value['lat'] as num).toDouble(),
        lon: (entry.value['lon'] as num).toDouble(),
        capacity: (entry.value['capacity'] as num).toInt(),
        crowd: (entry.value['crowd'] as num?)?.toInt() ?? 0,
        // Image assets are bundled with the app; the backend's `image`
        // field refers to original local paths, so we map by place name.
        imagePaths: placeImages[entry.key] ?? const [],
      ),
  ];
}

/// GET /api/cities — cities + city profiles from Python `data.py`.
Future<(List<City>, Map<String, String>)> fetchCities() async {
  final json = await _getJson('/api/cities');
  final citiesJson = json['egypt_cities'] as Map<String, dynamic>;
  final infoJson = (json['cities_info'] as Map).cast<String, String>();
  final cities = [
    for (final entry in citiesJson.entries)
      City(
        name: entry.key,
        lon: ((entry.value as List)[0] as num).toDouble(),
        lat: (entry.value[1] as num).toDouble(),
        profile: infoJson[entry.key],
      ),
  ];
  return (cities, infoJson);
}

/// GET /api/earthquake-events — event definitions from Python `data.py`.
Future<List<EarthquakeEvent>> fetchEarthquakeEvents() async {
  final json = await _getJson('/api/earthquake-events');
  return [
    for (final e in json['events'] as List)
      EarthquakeEvent(
        id: e['id'] as String,
        label: e['label'] as String,
        magnitude: (e['magnitude'] as num).toDouble(),
        epicenterLon: (e['epicenter_lon'] as num).toDouble(),
        epicenterLat: (e['epicenter_lat'] as num).toDouble(),
        story: e['story'] as String,
        shortTag: e['short_tag'] as String,
      ),
  ];
}

/// GET /api/map-coordinates
Future<MapCoordinates> fetchMapCoordinates() async {
  return MapCoordinates.fromJson(await _getJson('/api/map-coordinates'));
}

/// GET /api/earthquake — runs Python `one_call()`.
Future<EarthquakeAnalysis> fetchEarthquakeAnalysis({
  required double epicenterLon,
  required double epicenterLat,
  required double cityLon,
  required double cityLat,
  required double magnitude,
}) async {
  final json = await _getJson('/api/earthquake', {
    'lon_c': epicenterLon.toString(),
    'lat_c': epicenterLat.toString(),
    'lon2': cityLon.toString(),
    'lat1': cityLat.toString(),
    'magnitude': magnitude.toString(),
  });
  return EarthquakeAnalysis.fromJson(json);
}

/// GET /api/crowd/simulate — runs Python `simulate_crowd(places)`.
Future<List<SimulatedPlace>> fetchSimulatedCrowd() async {
  final json = await _getJson('/api/crowd/simulate');
  return [
    for (final entry in json.entries)
      SimulatedPlace.fromJson(entry.key, entry.value as Map<String, dynamic>),
  ];
}

/// GET /api/crowd/visitors — runs Python `calculate_visitors()`.
Future<int> fetchVisitors({required int capacity, required int crowd}) async {
  final json = await _getJson('/api/crowd/visitors', {
    'capacity': capacity.toString(),
    'crowd': crowd.toString(),
  });
  return (json['visitors'] as num).toInt();
}

/// GET /api/crowd/status — runs Python `get_crowd_status()`.
Future<String> fetchCrowdStatus({required int crowd}) async {
  final json = await _getJson('/api/crowd/status', {'crowd': crowd.toString()});
  return json['status'] as String;
}
