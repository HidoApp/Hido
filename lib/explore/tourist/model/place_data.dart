// Create a simple data structure to send to the isolate
import 'package:ajwad_v4/explore/widget/map_marker.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceData {
  final String id;
  final String latitude;
  final String longitude;
  final String image;
  final String nameEn;

  PlaceData({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.nameEn,
  });
}

// The isolate-safe function to generate marker data
List<MarkerData> _generateMarkerData(List<PlaceData> places) {
  return places.map((place) {
    return MarkerData(
      marker: Marker(
        markerId: MarkerId(place.id),
        position: LatLng(
          double.parse(place.latitude),
          double.parse(place.longitude),
        ),
        onTap: () {
          // Since this is in the isolate, handle this in the main thread later
        },
      ),
      child: MapMarker(
        image: place.image,
        region: place.nameEn, // Safely use nameEn
      ),
    );
  }).toList();
}
