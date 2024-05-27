import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/view/notification/notification_screen.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/explore/widget/trip_card.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/messages_screen.dart';
import 'package:ajwad_v4/profile/view/ticket_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  List<Booking> _EndTicket = [];
  List<Booking> _upcomingBookings = [];
  late String days;
  bool isStarChecked = false;
  int startIndex = -1;
  bool isSendTapped = false;

  void getBooking() async {
    List<Booking>? bookings =
        await _profileController.getUpcommingTicket(context: context);
    if (bookings != null) {
      setState(() {
        _EndTicket = bookings;
        getEndBookings();
      });
      print(_EndTicket.length);
    } else {}
  }

  void getEndBookings() async {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    if (_EndTicket.isEmpty) {
      print('No bookings');
      return;
    }

    for (Booking booking in _EndTicket) {
      DateTime bookingDate = DateTime.parse(booking.date);
      DateTime bookingDateWithoutTime =
          DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
      print(
          "arrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(bookingDateWithoutTime);
      if (bookingDateWithoutTime.isBefore(today) ||
          bookingDateWithoutTime.isAtSameMomentAs(today)) {
        print(
            "arrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr222");
        print(bookingDateWithoutTime.isBefore(today));
        print(bookingDateWithoutTime.isAtSameMomentAs(today));

        DateTime timeToReturn = DateTime.parse(booking.timeToReturn);
        // if (timeToReturn.isAfter(now)) {

        // Display bottom sheet
        await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return SizedBox(
                width: width,
                height: isStarChecked ? height * 0.4 : height * 0.35,
                child: isStarChecked
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: 'sorryForHearingThat'.tr,
                              fontFamily: 'Kufam',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.center,
                            ),
                            CustomText(
                              text: 'tellUsWhatHappened'.tr,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            ),
                            CustomTextArea(
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                            CustomButton(
                              onPressed: () {
                                setState(() {
                                  isSendTapped = false;
                                  isStarChecked = false;
                                });
                                Get.back();
                              },
                              title: 'send'.tr,
                              icon: AppUtil.rtlDirection2(context)
                                  ? const Icon(Icons.arrow_back)
                                  : const Icon(Icons.arrow_forward),
                            )
                          ],
                        ),
                      )
                    : isSendTapped
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomText(
                                  text: AppUtil.rtlDirection2(context)
                                      ? 'ما رايك في محمد كأجودي؟'
                                      : 'What do you think about Mohammed As ajwady?',
                                  fontFamily: 'Kufam',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.center,
                                ),
                                CustomText(
                                  text: AppUtil.rtlDirection2(context)
                                      ? 'محمد أخذك في رحلة في طويق ، اليوم الساعة 19:47.'
                                      : 'Mohammed give you a trip in Tuwaik , today at 19:47.',
                                  fontFamily: 'Kufam',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        width: 16,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            startIndex = index;
                                          });
                                        },
                                        child: index <= startIndex
                                            ? const Icon(
                                                Icons.star,
                                                size: 40,
                                                color: Colors.yellow,
                                              )
                                            : const Icon(
                                                Icons.star_border,
                                                size: 40,
                                                color: Colors.yellow,
                                              ),
                                      );
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (startIndex + 1 <= 2) {
                                      // Show "What happened" part
                                      setState(() {
                                        isStarChecked = true;
                                      });
                                    } else {
                                      // Finish and close the bottom sheet

                                      Get.back();
                                    }
                                  },
                                  child: Text('Done'),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: 'howWasTheTrip'.tr,
                                  fontFamily: 'Kufam',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.center,
                                ),
                                CustomTextArea(
                                  onChanged: (value) {
                                    print(value);
                                  },
                                ),
                                CustomButton(
                                  onPressed: () {
                                    setState(() {
                                      isSendTapped = true;
                                    });
                                  },
                                  title: 'send'.tr,
                                  icon: AppUtil.rtlDirection2(context)
                                      ? const Icon(Icons.arrow_back)
                                      : const Icon(Icons.arrow_forward),
                                )
                              ],
                            ),
                          ),
              );
            });
          },
        );

        // } else {
        //   // Display bottom sheet

        // }
      }
    }
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
    getScrollingCards('ALL');

    addCustomIcon();
    getLocation();
    if (!AppUtil.isGuest()) {
      getBooking();
    }

    // Show the bottom sheet after a short delay
    // Future.delayed(Duration(milliseconds: 500), () {
    //   getEndBookings();
    // });
  }

  // void searchForPlace(String letters) {
  //   //for searching feature
  //   searchedPlaces = _touristExploreController.touristModel.value!.places!
  //       .where((place) =>
  //           place.nameEn!.toLowerCase().startsWith(letters.toLowerCase()))
  //       .toList();
  //   if (searchedPlaces.isEmpty) {
  //     searchedPlaces = _touristExploreController.touristModel.value!.places!;
  //   }
  // }

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
      backgroundColor: Colors.white,
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
                              // ProfileController _profileController =
                              //     Get.put(ProfileController());
                              // Get.to(() => AppUtil.isGuest()
                              //     ? const SignInScreen()
                              //     : MessagesScreen(
                              //         profileController: _profileController));
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
