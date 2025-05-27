import 'package:flutter_application_3/features/map/data/repositories/map_repository.dart';
import 'package:flutter_application_3/features/map/domain/entities/map_marker.dart';

class GetCurrentLocation {
  final MapRepository repository;

  GetCurrentLocation(this.repository);
  Future<MapMarker> call() => repository.getCurrentLocation(); 
}