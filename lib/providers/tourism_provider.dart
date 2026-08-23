import 'package:flutter/foundation.dart';
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

  /// Places fetched from `/api/places` with crowd values merged in from
  /// `/api/crowd/simulate`. Empty until [loadCrowd] succeeds.
  List<TouristPlace> _places = const [];
  LoadState _state = LoadState.loading;
  String? _error;

  TouristPlace? get selectedPlace => _selectedPlace;
  String get searchQuery => _searchQuery;
  LoadState get state => _state;
  String? get error => _error;

  /// Places filtered by the current search query (case-insensitive substring).
  List<TouristPlace> get filteredPlaces {
    if (_searchQuery.isEmpty) return _places;
    final q = _searchQuery.toLowerCase();
    return _places.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  /// Fetches places and simulated crowd data from the Python backend.
  /// Called on screen load and by the retry button after a failure.
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
    } catch (e) {
      _state = LoadState.error;
      _error = e.toString();
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
