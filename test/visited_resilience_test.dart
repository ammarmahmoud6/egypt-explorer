// Verifies the /api/visited resilience: a backend 404 / network failure must
// degrade gracefully instead of throwing and taking down the rest of the app.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:final_project/services/backend_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchVisitedPlaces returns empty list on 404', () async {
    setBackendClientForTesting(
      MockClient((request) async => http.Response('{"error":"Not Found"}', 404)),
    );
    final visited = await fetchVisitedPlaces();
    expect(visited, isEmpty);
  });

  test('fetchVisitedPlaces throws no error on network failure', () async {
    setBackendClientForTesting(
      MockClient((_) async => throw Exception('connection refused')),
    );
    // Must not throw even though the network call fails.
    final visited = await fetchVisitedPlaces();
    expect(visited, isEmpty);
  });

  test('fetchVisitedPlaces parses a valid list', () async {
    setBackendClientForTesting(
      MockClient(
        (request) async => http.Response('{"visited":["Luxor","Cairo"]}', 200),
      ),
    );
    final visited = await fetchVisitedPlaces();
    expect(visited, ['Luxor', 'Cairo']);
  });

  test('toggleVisitedPlace returns null on 404', () async {
    setBackendClientForTesting(
      MockClient((request) async => http.Response('{"error":"Not Found"}', 404)),
    );
    final result = await toggleVisitedPlace('Luxor');
    expect(result, isNull);
  });
}