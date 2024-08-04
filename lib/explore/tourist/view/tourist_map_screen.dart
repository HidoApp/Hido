import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/activity_progress.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/view/notification/notification_screen.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/explore/widget/progress_sheet.dart';
import 'package:ajwad_v4/explore/widget/rating_sheet.dart';
import 'package:ajwad_v4/explore/widget/trip_card.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/messages_screen.dart';
import 'package:ajwad_v4/profile/view/ticket_screen.dart';
import 'package:ajwad_v4/profile/widget/otp_sheet.dart';
import 'package:ajwad_v4/profile/widget/phone_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text_area.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:intl/intl.dart' as intel;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class TouristMapScreen extends StatefulWidget {
  const TouristMapScreen({super.key, this.fromAjwady = false});

  final bool fromAjwady;

  @override
  State<TouristMapScreen> createState() => _TouristMapScreenState();
}

class _TouristMapScreenState extends State<TouristMapScreen> {
  late GoogleMapController mapController;
  final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _userMarkers = {};
  Set<Marker> _markers = {};
  LatLng _currentLocation = const LatLng(24.7136, 46.6753);
  late final GoogleMapController _googleMapController;
  String? _darkMapStyle;
  final searchTextController = TextEditingController();
  final colors = [
    Colors.transparent,
    lightYellow,
    colorGreen,
    pink,
  ];
  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;
  final titles = [
    'ALL',
    'EVENT',
    'PLACE',
    'ADVENTURE',
  ];
  // late List<Place> searchedPlaces;
  String? selectedTitle;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor placeIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor eventIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor adventureIcon = BitmapDescriptor.defaultMarker;

  late UserLocation? userLocation;

  final ProfileController _profileController = Get.put(ProfileController());
  final _sheetController = SolidController();

  List<Booking> _EndTicket = [];
  List<Booking> _upcomingBookings = [];
  late String days;
  bool isStarChecked = false;
  int startIndex = -1;
  bool isSendTapped = false;
  bool showSheet = false;

  void getActivityProgress() async {
    await _touristExploreController.getActivityProgress(context: context);
    _touristExploreController.showActivityProgress(true);
  }

  void getBooking() async {
    List<Booking>? bookings =
        await _profileController.getUpcommingTicket(context: context);
    if (bookings != null) {
      setState(() {
        _EndTicket = bookings;
        // getEndBookings();
      });
      print(_EndTicket.length);
    } else {}
  }

