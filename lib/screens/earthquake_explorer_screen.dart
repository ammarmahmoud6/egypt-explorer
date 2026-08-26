import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/data/egypt_data.dart';
import 'package:final_project/providers/earthquake_provider.dart';
import 'package:final_project/widgets/egypt_map_painter.dart';

/// Earthquake Explorer screen.
///
/// Map geometry and earthquake analysis are fetched from the Python Flask
/// backend over HTTP; loading and error states are handled here.
class EarthquakeExplorerScreen extends StatelessWidget {
  const EarthquakeExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EarthquakeProvider()..loadMap(),
      child: const _EarthquakeExplorerView(),
    );
  }
}

class _EarthquakeExplorerView extends StatefulWidget {
  const _EarthquakeExplorerView();

  @override
  State<_EarthquakeExplorerView> createState() =>
      _EarthquakeExplorerViewState();
}

class _EarthquakeExplorerViewState extends State<_EarthquakeExplorerView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<City> get _filteredCities {
    final cities = context.read<EarthquakeProvider>().cities;
    if (_searchQuery.isEmpty) return cities;
    final q = _searchQuery.toLowerCase();
    return cities.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EarthquakeProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Earthquake Explorer')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Earthquake selection cards.
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                for (final event in provider.events) ...[
                  Expanded(
                    child: _EventCard(
                      event: event,
                      selected: provider.selectedEvent?.id == event.id,
                      onTap: () => provider.selectEvent(event),
                    ),
                  ),
                  if (event != provider.events.last) const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          // Expandable story panel: collapsed by default so it never takes
          // vertical space away from the map; tap to read the full story.
          if (provider.selectedEvent != null)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              elevation: 1,
              child: ExpansionTile(
                key: ValueKey('event-${provider.selectedEvent!.id}'),
                leading: const Icon(Icons.info_outline),
                title: Text(
                  provider.selectedEvent!.shortTag,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: const Text('Tap to read the full story'),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      provider.selectedEvent!.story,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          // Map — fixed height inside the scrollable page (so the whole page
          // can scroll instead of being squeezed against the viewport).
          SizedBox(
            height: 360,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: EgyptMapPainter(
                    coordinates: provider.mapCoordinates,
                    selectedEvent: provider.selectedEvent,
                    selectedCity: provider.selectedCity,
                    // Intentionally no zoomBounds: the map keeps a fixed
                    // full-Egypt view instead of zooming/magnifying when a
                    // city or event is tapped.
                    cities: provider.cities,
                  ),
                ),
                // Loading / error overlay while map coordinates load from
                // the backend — the painter needs data before it can draw.
                if (provider.mapState == LoadState.loading)
                  const ColoredBox(
                    color: Colors.black26,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (provider.mapState == LoadState.error)
                  _MapErrorOverlay(
                    message: provider.mapError ?? 'Failed to load map data',
                    onRetry: () => provider.loadMap(),
                  ),
              ],
            ),
          ),
          // City info panel.
          _CityInfoPanel(provider: provider),
          // Search + city list.
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search cities...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          // City list — plain column inside the outer scroll view (the outer
          // SingleChildScrollView owns scrolling, so this stays non-scrollable).
          for (final city in _filteredCities)
            ListTile(
              dense: true,
              title: Text(city.name),
              selected: provider.selectedCity?.name == city.name,
              onTap: () => provider.selectCity(city),
            ),
          // Reset button.
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                  provider.clear();
                },
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _MapErrorOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MapErrorOverlay({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
      // Scrollable so the error content never overflows the (possibly
      // small) map area on narrow screens.
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off,
                size: 40,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 8),
              Text(
                'Could not load map data from the backend',
                style: Theme.of(context).textTheme.titleSmall,
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
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EarthquakeEvent event;
  final bool selected;
  final VoidCallback onTap;

  const _EventCard({
    required this.event,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: selected ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.crisis_alert,
                color: selected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                event.label,
                style: theme.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              Text('Mag ${event.magnitude}', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityInfoPanel extends StatelessWidget {
  final EarthquakeProvider provider;

  const _CityInfoPanel({required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final city = provider.selectedCity;
    final event = provider.selectedEvent;

    Widget content;
    if (city == null) {
      content = const Text('Select a city to read its profile');
    } else if (event == null) {
      content = Text(provider.citiesInfo[city.name] ?? '');
    } else if (provider.analysisLoading) {
      content = Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(
            'Analyzing on the Python backend...',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      );
    } else if (provider.analysisError != null || provider.analysis == null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Could not compute the earthquake analysis: '
            '${provider.analysisError ?? "unknown error"}',
            style: TextStyle(color: theme.colorScheme.error),
          ),
          const SizedBox(height: 4),
          TextButton.icon(
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
            onPressed: () => provider.selectCity(city), // re-triggers analysis
          ),
        ],
      );
    } else {
      final analysis = provider.analysis!;
      final nl = String.fromCharCode(10);
      content = Text(
        'Important info about the city in the earthquake:$nl'
        'Magnitude at the earthquake center: ${analysis.magnitude}$nl'
        'Distance between city and center: ${analysis.distance} km$nl'
        'Time between earth shake and the destroying wave: '
        '${analysis.timeGap} seconds$nl'
        'Its magnitude when it reached the city: ${analysis.attenuation}',
      );
    }

    // Compact title for the collapsible profile panel.
    final String title;
    if (city == null) {
      title = 'City profile';
    } else {
      title = city.name;
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ExpansionTile(
        key: ValueKey('city-${city?.name ?? 'none'}-${event?.id ?? 'none'}'),
        leading: const Icon(Icons.location_city),
        title: Text(title),
        subtitle: Text(
          city == null
              ? 'Select a city to read its profile'
              : 'City profile — tap to expand/collapse',
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              // Cap the panel at ~1/3 of the viewport height so the stats text
              // scrolls instead of overflowing/clipping when an earthquake and
              // a city are both selected.
              maxHeight: MediaQuery.sizeOf(context).height / 3,
            ),
            child: SingleChildScrollView(child: content),
          ),
        ],
      ),
    );
  }
}
