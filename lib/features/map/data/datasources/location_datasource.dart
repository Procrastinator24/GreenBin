import 'package:geolocator/geolocator.dart';

class LocationDatasource {
  Future<Position> getPosition() async {
    final hasPermission = await Geolocator.checkPermission();
    if (hasPermission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    return Geolocator.getCurrentPosition();
  }
}