  Future<void> _animateCamera(
      {required double latitude, required double longitude}) async {
    setState(() {
      if (mounted) {
        _currentLocation = LatLng(latitude, longitude);
      }
    });
    // marker added for current user location
    _markers.add(Marker(
      markerId: const MarkerId('icon'),
      icon: markerIcon,
      position: LatLng(latitude, longitude),
    ));

    _userMarkers.add(Marker(
      markerId: const MarkerId('icon'),
      icon: markerIcon,
      position: LatLng(latitude, longitude),
    ));

    _googleMapController = await _controller.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 10,
    );
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/map_styles/map_style.json');
    final controller = await _controller.future;
    await controller.setMapStyle(_darkMapStyle);
  }

  void getScrollingCards(String tourType) async {
    _markers = {};

    if (_userMarkers.isNotEmpty) {
      _markers.add(_userMarkers.first);
    }

    await _touristExploreController.touristMap(
        context: context, tourType: tourType);

    if (_touristExploreController.touristModel.value!.places != null) {
      for (var element
          in _touristExploreController.touristModel.value!.places!) {
        if (mounted) {
          _markers.add(Marker(
            markerId: MarkerId('place${element.id}'),
            icon: await getMarkerIcon(
                name: !AppUtil.rtlDirection(context)
                    ? element.nameAr!
                    : element.nameEn!,
                color: colorGreen),
            position: LatLng(double.parse(element.coordinates!.latitude!),
                double.parse(element.coordinates!.longitude!)),
          ));
        }
      }
    }

    if (_touristExploreController.touristModel.value!.adventures != null) {
      for (var element
          in _touristExploreController.touristModel.value!.adventures!) {
        if (mounted) {
          _markers.add(Marker(
            markerId: MarkerId('adv${element.id}'),
            icon: await getMarkerIcon(
                name: !AppUtil.rtlDirection(context)
                    ? element.nameAr!
                    : element.nameEn!,
                color: pink),
            position: LatLng(double.parse(element.coordinates!.latitude!),
                double.parse(element.coordinates!.longitude!)),
          ));
        }
      }
    }

    if (_touristExploreController.touristModel.value!.events != null) {
      for (var element
          in _touristExploreController.touristModel.value!.events!) {
        if (mounted) {
          _markers.add(Marker(
            markerId: MarkerId('event${element.id}'),
            icon: await getMarkerIcon(
                name: !AppUtil.rtlDirection(context)
                    ? element.nameAr!
                    : element.nameEn!,
                color: yellowDark),
            position: LatLng(double.parse(element.coordinates!.latitude!),
                double.parse(element.coordinates!.longitude!)),
          ));
        }
      }
    }
  }

  void getLocation() async {
    userLocation = await LocationService().getUserLocation();

    if (userLocation != null) {
      _animateCamera(
          latitude: userLocation!.latitude, longitude: userLocation!.longitude);
    } else {
      _animateCamera(latitude: 24.7136, longitude: 46.6753);
    }
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

  @override
  void initState() {
    super.initState();
    getPlaces();
    addCustomIcon();
    getLocation();
    if (!AppUtil.isGuest()) {
      getBooking();
      // getActivityProgress();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _sheetController.dispose();

    super.dispose();
  }

  void getPlaces() async {
    await _touristExploreController.touristMap(
        context: context, tourType: "PLACE");
    if (!AppUtil.isGuest()) {
      checkForProgress();
    }
  }

  void checkForProgress() async {
    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime currentDate = DateTime(currentDateInRiyadh.year,
        currentDateInRiyadh.month, currentDateInRiyadh.day);
    String currentDateString =
        intel.DateFormat('yyyy-MM-dd').format(currentDate);
    int length = _touristExploreController.touristModel.value!.places!.length;
    for (var i = 0; i < length; i++) {
      if (_touristExploreController
              .touristModel.value!.places![i].booking!.isNotEmpty &&
          currentDateString ==
              _touristExploreController
                  .touristModel.value!.places![i].booking!.first.date) {
        if (_touristExploreController
                .touristModel.value!.places![i].booking!.first.orderStatus ==
            '') {}
        print("EQUALLL");
        print(currentDateString);
        print(_touristExploreController
            .touristModel.value!.places![i].booking!.first.date);
        getActivityProgress();
        setProgressStep();

        return;
      }
    }
  }

  void setProgressStep() {
    switch (
        _touristExploreController.activityProgres.value!.activityProgress!) {
      case 'ON_WAY':
        _touristExploreController.activeStepProgres(-1);
        break;
      case 'ARRIVED':
        _touristExploreController.activeStepProgres(0);
        break;
      case 'IN_PROGRESS':
        _touristExploreController.activeStepProgres(1);
        break;
      case 'COMPLETED':
        _touristExploreController.activeStepProgres(2);
        _touristExploreController.showActivityProgress(false);
        Get.bottomSheet(
          const RatingSheet(),
          isScrollControlled: true,
        );

        break;
      default:
    }
  }

  void toTripDetails(int index, double distance) async {
    if (userLocation != null) {
      distance = calculateDistanceBtwUserAndPlace(
        userLocation!.latitude,
        userLocation!.longitude,
        double.parse(_touristExploreController
            .touristModel.value!.places![index].coordinates!.latitude!),
        double.parse(_touristExploreController
            .touristModel.value!.places![index].coordinates!.longitude!),
      );
    } else {
      print('CAN NOT CALCULATE DISTANCE');
    }

    Get.to(
      () => TripDetails(
        fromAjwady: false,
        place: _touristExploreController.touristModel.value!.places![index],
        distance: distance != 0.0 ? distance.roundToDouble() : distance,
        userLocation: userLocation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomSheet: Obx(
        () => _touristExploreController.isActivityProgressLoading.value ||
                _touristExploreController.isTouristMapLoading.value
            ? const CircularProgressIndicator.adaptive()
            : _touristExploreController.showActivityProgress.value
                ? Container(
                  color: Colors.white,
                  child: SolidBottomSheet(
                      showOnAppear: showSheet,
                      toggleVisibilityOnTap: true,
                      
                      maxHeight: 209,
                      controller: _sheetController,
                      onHide: () {
                        setState(() {
                          showSheet = false;
                        });
                      },
                      onShow: () {
                        setState(() {
                          showSheet = true;
                        });
                      },
                      headerBar: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(24),
                                topLeft: Radius.circular(24))),
                        height: 50,
                        child: const BottomSheetIndicator(),
                      ),
                      body: const ProgressSheet(),
                    ),
                    body: const ProgressSheet(),
                  )
                : const SizedBox.shrink(),

      ),
      body: Obx(
        () => Stack(
          children: [
            //  isLoaded ?
            CustomGoogleMapMarkerBuilder(
                customMarkers: List.generate(
                  _touristExploreController.touristModel.value!.places!.length,
                  (index) {
                    double distance = 0.0;
                    return MarkerData(
                      marker: Marker(
                          onTap: () {
                            toTripDetails(index, distance);
                          },
                          markerId: MarkerId(_touristExploreController
                              .touristModel.value!.places![index].id!),
                          position: LatLng(
                            double.parse(_touristExploreController.touristModel
                                .value!.places![index].coordinates!.latitude!),
                            double.parse(_touristExploreController.touristModel
                                .value!.places![index].coordinates!.longitude!),
                          )),
                      child: Column(children: [
                        Container(
                          height: width * 0.1,
                          width: width * 0.1,
                          padding: EdgeInsets.all(width * 0.025),
                          margin: EdgeInsets.all(width * 0.025),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: index % 2 == 0 ? colorGreen : yellow,
                                  blurRadius: width * 0.035,
                                )
                              ],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  errorListener: (p0) =>
                                      const CircularProgressIndicator(),
                                  _touristExploreController.touristModel.value!
                                      .places![index].image!.first,
                                ),
                              ),
                              border: Border.all(
                                  color: Colors.white, width: width * 0.0025)),
                        ),
                        CustomText(
                          text: AppUtil.rtlDirection2(context)
                              ? _touristExploreController
                                  .touristModel.value!.places![index].nameAr!
                              : _touristExploreController
                                  .touristModel.value!.places![index].nameEn!,
                          fontSize: width * 0.03,
                          fontWeight: ui.FontWeight.w700,
                          shadows: const [
                            BoxShadow(
                              color: Colors.white,
                              offset: ui.Offset(1, 1),
                            ),
                          ],
                        )
                      ]),
                    );
                  },
                ),
                builder: (context, markers) {
                  if (markers == null) {
                    return GoogleMap(
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      markers: _userMarkers,
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation,
                        zoom: 10,
                      ),
                      mapType: MapType.normal,
                      onMapCreated: (controller) {
                        _controller.complete(controller);
                        _loadMapStyles();
                      },
                      onCameraMove: (position) {
                        setState(() {
                          _currentLocation = position.target;
                        });
                      },
                    );
                  }
                  return GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation,
                      zoom: 10,
                    ),
                    markers: markers,
                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                      _loadMapStyles();
                    },
                    onCameraMove: (position) {
                      setState(() {
                        _currentLocation = position.target;
                      });
                    },
                  );
                }),
            Positioned(
              top: width * .125,
              left: width * 0.041,
              right: width * 0.041,
              child: Column(
                children: [
                  // text field and icons
                  Container(
                    alignment: Alignment.center,
                    width: width * 0.87,
                    height: width * 0.087,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(width * 0.051),
                      ),
                    ),
                    child: TextField(
                      controller: searchTextController,
                      style: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.normal),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/General.svg',
                        ),
                        contentPadding: EdgeInsets.only(
                            top: width * .02,
                            left: width * 0.11,
                            right: width * 0.030),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.051),
                            ),
                            borderSide: BorderSide(
                                color: Colors.grey, width: width * .002)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.051),
                            ),
                            borderSide: BorderSide(
                                color: Colors.grey, width: width * .002)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(width * 0.051),
                          ),
                          borderSide: BorderSide(
                              color: Colors.grey, width: width * .002),
                        ),
                        hintText: "Search",
                        hintStyle: TextStyle(
                            color: lightGrey,
                            fontSize: width * 0.041,
                            fontWeight: ui.FontWeight.w400),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: width * 0.03,
                  ),
                  if (!AppUtil.isGuest())
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //ticket
                        Container(
                          padding: EdgeInsets.all(width * 0.012),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.04),
                            ),
                          ),
                          child: GestureDetector(
                              onTap: () {
                                ProfileController profileController =
                                    Get.put(ProfileController());
                                Get.to(() => AppUtil.isGuest()
                                    ? const SignInScreen()
                                    : TicketScreen(
                                        profileController: profileController,
                                      ));
                              },
                              child: SvgPicture.asset(
                                'assets/icons/ticket_icon.svg',
                                color: colorGreen,
                              )),
                        ),
                        SizedBox(
                          width: width * 0.030,
                        ),
                        Container(
                          padding: EdgeInsets.all(width * 0.0128),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.04),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              ProfileController _profileController =
                                  Get.put(ProfileController());
                              Get.to(() => AppUtil.isGuest()
                                  ? const SignInScreen()
                                  : MessagesScreen(
                                      profileController: _profileController));
                            },
                            child: SvgPicture.asset(
                              'assets/icons/Communication.svg',
                              color: colorGreen,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.030,
                        ),
                        Container(
                          padding: EdgeInsets.all(width * 0.0128),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.04),
                            ),
                          ),
                          child: GestureDetector(
                              onTap: () => Get.to(
                                    () => AppUtil.isGuest()
                                        ? const SignInScreen()
                                        : NotificationScreen(),
                                  ),
                              child: SvgPicture.asset(
                                'assets/icons/Alerts.svg',
                                color: colorGreen,
                              )),
                        ),
                        SizedBox(
                          width: width * 0.030,
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateDistanceBtwUserAndPlace(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<BitmapDescriptor> createCustomMarkerBitmapWithNameAndImage(
      {required Size size, required String name, required Color color}) async {
    TextSpan span = TextSpan(
        style: const TextStyle(
          height: 1.2,
          overflow: TextOverflow.clip,
          color: Colors.black,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        text: name);

    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: size.width * 0.5);

    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder);

    final Paint rectanglePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final a = Offset(size.width * 1 / 6, size.height * 1 / 4);
    final b = Offset(size.width * 5 / 6, size.height * 3 / 4);
    final rectangle = Rect.fromPoints(a, b);
    final theRaduis = const Radius.circular(10);

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rectangle,
          topLeft: theRaduis,
          topRight: theRaduis,
          bottomLeft: theRaduis,
          bottomRight: theRaduis,
        ),
        rectanglePaint);

    final Paint smallTrianglePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path smallTri = Path();

    smallTri.moveTo(size.width * 0.45, size.height / 1.1);

    smallTri.lineTo(size.width * 0.38, size.height * 0.7);
    smallTri.lineTo(size.width * 0.52, size.height * 0.7);
    smallTri.close();
    canvas.drawPath(smallTri, smallTrianglePaint);

    final Paint trianglePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();

    path.moveTo(size.width * 0.7, size.height * 0.3);
    path.lineTo(size.width * 0.6, size.height * 0.6);
    path.lineTo(size.width * 0.8, size.height * 0.6);
    path.close();

    canvas.drawPath(path, trianglePaint);

    tp.paint(canvas, Offset(60, size.height * 1 / 3));

    ui.Picture p = recorder.endRecording();
    ByteData? pngBytes = await (await p.toImage(300, 300))
        .toByteData(format: ui.ImageByteFormat.png);

    Uint8List data = Uint8List.view(pngBytes!.buffer);

    return BitmapDescriptor.fromBytes(data);
  }

  Future<BitmapDescriptor> getMarkerIcon(
      {required String name, required Color color}) async {
    Size size = const Size(330, 160);

    var icon = await createCustomMarkerBitmapWithNameAndImage(
        size: size, name: name, color: color);

    return icon;
  }
}
