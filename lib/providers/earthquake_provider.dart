import 'package:flutter/foundation.dart';
import 'package:final_project/data/egypt_data.dart';
import 'package:final_project/services/backend_service.dart';

/// Load state for backend-backed data.
enum LoadState { loading, loaded, error }

/// Holds the state for the Earthquake Explorer screen.
///
/// All data comes from the Python Flask backend over HTTP:
/// - cities + city profiles from `/api/cities` (`data.py`)
/// - earthquake event definitions from `/api/earthquake-events` (`data.py`)
/// - map geometry from `/api/map-coordinates`
/// - earthquake analysis from `/api/earthquake`
/// No Dart-side hardcoded data or math.
class EarthquakeProvider extends ChangeNotifier {
  EarthquakeEvent? _selectedEvent;
  City? _selectedCity;
  double? _zoomLonMin;
  double? _zoomLonMax;
  double? _zoomLatMin;
  double? _zoomLatMax;

  // Cities + profiles (fetched from /api/cities).
  List<City> _cities = const [];
  Map<String, String> _citiesInfo = const {};

  // Earthquake events (fetched from /api/earthquake-events).
  List<EarthquakeEvent> _events = const [];

  // Map coordinates (fetched once from /api/map-coordinates).
  MapCoordinates? _mapCoordinates;
  LoadState _mapState = LoadState.loading;
  String? _mapError;

  // Earthquake analysis (fetched from /api/earthquake when both an event
  // and a city are selected).
  EarthquakeAnalysis? _analysis;
  bool _analysisLoading = false;
  String? _analysisError;

  EarthquakeEvent? get selectedEvent => _selectedEvent;
  City? get selectedCity => _selectedCity;
  List<City> get cities => _cities;
  Map<String, String> get citiesInfo => _citiesInfo;
  List<EarthquakeEvent> get events => _events;
  MapCoordinates? get mapCoordinates => _mapCoordinates;
  LoadState get mapState => _mapState;
  String? get mapError => _mapError;
  EarthquakeAnalysis? get analysis => _analysis;
  bool get analysisLoading => _analysisLoading;
  String? get analysisError => _analysisError;

  /// Zoom bounds (lon/lat ranges) for the map, or null if not zoomed.
  (double, double, double, double)? get zoomBounds {
    if (_zoomLonMin == null ||
        _zoomLonMax == null ||
        _zoomLatMin == null ||
        _zoomLatMax == null) {
      return null;
    }
    return (_zoomLonMin!, _zoomLonMax!, _zoomLatMin!, _zoomLatMax!);
  }

  /// Fetches cities, earthquake events and map geometry from the backend.
  /// Called on screen load and by the retry button after a failure.
  Future<void> loadMap() async {
    _mapState = LoadState.loading;
    _mapError = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        fetchCities(),
        fetchEarthquakeEvents(),
        fetchMapCoordinates(),
      ]);
      final (cities, info) = results[0] as (List<City>, Map<String, String>);
      _cities = cities;
      _citiesInfo = info;
      _events = results[1] as List<EarthquakeEvent>;
      _mapCoordinates = results[2] as MapCoordinates;
      _mapState = LoadState.loaded;
    } catch (e) {
      _mapState = LoadState.error;
      _mapError = e.toString();
    }
    notifyListeners();
  }

  /// Selects an earthquake event (or null to clear).
  void selectEvent(EarthquakeEvent? event) {
    _selectedEvent = event;
    _refreshAnalysis();
    notifyListeners();
  }

  /// Selects a city, zooming the map to it (matching the Python
  /// `city_mouse_selection` behavior: ±3 degrees around the city).
  void selectCity(City? city) {
    _selectedCity = city;
    if (city != null) {
      _zoomLonMin = city.lon - 3;
      _zoomLonMax = city.lon + 3;
      _zoomLatMin = city.lat - 3;
      _zoomLatMax = city.lat + 3;
    } else {
      _zoomLonMin = null;
      _zoomLonMax = null;
      _zoomLatMin = null;
      _zoomLatMax = null;
    }
    _refreshAnalysis();
    notifyListeners();
  }

  /// Clears selection and zoom (matching the Python `clear()` behavior).
  void clear() {
    _selectedEvent = null;
    _selectedCity = null;
    _zoomLonMin = null;
    _zoomLonMax = null;
    _zoomLatMin = null;
    _zoomLatMax = null;
    _analysis = null;
    _analysisError = null;
    notifyListeners();
  }

  /// Runs the earthquake analysis on the Python backend whenever both an
  /// event and a city are selected; clears it otherwise.
  void _refreshAnalysis() {
    final event = _selectedEvent;
    final city = _selectedCity;
    if (event == null || city == null) {
      _analysis = null;
      _analysisError = null;
      return;
    }
    _analysisLoading = true;
    _analysisError = null;
    notifyListeners();
    fetchEarthquakeAnalysis(
          epicenterLon: event.epicenterLon,
          epicenterLat: event.epicenterLat,
          cityLon: city.lon,
          cityLat: city.lat,
          magnitude: event.magnitude,
        )
        .then((result) {
          if (_selectedEvent == event && _selectedCity == city) {
            _analysis = result;
          }
        })
        .catchError((Object e) {
          if (_selectedEvent == event && _selectedCity == city) {
            _analysisError = e.toString();
          }
        })
        .whenComplete(() {
          _analysisLoading = false;
          notifyListeners();
        });
  }
}
