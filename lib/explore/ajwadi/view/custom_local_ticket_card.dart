import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/trip_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/view/next_activity.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen.dart';
import 'package:ajwad_v4/services/view/widgets/itenrary_tile.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:intl/intl.dart' as intel;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLocalTicketCard extends StatefulWidget {
  CustomLocalTicketCard({
    Key? key,
  }) : super(key: key);

  @override
  _CustomLocalTicketCardState createState() => _CustomLocalTicketCardState();
}

class _CustomLocalTicketCardState extends State<CustomLocalTicketCard> {
  bool isDetailsTapped1 = false;
  late ExpandedTileController _controller;
  String address = '';
  Rx<bool> isTripStart = false.obs;
  Rx<bool> isTripEnd = false.obs;

  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;

  final _tripController = Get.put(TripController(), permanent: true);
  final _requestController = Get.put(RequestController());
  void updateProgress(double newProgress) {
    
      _tripController.progress.value = newProgress.clamp(0.0, 1.0);
    
  }

  void returnProgress(double newProgress) {
      _tripController.progress.value = newProgress.clamp(0.0, 1.0);
    
  }

  void updateStepss(String newSteps) {
  
      _tripController.nextStep.value = newSteps;
  
  }

  void checkCondition() {
    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime currentDate = DateTime(currentDateInRiyadh.year,
        currentDateInRiyadh.month, currentDateInRiyadh.day);

    String currentDateString =
        intel.DateFormat('yyyy-MM-dd').format(currentDate);

    DateTime currentTime = DateTime(
        currentDateInRiyadh.year,
        currentDateInRiyadh.month,
        currentDateInRiyadh.day,
        currentDateInRiyadh.hour,
        currentDateInRiyadh.minute,
        currentDateInRiyadh.second);
    final parsedBookingDate =
        DateTime.parse(_tripController.nextTrip.value.booking!.date ?? '');

    if (_tripController.nextTrip.value.booking!.date == currentDateString ||
        parsedBookingDate.isAtSameMomentAs(currentDate) ||
        parsedBookingDate.isBefore(currentDate)) {
      String timeToGoStr = _tripController.nextTrip.value.booking!.timeToGo;
      String? bookingDateStr = _tripController.nextTrip.value.booking!.date;

      DateTime timeToGo = DateTime.parse('$bookingDateStr $timeToGoStr');

      Duration difference = timeToGo.difference(currentTime);

      if (difference.inHours <= 4) {
        setState(() {
          isTripStart.value = true;
        });
      } else {
        setState(() {
          isTripStart.value = false;
        });
      }
    }
  }

  bool checkEndTime(String timeToReturnStr) {
    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);

    // Parse the booking date and timeToReturn
    DateTime bookingDate =
        DateTime.parse(_tripController.nextTrip.value.booking!.date ?? '');

    List<String> timeParts = timeToReturnStr.split(':');
    int returnHour = int.parse(timeParts[0]);
    int returnMinute = int.parse(timeParts[1]);

