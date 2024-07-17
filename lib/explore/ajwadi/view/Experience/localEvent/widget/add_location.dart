import 'dart:async';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class AddEventLocation extends StatefulWidget {
 AddEventLocation({
    Key? key,
    required this.textField1Controller,
  }) : super(key: key);

  final TextEditingController textField1Controller;

  @override
  _AddEventLocationState createState() => _AddEventLocationState();
}


class _AddEventLocationState extends State<AddEventLocation> {
  final EventController _EventrController =
      Get.put( EventController());
      
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  final Completer<GoogleMapController> _controller = Completer();
  bool _isLoading = true;

  late GoogleMapController mapController;
  LatLng? _currentPosition;
  String address = '';
   UserLocation? userLocation;
    Set<Marker> _userMarkers = {};
  Set<Marker> _markers = {};
  LatLng _currentLocation = const LatLng(24.7136, 46.6753);


  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/pin_marker.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

    
  void getLocation() async {
    userLocation = await LocationService().getUserLocation();
    //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('this location');
   // print(position.latitude);
//print(position.longitude);

    if (userLocation != null) {
      setState(() {
      if (mounted) {
      //  _currentPosition = LatLng(position.latitude, position.longitude);
         _currentPosition = LatLng(userLocation!.latitude, userLocation!.longitude);

         _EventrController.pickUpLocLatLang.value = _currentPosition!;
                                    
       
      }
    });
        _fetchAddress();

  
    } else {
       setState(() {
      if (mounted) {
       _currentPosition = LatLng( _currentLocation.latitude, _currentLocation.longitude);
       
      }
    });
   _fetchAddress();

    }
  }
  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        setState(() {
          address =
              '${placemark.locality}, ${placemark.subLocality}, ${placemark.country}';
          // address = '${placemarks.first.country} - ${placemarks.first.locality} - ${placemarks.first.name} - ${placemarks.first.street}';
        });
        print(widget.textField1Controller.text);
        print('this location');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_loadMapStyles();

    //addCustomIcon();
          getLocation();
    //  if(_currentPosition==null){//remove
    //    setState(() {
    //    _currentPosition = LatLng( _currentLocation.latitude, _currentLocation.longitude);
    //     _EventrController.pickUpLocLatLang.value= _currentPosition!;
    
    // });
    //    _fetchAddress();

    //  }//remove until this
    // _currentPosition = LatLng(
    //   _EventrController.pickUpLocLatLang.value.latitude,
    //   _EventrController.pickUpLocLatLang.value.longitude,
    // );
  }

  Future<String> _getAddressFromLatLng(
      double position1, double position2) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position1, position2);
      print(placemarks);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        print(placemarks.first);

        return '${placemark.locality}, ${placemark.subLocality}, ${placemark.country}';
      }
    } catch (e) {
      print("Error retrieving address: $e");
    }
    return '';
  }

  Future<void> _fetchAddress() async {
    double latitude = _currentPosition!.latitude;
    double longitude = _currentPosition!.longitude;
    String fetchedAddress = await _getAddressFromLatLng(latitude, longitude);
    setState(() {
      address = fetchedAddress;
      _isLoading = false;
    });
  }
  void _onTap(LatLng position) {
    setState(() {
      _EventrController.pickUpLocLatLang.value = position;
      _currentPosition = position;
      _isLoading = true;
      _fetchAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    print(address);
    print('this location');
    print(_EventrController.pickUpLocLatLang.toString());


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'locationCheckEvent'.tr,
              style: TextStyle(
                color: black,
                fontSize: 17,
                fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic':'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Directionality(
          textDirection: AppUtil.rtlDirection2(context)
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'locationMSG'.tr,
                    //   style: TextStyle(
                    //     color: starGreyColor,
                    //     fontSize: 16,
                    //     fontFamily: 'SF Pro',
                    //     fontWeight: FontWeight.w400,
                    //     height: 0,
                    //   ),
                    // ),
                    // SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _isLoading
                            ? Align(
                              alignment: Alignment.topLeft,
                              child: Container()
                              )
                            : TextField(
                                controller: widget.textField1Controller,
                                enabled:false,

                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic':'SF Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  hintText: address,
                                  hintStyle: TextStyle(
                                    color: Color(0xFFB9B8C1),
                                    fontSize: 15,
                                    fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic':'SF Pro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10, bottom: 14),
                                    child: SvgPicture.asset(
                                      'assets/icons/map_pin.svg',
                                      color: Color(0xFFB9B8C1),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: almostGrey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      // height: 520,
                        height: AppUtil.rtlDirection2(context)? height*0.57:height*0.57,
                      width: double.infinity,
                      child: _currentPosition == null
          ? Center(child: CircularProgressIndicator.adaptive())
          : GoogleMap(
                        scrollGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target:
                              // // _servicesController == null
                              // //     ? locLatLang
                              // // :
                              // LatLng(
                              //     _servicesController
                              //         .pickUpLocLatLang
                              //         .value
                              //         .latitude,
                              //     _servicesController
                              //         .pickUpLocLatLang
                              //         .value
                              //         .longitude!)
                              _currentPosition!,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId("marker1"),
                            position: _currentPosition!,
                            // LatLng(
                            //     _servicesController
                            //         .pickUpLocLatLang
                            //         .value
                            //         .latitude,
                            //     _servicesController
                            //         .pickUpLocLatLang
                            //         .value
                            //         .longitude),
                            draggable: true,
                            onDragEnd: (LatLng newPosition) {
                              setState(() {
                                _EventrController.pickUpLocLatLang
                                    .value = newPosition;
                                _currentPosition = newPosition;

                                _isLoading = true;
                              });

                              //  mapController.animateCamera(
                              //   CameraUpdate.newCameraPosition(
                              //     CameraPosition(
                              //       target: newPosition,
                              //       zoom: 15,
                              //     ),
                              //   ),
                              // );
                              _fetchAddress();

                            },
                //              onTap: () {
                //         _onTap(_currentPosition!);
                // },
                            icon: markerIcon,
                          ),
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: 358,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        border: Border.all(
                          color: Color(
                              0xFFE2E2E2), // Change this to your desired border color
                          width: 2, // Change this to your desired border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      address,
                                      style: TextStyle(
                                        color: Color(0xFF9392A0),
                                        fontSize: 13,
                                        fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic':'SF Pro',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}