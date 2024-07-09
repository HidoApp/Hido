import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/trip_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/model/last_activity.dart';
import 'package:ajwad_v4/explore/ajwadi/view/next_activity.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen.dart';
import 'package:ajwad_v4/services/view/widgets/itenrary_tile.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';
import 'package:intl/intl.dart' as intel;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLocalTicketCard extends StatefulWidget {
  CustomLocalTicketCard({
    Key? key,
    this.nextTrip,
  }) : super(key: key);

  NextActivity? nextTrip;

  @override
  _CustomLocalTicketCardState createState() => _CustomLocalTicketCardState();
}

class _CustomLocalTicketCardState extends State<CustomLocalTicketCard> {
  bool isDetailsTapped1 = false;
  late ExpandedTileController _controller;
  String address = '';
  Rx<bool> isTripStart = false.obs;

  final _tripController = Get.put(TripController());
  final _requestController = Get.put(RequestController());
  void updateProgress(double newProgress) {
    setState(() {
      _tripController.progress.value = newProgress.clamp(0.0, 1.0);
    });
  }

void returnProgress(double newProgress) {
    setState(() {
      _tripController.progress.value = newProgress.clamp(0.0, 1.0);
    });
  }

  void updateStepss(String newSteps) {
    setState(() {
      _tripController.nextStep.value = newSteps;
    });
  }
  

  void checkCondition() {
    if (widget.nextTrip!.booking!.date == "2024-06-29")
      setState(() {
        isTripStart.value = true;
      });
//       _tripController.nextStep.value=='PENDING';
// _tripController.progress.value==0.1;
  }

  void initState() {
    super.initState();


    _controller = ExpandedTileController(isExpanded: false);
    getAddressFromCoordinates(
        double.parse(widget.nextTrip!.booking!.coordinates.latitude ?? ''),
        double.parse((widget.nextTrip!.booking!.coordinates.longitude ?? '')));

    checkCondition();
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
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TouristExploreController _touristExploreController =
        Get.put(TouristExploreController());
print(_tripController.nextStep.value);
print(_tripController.progress.value);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return InkWell(
      child: Column(
        children: [
          LastActivity(),
          SizedBox(height: 11),
          Container(
            width: double.infinity,
            height: _controller.isExpanded ? width * 0.65 : width * 0.30,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: [
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
                                  ? widget.nextTrip!.requestName!.nameAr
                                  : widget.nextTrip!.requestName!.nameEn,
                              color: Color(0xFF070708),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              fontFamily: !AppUtil.rtlDirection2(context)
                                  ? 'SF Pro'
                                  : 'SF Arabic',
                            ),
                            SizedBox(height: 4),
                            CustomText(
                              text: 'With Eddie Bravo',
                              textAlign: TextAlign.right,
                              color: Color(0xFF41404A),
                              fontSize: 12,
                              fontFamily: 'SF Pro',
                              height: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.to(ChatScreen(
                                    chatId: widget.nextTrip!.booking!.chatId));
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                surfaceTintColor:
                                    MaterialStateProperty.all(Colors.white),
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(
                                    color: Color(0xFF37B268),
                                    fontSize: 13,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                                fixedSize:
                                    MaterialStateProperty.all(Size(73, 40)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(
                                      color: Color(0xFF37B268),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              child: Text(AppUtil.rtlDirection2(context)
                                  ? "محادثة"
                                  : 'Chat'),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => ElevatedButton(
                                onPressed: isTripStart.value
                                        ?() async {
                                            
                                                await _tripController
                                                    .updateActivity(
                                              id: widget.nextTrip!.id ?? '',
                                              context: context,
                                            ).then((updatedValue) async {
                
                          
                                            if (!_tripController
                                                .isActivityProgressLoading
                                                .value) {
                                              if (updatedValue == []) {
                                                print("this is widget book");
                                              } else {
                                                print('this the value');
                                                updateProgress((_tripController
                                                        .progress.value +
                                                    0.25));

                                                updateStepss(updatedValue!
                                                        .activityProgress ??
                                                  '');
                                                if (updatedValue!
                                                        .activityProgress ==
                                                    'COMPLETED') {
                                                  log("End Trip Taped ${widget.nextTrip!.id}");

                                                  bool requestEnd =
                                                      await _requestController
                                                              .requestEnd(
                                                                  context:
                                                                      context,
                                                                  id: widget
                                                                          .nextTrip!
                                                                          .id ??
                                                                      '') ??
                                                          false;
                                                  if (requestEnd) {
                                                      returnProgress(_tripController
                                                        .progress.value -
                                                    1.0);
                                                    await _tripController
                                                        .getNextActivity(
                                                          context: context,
                                                        )
                                                        .then((value) =>
                                                        
                                                            setState(() {
                                                              widget.nextTrip =
                                                                  value;
                                                              _tripController.nextStep.value='PENDING';
                                                            }));
                                                  } else {
                                                    AppUtil.errorToast(
                                                        context, 'EndTrip'.tr);
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                  }
                                                }
                                              }
                                            }
                                            }
                                            );
                                          }
                                    : null,
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                  ),
                                  backgroundColor: isTripStart.value
                                      ? MaterialStateProperty.all(colorGreen)
                                      : MaterialStateProperty.all(lightGrey),
                                  fixedSize:
                                      MaterialStateProperty.all(Size(89, 40)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      side: BorderSide(
                                        color: isTripStart.value
                                            ? colorGreen
                                            : lightGrey,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Text(
                                 
                                     getActivityProgressText(
                                          _tripController.nextStep.value,
                                          context),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 13,
                                    fontFamily: 'SF Pro',
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
                  //                              // SizedBox(height: width * 0.03),
                  ExpandedTile(
                    contentseparator: 12,
                    trailing: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: width * 0.046,
                    ),
                    disableAnimation: true,
                    trailingRotation: 180,
                    onTap: () {
                      // print(widget.request.date);
                      setState(() {});
                    },
                    title: !_controller.isExpanded
                        ? CustomText(
                            text: AppUtil.rtlDirection2(context)
                                ? 'المزيد'
                                : 'See more',
                            color: Color(0xFF36B268),
                            fontSize: 13,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w500,
                          )
                        : Text(''),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItineraryTile(
                          title:
                              ' ${AppUtil.formatStringTimeWithLocale(context, widget.nextTrip!.booking!.timeToReturn)} -  ${AppUtil.formatStringTimeWithLocale(context, widget.nextTrip!.booking!.timeToGo)}',
                          image: "assets/icons/timeGrey.svg",
                        ),
                        //SizedBox(height: width * 0.025),
                        SizedBox(height: 8),

                        ItineraryTile(
                          title: address,
                          image: 'assets/icons/map_pin.svg',
                          imageUrl: AppUtil.getLocationUrl(
                              widget.nextTrip!.booking!.coordinates),
                          line: true,
                        ),
                        // SizedBox(height: width * 0.025),
                        SizedBox(height: 8),

                        ItineraryTile(
                          title:
                              "${widget.nextTrip!.booking!.guestNumber} ${"guests".tr}",
                          image: "assets/icons/guests.svg",
                        ),

                        SizedBox(height: 11),

                        _controller.isExpanded
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
                            : Text(''),
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
    print('this state');
    print(activityProgress);

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
