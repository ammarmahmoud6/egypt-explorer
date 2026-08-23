import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:final_project/data/egypt_data.dart';
import 'package:final_project/services/backend_service.dart';

/// Paints the Egypt map (outline, Nile, Lake Nasser, cities, epicenter).
///
/// All geometry (Egypt outline, Nile branches, Lake Nasser, important-city
/// list) is fetched from the Python backend's `/api/map-coordinates` endpoint
/// and passed in as [coordinates] — nothing is hardcoded here anymore.
class EgyptMapPainter extends CustomPainter {
  final MapCoordinates? coordinates;
  final EarthquakeEvent? selectedEvent;
  final City? selectedCity;
  final (double, double, double, double)? zoomBounds;

  /// Cities fetched from `/api/cities`; used to draw the important-city
  /// dots. May be empty (nothing drawn) until data arrives.
  final List<City> cities;

  EgyptMapPainter({
    this.coordinates,
    this.selectedEvent,
    this.selectedCity,
    this.zoomBounds,
    this.cities = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final coords = coordinates;
    if (coords == null) return; // nothing to draw until data arrives

    // Determine the visible lon/lat range (zoom or full Egypt).
    double lonMin, lonMax, latMin, latMax;
    if (zoomBounds != null) {
      (lonMin, lonMax, latMin, latMax) = zoomBounds!;
    } else {
      lonMin = 25.0;
      lonMax = 36.892;
      latMin = 22.0;
      latMax = 31.65;
    }

    // Projection: map lon/lat to canvas coordinates, preserving aspect ratio.
    final scale = math.min(
      size.width / (lonMax - lonMin),
      size.height / (latMax - latMin),
    );
    final offsetX = (size.width - (lonMax - lonMin) * scale) / 2;
    final offsetY = (size.height - (latMax - latMin) * scale) / 2;

    Offset project(double lon, double lat) {
      final x = offsetX + (lon - lonMin) * scale;
      final y = offsetY + (latMax - lat) * scale; // invert lat (north up)
      return Offset(x, y);
    }

    Path pathFrom(List<GeoPoint> points) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final p = project(points[i].lon, points[i].lat);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      return path;
    }

    // 1. Egypt outline (tan fill, black stroke) — matches matplotlib.
    final outlinePath = pathFrom(coords.egyptOutline);
    canvas.drawPath(
      outlinePath,
      Paint()..color = const Color(0x14D2B48C), // tan with alpha 0.08
    );
    canvas.drawPath(
      outlinePath,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // 2. Nile segments (steelblue).
    final nilePaint = Paint()
      ..color =
          const Color(0xFF4682B4) // steelblue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final segment in [
      coords.nileMain,
      coords.nileRosetta,
      coords.nileDamietta,
    ]) {
      final path = Path();
      for (var i = 0; i < segment.length; i++) {
        final p = project(segment[i].lon, segment[i].lat);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(path, nilePaint);
    }

    // 3. Lake Nasser (dodgerblue fill + stroke).
    final lakePath = pathFrom(coords.lakeNasser);
    canvas.drawPath(
      lakePath,
      Paint()..color = const Color(0x4D1E90FF), // dodgerblue with alpha 0.3
    );
    canvas.drawPath(
      lakePath,
      Paint()
        ..color =
            const Color(0xFF1E90FF) // dodgerblue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // 4. Important cities (red dots) — matching Python.
    final cityPaint = Paint()..color = Colors.red;
    for (final city in cities) {
      if (!coords.importantCities.contains(city.name)) continue;
      final p = project(city.lon, city.lat);
      canvas.drawCircle(p, 3, cityPaint);
    }

    // 5. Selected city (blue dot) — matching Python.
    if (selectedCity != null) {
      final p = project(selectedCity!.lon, selectedCity!.lat);
      canvas.drawCircle(p, 4, Paint()..color = Colors.blue);
    }

    // 6. Epicenter translucent red damage-radius circle — matching Python.
    if (selectedEvent != null) {
      final epicenter = project(
        selectedEvent!.epicenterLon,
        selectedEvent!.epicenterLat,
      );
      // Radius of 1.55 degrees in pixels (matching Python radius=1.55).
      final radiusPx = 1.55 * scale;
      canvas.drawCircle(
        epicenter,
        radiusPx,
        Paint()..color = const Color(0x40FF0000), // red with alpha 0.25
      );
    }
  }

  @override
  bool shouldRepaint(covariant EgyptMapPainter oldDelegate) {
    return oldDelegate.coordinates != coordinates ||
        oldDelegate.selectedEvent != selectedEvent ||
        oldDelegate.selectedCity != selectedCity ||
        oldDelegate.zoomBounds != zoomBounds ||
        oldDelegate.cities != cities;
  }
}
