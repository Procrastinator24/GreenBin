part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}

class LoadMap extends MapEvent {}
class LoadUserLocationEvent extends MapEvent{}
class MoveToLocation extends MapEvent {
  final MapMarker location;
  final double zoom;

  MoveToLocation({required this.location, this.zoom = 16.0});
}
