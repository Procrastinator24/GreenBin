import 'dart:ffi';

import 'package:flutter_application_3/features/map/data/datasources/location_datasource.dart';
import 'package:flutter_application_3/features/map/data/repositories/map_repository.dart';
import 'package:flutter_application_3/features/map/domain/entities/map_marker.dart';
import 'package:geolocator/geolocator.dart';

class MapRepositoryImpl implements MapRepository{

  final LocationDatasource datasource;
  MapRepositoryImpl(this.datasource);

  @override
  Future<List<MapMarker>> getMarkers(bool useGeoposition) async {

    // if (useGeoposition){
      
    //   final currentPosition = await determinePosition();

    //   return [
    //     MapMarker(latitude: currentPosition.latitude, longtitude: currentPosition.longitude, title: 'Вы находитесь здесь')
    //   ];

    // } else{  
    
    //   // Заглушка 
    //   return [
    //     MapMarker(latitude: 55.75, longtitude: 37.61, title: 'Москва')
    //   ];
    // }
    // Заглушка 
      return [
        MapMarker(latitude: 55.75, longtitude: 37.61, title: 'Москва')
      ];
  }

  @override
  Future<MapMarker> getCurrentLocation() async {
    final position = await datasource.getPosition();
    return MapMarker(
      latitude: position.latitude,
      longtitude: position.longitude,
      title: "Вы находитесь тут");
  }
  // @override
  // Future<Position> determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;


  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   if (!serviceEnabled){
  //     throw Exception('Службы геолокации отключены.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw Exception('Разрешение на геолокацию отклонено');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     throw Exception('Разрешение на геолокацию отклонено навсегда');
  //   }

  //   return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // }
}