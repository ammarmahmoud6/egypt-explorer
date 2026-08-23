import 'package:flutter/material.dart';

/// About screen: short blurb about the project and data sources.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Egypt Explorer', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(
              'An interactive tourism and earthquake-awareness app for Egypt. '
              'Explore iconic tourist destinations across the country, view '
              'live crowd levels, and learn about significant earthquake '
              'events and their impact on Egyptian cities.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text('Data Sources', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '• Tourist place data (names, coordinates, capacities) '
              'compiled from official tourism statistics and estimates.\n'
              '• City profiles describing each governorate\'s history, '
              'geography, and culture.\n'
              '• Earthquake event information based on public reports from '
              'the National Research Institute of Astronomy and Geophysics '
              '(NRIAG) and historical records.\n'
              '• Map outline, Nile river, and Lake Nasser coordinates '
              'hand-drawn to match the original Python matplotlib project.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text('Physics', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Seismic wave travel times, P/S wave time gaps, and magnitude '
              'attenuation are calculated using the haversine formula and '
              'standard wave speeds (P-wave 6.5 km/s, S-wave 3.5 km/s), '
              'ported 1:1 from the original Python logic.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
