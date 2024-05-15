import 'package:flutter_map/flutter_map.dart';

class MapService {
  static const String MAPBOX_ACCESS_TOKEN =
      'pk.eyJ1IjoiY2FydmFqYWxtYXJpZWxzeSIsImEiOiJjbHZyOWdkZGEwa2JlMmttZzNuZ2V3Nm52In0.XzknMqNCOBNtUgnHKvCHhg';

  static TileLayer getMap(bool isDarkMode) {
    return TileLayer(
      urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token={accessToken}',
      additionalOptions: {
        'accessToken': MAPBOX_ACCESS_TOKEN,
        'id': isDarkMode ? 'mapbox/dark-v11' : 'mapbox/light-v11'
      },
      
    );
  }
}
