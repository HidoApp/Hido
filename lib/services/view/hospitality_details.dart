import 'dart:developer';

import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/view/edit_hospitality.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';
import 'package:ajwad_v4/request/tourist/view/local_offer_info.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/service_local_info.dart';
import 'package:ajwad_v4/services/view/widgets/images_services_widget.dart';
import 'package:ajwad_v4/services/view/widgets/reservation_details_sheet.dart';
import 'package:ajwad_v4/services/view/widgets/hospitality_booking_sheet.dart';
import 'package:ajwad_v4/services/view/widgets/service_profile_card.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_aleart_widget.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_policy_sheet.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/floating_booking_button.dart';
import 'package:ajwad_v4/widgets/home_icons_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'review_hospitalty_screen.dart';

class HospitalityDetails extends StatefulWidget {
  const HospitalityDetails(
      {Key? key,
      required this.hospitalityId,
      this.isLocal = false,
      this.experienceType = '',
      this.address = '',
      this.isHasBooking = false})
      : super(key: key);

  final String hospitalityId;
  final bool isLocal;
  final String experienceType;
  final String address;
  final bool isHasBooking;

  @override
  State<HospitalityDetails> createState() => _HospitalityDetailsState();
}

late double width, height;

class _HospitalityDetailsState extends State<HospitalityDetails> {
  final _servicesController = Get.put(HospitalityController());
  int _currentIndex = 0;
  bool isExpanded = false;
  bool isAviailable = false;
  List<DateTime> avilableDate = [];
  var locLatLang = const LatLng(24.691846000000012, 46.68552199999999);
  String address = '';
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
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

  late Hospitality? hospitalityObj;
  var hideLocation = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //    initializeDateFormatting(); //very important

    addCustomIcon();
    getHospitalityById();

