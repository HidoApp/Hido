import 'dart:async';
import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/widget/guide_bottom_sheet.dart';
import 'package:ajwad_v4/explore/widget/map_icons_widget.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/explore/widget/map_marker.dart';
import 'package:ajwad_v4/explore/widget/map_widget.dart';
import 'package:ajwad_v4/explore/widget/progress_sheet.dart';
import 'package:ajwad_v4/explore/widget/rating_sheet.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:intl/intl.dart' as intel;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class TouristMapScreen extends StatefulWidget {
  const TouristMapScreen({
    super.key,
  });

  @override
  State<TouristMapScreen> createState() => _TouristMapScreenState();
}

class _TouristMapScreenState extends State<TouristMapScreen> {
  final _touristExploreController = Get.put(TouristExploreController());
  final Completer<GoogleMapController> _controller = Completer();

  LatLng _currentLocation = const LatLng(24.7136, 46.6753);
  String? _darkMapStyle;
  final colors = [
    Colors.transparent,
    lightYellow,
    colorGreen,
    pink,
  ];
  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;

  // late List<Place> searchedPlaces;
  String? selectedTitle;

  UserLocation? userLocation;
  final ProfileController _profileController = Get.put(ProfileController());
  final _sheetController = SolidController();

  late String days;
  bool isStarChecked = false;
  int startIndex = -1;
  bool isSendTapped = false;
  //bool showSheet = true;
  bool isNew = false;
  var userCountry = '';
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
      return null;
    });
  }

  Future<void> _animateCamera(
      {required double latitude, required double longitude}) async {
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(latitude, longitude);
      });
    }

    if (mounted) {
      final GoogleMapController controller = await _controller.future;
      CameraPosition newCameraPosition = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 6,
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

    if (userLocation == null || !mounted) {
      _animateCamera(latitude: 24.7136, longitude: 46.6753);
      return;
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          userLocation!.latitude, userLocation!.longitude);

      if (!mounted) return;

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          userCountry = place.isoCountryCode ?? '';
        });

        if (userCountry == 'SA') {
          _animateCamera(
              latitude: userLocation!.latitude,
              longitude: userLocation!.longitude);
        } else {
          _animateCamera(latitude: 24.7136, longitude: 46.6753);
        }
      }
    } catch (e) {
      debugPrint('Error fetching placemark: $e');
      _animateCamera(latitude: 24.7136, longitude: 46.6753);
    }
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

    _touristExploreController.customMarkers.value = List.generate(
      _touristExploreController.touristModel.value!.places!.length,
      (index) {
        return MarkerData(
            marker: Marker(
                onTap: () {
                  toTripDetails(index);
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
      if (!mounted) return;

      final activityProgress = _profileController.actionsList.first;

      // Show bottom sheet
      await Get.bottomSheet(
          RatingSheet(
            activityProgress: activityProgress,
          ),
          isScrollControlled: true);
      log("after Rating");
      // After the bottom sheet is fully dismissed, update user action
      if (mounted) {
        await _profileController.updateUserAction(
          context: context,
          id: activityProgress.id ?? "",
        );
      }
    }
  }

  void toTripDetails(int index) async {
    Get.to(
      () => TripDetails(
        fromAjwady: false,
        placeId:
            _touristExploreController.touristModel.value!.places![index].id!,
        //  place: _touristExploreController.touristModel.value!.places![index],
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
    log("Screen full");
    final width = MediaQuery.sizeOf(context).width;
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
                      autoSwiped: false, //   elevation: 10,
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
                : const GuideBottomSheet(),
      ),
      body: Stack(
        children: [
          const MapWidget(),
          Positioned(
            top: width * .19,
            left: width * 0.041,
            right: width * 0.041,
            child: Column(
              children: [
                // text field and icons
                // RepaintBoundary(
                //   child: MapSearchWidget(
                //     userLocation: userLocation,
                //   ),
                // ),

                // SizedBox(
                //   height: width * 0.03,
                // ),
                if (!AppUtil.isGuest()) const MapIconsWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
