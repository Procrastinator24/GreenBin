import 'package:bloc/bloc.dart';
import 'package:flutter_application_3/features/map/domain/entities/map_marker.dart';
import 'package:flutter_application_3/features/map/domain/usecases/get_current_location.dart';
import 'package:flutter_application_3/features/map/domain/usecases/get_markers_usecase.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetCurrentLocation getCurrentLocation;

  MapBloc(this.getCurrentLocation) : super(MapInitial()) {


    on<LoadUserLocationEvent>(_onLoadUserLocation);
    on<MoveToLocation>(_onMoveToLocation);
    on<LoadMap>((event, emit) async {
      emit(MapLoading());
      try {
        final location = await getCurrentLocation();
        emit(MapLoaded(location, 16));
      } catch (e) {
        emit(MapError("Ошибка загрузки локации"));
      }
    });
  }


    Future<void> _onLoadUserLocation(
      LoadUserLocationEvent event, Emitter<MapState> emit
    ) async {
      emit(MapLoading());
      try{
        final location = await getCurrentLocation();
        print("User location: ${location.latitude}, ${location.longtitude}");
        emit(MapLoaded(location, 16.0));
      }catch (e){
        emit(MapError("Не удалось получить местоположение"));
      }
  }

    void _onMoveToLocation(MoveToLocation event, Emitter<MapState> emit){
      emit(MapLoaded(event.location, event.zoom));
  }
    
  
}