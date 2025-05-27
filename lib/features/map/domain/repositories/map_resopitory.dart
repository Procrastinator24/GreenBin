import 'package:flutter_application_3/features/map/domain/entities/map_marker.dart';
import 'package:geolocator/geolocator.dart';

abstract class MapRepository {
  Future<List<MapMarker>> getMarkers(bool useGeoposition);
  Future<MapMarker> getCurrentLocation();
}