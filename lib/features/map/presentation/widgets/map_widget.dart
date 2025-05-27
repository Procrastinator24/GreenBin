import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/map/domain/entities/map_marker.dart';
import 'package:flutter_application_3/features/map/presentation/bloc/bloc/map_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  // const MapWidget({super.key, required this.location});

  // final MapMarker location;
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is MapLoading || state is MapInitial){
          return const Center(child: CircularProgressIndicator(),);
        }else if (state is MapLoaded){
          // mapController.move(LatLng(state.location.latitude, state.location.longtitude),state.zoom);
          return FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(state.location.latitude, state.location.longtitude),
              initialZoom: state.zoom,
              
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(state.location.latitude, state.location.longtitude),
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_pin, color: Color(0xff228C7B), size: 40,),
                  ),
                ],
              ),
            ],
          );
        } else if (state is MapError){
          return Center(child: Text(state.error),);
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}
