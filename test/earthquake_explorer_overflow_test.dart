import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:final_project/screens/earthquake_explorer_screen.dart';
import 'package:final_project/services/backend_service.dart';

/// Minimal fake backend responses so the screen can render without a live
/// Flask server.
http.Response _jsonResponse(Map<String, dynamic> json) =>
    http.Response(jsonEncode(json), 200);

MockClient _fakeBackend() => MockClient((request) async {
  switch (request.url.path) {
    case '/api/cities':
      return _jsonResponse({
        'egypt_cities': {
          'Cairo': [31.2333, 30.0444],
          'Suez': [32.5498, 29.9668],
        },
        'cities_info': {'Cairo': 'Cairo profile text'},
      });
    case '/api/earthquake-events':
      return _jsonResponse({
        'events': [
          {
            'id': 'cairo',
            'label': 'Cairo 1992',
            'magnitude': 5.8,
            'epicenter_lon': 31.2333,
            'epicenter_lat': 30.0444,
            'story': 'Story text',
            'short_tag': 'Short tag',
          },
        ],
      });
    case '/api/map-coordinates':
      return _jsonResponse({
        'egypt_outline': [
          [25.0, 22.0],
          [36.0, 22.0],
          [36.0, 31.0],
          [25.0, 31.0],
        ],
        'nile_main': [],
        'nile_rosetta': [],
        'nile_damietta': [],
        'lake_nasser': [],
        'important_cities': ['Cairo'],
      });
    default:
      return http.Response('not found', 404);
  }
});

void failIfOverflow(Object? exception, String label) {
  if (exception == null) return;
  final str = exception.toString();
  if (str.contains('RenderFlex') && str.contains('overflowed')) {
    fail('Overflow at $label: $str');
  }
  // Re-throw unrelated exceptions.
  fail('Unexpected exception at $label: $str');
}

void main() {
  setUpAll(() {
    setBackendClientForTesting(_fakeBackend());
  });

  for (final size in [
    const Size(360, 640), // narrow phone
    const Size(412, 800), // tall-ish phone
    const Size(1280, 800), // desktop / web
  ]) {
    testWidgets(
      'no overflow at ${size.width}x${size.height} with city + earthquake selected',
      (tester) async {
        tester.view.physicalSize = size * tester.view.devicePixelRatio;
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          const MaterialApp(home: EarthquakeExplorerScreen()),
        );
        await tester.pumpAndSettle();

        // Data must have arrived from the (mocked) backend before we tap:
        // the event card proves /api/earthquake-events was consumed.
        expect(find.textContaining('Cairo'), findsWidgets);

        // Select an earthquake event card.
        await tester.tap(find.textContaining('Cairo').first);
        await tester.pumpAndSettle();

        // Select a city from the list.
        await tester.tap(find.text('Cairo').last);
        await tester.pumpAndSettle();

        failIfOverflow(tester.takeException(), '${size.width}x${size.height}');
      },
    );
  }
}
