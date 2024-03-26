import 'dart:async';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/calender_dialog.dart';
import 'package:ajwad_v4/explore/ajwadi/view/set_location.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_with_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

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
    addCustomIcon();

    _touristExploreController.isBookingDateSelected(false);
    _touristExploreController.isBookingTimeSelected(false);

    if (widget.userLocation != null) {
      _touristExploreController.pickUpLocLatLang(LatLng(
        widget.userLocation!.latitude,
        widget.userLocation!.longitude,
      ));
    }
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

  late DateTime time, returnTime, newTime = DateTime.now();
  bool isNew = false;

  //var locLatLang = const LatLng(24.9470921, 45.9903698);

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
    height = MediaQuery.of(context).size.height;
    time = DateTime.now();
    returnTime = DateTime.now();
    // h = time.hour.toString();
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
                    left: width * 0.03,
                    right: width * 0.03,
                    bottom: height * 0.03),
                child: ListView(children: [
                  const Icon(
                    Icons.keyboard_arrow_up_outlined,
                    size: 30,
                  ),
                  CustomText(
                    text: "date".tr,
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Align(
                    alignment: AppUtil.rtlDirection(context)
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: CustomTextWithIconButton(
                      onTap: () {
                        print("object");
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
                      height: height * 0.06,
                      width: width * 0.65,
                      title:
                          !_touristExploreController.isBookingDateSelected.value
                              ? 'chooseFromCalender'.tr
                              : _touristExploreController.selectedDate.value
                                  .substring(0, 10),
                      borderColor: lightGreyColor,
                      prefixIcon: SvgPicture.asset(
                        "assets/icons/green_calendar.svg",
                      ),
                      suffixIcon: const Icon(
                        Icons.arrow_forward_ios,
                        color: almostGrey,
                        size: 15,
                      ),
                      textColor: almostGrey,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //TODO:this Row need refactoring
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Time to go",
                            color: Colors.black,
                            fontSize: 14,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                CupertinoButton(
                                                  onPressed: () {
                                                    widget
                                                        .touristExploreController
                                                        .isBookingTimeSelected(
                                                            true);
                                                    setState(() {
                                                      Get.back();
                                                      time = newTime;
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
                                                initialDateTime: newTime,
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                use24hFormat: false,
                                                onDateTimeChanged:
                                                    (DateTime newT) {
                                                  print(DateFormat('HH:mm:ss')
                                                      .format(newTime));
                                                  setState(() {
                                                    newTime = newT;
                                                    //   print(newTime);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              height: height * 0.06,
                              width: width * 0.4,
                              title: !_touristExploreController
                                      .isBookingTimeSelected.value
                                  ? "00 :00 PM"
                                  : DateFormat('hh:mm a').format(newTime),
                              //  test,
                              borderColor: lightGreyColor,
                              prefixIcon: SvgPicture.asset(
                                "assets/icons/time_icon.svg",
                              ),
                              suffixIcon: Container(),
                              textColor: almostGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Return Time",
                            color: Colors.black,
                            fontSize: 14,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                CupertinoButton(
                                                  onPressed: () {
                                                    widget
                                                        .touristExploreController
                                                        .isBookingTimeSelected(
                                                            true);
                                                    setState(() {
                                                      Get.back();
                                                      time = newTime;
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
                                                initialDateTime: newTime,
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                use24hFormat: false,
                                                onDateTimeChanged:
                                                    (DateTime newT) {
                                                  print(DateFormat('HH:mm:ss')
                                                      .format(newTime));
                                                  setState(() {
                                                    returnTime = newT;
                                                    //   print(newTime);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              height: height * 0.06,
                              width: width * 0.4,
                              title: !_touristExploreController
                                      .isBookingTimeSelected.value
                                  ? "00 :00 PM"
                                  : DateFormat('hh:mm a').format(returnTime),
                              //  test,
                              borderColor: lightGreyColor,
                              prefixIcon: SvgPicture.asset(
                                "assets/icons/time_icon.svg",
                              ),
                              suffixIcon: Container(),
                              textColor: almostGrey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomText(
                    text: "guests2".tr,
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  Container(
                    height: 64,
                    width: 380,
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    margin: EdgeInsets.only(top: height * 0.02, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: lightGreyColor),
                    ),
                    child: Row(
                      children: [
                        CustomText(
                          text: "guests".tr,
                          fontWeight: FontWeight.w700,
                          color: textGreyColor,
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
                                print(selectedRide);
                              }
                            },
                            child: const Icon(Icons.horizontal_rule_outlined,
                                color: almostGrey)),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomText(
                          text: guestNum.toString(),
                          color: colorDarkGrey,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                print("widget.place!.visitors");
                                print(widget.place!.visitors);

                                guestNum = guestNum + 1;
                              });
                              if (selectedRide == 'van' && guestNum <= 10) {
                                selectedRide = "";
                              }
                              print(selectedRide);
                            },
                            child: const Icon(Icons.add, color: almostGrey)),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "forMoreThan10".tr,
                        fontSize: 10,
                        color: almostGrey,
                      )),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomText(
                    text: "pickUpLocation".tr,
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  //  Obx( () =>
                  Stack(
                    children: [
                      Container(
                        height: 130,
                        width: 320,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: lightGrey,
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
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomText(
                    text: "pickUpRide".tr,
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  pickupRide(),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          CustomText(
                            text: "startFrom".tr,
                            fontSize: 12,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          CustomText(
                            text: '${widget.place!.price} ${'sar'.tr}',
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          )
                        ],
                      ),
                      const Spacer(),
                      _touristExploreController.isBookingIsMaking.value ||
                              _touristExploreController.isPlaceIsLoading.value
                          ? const CircularProgressIndicator(
                              color: colorGreen,
                            )
                          : CustomButton(
                              title: "findLocal".tr,
                              onPressed: () async {
                                // Get.to(() => const FindAjwady());

                                if (_touristExploreController.isBookingDateSelected.value &&
                                    _touristExploreController
                                        .isBookingTimeSelected.value &&
                                    selectedRide != "") {
                                  _touristExploreController.isBookedMade(true);

                                  // AppUtil.successToast(
                                  //     context, 'TIME AND DATE IS SELECTED');

                                  //  Navigator.pop(context);
                                  if (widget.place != null) {
                                    final isSuccess =
                                        await _touristExploreController.bookPlace(
                                            placeId: widget.place!.id!,
                                            time:
                                                DateFormat(
                                                        'HH:mm:ss')
                                                    .format(newTime),
                                            date:
                                                _touristExploreController
                                                    .selectedDate.value
                                                    .substring(0, 10),
                                            guestNumber: guestNum,
                                            cost: guestNum *
                                                widget.place!.price!,
                                            lng:
                                                _touristExploreController
                                                    .pickUpLocLatLang
                                                    .value
                                                    .longitude
                                                    .toString(),
                                            lat: _touristExploreController
                                                .pickUpLocLatLang.value.latitude
                                                .toString(),
                                            vehicle: selectedRide,
                                            context: context);

                                    if (isSuccess) {
                                      Place? thePlace =
                                          await _touristExploreController
                                              .getPlaceById(
                                                  id: widget.place!.id!,
                                                  context: context);
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
                                    }
                                  }
                                } else {
                                  AppUtil.errorToast(
                                      context, 'bookingValidation'.tr);
                                }
                              },
                              icon: !AppUtil.rtlDirection(context)
                                  ? const Icon(Icons.arrow_back_ios)
                                  : const Icon(Icons.arrow_forward_ios),
                              customWidth: width * 0.53,
                            )
                    ],
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
            margin: EdgeInsets.only(left: 2),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (key == 'van' && guestNum > 10) {
                    selectedRide = key;
                  } else if (key != 'van') {
                    selectedRide = key;
                  }
                });
              },
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (key == 'van' && guestNum <= 10)
                        ? Colors.transparent
                        : selectedRide == key
                            ? colorGreen
                            : Colors.transparent,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: lightGreyColor.withOpacity(0.4),
                        blurRadius: 9,
                        spreadRadius: 8)
                  ],
                  color: (key == 'van' && guestNum <= 10)
                      ? lightGreyColor
                      : selectedRide == key
                          ? lightGreen
                          : Colors.white,
                ),
                child: Column(
                  children: [
                    Spacer(),
                    SvgPicture.asset(
                      selectedRide == key ? values[0] : values[1],
                      color: (key == 'van' && guestNum <= 10)
                          ? tileGreyColor
                          : null,
                    ),
                    Spacer(),
                    CustomText(
                      text: "$key".tr,
                      color: (key == 'van' && guestNum <= 10)
                          ? tileGreyColor
                          : selectedRide == key
                              ? colorGreen
                              : dividerColor,
                    )
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