    DateTime timeToReturn = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      returnHour,
      returnMinute,
    );

    // if (returnHour < currentDateInRiyadh.hour ||
    //     (returnHour == currentDateInRiyadh.hour &&
    //         returnMinute <= currentDateInRiyadh.minute)) {
    //   timeToReturn = timeToReturn.add(Duration(days: 1));
    // }
    // Get the current time for comparison

  //   if (returnHour >= 0 && returnHour < 6 && currentDateInRiyadh.isAfter(timeToReturn)) {
  //   // Add a day if the return time is in the early morning (0 AM to 5:59 AM)
  //   timeToReturn = timeToReturn.add(Duration(days: 1));
  // }
    DateTime currentTime = DateTime(
      currentDateInRiyadh.year,
      currentDateInRiyadh.month,
      currentDateInRiyadh.day,
      currentDateInRiyadh.hour,
      currentDateInRiyadh.minute,
      currentDateInRiyadh.second,
    );


  log('${currentTime.isAfter(timeToReturn) ||
        currentTime.isAtSameMomentAs(timeToReturn)}');
  log(currentTime.toString());
  log(timeToReturn.toString());
  log('${returnHour >= 0 && returnHour < 6 && currentDateInRiyadh.isAfter(timeToReturn)}');


    if (currentTime.isAfter(timeToReturn) ||
        currentTime.isAtSameMomentAs(timeToReturn)) {
      _tripController.isTripFinallyEnd.value = true;
      _tripController.isTripEnd.value = false;
      
      return true;
    } else {
      _tripController.isTripFinallyEnd.value = false;
      if (_tripController.nextStep.value == 'IN_PROGRESS') {
        _tripController.isTripEnd.value = true;
      }

      return false;
    }
    
  }

  void isDateBefore24Hours() {
    final String timeZoneName = 'Asia/Riyadh';
    late tz.Location location;

    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime parsedDate =
        DateTime.parse(_tripController.nextTrip.value.booking!.date ?? '');
    Duration difference = parsedDate.difference(currentDateInRiyadh);

    if (difference.inHours < 6) {
      setState(() {
        isTripStart.value = true;
      });
    }
  }

  void initState() {
    super.initState();

    _controller = ExpandedTileController(isExpanded: false);
    checkCondition();
    checkEndTime(_tripController.nextTrip.value.booking!.timeToReturn);
    String latitudeStr =
        _tripController.nextTrip.value.booking?.coordinates.latitude ?? '';
    String longitudeStr =
        _tripController.nextTrip.value.booking?.coordinates.longitude ?? '';

    if (latitudeStr.isNotEmpty && longitudeStr.isNotEmpty) {
      try {
        double latitude = double.parse(latitudeStr);
        double longitude = double.parse(longitudeStr);
        getAddressFromCoordinates(latitude, longitude);
      } catch (e) {}
    } else {}
  }

  void getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        address =
            "${placemark.postalCode}, ${placemark.subLocality}, ${placemark.country}";
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final TouristExploreController _touristExploreController =
        Get.put(TouristExploreController());

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return InkWell(
      child: Column(
        children: [
          const LastActivity(),
          const SizedBox(height: 11),
          Container(
            width: double.infinity,
            height: _controller.isExpanded ? width * 0.65 : width * 0.30,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3FC7C7C7),
                  blurRadius: 15,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    textDirection: AppUtil.rtlDirection2(context)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: AppUtil.rtlDirection2(context)
                                  ? _tripController
                                      .nextTrip.value.requestName!.nameAr
                                  : _tripController
                                      .nextTrip.value.requestName!.nameEn,
                              color: Color(0xFF070708),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              fontFamily: !AppUtil.rtlDirection2(context)
                                  ? 'SF Pro'
                                  : 'SF Arabic',
                            ),
                            // SizedBox(height: 4),
                            // CustomText(
                            //   text: 'With Eddie Bravo',
                            //   textAlign: TextAlign.right,
                            //   color: Color(0xFF41404A),
                            //   fontSize: 12,
                            //   fontFamily: 'SF Pro',
                            //   height: 0,
                            //   fontWeight: FontWeight.w500,
                            // ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.to(ChatScreen(
                                    chatId: _tripController
                                        .nextTrip.value.booking!.chatId));
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                ),
                                surfaceTintColor:
                                    MaterialStateProperty.all(Colors.white),
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(
                                    color: Color(0xFF37B268),
                                    fontSize: 13,
                                    fontFamily: AppUtil.SfFontType(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                fixedSize:
                                    MaterialStateProperty.all(Size(80, 40)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(
                                      color: Color(0xFF37B268),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                elevation: MaterialStateProperty.all(0),
                              ),
                              child: FittedBox(
                                child: CustomText(
                                  text: 'chat2'.tr,
                                  color: colorGreen,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => _tripController
                                      .isActivityProgressLoading.value
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(right:15.0),
                                        child: SizedBox(
                                        width: 25.0, // Set the width
                                        height: 25.0, // Set
                                        child:
                                            CircularProgressIndicator.adaptive(),
                                                                          ),
                                      ))
                                  : ElevatedButton(
                                      onPressed: isTripStart.value &&
                                              !_tripController.isTripEnd.value 
                                          ? () async {
                                              await _tripController
                                                  .updateActivity(
                                                id: _tripController
                                                        .nextTrip.value.id ??
                                                    '',
                                                context: context,
                                              )
                                                  .then((updatedValue) async {
                                                if (!_tripController
                                                    .isActivityProgressLoading
                                                    .value) {
                                                  // if (_tripController
                                                  //         .updatedActivity.value.id ==
                                                  //     null) {
                                                  //   log('enter 1');
                                                  // } else {
                                                  updateProgress(
                                                      (_tripController
                                                              .progress.value +
                                                          0.25));

                                                  updateStepss(_tripController
                                                          .updatedActivity
                                                          .value
                                                          .activityProgress ??
                                                      '');
                                                  log(" end trip before${_tripController.isTripEnd.value}");
                                                  if (_tripController
                                                          .updatedActivity
                                                          .value
                                                          .activityProgress ==
                                                      'IN_PROGRESS') {
                                                    if (checkEndTime(
                                                        _tripController
                                                            .nextTrip
                                                            .value
                                                            .booking!
                                                            .timeToReturn)) {
                                                      log("this activity progress");
                                                      log(_tripController
                                                          .updatedActivity
                                                          .value
                                                          .activityProgress!);

                                                      log("this end trip ${_tripController.isTripEnd.value}");
                                                    } else {
                                                      _tripController.isTripEnd
                                                          .value = true;
                                                      log("this activity progress");
                                                      log(_tripController
                                                          .updatedActivity
                                                          .value
                                                          .activityProgress!);

                                                      log("this end trip ${_tripController.isTripEnd.value}");
                                                    }
                                                  }

                                                  if (_tripController
                                                          .updatedActivity
                                                          .value
                                                          .activityProgress ==
                                                      'COMPLETED') {
                                                    updateProgress(
                                                        (_tripController
                                                                .progress
                                                                .value +
                                                            0.25));

                                                    updateStepss(_tripController
                                                            .updatedActivity
                                                            .value
                                                            .activityProgress ??
                                                        '');
                                                    log("enter completed state");
                                                    log(_tripController
                                                        .updatedActivity
                                                        .value
                                                        .activityProgress!);
                                                    log("this end trip ${_tripController.isTripEnd.value}");
                                                    log("End Trip Taped ${_tripController.nextTrip.value.id}");

                                                    bool requestEnd =
                                                        await _requestController.requestEnd(
                                                                context:
                                                                    context,
                                                                id: _tripController
                                                                        .nextTrip
                                                                        .value
                                                                        .id ??
                                                                    '') ??
                                                            false;
                                                    if (requestEnd) {
                                                      returnProgress(
                                                          _tripController
                                                                  .progress
                                                                  .value -
                                                              1.0);
                                                      await _tripController
                                                          .getNextActivity(
                                                        context: context,
                                                      )
                                                          .then((value) {
                                                        if (!_tripController
                                                            .isNextActivityLoading
                                                            .value) {
                                                          _tripController
                                                                  .nextStep
                                                                  .value =
                                                              'PENDING';
                                                        } else {
                                                          print(
                                                              "this is widget book2");
                                                        }
                                                      });
                                                    } else {
                                                      AppUtil.errorToast(
                                                          context,
                                                          'EndTrip1'.tr);
                                                      await Future.delayed(
                                                          const Duration(
                                                              seconds: 3));
                                                    }
                                                    // } else {

                                                    //   AppUtil.errorToast(
                                                    //       context,
                                                    //       "The tour time hasn't ended yet"
                                                    //           .tr);
                                                    //   await Future.delayed(
                                                    //       const Duration(
                                                    //           seconds: 1));
                                                    // }
                                                  }
                                                  //  }
                                                }
                                              });
                                            }
                                          : isTripStart.value ||
                                                  _tripController
                                                      .isTripEnd.value
                                              ? () async {
                                                  AppUtil.errorToast(context,
                                                      "EndTourTime".tr);
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1));
                                                }
                                              : () async {
                                                  AppUtil.errorToast(context,
                                                      "StartTourTime".tr);
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1));
                                                },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                        ),
                                        backgroundColor: isTripStart.value
                                            ? MaterialStateProperty.all(
                                                colorGreen)
                                            : MaterialStateProperty.all(
                                                lightGrey),
                                        fixedSize: MaterialStateProperty.all(
                                            Size(89, 40)),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            side: BorderSide(
                                              color: isTripStart.value
                                                  ? colorGreen
                                                  : lightGrey,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        elevation: MaterialStateProperty.all(0),
                                      ),
                                      child: FittedBox(
                                        child: CustomText(
                                          text: getActivityProgressText(
                                              _tripController.nextStep.value,
                                              context),
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: width * 0.03,
                                          fontFamily:
                                              AppUtil.rtlDirection2(context)
                                                  ? 'SF Arabic'
                                                  : 'SF Pro',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // SizedBox(height: 2),
                  const Divider(
                    color: lightGrey,
                  ),
                  // SizedBox(height: width * 0.03),
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: ExpandedTile(
                      contentseparator: 12,
                      trailing: Directionality(
                        textDirection: AppUtil.rtlDirection2(context)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: _controller.isExpanded
                            ? CustomText(
                                text: AppUtil.rtlDirection2(context)
                                    ? 'القليل'
                                    : 'See less',
                                color: Color(0xFF36B268),
                                fontSize: 13,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                fontWeight: FontWeight.w500,
                              )
                            : CustomText(
                                text: 'seeMore'.tr,
                                color: Color(0xFF36B268),
                                fontSize: 13,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                fontWeight: FontWeight.w500,
                              ),
                      ),
                      disableAnimation: true,
                      trailingRotation: 0,
                      onTap: () {
                        //
                        setState(() {});
                      },
                      title:
                          //!_controller.isExpanded
                          //     ? CustomText(
                          //         text:'seeMore'.tr,
                          //         color: Color(0xFF36B268),
                          //         fontSize: 13,
                          //         fontFamily: AppUtil.rtlDirection2(context)
                          //             ? 'SF Arabic'
                          //             : 'SF Pro',
                          //         fontWeight: FontWeight.w500,
                          //       )
                          //     :
                          Text(''),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItineraryTile(
                            title:
                                ' ${AppUtil.formatBookingDate(context, _tripController.nextTrip.value.booking!.date!)}',
                            image: "assets/icons/date.svg",
                          ),
                          SizedBox(height: 8),

                          ItineraryTile(
                            title:
                                ' ${AppUtil.formatStringTimeWithLocale(context, _tripController.nextTrip.value.booking!.timeToGo)} - ${AppUtil.formatStringTimeWithLocale(context, _tripController.nextTrip.value.booking!.timeToReturn)}',
                            image: "assets/icons/timeGrey.svg",
                          ),
                          //SizedBox(height: width * 0.025),

                          SizedBox(height: 8),
                          ItineraryTile(
                            title: address,
                            image: 'assets/icons/map_pin.svg',
                            imageUrl: AppUtil.getLocationUrl(_tripController
                                .nextTrip.value.booking!.coordinates),
                            line: true,
                          ),

                          SizedBox(height: 8),

                          ItineraryTile(
                            title:
                                "${_tripController.nextTrip.value.booking!.guestNumber} ${"guests".tr}",
                            image: "assets/icons/guests.svg",
                          ),

                          SizedBox(height: 11),

                          // _controller.isExpanded
                          //     ? CustomText(
                          //         text: AppUtil.rtlDirection2(context)
                          //             ? 'القليل'
                          //             : 'See less',
                          //         color: Color(0xFF36B268),
                          //         fontSize: 13,
                          //         fontFamily: AppUtil.rtlDirection2(context)
                          //             ? 'SF Arabic'
                          //             : 'SF Pro',
                          //         fontWeight: FontWeight.w500,
                          //       )
                          //     :CustomText(text:''),
                        ],
                      ),
                      controller: _controller,
                      theme: const ExpandedTileThemeData(
                        leadingPadding: EdgeInsets.zero,
                        titlePadding: EdgeInsets.zero,
                        headerPadding: EdgeInsets.zero,
                        contentPadding: EdgeInsets.zero,
                        headerSplashColor: Colors.transparent,
                        headerColor: Colors.transparent,
                        contentBackgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getActivityProgressText(
      String activityProgress, BuildContext context) {
    if (AppUtil.rtlDirection2(context)) {
      switch (activityProgress) {
        case 'PENDING':
          return 'ابدأ';
        case 'ON_WAY':
          return 'وصلت';
        case 'ARRIVED':
          return 'ركب السائح';
        case 'IN_PROGRESS':
          return 'إنهاء الجولة';
        default:
          return 'ابدأ'; // Handle any other possible values
      }
    } else {
      switch (activityProgress) {
        case 'PENDING':
          return 'Start';
        case 'ON_WAY':
          return 'Arrived';
        case 'ARRIVED':
          return 'Picked Up';
        case 'IN_PROGRESS':
          return 'Completed';
        default:
          return 'Start'; // Handle any other possible values
      }
    }
  }

  String getBookingTypeText(BuildContext context, String bookingType) {
    if (AppUtil.rtlDirection2(context)) {
      switch (bookingType) {
        case 'place':
          return 'جولة';
        case 'adventure':
          return 'مغامرة';
        case 'hospitality':
          return 'ضيافة';
        case 'event':
          return 'فعالية';
        default:
          return bookingType;
      }
    } else {
      if (bookingType == 'place') {
        return "Tour";
      } else {
        return bookingType;
      }
    }
  }

  String formatBookingDate(BuildContext context, String date) {
    DateTime dateTime = DateTime.parse(date);
    if (AppUtil.rtlDirection2(context)) {
      // Set Arabic locale for date formatting
      return intel.DateFormat('EEEE، d MMMM yyyy', 'ar').format(dateTime);
    } else {
      // Default to English locale
      return intel.DateFormat('EEEE, d MMMM yyyy').format(dateTime);
    }
  }
}