    _servicesController.isHospatilityDateSelcted(false);
    _servicesController.selectedDate('');
    _servicesController.selectedDateIndex(-1);
  }

  void getHospitalityById() async {
    hospitalityObj = (await _servicesController.getHospitalityById(
        context: context, id: widget.hospitalityId));

    if (hospitalityObj!.booking != null) {
      hideLocation = hospitalityObj!.booking!.isEmpty;
    }
    for (var day in hospitalityObj!.daysInfo) {
      print(day.startTime);
      if (AppUtil.isDateTimeBefore24Hours(day.startTime))
        avilableDate.add(
          DateTime.parse(
            day.startTime.substring(0, 10),
          ),
        );
    }

    if (!widget.isLocal) {
      _fetchAddress(hospitalityObj!.coordinate!.latitude ?? '',
          hospitalityObj!.coordinate!.longitude ?? '');
    }
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
        return '${placemark.locality}, ${placemark.subLocality}';
      }
    } catch (e) {
      print("Error retrieving address: $e");
    }
    return '';
  }

  Future<void> _fetchAddress(String position1, String position2) async {
    try {
      String result = await _getAddressFromLatLng(
          double.parse(position1), double.parse(position2));
      setState(() {
        address = result;
      });
    } catch (e) {
      // Handle error if necessary
      print('Error fetching address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Obx(
      () => _servicesController.isHospitalityByIdLoading.value
          ? const Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: CustomAppBar(""),
              body: Center(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
            )
          : Scaffold(
              bottomNavigationBar: !widget.isLocal
                  ? SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(top: width * 0.025),
                        child: BottomHospitalityBooking(
                          hospitalityObj: hospitalityObj!,
                          servicesController: _servicesController,
                          avilableDate: avilableDate,
                          address: address,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          right: 17, left: 17, bottom: width * 0.085),
                      child: Row(
                        children: [
                          CustomText(
                            text: "pricePerPerson".tr,
                            fontSize: width * 0.038,
                            color: colorDarkGrey,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                          ),
                          CustomText(
                            text: " /  ",
                            fontWeight: FontWeight.w900,
                            fontSize: width * 0.043,
                            color: Colors.black,
                          ),
                          CustomText(
                            text: '${hospitalityObj!.price} ${'sar'.tr}',
                            fontWeight: FontWeight.w900,
                            fontSize: width * 0.043,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                          ),
                        ],
                      ),
                    ),
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              persistentFooterAlignment: AlignmentDirectional.bottomCenter,
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // images widget on top of screen
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ViewTripImages(
                                  tripImageUrl: hospitalityObj!.images,
                                  fromNetwork: true,
                                ));
                          },
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                                height: height * 0.3,
                                viewportFraction: 1,
                                onPageChanged: (i, reason) {
                                  setState(() {
                                    _currentIndex = i;
                                  });
                                }),
                            itemCount: hospitalityObj!.images.length,
                            itemBuilder: (context, index, realIndex) {
                              return ImagesServicesWidget(
                                image: hospitalityObj!.images[index],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: width * 0.10,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Column(
                            children: [
                              Align(
                                  alignment: AppUtil.rtlDirection2(context)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: CustomText(
                                    text: !AppUtil.rtlDirection(context)
                                        ? hospitalityObj!.titleAr
                                        : hospitalityObj!.titleEn,
                                    fontSize: width * 0.07,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                  )),
                              SizedBox(
                                height: width * 0.025,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/map_pin.svg",
                                  ),
                                  SizedBox(
                                    width: width * 0.012,
                                  ),
                                  CustomText(
                                    text: !widget.isLocal
                                        ? address
                                        : AppUtil.rtlDirection2(context)
                                            ? '${hospitalityObj!.regionAr}, ${widget.address}'
                                            : '${hospitalityObj!.regionEn}, ${widget.address}',
                                    color: colorDarkGrey,
                                    fontSize: width * 0.038,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: width * 0.01,
                              ),
                              if (hospitalityObj!.daysInfo.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/Clock.svg",
                                    ),
                                    SizedBox(
                                      width: width * .012,
                                    ),
                                    CustomText(
                                      text:
                                          '${'From'.tr}  ${AppUtil.formatTimeWithLocale(context, hospitalityObj!.daysInfo[0].startTime, 'hh:mm a')} ${'To'.tr}  ${AppUtil.formatTimeWithLocale(context, hospitalityObj!.daysInfo[0].endTime, 'hh:mm a')}',
                                      color: colorDarkGrey,
                                      fontSize: width * 0.038,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: width * 0.01,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/meal.svg",
                                  ),
                                  SizedBox(
                                    width: width * 0.012,
                                  ),
                                  CustomText(
                                    text: AppUtil.rtlDirection2(context)
                                        ? hospitalityObj!.mealTypeAr
                                        : AppUtil.capitalizeFirstLetter(
                                            hospitalityObj!.mealTypeEn),
                                    color: colorDarkGrey,
                                    fontSize: width * 0.038,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: width * 0.025,
                              ),
                              SizedBox(
                                height: width * 0.012,
                              ),
                              Align(
                                  alignment: AppUtil.rtlDirection2(context)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: CustomText(
                                    text: "about".tr,
                                    fontSize: width * 0.046,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'HT Rakik',
                                  )),
                              SizedBox(
                                height: width * 0.025,
                              ),
                              Align(
                                alignment: AppUtil.rtlDirection2(context)
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: ConstrainedBox(
                                  constraints: isExpanded
                                      ? const BoxConstraints()
                                      : BoxConstraints(
                                          maxHeight: width * 0.097),
                                  child: CustomText(
                                      //   textAlign: AppUtil.rtlDirection(context) ? TextAlign.end : TextAlign.start ,
                                      textDirection:
                                          AppUtil.rtlDirection(context)
                                              ? TextDirection.ltr
                                              : TextDirection.rtl,
                                      textOverflow: isExpanded
                                          ? TextOverflow.visible
                                          : TextOverflow.clip,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                      fontSize: width * 0.038,
                                      color: starGreyColor,
                                      text: !AppUtil.rtlDirection(context)
                                          ? hospitalityObj!.bioAr
                                          : hospitalityObj!.bioEn),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.012,
                              ),
                              isExpanded
                                  ? Align(
                                      alignment: AppUtil.rtlDirection2(context)
                                          ? Alignment.bottomRight
                                          : Alignment.bottomLeft,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() => isExpanded = false);
                                        },
                                        child: CustomText(
                                          textDirection:
                                              AppUtil.rtlDirection2(context)
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                          text: AppUtil.rtlDirection2(context)
                                              ? "القليل"
                                              : "Show less",
                                          fontFamily:
                                              AppUtil.rtlDirection2(context)
                                                  ? 'SF Arabic'
                                                  : 'SF Pro',
                                          color: blue,
                                        ),
                                      ),
                                    )
                                  : Align(
                                      alignment: AppUtil.rtlDirection2(context)
                                          ? Alignment.bottomRight
                                          : Alignment.bottomLeft,
                                      child: GestureDetector(
                                        onTap: () =>
                                            setState(() => isExpanded = true),
                                        child: CustomText(
                                          textDirection:
                                              AppUtil.rtlDirection2(context)
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                          text: "readMore".tr,
                                          fontFamily:
                                              AppUtil.rtlDirection2(context)
                                                  ? 'SF Arabic'
                                                  : 'SF Pro',
                                          color: blue,
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: width * 0.025,
                              ),
                              const Divider(
                                color: lightGrey,
                              ),
                              SizedBox(
                                height: width * 0.025,
                              ),
                              Align(
                                  alignment: AppUtil.rtlDirection2(context)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: CustomText(
                                    text: !widget.isLocal
                                        ? "whereWeWillBe".tr
                                        : AppUtil.rtlDirection2(context)
                                            ? 'الموقع'
                                            : 'Location',
                                    fontSize: width * 0.046,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'HT Rakik',
                                  )),
                              SizedBox(
                                height: width * 0.025,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: almostGrey.withOpacity(0.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(width * 0.051)),
                                    ),
                                    height: height * 0.2,
                                    width: width * 0.9,
                                    child: GoogleMap(
                                      scrollGesturesEnabled: false,
                                      zoomControlsEnabled: false,
                                      initialCameraPosition: CameraPosition(
                                        target: hospitalityObj == null
                                            ? locLatLang
                                            : LatLng(
                                                double.parse(hospitalityObj!
                                                    .coordinate.latitude!),
                                                double.parse(hospitalityObj!
                                                    .coordinate.longitude!)),
                                        zoom: 15,
                                      ),
                                      markers: {
                                        Marker(
                                          markerId: MarkerId("marker1"),
                                          position: hospitalityObj == null
                                              ? locLatLang
                                              : LatLng(
                                                  double.parse(hospitalityObj!
                                                      .coordinate.latitude!),
                                                  double.parse(hospitalityObj!
                                                      .coordinate.longitude!)),
                                          draggable: true,
                                          onDragEnd: (value) {
                                            // value is the new position
                                          },
                                          icon: markerIcon,
                                        ),
                                      },
                                    ),
                                  ),
                                  if (!widget.isLocal)
                                    if (hideLocation)
                                      Container(
                                        height: height * 0.2,
                                        width: width * 0.9,
                                        color: textGreyColor.withOpacity(0.7),
                                        child: Center(
                                          child: CustomText(
                                            text:
                                                'locationWillBeAvailableAfterBooking'
                                                    .tr,
                                            fontFamily:
                                                AppUtil.rtlDirection2(context)
                                                    ? 'SF Arabic'
                                                    : 'SF Pro',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                              if (widget.isLocal) ...[
                                SizedBox(
                                  height: width * 0.028,
                                ),
                                const Divider(
                                  color: lightGrey,
                                ),
                                SizedBox(
                                  height: width * 0.038,
                                ),
                              ],
                              if (!widget.isLocal) ...[
                                if (hideLocation)
                                  SizedBox(
                                    height: width * 0.025,
                                  ),
                                const Divider(
                                  color: lightGrey,
                                ),
                                SizedBox(
                                  height: width * 0.051,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.bottomSheet(
                                      const CustomPloicySheet(),
                                    );
                                  },
                                  child: Align(
                                      alignment: !AppUtil.rtlDirection(context)
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: "cancellationPolicy".tr,
                                                fontSize: width * 0.0461,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'HT Rakik',
                                              ),
                                              SizedBox(
                                                height: width * 0.010,
                                              ),
                                              SizedBox(
                                                width: width * 0.83,
                                                child: CustomText(
                                                  text:
                                                      "cancellationPolicyBreifAdventure"
                                                          .tr,
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.w400,
                                                  maxlines: 2,
                                                  color: tileGreyColor,
                                                  fontFamily:
                                                      AppUtil.rtlDirection2(
                                                              context)
                                                          ? 'SF Arabic'
                                                          : 'SF Pro',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: tileGreyColor,
                                            size: width * 0.046,
                                          )
                                        ],
                                      )),
                                ),
                                const Divider(
                                  color: lightGrey,
                                ),
                              ],
                            ],
                          ),
                        )
                      ],
                    ),
                    if (!widget.isLocal)
                      Positioned(
                        top: height * 0.066,
                        right: AppUtil.rtlDirection2(context)
                            ? width * 0.82
                            : width * 0.072,
                        child: Container(
                            width: 35,
                            height: 36,
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withOpacity(0.20000000298023224),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              "assets/icons/white_bookmark.svg",
                              height: 28,
                            )),
                      ),
                    if (widget.isLocal)
                      Positioned(
                          top: height * 0.066,
                          right: AppUtil.rtlDirection2(context)
                              ? width * 0.82
                              : width * 0.072,
                          child: GestureDetector(
                              onTap: widget.isHasBooking
                                  ? () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomAlertDialog();
                                        },
                                      );
                                    }
                                  : () {
                                      Get.to(() => EditHospitality(
                                          hospitalityObj: hospitalityObj!,
                                          experienceType:
                                              widget.experienceType));
                                    },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(0.20000000298023224),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/icons/editPin.svg',
                                  height: 28,
                                  color: Colors.white,
                                ),
                              ))),

                    Positioned(
                      top: height * 0.06,
                      left: AppUtil.rtlDirection2(context)
                          ? width * 0.82
                          : width * 0.06,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            textDirection: AppUtil.rtlDirection2(context)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            size: 20,
                            color: Colors.white),
                        onPressed: () => Get.back(),
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                        top: height * 0.265,
                        right: width * 0.1,
                        left: width * 0.1,
                        // local profile
                        child: ServicesProfileCard(
                          onTap: () {
                            Get.to(
                              () => ServicesLocalInfo(
                                  isHospitality: true,
                                  profileId: hospitalityObj!.userId),
                            );
                          },
                          image: hospitalityObj!.user.profile.image,
                          name: hospitalityObj!.user.profile.name,
                        )),
                    //indicator
                    Positioned(
                      top: height * 0.22,
                      left: width * 0.3,
                      right: width * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: hospitalityObj!.images.map((imageUrl) {
                          int index = hospitalityObj!.images.indexOf(imageUrl);
                          return Container(
                            width: width * 0.025,
                            height: width * 0.025,
                            margin: EdgeInsets.symmetric(
                                vertical: width * 0.025,
                                horizontal: width * 0.005),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? hospitalityObj!.images.length == 1
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.white
                                  : Colors.white.withOpacity(0.8),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
