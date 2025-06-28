import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/view/edit_hospitality.dart';
import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/bookmark.dart';
import 'package:ajwad_v4/profile/services/bookmark_services.dart';
import 'package:ajwad_v4/request/tourist/controllers/rating_controller.dart';
import 'package:ajwad_v4/reviews/allReviewsScreen.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/service_local_info.dart';
import 'package:ajwad_v4/services/view/widgets/images_services_widget.dart';
import 'package:ajwad_v4/services/view/widgets/service_profile_card.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_aleart_widget.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_policy_sheet.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/floating_booking_button.dart';
import 'package:ajwad_v4/widgets/read_more_widget.dart';
import 'package:ajwad_v4/widgets/share_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  final _profileController = Get.put(ProfileController());
  // final _rattingController = Get.put(RatingController());

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

  Hospitality? hospitalityObj;
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

    if (hospitalityObj?.daysInfo != null &&
        hospitalityObj!.daysInfo.isNotEmpty) {
      _servicesController.startTime(hospitalityObj!.daysInfo.first.startTime);
    }
    if (!widget.isLocal) {
      _fetchAddress(hospitalityObj!.coordinate.latitude ?? '',
          hospitalityObj!.coordinate.longitude ?? '');

      if (hospitalityObj!.booking != null) {
        hideLocation = hospitalityObj!.booking!.isEmpty;
      }
    }
    for (var day in hospitalityObj!.daysInfo) {
      if (AppUtil.isDateTimeBefore24Hours(day.startTime)) {
        avilableDate.add(
          DateTime.parse(
            day.startTime.substring(0, 10),
          ),
        );
      }
    }

    if (!AppUtil.isGuest() &&
        _profileController.profile.id != '' &&
        !widget.isLocal) {
      _profileController.bookmarkList(BookmarkService.getBookmarks());
      _profileController.isHospitaltyBookmarked(_profileController.bookmarkList
          .any((bookmark) => bookmark.id == hospitalityObj!.id));
    }
  }

  Future<String> _getAddressFromLatLng(
      double position1, double position2) async {
    try {
      String languageCode = Get.locale?.languageCode == 'ar' ? 'ar' : 'en';
      String countryCode = languageCode == 'ar'
          ? 'SA'
          : 'US'; // Assuming Saudi Arabia for Arabic and US for English
      String lang = '${languageCode}_$countryCode';

      List<Placemark> placemarks = await placemarkFromCoordinates(
          position1, position2,
          localeIdentifier: lang);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        if (placemark.subLocality!.isNotEmpty &&
            placemark.locality!.isNotEmpty) {
          return '${placemark.locality}, ${placemark.subLocality}';
        } else {
          if (placemark.locality!.isNotEmpty) {
            return '${placemark.locality}, ${placemark.administrativeArea}';
          } else if (placemark.subLocality!.isNotEmpty)
            return '${placemark.subLocality}, ${placemark.administrativeArea}';
          else
            return '${placemark.administrativeArea}, ${placemark.thoroughfare}';
        }
      }
    } catch (e) {}
    return '';
  }

  Future<void> _fetchAddress(String position1, String position2) async {
    try {
      String result = await _getAddressFromLatLng(
          double.parse(position1), double.parse(position2));
      setState(() {
        address = result;
      });
      log(address);
    } catch (e) {
      // Handle error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
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
              bottomNavigationBar:
                  !widget.isLocal && hospitalityObj!.status != 'CLOSED'
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
                          child: hospitalityObj!.images.isEmpty
                              ? Image.asset(
                                  'assets/images/Placeholder.png',
                                  height: height * 0.3,
                                  fit: BoxFit.cover,
                                )
                              : CarouselSlider.builder(
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
                              Row(
                                children: [
                                  Align(
                                      alignment: AppUtil.rtlDirection2(context)
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: CustomText(
                                        text: AppUtil.rtlDirection2(context)
                                            ? hospitalityObj!.titleAr
                                            : hospitalityObj!.titleEn,
                                        fontSize: width * 0.07,
                                        fontWeight: FontWeight.w700,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                      )),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => CommonReviewsScreen(
                                            id: widget.hospitalityId,
                                            ratingType: 'HOSPITALITY',
                                          ));
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/star.svg',
                                          //  color: black,
                                        ),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        //  if (!AppUtil.rtlDirection2(context))
                                        CustomText(
                                          text:
                                              hospitalityObj!.rating.toString(),
                                          fontSize: width * 0.03,
                                          fontWeight: FontWeight.w500,
                                          color: black,
                                          fontFamily:
                                              AppUtil.SfFontType(context),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
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
                                        ? address.isEmpty
                                            ? AppUtil.rtlDirection2(context)
                                                ? '${hospitalityObj!.regionAr}'
                                                : hospitalityObj!.regionEn
                                            : address
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
                                    fontSize: width * 0.043,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'HT Rakik',
                                  )),
                              SizedBox(
                                height: width * 0.025,
                              ),
                              Align(
                                alignment: AppUtil.rtlDirection2(context)
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: ReadMoreWidget(
                                  text: hospitalityObj == null
                                      ? "******"
                                      : AppUtil.rtlDirection2(context)
                                          ? hospitalityObj!.bioAr
                                          : hospitalityObj!.bioEn,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.012,
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
                              if (hospitalityObj != null &&
                                  (hospitalityObj!.priceIncludesAr.isNotEmpty &&
                                      hospitalityObj!
                                          .priceIncludesEn.isNotEmpty &&
                                      hospitalityObj!
                                          .priceIncludesZh.isNotEmpty)) ...[
                                Align(
                                    alignment: AppUtil.rtlDirection2(context)
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: CustomText(
                                      text: "priceInclude".tr,
                                      fontSize: width * 0.043,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'HT Rakik',
                                    )),
                                SizedBox(
                                  height: width * 0.021,
                                ),
                                Align(
                                  alignment: AppUtil.rtlDirection2(context)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: (AppUtil.rtlDirection2(context)
                                            ? hospitalityObj!.priceIncludesAr
                                            : hospitalityObj!.priceIncludesEn)
                                        .map((item) => Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(width: width * 0.021),
                                                CustomText(
                                                  text: '•   $item',
                                                  fontSize: width * 0.039,
                                                  fontFamily:
                                                      AppUtil.SfFontType(
                                                          context),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.012,
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
                              ],
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
                                    fontSize: width * 0.043,
                                    fontWeight: FontWeight.w500,
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
                                          markerId: const MarkerId("marker1"),
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
                              SizedBox(
                                height: width * 0.028,
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
                                // if (hideLocation)
                                SizedBox(
                                  height: width * 0.028,
                                ),
                                const Divider(
                                  color: lightGrey,
                                ),
                                SizedBox(
                                  height: width * 0.051,
                                ),
                                InkWell(
                                  onTap: () => Get.bottomSheet(
                                      const CustomPloicySheet()),
                                  child: Align(
                                      alignment: AppUtil.rtlDirection2(context)
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
                                                  fontSize: width * 0.038,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      AppUtil.rtlDirection2(
                                                              context)
                                                          ? 'SF Arabic'
                                                          : 'SF Pro',
                                                  color: starGreyColor,
                                                  maxlines: 1,
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
                                SizedBox(
                                  height: width * 0.025,
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
                    if (!widget.isLocal && !AppUtil.isGuest()) ...[
                      Positioned(
                        top: height * 0.066,
                        right: AppUtil.rtlDirection2(context)
                            ? width * 0.75
                            : width * 0.072,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _profileController.isHospitaltyBookmarked(
                                      !_profileController
                                          .isHospitaltyBookmarked.value);
                                  if (_profileController
                                      .isHospitaltyBookmarked.value) {
                                    final bookmark = Bookmark(
                                        isBookMarked: true,
                                        id: hospitalityObj!.id,
                                        titleEn: hospitalityObj!.titleEn ?? "",
                                        titleAr: hospitalityObj!.titleAr ?? "",
                                        image: hospitalityObj!.images.first,
                                        type: 'hospitality');
                                    BookmarkService.addBookmark(bookmark);
                                    // AppUtil.successToast(
                                    //     context, 'Added to bookmarks');
                                  } else {
                                    BookmarkService.removeBookmark(
                                        hospitalityObj!.id);
                                    // AppUtil.successToast(
                                    //     context, 'Removed from bookmarks');
                                  }
                                },
                                child: Container(
                                  width: 35,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                        .withOpacity(0.20000000298023224),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    _profileController
                                            .isHospitaltyBookmarked.value
                                        ? "assets/icons/bookmark_fill.svg"
                                        : "assets/icons/bookmark_icon.svg",
                                    height: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              ShareWidget(
                                id: hospitalityObj!.id,
                                type: 'hospitality',
                                title: hospitalityObj!.titleEn,
                                description: hospitalityObj!.bioEn,
                                image: hospitalityObj!.images[0],
                                validTo: (hospitalityObj?.daysInfo != null &&
                                        hospitalityObj!.daysInfo.isNotEmpty)
                                    ? hospitalityObj!.daysInfo.last.endTime
                                    : '',
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (widget.isLocal)
                      Positioned(
                          top: height * 0.066,
                          right: AppUtil.rtlDirection2(context)
                              ? width * 0.75
                              //  ? width * 0.82
                              : width * 0.065,
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: widget.isHasBooking
                                      ? () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const CustomAlertDialog();
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
                                  )),
                              SizedBox(
                                width: width * 0.0205,
                              ),
                              ShareWidget(
                                id: hospitalityObj!.id,
                                type: 'hospitality',
                                title: hospitalityObj!.titleEn,
                                description: hospitalityObj!.bioEn,
                                image: hospitalityObj!.images[0],
                                validTo: (hospitalityObj?.daysInfo != null &&
                                        hospitalityObj!.daysInfo.isNotEmpty)
                                    ? hospitalityObj!.daysInfo[0].endTime
                                    : "",
                              )
                            ],
                          )),

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
                    if (!widget.isLocal && !AppUtil.isGuest())
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
                    Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top:
                                !widget.isLocal ? height * 0.24 : height * 0.26,
                          ), // Set the top padding to control vertical position
                          child: AnimatedSmoothIndicator(
                            effect: WormEffect(
                              // dotColor: starGreyColor,
                              dotWidth: width * 0.030,
                              dotHeight: width * 0.030,
                              activeDotColor: Colors.white,
                            ),
                            activeIndex: _currentIndex,
                            count: hospitalityObj!.images.length >= 6
                                ? 6
                                : hospitalityObj!.images.length,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
