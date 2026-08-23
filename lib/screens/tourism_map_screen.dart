import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/data/egypt_data.dart';
import 'package:final_project/providers/tourism_provider.dart';
import 'package:final_project/services/backend_service.dart';
import 'package:final_project/widgets/egypt_map_painter.dart';

/// Tourism Map screen: interactive map of Egypt with tourist place markers.
///
/// Crowd data is simulated by the Python backend (`simulation.py`) and fetched
/// over HTTP; map geometry comes from `/api/map-coordinates`.
class TourismMapScreen extends StatelessWidget {
  const TourismMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourismProvider()..loadCrowd(),
      child: const _TourismMapView(),
    );
  }
}

class _TourismMapView extends StatelessWidget {
  const _TourismMapView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TourismProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tourist Places')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search places...',
                border: OutlineInputBorder(),
              ),
              onChanged: provider.setSearchQuery,
            ),
          ),
          Expanded(
            // Map coordinates are loaded from the backend before anything can
            // be drawn; crowd simulation is a separate request.
            child: FutureBuilder<MapCoordinates>(
              future: fetchMapCoordinates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _BackendErrorView(
                    message: '${snapshot.error}',
                    onRetry: () => provider.loadCrowd(),
                  );
                }
                switch (provider.state) {
                  case LoadState.loading:
                    return const Center(child: CircularProgressIndicator());
                  case LoadState.error:
                    return _BackendErrorView(
                      message: provider.error ?? 'Failed to load crowd data',
                      onRetry: () => provider.loadCrowd(),
                    );
                  case LoadState.loaded:
                    return _TourismMap(
                      places: provider.filteredPlaces,
                      coordinates: snapshot.data!,
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BackendErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _BackendErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 40, color: theme.colorScheme.error),
            const SizedBox(height: 8),
            Text(
              'Could not reach the Python backend',
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _TourismMap extends StatelessWidget {
  final List<TouristPlace> places;
  final MapCoordinates coordinates;

  const _TourismMap({required this.places, required this.coordinates});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onTapUp: (details) {
            _handleTap(context, details.localPosition, size);
          },
          child: CustomPaint(
            size: size,
            painter: EgyptMapPainter(coordinates: coordinates),
            child: Stack(
              children: [
                for (final place in places)
                  _PlaceMarker(
                    place: place,
                    size: size,
                    onTap: () => _showPlaceSheet(context, place),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context, Offset position, Size size) {
    // Convert tap position to lon/lat using the same projection as the painter.
    const lonMin = 25.0, lonMax = 36.892, latMin = 22.0, latMax = 31.65;
    final scale =
        (size.width / (lonMax - lonMin)) < (size.height / (latMax - latMin))
        ? size.width / (lonMax - lonMin)
        : size.height / (latMax - latMin);
    final offsetX = (size.width - (lonMax - lonMin) * scale) / 2;
    final offsetY = (size.height - (latMax - latMin) * scale) / 2;

    final lon = (position.dx - offsetX) / scale + lonMin;
    final lat = latMax - (position.dy - offsetY) / scale;

    // Find the nearest place within a small threshold.
    const threshold = 0.5; // degrees
    TouristPlace? nearest;
    double bestDist = double.infinity;
    for (final place in places) {
      final d =
          (place.lon - lon) * (place.lon - lon) +
          (place.lat - lat) * (place.lat - lat);
      if (d < bestDist) {
        bestDist = d;
        nearest = place;
      }
    }
    if (nearest != null && bestDist < threshold * threshold) {
      _showPlaceSheet(context, nearest);
    }
  }

  void _showPlaceSheet(BuildContext context, TouristPlace place) {
    context.read<TourismProvider>().selectPlace(place);
    showModalBottomSheet(
      context: context,
      builder: (_) => _PlaceBottomSheet(place: place),
    );
  }
}

class _PlaceMarker extends StatefulWidget {
  final TouristPlace place;
  final Size size;
  final VoidCallback onTap;

  const _PlaceMarker({
    required this.place,
    required this.size,
    required this.onTap,
  });

  @override
  State<_PlaceMarker> createState() => _PlaceMarkerState();
}

class _PlaceMarkerState extends State<_PlaceMarker> {
  late Future<String> _statusFuture;

  @override
  void initState() {
    super.initState();
    // Crowd status is computed by the Python backend (`get_crowd_status`).
    _statusFuture = fetchCrowdStatus(crowd: widget.place.crowd);
  }

  @override
  void didUpdateWidget(covariant _PlaceMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.place.crowd != widget.place.crowd) {
      _statusFuture = fetchCrowdStatus(crowd: widget.place.crowd);
    }
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    // Project lon/lat to position (same projection as painter).
    const lonMin = 25.0, lonMax = 36.892, latMin = 22.0, latMax = 31.65;
    final scale =
        (widget.size.width / (lonMax - lonMin)) <
            (widget.size.height / (latMax - latMin))
        ? widget.size.width / (lonMax - lonMin)
        : widget.size.height / (latMax - latMin);
    final offsetX = (widget.size.width - (lonMax - lonMin) * scale) / 2;
    final offsetY = (widget.size.height - (latMax - latMin) * scale) / 2;

    final x = offsetX + (place.lon - lonMin) * scale;
    final y = offsetY + (latMax - place.lat) * scale;

    return Positioned(
      left: x - 10,
      top: y - 10,
      child: GestureDetector(
        onTap: widget.onTap,
        child: FutureBuilder<String>(
          future: _statusFuture,
          builder: (context, snapshot) {
            final color = snapshot.hasData
                ? _crowdColor(snapshot.data!)
                : Colors.grey;
            return Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 3),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Marker color keyed off the backend-computed crowd status:
  /// green = Low, yellow = Medium, red = High.
  Color _crowdColor(String status) {
    switch (status) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.yellow.shade700;
      default:
        return Colors.red;
    }
  }
}

class _PlaceBottomSheet extends StatelessWidget {
  final TouristPlace place;

  const _PlaceBottomSheet({required this.place});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Visitors count and crowd status are both computed by the Python backend.
    final statsFuture = Future.wait([
      fetchVisitors(capacity: place.capacity, crowd: place.crowd),
      fetchCrowdStatus(crowd: place.crowd),
    ]);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image gallery (carousel) if the place has photos, otherwise
          // fall back to the placeholder (solid color + icon + name).
          if (place.imagePaths.isNotEmpty)
            _ImageGallery(imagePaths: place.imagePaths)
          else
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: 48,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.name,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Text(place.name, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Capacity: ${place.capacity}'),
          FutureBuilder<List<dynamic>>(
            future: statsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text(
                  'Could not load crowd stats: ${snapshot.error}',
                  style: TextStyle(color: theme.colorScheme.error),
                );
              }
              final visitors = snapshot.data![0] as int;
              final status = snapshot.data![1] as String;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Simulated crowd: $visitors visitors'),
                      const SizedBox(width: 6),
                      Tooltip(
                        message:
                            'Crowd data is randomly simulated on the Python '
                            'backend for this demo — not live data.',
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'simulated',
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('Crowd level: $status'),
                ],
              );
            },
          ),
          if (place.description != null) ...[
            const SizedBox(height: 8),
            Text(place.description!),
          ],
        ],
      ),
    );
  }
}

/// A simple swipeable image carousel for a place's photos.
class _ImageGallery extends StatefulWidget {
  final List<String> imagePaths;

  const _ImageGallery({required this.imagePaths});

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: widget.imagePaths.length,
                  onPageChanged: (index) => setState(() => _current = index),
                  itemBuilder: (context, index) {
                    return Image.asset(
                      widget.imagePaths[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.broken_image,
                            size: 48,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        );
                      },
                    );
                  },
                ),
                if (widget.imagePaths.length > 1)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_current + 1}/${widget.imagePaths.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.imagePaths.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < widget.imagePaths.length; i++)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _current
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
