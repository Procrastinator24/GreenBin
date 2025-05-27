import 'package:flutter_application_3/features/map/data/repositories/map_repository.dart';
import 'package:flutter_application_3/features/map/domain/entities/map_marker.dart';

class GetMarkersUsecase {
  final MapRepository repository;
  
  GetMarkersUsecase(this.repository);

  Future<List<MapMarker>> call([bool useGeoposition = false]) {
    return repository.getMarkers(useGeoposition);
  }
}