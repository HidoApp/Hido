import 'dart:async';
import 'dart:developer';

import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  final _touristExploreController = Get.put(TouristExploreController());
  final storage = GetStorage('map_markers');
  @override
  void dispose() {
    // TODO: implement dispose
    log("dis map");
    // _touristExploreController.customMarkers.value = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Skeleton.replace(
        replace: _touristExploreController.isNewMarkers.value,
        replacement: GoogleMap(
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          //  markers: storage.read<List<Marker>>('markers')!.toSet(),
          initialCameraPosition: CameraPosition(
            target: _touristExploreController.currentLocation.value,
            zoom: 6,
          ),
          mapType: MapType.normal,
          onMapCreated: (controller) {
            _controller.complete(controller);

            // _loadMapStyles();
          },
          onCameraMove: (position) {
            _touristExploreController.currentLocation.value = position.target;
            // setState(() {});
          },
        ),
        child: CustomGoogleMapMarkerBuilder(
            customMarkers: _touristExploreController.customMarkers,
            builder: (context, markers) {
              if (markers == null) {
                return Obx(
                  () => RepaintBoundary(
                    child: GoogleMap(
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      markers: storage.read<List<Marker>>('markers')!.toSet(),
                      initialCameraPosition: CameraPosition(
                        target: _touristExploreController.currentLocation.value,
                        zoom: 6,
                      ),
                      mapType: MapType.normal,
                      onMapCreated: (controller) {
                        _controller.complete(controller);

                        // _loadMapStyles();
                      },
                      onCameraMove: (position) {
                        _touristExploreController.currentLocation.value =
                            position.target;
                        // setState(() {});
                      },
                    ),
                  ),
                );
              }
              if (_touristExploreController.isNewMarkers.value) {
                log('assaign');
                storage.write('markers', markers.toList()).then((val) {
                  _touristExploreController.isNewMarkers.value = false;
                  _touristExploreController.updateMap(true);
                });
              }
              return Obx(
                () => RepaintBoundary(
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: _touristExploreController.currentLocation.value,
                      zoom: 6,
                    ),
                    markers: markers,
                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                      // _loadMapStyles();
                    },
                    onCameraMove: (position) {
                      _touristExploreController.currentLocation.value =
                          position.target;
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}