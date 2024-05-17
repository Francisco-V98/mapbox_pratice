import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

LatLngBounds mapBounds = LatLngBounds(
  const LatLng(10.098259, -69.125802),
  const LatLng(10.058619, -69.095283),
);

// Define un provider para el StateNotifier
final markerPositionsProvider = StateNotifierProvider<MarkerPositionsNotifier, List<LatLng>>((ref) {
  return MarkerPositionsNotifier();
});

class MarkerPositionsNotifier extends StateNotifier<List<LatLng>> {
  MarkerPositionsNotifier() : super([]) {
    generateRandomPositions();
  }

  void generateRandomPositions() {
    // Genera posiciones aleatorias
    List<LatLng> positions = [];
    for (int i = 0; i < 20; i++) {
      positions.add(
        LatLng(
          mapBounds.southWest.latitude +
              (mapBounds.northEast.latitude - mapBounds.southWest.latitude) *
                  Random().nextDouble(),
          mapBounds.southWest.longitude +
              (mapBounds.northEast.longitude - mapBounds.southWest.longitude) *
                  Random().nextDouble(),
        ),
      );
    }
    state = positions;
  }
}