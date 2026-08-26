import 'package:flutter/material.dart';
import 'package:final_project/data/egypt_data.dart';
import 'package:final_project/services/backend_service.dart';

/// Load state for backend-backed data.
enum LoadState { loading, loaded, error }

/// Holds the state for the Tourism Map screen.
///
/// All place data (names, coordinates, capacities) is fetched from the
/// Python backend's `/api/places` endpoint, and crowd values are simulated
/// by the backend (`simulation.py`) via `/api/crowd/simulate` — no Dart-side
/// hardcoded data or simulation.
class TourismProvider extends ChangeNotifier {
  TouristPlace? _selectedPlace;
  String _searchQuery = '';

  /// Places fetched from `/api/visited` — names the user marked as visited.
  List<String> _visitedPlaces = const [];

  /// Places fetched from `/api/places` with crowd values merged in from
  /// `/api/crowd/simulate`. Empty until [loadCrowd] succeeds.
  List<TouristPlace> _places = const [];
  LoadState _state = LoadState.loading;
  String? _error;

  TouristPlace? get selectedPlace => _selectedPlace;

  /// Names of the places the user has marked as visited.
  List<String> get visitedPlaces => _visitedPlaces;

  /// True if [placeName] is currently marked as visited.
  bool isVisited(String placeName) => _visitedPlaces.contains(placeName);

  /// Crowd status of the currently selected place — 'Low' / 'Medium' / 'High',
  /// or null when no place is selected. Uses the same thresholds as the
  /// Python backend's `get_crowd_status()` (<=30 Low, <=70 Medium, else High).
  String? get selectedCrowdStatus {
    final place = _selectedPlace;
    if (place == null) return null;
    if (place.crowd <= 30) return 'Low';
    if (place.crowd > 70) return 'High';
    return 'Medium';
  }

  /// Maps a crowd status to a background tint for the place card:
  /// - High -> semi-transparent red
  /// - Low  -> semi-transparent green
  /// - Medium / no selection -> transparent (default surface background)
  ///
  /// Translucent tints (rather than opaque shades) are used on purpose so the
  /// tint blends with the theme's surface color and keeps the theme's text
  /// color legible in both light and dark mode.
  Color getBackgroundColor(String? crowdStatus) {
    switch (crowdStatus) {
      case 'High':
        return Colors.red.withValues(alpha: 0.20);
      case 'Low':
        return Colors.green.withValues(alpha: 0.20);
      default:
        return Colors.transparent;
    }
  }

  String get searchQuery => _searchQuery;
  LoadState get state => _state;
  String? get error => _error;

  /// Places filtered by the current search query (case-insensitive substring).
  List<TouristPlace> get filteredPlaces {
    if (_searchQuery.isEmpty) return _places;
    final q = _searchQuery.toLowerCase();
    return _places.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  /// Fetches places, simulated crowd data, and the visited-places list from
  /// the Python backend. Called on screen load and by the retry button after a
  /// failure.
  ///
  /// The visited-places fetch is deliberately isolated from the main data
  /// load: a failure there (e.g. the backend 404ing on /api/visited) must never
  /// prevent /api/places or /api/crowd/simulate from rendering the map.
  Future<void> loadCrowd() async {
    _state = LoadState.loading;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([fetchPlaces(), fetchSimulatedCrowd()]);
      final places = results[0] as List<TouristPlace>;
      final simulated = results[1] as List<SimulatedPlace>;
      final crowdByName = {for (final p in simulated) p.name: p.crowd};
      _places = [
        for (final place in places)
          place.copyWith(crowd: crowdByName[place.name] ?? place.crowd),
      ];
      _state = LoadState.loaded;
      // Secondary, optional data — isolated so a failure can't block the map.
      try {
        _visitedPlaces = await fetchVisitedPlaces();
      } catch (_) {
        _visitedPlaces = const [];
      }
    } catch (e) {
      _state = LoadState.error;
      _error = e.toString();
    }
    notifyListeners();
  }

  /// Toggles a place in the visited list via the backend, then updates local
  /// state from the response and notifies listeners.
  ///
  /// If the backend call fails (returns `null`), the toggle is applied locally
  /// as an optimistic fallback so the UI stays responsive without breaking
  /// state.
  Future<void> toggleVisited(String placeName) async {
    final result = await toggleVisitedPlace(placeName);
    if (result != null) {
      _visitedPlaces = (result['visited'] as List).cast<String>();
    } else {
      // Local fallback: mirror the toggle locally so the button still responds
      // even though the change couldn't be persisted to the backend.
      if (_visitedPlaces.contains(placeName)) {
        _visitedPlaces =
            _visitedPlaces.where((n) => n != placeName).toList();
      } else {
        _visitedPlaces = [..._visitedPlaces, placeName];
      }
    }
    notifyListeners();
  }

  void selectPlace(TouristPlace? place) {
    _selectedPlace = place;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
