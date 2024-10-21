import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/view/notification/notification_screen.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/explore/widget/map_marker.dart';
import 'package:ajwad_v4/explore/widget/progress_sheet.dart';
import 'package:ajwad_v4/explore/widget/rating_sheet.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/messages_screen.dart';
import 'package:ajwad_v4/profile/view/ticket_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  final _touristExploreController = Get.put(TouristExploreController());
  final Completer<GoogleMapController> _controller = Completer();
  List<MarkerData> customMarkers = [];
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
  final storage = GetStorage('map_markers');
  final ProfileController _profileController = Get.put(ProfileController());
  final _sheetController = SolidController();

  // List<Booking> _EndTicket = [];
  List<Booking> _upcomingBookings = [];
  late String days;
  bool isStarChecked = false;
  int startIndex = -1;
  bool isSendTapped = false;
  //bool showSheet = true;
  bool isNew = false;

  void getActivityProgress() async {
    await _touristExploreController
        .getActivityProgress(context: context)
        .then((onValue) {
      setProgressStep();
    });
    _touristExploreController.showActivityProgress(true);
  }

  void getBooking() async {
    List<Booking>? bookings = await _profileController
        .getUpcommingTicket(context: context)
        .then((value) {
      checkForProgress();
    });
  }

  Future<void> _animateCamera(
      {required double latitude, required double longitude}) async {
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(latitude, longitude);
      });
    }

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

    if (mounted) {
      final GoogleMapController controller = await _controller.future;
      CameraPosition newCameraPosition = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 10,
      );
      controller
          .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    }
  }

  Future<void> _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/map_styles/map_style.json');
    final controller = await _controller.future;
    await controller.setMapStyle(_darkMapStyle);
  }

  void getLocation() async {
    userLocation = await LocationService().getUserLocation();
    if (userLocation == null) {
      return;
    }
    if (mounted && userLocation != null) {
      _animateCamera(
          latitude: userLocation!.latitude, longitude: userLocation!.longitude);
    } else if (mounted) {
      _animateCamera(latitude: 24.7136, longitude: 46.6753);
    }
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/pin_marker.png")
        .then(
      (icon) {
        // setState(() {
        //   markerIcon = icon;
        // });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPlaces();
    _touristExploreController.isNewMarkers.value = true;
    if (!AppUtil.isGuest()) {
      getUserActions();
    }

    // addCustomIcon();
    getLocation();
    // AmplitudeService.initializeAmplitude();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _sheetController.dispose();
    // isNew = true;
    _touristExploreController.showActivityProgress(false);

    super.dispose();
  }

  void getPlaces() async {
    await _touristExploreController.touristMap(
        context: context, tourType: "PLACE");

    if (!mounted) return; // Ensure the widget is still mounted
    genreateMarkers();
    _touristExploreController.isNewMarkers.value = true;

    if (!AppUtil.isGuest()) {
      getBooking();
    }
  }

  void genreateMarkers() {
    if (!mounted) return; // Check if the widget is still mounted

    customMarkers = List.generate(
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
                  double.parse(_touristExploreController.touristModel.value!
                      .places![index].coordinates!.latitude!),
                  double.parse(_touristExploreController.touristModel.value!
                      .places![index].coordinates!.longitude!),
                )),
            child: MapMarker(
              image: _touristExploreController
                  .touristModel.value!.places![index].image!.first,
              region: AppUtil.rtlDirection2(context)
                  ? _touristExploreController
                      .touristModel.value!.places![index].nameAr!
                  : _touristExploreController
                      .touristModel.value!.places![index].nameEn!,
            ));
      },
    ).toList();
    setState(() {});
  }

  void checkForProgress() async {
    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime currentDate = DateTime(currentDateInRiyadh.year,
        currentDateInRiyadh.month, currentDateInRiyadh.day);
    String currentDateString =
        intel.DateFormat('yyyy-MM-dd').format(currentDate);

    final filterdBooking = _profileController.upcommingTicket
        .where((book) => book.bookingType == 'place')
        .toList();
    if (filterdBooking.isEmpty) {
      return;
    }

    int length = filterdBooking.length;

    for (var i = 0; i < length; i++) {
      if (filterdBooking.isNotEmpty &&
          currentDateString == filterdBooking[i].date.substring(0, 10)) {
        if (filterdBooking[i].orderStatus == 'PENDING') {
          _touristExploreController.showActivityProgress(false);

          return;
        }
// Your tour is going to start at

// جولتك بتبدأ الساعة
        getActivityProgress();

        return;
      } else {
        _touristExploreController.showActivityProgress(false);
      }
    }
  }

  void setProgressStep() {
    switch (
        _touristExploreController.activityProgres.value!.activityProgress!) {
      case 'PENDING':
        _touristExploreController.activeStepProgres(-1);
        break;
      case 'ON_WAY':
        _touristExploreController.activeStepProgres(0);
        break;

      case 'ARRIVED':
        _touristExploreController.activeStepProgres(1);
        break;
      case 'IN_PROGRESS':
        _touristExploreController.activeStepProgres(2);
        _touristExploreController.showActivityProgress(false);
        break;
      case 'COMPLETED':
        _touristExploreController.activeStepProgres(2);

        break;
      default:
    }
  }

  void getUserActions() async {
    await _profileController.getAllActions(context: context);
    if (_profileController.actionsList.isNotEmpty) {
      Get.bottomSheet(
              isScrollControlled: true,
              RatingSheet(
                activityProgress: _profileController.actionsList.first,
              ))
          .then((value) => _profileController.updateUserAction(
              context: context,
              id: _profileController.actionsList.first.id ?? ""));
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
    } else {}

    Get.to(
      () => TripDetails(
        fromAjwady: false,
        place: _touristExploreController.touristModel.value!.places![index],
        distance: distance != 0.0 ? distance.roundToDouble() : distance,
        userLocation: userLocation,
      ),
    );
    AmplitudeService.amplitude
        .track(BaseEvent('Select tour site from the map', eventProperties: {
      'Place name':
          _touristExploreController.touristModel.value!.places![index].nameEn,
    }));
  }

  @override
  Widget build(BuildContext context) {
    print(_touristExploreController.touristModel.value!.places!.length);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomSheet: Obx(
        () => _touristExploreController.isActivityProgressLoading.value
            ? const SizedBox.shrink()
            : _touristExploreController.showActivityProgress.value
                ? Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24),
                            topLeft: Radius.circular(24))),
                    child: SolidBottomSheet(
                      canUserSwipe: false,
                      //   elevation: 10,
                      showOnAppear: _touristExploreController.showSheet.value,
                      toggleVisibilityOnTap: true,
                      maxHeight: width * 0.45,
                      controller: _sheetController,
                      onHide: () {
                        _touristExploreController.showSheet.value = false;
                      },
                      onShow: () {
                        _touristExploreController.showSheet.value = true;
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
                  )
                : const SizedBox.shrink(),
      ),
      body: Stack(
        children: [
          //  isLoaded ?
          CustomGoogleMapMarkerBuilder(
              customMarkers: customMarkers,
              builder: (context, markers) {
                if (markers == null) {
                  return Obx(
                    () => GoogleMap(
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      markers: storage.read<List<Marker>>('markers')!.toSet(),
                      initialCameraPosition: CameraPosition(
                        target: _touristExploreController.currentLocation.value,
                        zoom: 10,
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
                  );
                }
                if (_touristExploreController.isNewMarkers.value) {
                  storage.write('markers', markers.toList()).then((val) {
                    _touristExploreController.isNewMarkers.value = false;
                    _touristExploreController.updateMap(true);
                    // setState(() {});
                  });
                }
                return Obx(
                  () => GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: _touristExploreController.currentLocation.value,
                      zoom: 10,
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
                );
              }),
          Positioned(
            top: width * .19,
            left: width * 0.041,
            right: width * 0.041,
            child: Column(
              children: [
                // text field and icons
                CupertinoTypeAheadField<Place>(
                  decorationBuilder: (context, child) => Container(
                    height: width * 1.02,
                    padding: const EdgeInsets.only(
                      top: 12,
                      // left: 16,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: child,
                  ),
                  emptyBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      text: 'noPlace'.tr,
                      color: starGreyColor,
                      fontFamily: AppUtil.SfFontType(context),
                      fontSize: width * 0.038,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  itemSeparatorBuilder: (context, index) => const Divider(
                    color: lightGrey,
                  ),
                  suggestionsCallback: (search) {
                    if (AppUtil.rtlDirection2(context)) {
                      return _touristExploreController
                          .touristModel.value!.places!
                          .where((place) => place.nameAr!
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList();
                    }
                    return _touristExploreController.touristModel.value!.places!
                        .where((place) => place.nameEn!
                            .toLowerCase()
                            .contains(search.toLowerCase()))
                        .toList();
                  },
                  builder: (context, controller, focusNode) {
                    return Container(
                      // padding: EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: CustomTextField(
                        borderColor: Colors.transparent,
                        raduis: 25,
                        verticalHintPadding:
                            AppUtil.rtlDirection2(context) ? 0 : 10,
                        height: 34,
                        enable: !_touristExploreController
                            .isTouristMapLoading.value,
                        hintText: 'search'.tr,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(8),
                          child: RepaintBoundary(
                            child: SvgPicture.asset(
                              'assets/icons/General.svg',
                              width: 10,
                              height: 1,
                            ),
                          ),
                        ),
                        focusNode: focusNode,
                        controller: controller,
                        onChanged: (value) {},
                      ),
                    );
                  },
                  itemBuilder: (context, place) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: AppUtil.rtlDirection2(context)
                                ? place.nameAr
                                : place.nameEn,
                            fontFamily: AppUtil.SfFontType(context),
                            fontSize: width * 0.038,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          CustomText(
                            text: AppUtil.rtlDirection2(context)
                                ? place.regionAr
                                : place.regionEn,
                            fontFamily: AppUtil.SfFontType(context),
                            fontSize: width * 0.033,
                            fontWeight: FontWeight.w500,
                            color: starGreyColor,
                          )
                        ],
                      ),
                    );
                  },
                  onSelected: (place) {
                    final distance = calculateDistanceBtwUserAndPlace(
                      userLocation!.latitude,
                      userLocation!.longitude,
                      double.parse(place.coordinates!.latitude!),
                      double.parse(place.coordinates!.longitude!),
                    );
                    Get.to(
                      () => TripDetails(
                        fromAjwady: false,
                        place: place,
                        distance: distance != 0.0
                            ? distance.roundToDouble()
                            : distance,
                        userLocation: userLocation,
                      ),
                    );
                    AmplitudeService.amplitude.track(BaseEvent(
                        'Select tour site from the map',
                        eventProperties: {
                          'Place name': place.nameEn,
                        }));
                  },
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
