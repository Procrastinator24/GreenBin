import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/map/domain/entities/map_marker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final MapMarker location;

  const MapWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(55.75, 37.61),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [Marker(
              point: LatLng(location.latitude, location.longtitude),
              width: 40,
              height: 40,
              child: const Icon(Icons.location_pin, color: Colors.red),
            ),]
        ),
      ],
    );
  }
}
