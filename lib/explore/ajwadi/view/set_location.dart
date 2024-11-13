import 'dart:async';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen(
      {super.key,
      this.fromAjwady = true,
      this.touristExploreController,
      this.mapController});

  final bool fromAjwady;
  final TouristExploreController? touristExploreController;
  final GoogleMapController? mapController;

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  late List<Placemark> placemarks;
  String address = "";
  String subLocality = '';

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  LatLng _currentLocation = const LatLng(24.7136, 46.6753);
  late final GoogleMapController _googleMapController;
  String? _darkMapStyle;

  Future<void> getPlaceAddress(double lat, double lng) async {
    placemarks = await placemarkFromCoordinates(lat, lng);
    setState(() {
      subLocality = '${placemarks.first.subLocality}';
      address =
          '${placemarks.first.country} - ${placemarks.first.locality} - ${placemarks.first.name} - ${placemarks.first.street}';
    });
  }

  // Future<Position> _getCurrentUserLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   return await Geolocator.getCurrentPosition();
  // }

  // Future<void> _animateCamera(
  //     {required double latitude, required double longitude}) async {
  //   setState(() {
  //     _currentLocation = LatLng(latitude, longitude);
  //   });
  //   // marker added for current user location
  //   _markers.add(Marker(
  //     markerId: const MarkerId('icon'),
  //     icon: await MarkerIcon.svgAsset(
  //         assetName: 'assets/icons/marker.svg', context: context, size: 100),
  //     position: LatLng(latitude, longitude),
  //   ));
  //   _googleMapController = await _controller.future;
  //   CameraPosition newCameraPosition = CameraPosition(
  //     target: LatLng(latitude, longitude),
  //     zoom: 18,
  //   );
  //   _googleMapController
  //       .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  // }

  Future<void> _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/map_styles/map_style.json');
    final controller = await _controller.future;
    await controller.setMapStyle(_darkMapStyle);
  }

  @override
  void initState() {
    super.initState();
    //  _getCurrentUserLocation();

    getPlaceAddress(
        widget.touristExploreController!.pickUpLocLatLang.value.latitude,
        widget.touristExploreController!.pickUpLocLatLang.value.longitude);
    if (widget.fromAjwady) {
      _loadMapStyles();
    }
    Future.delayed(Duration.zero, () {
      addMaker();
    });
  }

  Future<void> addMaker() async {
    // await BitmapDescriptor.fromAssetImage(
    //         const ImageConfiguration(), "assets/images/pin_marker.png")
    //     .then(
    //   (icon) {
    //     setState(() {
    //       markerIcon = icon;
    //     });
    //   },
    // );

    if (widget.touristExploreController != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId("marker1"),
          position: widget.touristExploreController!.pickUpLocLatLang.value,
          draggable: true,
          onDragEnd: (position) async {
            getPlaceAddress(position.latitude, position.longitude);
            widget.touristExploreController!.isNotGetUserLocation.value = false;

            setState(() {
              widget.touristExploreController!.pickUpLocLatLang(position);

              widget.mapController!
                  .animateCamera(CameraUpdate.newLatLngZoom(position, 18));
            });
          },
          icon: markerIcon,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: widget.touristExploreController != null
                  ? widget.touristExploreController!.pickUpLocLatLang.value
                  : _currentLocation,
              zoom: 18,
            ),
            markers: _markers,
            mapType: MapType.normal,
            onTap: (position) async {
              getPlaceAddress(position.latitude, position.longitude);

              widget.touristExploreController!.pickUpLocLatLang(position);
              widget.touristExploreController!.isNotGetUserLocation.value =
                  false;

              // var addresses = await Geolocator.local
              //     .findAddressesFromCoordinates(coordinates);
              widget.mapController!
                  .animateCamera(CameraUpdate.newLatLngZoom(position, 18));

              setState(() {
                _markers.add(
                  Marker(
                    markerId: const MarkerId("marker1"),
                    position: position,
                    draggable: true,
                    onDragEnd: (position) async {
                      widget.touristExploreController!.isNotGetUserLocation
                          .value = false;

                      getPlaceAddress(position.latitude, position.longitude);

                      setState(() {
                        widget.touristExploreController!
                            .pickUpLocLatLang(position);

                        widget.touristExploreController!.isNotGetUserLocation
                            .value = false;

                        widget.mapController!.animateCamera(
                            CameraUpdate.newLatLngZoom(position, 18));
                      });
                    },
                    icon: markerIcon,
                  ),
                );
              });
            },
            onMapCreated: (controller) {
              _controller.complete(controller);
              _loadMapStyles();
            },
            onCameraMove: (position) {
              setState(() {
                _currentLocation = position.target;
              });
            },
          ),
          Positioned(
            bottom: 21,
            left: 16,
            right: 16,
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 15, right: 15, bottom: 10),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/location_pin.svg",
                            height: 24,
                          ),
                        ),
                        CustomText(
                          text: subLocality,
                          color: black,
                          fontFamily: 'HT Rakik',
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.044,
                        ),
                        // Spacer(),
                        // CustomText(text: "change".tr, color: Colors.black),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      text: address,
                      color: starGreyColor,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      maxlines: 4,
                      fontSize: width * 0.035,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: CustomButton(
                        onPressed: () {
                          Get.back();
                        },
                        title: "confirmLocation".tr,
                        icon: AppUtil.rtlDirection2(context)
                            ? const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                              )
                            : const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
