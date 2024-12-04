import 'dart:async';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/calender_dialog.dart';
import 'package:ajwad_v4/explore/ajwadi/view/set_location.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_with_icon_button.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class BookingSheet extends StatefulWidget {
  const BookingSheet(
      {Key? key,
      this.fromAjwady = true,
      this.place,
      this.userLocation,
      required this.touristExploreController})
      : super(key: key);
  final bool fromAjwady;
  final Place? place;
  final UserLocation? userLocation;
  final TouristExploreController touristExploreController;
  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  late double width, height;
  int selectedChoice = 3;
  int guestNum = 1;

  var selectedRide = "";
  bool isVanAvilable = false;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  late final GoogleMapController _googleMapController;

  String? _darkMapStyle;

  Future<void> _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/map_styles/map_style.json');
    final controller = await _controller.future;
    await controller.setMapStyle(_darkMapStyle);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //addCustomIcon();

    _touristExploreController.TimeErrorMessage(false);
    _touristExploreController.isBookingDateSelected(false);
    _touristExploreController.isBookingTimeSelected(false);

    if (widget.userLocation != null) {
      _touristExploreController.pickUpLocLatLang(LatLng(
        widget.userLocation!.latitude,
        widget.userLocation!.longitude,
      ));
    } else {
      _touristExploreController.isNotGetUserLocation.value = true;
    }
    // AmplitudeService.initializeAmplitude();
  }

  final Map _pickupRide = {
    'sedan': [
      'assets/icons/selected_sedan_icon.svg',
      'assets/icons/unselected_sedan_icon.svg'
    ],
    'suv': [
      'assets/icons/selected_suv_car.svg',
      'assets/icons/unselected_suv_icon.svg'
    ],
    '4x4': [
      'assets/icons/selected_4x4_icon.svg',
      'assets/icons/unselected_4x4_icon.svg'
    ],
    'van': [
      'assets/icons/selected_van_icon.svg',
      'assets/icons/unselected_van_icon.svg'
    ]
  };

  late DateTime time, returnTime, newTimeToGo = DateTime.now();

  DateTime newTimeToReturn = DateTime.now();
  bool isNew = false;
  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;
  bool DateErrorMessage = false;
  bool TimeErrorMessage = false;

  bool DurationErrorMessage = false;

  bool GuestErrorMessage = false;
  bool vehicleErrorMessage = false;
  bool locationErrorMessage = false;

  //var locLatLang = const LatLng(24.9470921, 45.9903698);
  late DateTime newTimeToGoInRiyadh;
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
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.sizeOf(context).height;
    time = DateTime.now();
    returnTime = DateTime.now();

    tz.initializeTimeZones();

    location = tz.getLocation(timeZoneName);

    bool validateTime() {
      final Duration totalTime = newTimeToReturn.difference(newTimeToGo);
      final Duration eightHours = const Duration(hours: 8);
      //final Duration fourHours = const Duration(hours: 4);
      final Duration adjustedTotalTime = totalTime.isNegative
          ? totalTime +
              const Duration(
                  days:
                      1) // Adjust by adding one day if the duration is negative
          : totalTime;
      // ? totalTime + Duration(days: 1) +Duration(hours: 1);

      // if (adjustedTotalTime >= fourHours && adjustedTotalTime <= eightHours) {
      if (adjustedTotalTime <= eightHours) {
        setState(() {
          DurationErrorMessage = false;
        });

        return true;
      } else {
        setState(() {
          DurationErrorMessage = true;
        });

        return false;
      }
    }

    DateTime Date = DateTime.now();
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    //DateTime currentDate = DateTime(currentDateInRiyadh.year, currentDateInRiyadh.month, currentDateInRiyadh.day,currentDateInRiyadh.hour+2,currentDateInRiyadh.minute);

    // h = time.hour.toString();

    DateTime nowPlusTwoHours =
        currentDateInRiyadh.add(const Duration(hours: 2));

    return DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.8,
        maxChildSize: 1,
        builder: (_, controller) {
          return Obx(
            () => Container(
              decoration: BoxDecoration(
                  color: widget.fromAjwady ? lightBlack : Colors.white,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              padding: const EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.only(
                    left: width * 0.023,
                    right: width * 0.023,
                    bottom: height * 0.03),
                child: ListView(children: [
                  const BottomSheetIndicator(),

                  const SizedBox(
                    height: 12,
                  ),
                  CustomText(
                    text: "date".tr,
                    color: const Color(0xFF070708),
                    fontSize: width * 0.044,
                    fontFamily:
                        AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: AppUtil.rtlDirection(context)
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: CustomTextWithIconButton(
                      onTap: () {
                        setState(() {
                          selectedChoice = 3;
                        });

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CalenderDialog(
                                fromAjwady: false,
                                type: 'book',
                                touristExploreController:
                                    _touristExploreController,
                              );
                            });
                      },
                      height: height * 0.061,
                      width: width * 0.90,
                      title:
                          !_touristExploreController.isBookingDateSelected.value
                              ? 'mm/dd/yyy'.tr
                              : _touristExploreController.selectedDate.value
                                  .substring(0, 10),
                      borderColor:
                          DateErrorMessage ?? false ? Colors.red : borderGrey,
                      prefixIcon: Container(),
                      suffixIcon: SvgPicture.asset(
                        "assets/icons/green_calendar.svg",
                      ),
                      textColor: borderGrey,
                    ),
                  ),
                  if (DateErrorMessage ?? false)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: CustomText(
                        text: AppUtil.rtlDirection2(context)
                            ? '*لابد من اختيار تاريخ للجولة '
                            : "Select Date",
                        color: Colors.red,
                        fontSize: width * 0.028,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      ),
                    ),

                  // const SizedBox(
                  //   height: 12,
                  // ),
                  //TODO:this Row need refactoring
                  Row(
                    children: [
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            CustomText(
                              text: AppUtil.rtlDirection2(context)
                                  ? "وقت الذهاب"
                                  : "Pick up time",
                              color: Colors.black,
                              fontSize: width * 0.044,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Align(
                              alignment: AppUtil.rtlDirection(context)
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: CustomTextWithIconButton(
                                onTap: () {
                                  showCupertinoModalPopup<void>(
                                      context: context,
                                      // barrierColor: Colors.white,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xffffffff),
                                                border: Border(
                                                  bottom: BorderSide(
                                                    //  color: Color(0xff999999),

                                                    width: 0.0,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    onPressed: () {
                                                      widget
                                                          .touristExploreController
                                                          .isBookingTimeSelected(
                                                              true);
                                                      Get.back();
                                                      setState(() {
                                                        time = newTimeToGo;
                                                        if (_touristExploreController
                                                            .isBookingDateSelected
                                                            .value) {
                                                          Date = DateTime.parse(
                                                              _touristExploreController
                                                                  .selectedDate
                                                                  .value
                                                                  .substring(
                                                                      0, 10));

                                                          newTimeToGoInRiyadh =
                                                              tz.TZDateTime(
                                                                  location,
                                                                  Date.year,
                                                                  Date.month,
                                                                  Date.day,
                                                                  newTimeToGo
                                                                      .hour,
                                                                  newTimeToGo
                                                                      .minute,
                                                                  newTimeToGo
                                                                      .second);
                                                        } else {
                                                          Date = DateTime.now();

                                                          newTimeToGoInRiyadh =
                                                              tz.TZDateTime(
                                                                  location,
                                                                  Date.year,
                                                                  Date.month,
                                                                  Date.day,
                                                                  newTimeToGo
                                                                      .hour,
                                                                  newTimeToGo
                                                                      .minute,
                                                                  newTimeToGo
                                                                      .second);
                                                        }

                                                        _touristExploreController
                                                            .selectedStartTime
                                                            .value = newTimeToGo;

                                                        _touristExploreController
                                                                .TimeErrorMessage
                                                                .value =
                                                            AppUtil.isEndTimeLessThanStartTime(
                                                                _touristExploreController
                                                                    .selectedStartTime
                                                                    .value,
                                                                _touristExploreController
                                                                    .selectedEndTime
                                                                    .value);
                                                        validateTime(); // Validate time after selection
                                                      });
                                                    },
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 5.0,
                                                    ),
                                                    child: CustomText(
                                                      text: "confirm".tr,
                                                      color: colorGreen,
                                                      fontSize: width * 0.038,
                                                      fontFamily:
                                                          AppUtil.rtlDirection2(
                                                                  context)
                                                              ? 'SF Arabic'
                                                              : 'SF Pro',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 220,
                                              width: width,
                                              margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: Container(
                                                width: width,
                                                color: Colors.white,
                                                child: CupertinoDatePicker(
                                                  backgroundColor: Colors.white,
                                                  initialDateTime: newTimeToGo,
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  use24hFormat: false,
                                                  onDateTimeChanged:
                                                      (DateTime newT) {
                                                    print(DateFormat('HH:mm:ss')
                                                        .format(newTimeToGo));
                                                    setState(() {
                                                      newTimeToGo = newT;
                                                      //
                                                    });
                                                    _touristExploreController
                                                        .selectedStartTime
                                                        .value = newTimeToGo;

                                                    _touristExploreController
                                                            .TimeErrorMessage
                                                            .value =
                                                        AppUtil.isEndTimeLessThanStartTime(
                                                            _touristExploreController
                                                                .selectedStartTime
                                                                .value,
                                                            _touristExploreController
                                                                .selectedEndTime
                                                                .value);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                height: height * 0.06,
                                width: width * 0.41,
                                title: !_touristExploreController
                                        .isBookingTimeSelected.value
                                    ? "00:00"
                                    : AppUtil.formatStringTimeWithLocale(
                                        context,
                                        DateFormat('HH:mm:ss')
                                            .format(newTimeToGo)),
                                //  test,
                                borderColor: TimeErrorMessage ?? false
                                    ? Colors.red
                                    : DurationErrorMessage ?? false
                                        ? Colors.red
                                        : borderGrey,

                                prefixIcon: Container(),
                                suffixIcon: Container(),
                                textColor: borderGrey,
                              ),
                            ),
                            if (TimeErrorMessage ||
                                _touristExploreController
                                    .TimeErrorMessage.value)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: CustomText(
                                  text: TimeErrorMessage ?? false
                                      ? AppUtil.rtlDirection2(context)
                                          ? "*لابد من إدخال وقت الذهاب"
                                          : "Select Time"
                                      : '',
                                  color: Colors.red,
                                  fontSize: width * 0.024,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            CustomText(
                              text: AppUtil.rtlDirection2(context)
                                  ? "وقت العودة"
                                  : "Drop off time",
                              color: Colors.black,
                              fontSize: width * 0.044,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Align(
                              alignment: AppUtil.rtlDirection(context)
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: CustomTextWithIconButton(
                                onTap: () {
                                  showCupertinoModalPopup<void>(
                                      context: context,
                                      // barrierColor: Colors.white,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xffffffff),
                                                border: Border(
                                                  bottom: BorderSide(
                                                    //  color: Color(0xff999999),
                                                    width: 0.0,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    onPressed: () {
                                                      widget
                                                          .touristExploreController
                                                          .isBookingTimeSelected(
                                                              true);
                                                      Get.back();
                                                      setState(() {
                                                        returnTime =
                                                            newTimeToReturn;

                                                        _touristExploreController
                                                                .selectedEndTime
                                                                .value =
                                                            newTimeToReturn;

                                                        _touristExploreController
                                                                .TimeErrorMessage
                                                                .value =
                                                            AppUtil.isEndTimeLessThanStartTime(
                                                                _touristExploreController
                                                                    .selectedStartTime
                                                                    .value,
                                                                _touristExploreController
                                                                    .selectedEndTime
                                                                    .value);

                                                        validateTime(); // Validate time after selection
                                                      });
                                                    },
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 5.0,
                                                    ),
                                                    child: CustomText(
                                                      text: "confirm".tr,
                                                      color: colorGreen,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 220,
                                              width: width,
                                              margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: Container(
                                                width: width,
                                                color: Colors.white,
                                                child: CupertinoDatePicker(
                                                  backgroundColor: Colors.white,
                                                  initialDateTime:
                                                      newTimeToReturn,
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  use24hFormat: false,
                                                  onDateTimeChanged:
                                                      (DateTime newT) {
                                                    print(DateFormat('HH:mm:ss')
                                                        .format(
                                                            newTimeToReturn));
                                                    setState(() {
                                                      newTimeToReturn = newT;
                                                      //
                                                    });

                                                    _touristExploreController
                                                            .selectedEndTime
                                                            .value =
                                                        newTimeToReturn;

                                                    _touristExploreController
                                                            .TimeErrorMessage
                                                            .value =
                                                        AppUtil.isEndTimeLessThanStartTime(
                                                            _touristExploreController
                                                                .selectedStartTime
                                                                .value,
                                                            _touristExploreController
                                                                .selectedEndTime
                                                                .value);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                height: height * 0.06,
                                width: width * 0.41,
                                title: !_touristExploreController
                                        .isBookingTimeSelected.value
                                    ? "00:00"
                                    : AppUtil.formatStringTimeWithLocale(
                                        context,
                                        DateFormat('HH:mm:ss')
                                            .format(newTimeToReturn)),
                                //  test,
                                borderColor: TimeErrorMessage ||
                                        _touristExploreController
                                            .TimeErrorMessage.value
                                    ? Colors.red
                                    : DurationErrorMessage ?? false
                                        ? Colors.red
                                        : borderGrey,

                                prefixIcon: Container(),
                                suffixIcon: Container(),
                                textColor: borderGrey,
                              ),
                            ),
                            if (TimeErrorMessage ||
                                _touristExploreController
                                    .TimeErrorMessage.value)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 4,
                                ),
                                child: CustomText(
                                  text: TimeErrorMessage ?? false
                                      ? AppUtil.rtlDirection2(context)
                                          ? "*لابد من إدخال وقت العودة"
                                          : "Select Time"
                                      : 'TimeDuration'.tr,
                                  color: Colors.red,
                                  maxlines: 2,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontSize: width * 0.024,
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomText(
                    text: "numberOfPeople".tr,
                    color: Colors.black,
                    fontSize: width * 0.044,
                    fontWeight: FontWeight.w500,
                    fontFamily:
                        AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    height: height * 0.063,
                    width: width * 0.90,
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    // margin: EdgeInsets.only(top: height * 0.02, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: borderGrey),
                    ),
                    child: Row(
                      children: [
                        CustomText(
                          text: "person".tr,
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.035,
                          color: borderGrey,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              if (guestNum > 1) {
                                setState(() {
                                  guestNum = guestNum - 1;
                                  if (selectedRide == 'van' && guestNum <= 10) {
                                    selectedRide = "";
                                  }
                                });
                              }
                            },
                            child: const Icon(Icons.horizontal_rule_outlined,
                                color: borderGrey)),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomText(
                          text: guestNum.toString(),
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.035,
                          color: borderGrey,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                guestNum = guestNum + 1;
                              });
                              if (selectedRide == 'van' && guestNum <= 7) {
                                selectedRide = "";
                              }
                            },
                            child: const Icon(Icons.add, color: borderGrey)),
                      ],
                    ),
                  ),

                  Align(
                      alignment: AppUtil.rtlDirection2(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: CustomText(
                        text: "forMoreThan10".tr,
                        fontSize: 10,
                        color: borderGrey,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      )),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  CustomText(
                    text: "pickUpLocation".tr,
                    color: Colors.black,
                    fontSize: width * 0.044,
                    fontFamily:
                        AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  //  Obx( () =>
                  Stack(
                    children: [
                      Container(
                        height: height * 0.15,
                        width: width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: locationErrorMessage
                              ? BorderRadius.circular(0)
                              : BorderRadius.circular(15),
                          color: lightGrey,
                          border: locationErrorMessage
                              ? Border.all(
                                  color: Colors.red,
                                  width:
                                      2) // Red border if userLocation is null
                              : null, // No border if userLocation is not null
                        ),
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            setState(() {
                              mapController = controller;
                            });

                            _loadMapStyles();
                          },
                          initialCameraPosition: CameraPosition(
                            target: _touristExploreController
                                .pickUpLocLatLang.value,
                            zoom: 14,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("marker1"),
                              position: _touristExploreController
                                  .pickUpLocLatLang.value,
                              draggable: true,
                              onDragEnd: (value) {
                                // value is the new position
                              },
                              icon: markerIcon,
                            ),
                          },
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(() => SetLocationScreen(
                                  fromAjwady: false,
                                  touristExploreController:
                                      _touristExploreController,
                                  mapController: mapController,
                                ));
                          },
                          child: Container(
                            height: 100,
                            width: 320,
                            color: Colors.transparent,
                          ))
                    ],
                  ),
                  //),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  // SizedBox(
                  //   height: height * 0.02,
                  // ),
                  CustomText(
                    text: "pickUpRide".tr,
                    color: Colors.black,
                    fontSize: width * 0.044,
                    fontWeight: FontWeight.w500,
                    fontFamily:
                        AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  pickupRide(),
                  if (vehicleErrorMessage ?? false)
                    Padding(
                      padding: EdgeInsets.only(top: width * 0.025),
                      child: CustomText(
                        text: AppUtil.rtlDirection2(context)
                            ? "اختر نوع السيارة"
                            : "Select vehicle type",
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        color: Colors.red,
                        fontSize: width * 0.028,
                      ),
                    ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  // SizedBox(
                  //   height: height * 0.01,
                  // ),
                  _touristExploreController.isBookingIsMaking.value ||
                          _touristExploreController.isPlaceIsLoading.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : CustomButton(
                          title: "findLocal".tr,
                          onPressed: () async {
                            if (!_touristExploreController
                                .isBookingDateSelected.value) {
                              setState(() {
                                DateErrorMessage = true;
                              });
                            }
                            setState(() {
                              DateErrorMessage = !_touristExploreController
                                  .isBookingDateSelected.value;
                            });

                            // Check if booking time is selected
                            if (!_touristExploreController
                                .isBookingTimeSelected.value) {
                              setState(() {
                                TimeErrorMessage = true;
                              });
                            }
                            setState(() {
                              TimeErrorMessage = !_touristExploreController
                                  .isBookingTimeSelected.value;
                            });

                            // Check if user location is set
                            if (_touristExploreController
                                .isNotGetUserLocation.value) {
                              setState(() {
                                locationErrorMessage = true;
                              });
                            }
                            setState(() {
                              locationErrorMessage = _touristExploreController
                                  .isNotGetUserLocation.value;
                            });

                            // Check if a vehicle is selected
                            if (selectedRide == "") {
                              setState(() {
                                vehicleErrorMessage = true;
                              });
                            }
                            setState(() {
                              vehicleErrorMessage = selectedRide == "";
                            });

                            if (_touristExploreController.isBookingDateSelected.value &&
                                _touristExploreController
                                    .isBookingTimeSelected.value &&
                                !_touristExploreController
                                    .isNotGetUserLocation.value &&
                                selectedRide != "") {
                              if (validateTime()) {
                                Date = DateTime.parse(_touristExploreController
                                    .selectedDate.value
                                    .substring(0, 10));

                                newTimeToGoInRiyadh = tz.TZDateTime(
                                    location,
                                    Date.year,
                                    Date.month,
                                    Date.day,
                                    newTimeToGo.hour,
                                    newTimeToGo.minute,
                                    newTimeToGo.second);
                                // if (newTimeToGoInRiyadh
                                //     .isAfter(nowPlusTwoHours))
                                if (newTimeToGoInRiyadh
                                    .isAfter(currentDateInRiyadh)) {
                                  if (!_touristExploreController
                                      .TimeErrorMessage.value) {
                                    _touristExploreController
                                        .isBookedMade(true);
                                    DateErrorMessage = false;

                                    // AppUtil.successToast(
                                    //     context, 'TIME AND DATE IS SELECTED');

                                    //  Navigator.pop(context);
                                    if (widget.place != null) {
                                      final isSuccess =
                                          await _touristExploreController
                                              .bookPlace(
                                                  placeId: widget.place!.id!,
                                                  timeToGo: DateFormat(
                                                          'HH:mm:ss')
                                                      .format(newTimeToGo),
                                                  timeToReturn: DateFormat(
                                                          'HH:mm:ss')
                                                      .format(newTimeToReturn),
                                                  date: _touristExploreController
                                                      .selectedDate.value
                                                      .substring(0, 10),
                                                  guestNumber: guestNum,
                                                  cost: guestNum *
                                                      widget.place!.price!,
                                                  lng: _touristExploreController
                                                      .pickUpLocLatLang
                                                      .value
                                                      .longitude
                                                      .toString(),
                                                  lat: _touristExploreController
                                                      .pickUpLocLatLang
                                                      .value
                                                      .latitude
                                                      .toString(),
                                                  vehicle: selectedRide,
                                                  context: context);

                                      if (isSuccess) {
                                        Place? thePlace =
                                            await _touristExploreController
                                                .getPlaceById(
                                                    id: widget.place!.id!,
                                                    context: context);

                                        // final Identify identify1 = Identify();
                                        // identify1.setOnce(
                                        //     'sign_up_date', '2015-08-24');
                                        // Amplitude.getInstance()
                                        //     .identify(identify1);

                                        // amplitude.logEvent('MyApp startup',
                                        //     eventProperties: {
                                        //       'friend_num': 10,
                                        //       'is_heavy_user': true
                                        //     });

                                        // Log event to Amplitude when the form is completed
                                        AmplitudeService.amplitude.track(
                                            BaseEvent('Successfully Book tour',
                                                eventProperties: {
                                              'selected_date':
                                                  _touristExploreController
                                                      .selectedDate.value,
                                              'selected_time_to_go':
                                                  newTimeToGo.toString(),
                                              'selected_time_to_return':
                                                  newTimeToReturn.toString(),
                                              // 'location_set': true,
                                              'vehicle_selected': selectedRide,
                                              'placeName': thePlace?.nameEn,
                                            }));

                                        Get.back();

                                        Get.to(
                                          () => FindAjwady(
                                            place: thePlace!,
                                            booking: thePlace.booking![0],
                                            placeId: thePlace.id!,
                                          ),
                                        );
                                      } else {
                                        AppUtil.errorToast(
                                            context, 'somthingWentWrong'.tr);
                                        AmplitudeService.amplitude.track(
                                            BaseEvent('Failed Book tour',
                                                eventProperties: {
                                              'selected_date':
                                                  _touristExploreController
                                                      .selectedDate.value,
                                              'selected_time_to_go':
                                                  newTimeToGo.toString(),
                                              'selected_time_to_return':
                                                  newTimeToReturn.toString(),
                                              // 'location_set': true,
                                              'vehicle_selected': selectedRide,
                                            }));
                                      }
                                    }
                                  } else {
                                    AppUtil.errorToast(
                                        context, 'TimeDuration'.tr);
                                    await Future.delayed(
                                        const Duration(seconds: 3));
                                  }
                                } else {
                                  AppUtil.errorToast(
                                      context,
                                      AppUtil.rtlDirection2(context)
                                          ? "يجب أن يكون وقت الجولة أكبر من الوقت الحالي"
                                          : "The tour time must be after the current time.");
                                  // ? "يجب أن يكون وقت الجولة بعد ساعتين على الأقل من الوقت الحالي"
                                  // : "The tour time must be at least two hours after the current time.");
                                }
                              } else {
                                AppUtil.errorToast(
                                    context,
                                    AppUtil.rtlDirection2(context)
                                        ? "يجب أن لا تزيد مدة الجولة عن ٨ ساعات"
                                        : "The Tour duration must be 8 hours or less");
                              }
                            } else {}
                          },
                          icon: AppUtil.rtlDirection2(context)
                              ? const Icon(Icons.arrow_back_ios)
                              : const Icon(Icons.arrow_forward_ios),
                          customWidth: width * 0.87,
                        )
                ]),
              ),
            ),
          );
        });
  }

  Widget pickupRide() {
    final button = _pickupRide
        .map((key, values) {
          final value = Container(
            margin: const EdgeInsets.only(left: 2),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (key == 'van' && guestNum > 7) {
                    selectedRide = key;
                  } else if (key != 'van') {
                    selectedRide = key;
                  }
                });
              },
              child: Container(
                height: height * 0.1,
                width: width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (key == 'van' && guestNum <= 7)
                        ? Colors.transparent
                        : selectedRide == key
                            ? colorGreen
                            : Colors.black,
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: lightGreyColor.withOpacity(0.4),
                  //       blurRadius: 9,
                  //       spreadRadius: 8)
                  // ],
                  color: (key == 'van' && guestNum <= 7)
                      ? lightGreyColor
                      : selectedRide == key
                          ? lightGreen
                          : Colors.white,
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    RepaintBoundary(
                      child: SvgPicture.asset(
                        selectedRide == key ? values[0] : values[1],
                        color: (key == 'van' && guestNum <= 7)
                            ? tileGreyColor
                            : null,
                      ),
                    ),
                    const Spacer(),
                    CustomText(
                      text: "$key".tr,
                      color: (key == 'van' && guestNum <= 7)
                          ? tileGreyColor
                          : selectedRide == key
                              ? colorGreen
                              : dividerColor,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
            ),
          );
          return MapEntry(key, value);
        })
        .values
        .toList();

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: button);
  }

  String? selectedTime;
  Future<void> displayTimeDialog() async {
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        selectedTime = time.format(context);
      });
    }
  }
}
