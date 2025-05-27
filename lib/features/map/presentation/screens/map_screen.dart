import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/map/data/datasources/location_datasource.dart';
import 'package:flutter_application_3/features/map/data/repositories/map_repository.dart';
import 'package:flutter_application_3/features/map/data/repositories/map_repository_impl.dart';
import 'package:flutter_application_3/features/map/domain/entities/map_marker.dart';
import 'package:flutter_application_3/features/map/domain/usecases/get_current_location.dart';
import 'package:flutter_application_3/features/map/domain/usecases/get_markers_usecase.dart';
import 'package:flutter_application_3/features/map/presentation/bloc/bloc/map_bloc.dart';
import 'package:flutter_application_3/features/map/presentation/widgets/form_widget.dart';
import 'package:flutter_application_3/features/map/presentation/widgets/map_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  // MapRepositoryImpl mapRepo = MapRepositoryImpl();
  // final usecase = GetMarkersUsecase(MapRepositoryImpl());
  @override
  Widget build(BuildContext context) {
    final mapBloc = MapBloc(GetCurrentLocation(MapRepositoryImpl(LocationDatasource())))..add(LoadMap());
    return BlocProvider(
      create: (context) => mapBloc,
      child: Scaffold(
        body: BlocBuilder<MapBloc, MapState>(
          bloc: mapBloc,
          builder: (context, state) {
            if (state is MapLoading){
              return const Center(child: CircularProgressIndicator());
            } else if (state is MapLoaded){
              return Stack(
                children: [
                  MapWidget(),

                  Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: const BorderSide(color: Color(0xff00858C)),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xff00858C),
                                ),
                                onPressed: () => context.read<MapBloc>().add(LoadUserLocationEvent()),
                                child: Icon(Icons.my_location)),
                            ),
                          ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.15,
                    minChildSize: 0.15,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return Stack(
                        children: [
                          
                          // Фон для draggable sheet
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, -3), blurRadius: 4)],
                            ),
                            // Основное содержимое
                            child: ListView(
                            controller: scrollController,
                            padding: EdgeInsets.all(0),
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.all(4),
                                  width: 28,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                        
                              Container(
                                height: 70,
                                child: Padding(padding: EdgeInsets.fromLTRB(16, 4, 16, 4), child: FormWidget(),),
                              ),     
                            ],
                          ),
                          ),
                          

                        ]
                      );
                    })
                ],
              );
            
            } else if (state is MapError){
              return  Center(
                child: Text('${state.error}'),
              );

            } else{
              return const Center(child: Scaffold(
                body: CircularProgressIndicator(),
              ),);
            }
          }
          
          ),
      ));
  }
}
