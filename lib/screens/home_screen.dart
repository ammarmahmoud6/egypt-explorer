import 'package:flutter/material.dart';
import 'package:final_project/screens/tourism_map_screen.dart';
import 'package:final_project/screens/earthquake_explorer_screen.dart';
import 'package:final_project/screens/about_screen.dart';

/// Home / Welcome screen with the two main navigation buttons.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egypt Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image.
          Image.asset(
            'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (5).jpeg',
            fit: BoxFit.cover,
          ),
          // Dark overlay for readability.
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Egypt Explorer',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      shadows: const [
                        Shadow(blurRadius: 8, color: Colors.black54),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Discover Egypt's iconic tourist destinations and learn "
                    'about earthquake awareness across the country.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      shadows: const [
                        Shadow(blurRadius: 8, color: Colors.black54),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Column(
                      children: [
                        FilledButton.icon(
                          icon: const Icon(Icons.map),
                          label: const Text('Explore Tourist Places'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            minimumSize: const Size(280, 52),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TourismMapScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          icon: const Icon(Icons.crisis_alert),
                          label: const Text('Earthquake Explorer'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            minimumSize: const Size(280, 52),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const EarthquakeExplorerScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
