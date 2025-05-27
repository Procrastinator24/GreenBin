import 'package:bloc/bloc.dart';
import 'package:flutter_application_3/features/map/domain/entities/map_marker.dart';
import 'package:flutter_application_3/features/map/domain/usecases/get_current_location.dart';
import 'package:flutter_application_3/features/map/domain/usecases/get_markers_usecase.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetCurrentLocation getCurrentLocation;

  MapBloc(this.getCurrentLocation) : super(MapInitial()) {
    on<LoadMap>((event, emit) async {
      emit(MapLoading());
      try {
        final location = await getCurrentLocation();
        emit(MapLoaded(location));
      } catch (e) {
        emit(MapError("Ошибка загрузки локации"));
      }
    });
  }
}