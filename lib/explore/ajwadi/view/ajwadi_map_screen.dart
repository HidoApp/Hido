import 'dart:async';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_on_map.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
import 'package:ajwad_v4/explore/tourist/view/notification/notification_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AjwadiMapScreen extends StatefulWidget {
  const AjwadiMapScreen({super.key, this.fromAjwady = true});

  final bool fromAjwady;

  @override
  State<AjwadiMapScreen> createState() => _AjwadiMapScreenState();
}

class _AjwadiMapScreenState extends State<AjwadiMapScreen> {
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {
    
  };
  // LatLng _currentLocation = const LatLng(24.7136, 46.6753);
  LatLng _currentLocation = LatLng(24.7136, 46.6753);
  late final GoogleMapController _googleMapController;
  String? _darkMapStyle;

  bool isLoaded = false;

  final _getStorage = GetStorage();
  final _authController = Get.put(AuthController());

  Future<Position> _getCurrentUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await Geolocator.getCurrentPosition();
  }

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

  Future<void> _animateCamera(
      {required double latitude, required double longitude ,InfoWindow? windoInfo}) async {
    setState(() {
      _currentLocation = LatLng(latitude, longitude);
    });
    // marker added for current user location
    _markers.add(Marker(
      markerId: const MarkerId('icon'),
      icon: markerIcon, 
      position: LatLng(latitude, longitude),
      infoWindow:windoInfo != null ?  InfoWindow(

      ) : InfoWindow()
    ));
    _googleMapController = await _controller.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 18,
    );
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    final controller = await _controller.future;
    await controller.setMapStyle(_darkMapStyle);
  }

  late UserLocation? userLocation;
  void getLocation() async {
    userLocation = await LocationService().getUserLocation();
    print(userLocation!.latitude);
    print(userLocation!.longitude);
    if (userLocation != null) {
      _animateCamera(
          latitude: userLocation!.latitude, longitude: userLocation!.longitude);
    } else {
      _animateCamera(latitude: 24.7136, longitude: 46.6753);
    }
  }

  @override
  void initState() {
    super.initState();
    String token = _getStorage.read('accessToken');
    AppUtil.isTokeValidate(token);

    addCustomIcon();

    getLocation();

    if (AppUtil.isTokeValidate(token)) {
      String refreshToken = _getStorage.read('refreshToken');
      _authController.refreshToken(
          refreshToken: refreshToken, context: context);
    }

    // _getCurrentUserLocation();
    // if (widget.fromAjwady) {
    //   _loadMapStyles();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 1,
            ),
            markers: _markers,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            onCameraMove: (position) {
              setState(() {
                _currentLocation = position.target;
              });
            },
          ),
          Positioned(
            top: 49,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              textDirection: TextDirection.ltr,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 36,
                    width: width * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      // textDirection: TextDirection.rtl,
                      children: [
                        const SizedBox(
                          width: 22,
                        ),
                        SvgPicture.asset(
                          'assets/icons/search.svg',
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        CustomText(
                          text: 'search'.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: thinGrey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => NotificationScreen());
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: gold,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset('assets/icons/message.svg'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => NotificationScreen());
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorGreen,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset('assets/icons/notifications.svg'),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 21,
            left: 24,
            right: 24,
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: CustomButton(
                onPressed: () async {
                  var token = _getStorage.read('accessToken') ?? '';
                  if (AppUtil.isTokeValidate(token)) {
                    String refreshToken = _getStorage.read('refreshToken');
                    _authController.refreshToken(
                        refreshToken: refreshToken, context: context);
                  }
                  showModalBottomSheet(
                      useRootNavigator: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      )),
                      context: context,
                      builder: (context) {
                        return AddOnMapSheet(
                          token: '',
                        );
                      });
                },
                title: 'add'.tr,
                icon: const CustomText(
                  text: '+',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
