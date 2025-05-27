part of 'map_bloc.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

final class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final MapMarker location;

  MapLoaded(this.location); 
}

class MapError extends MapState {
  final String error;

  MapError(this.error);
}
