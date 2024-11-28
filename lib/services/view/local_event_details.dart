import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/view/edit_event.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/bookmark.dart';
import 'package:ajwad_v4/profile/services/bookmark_services.dart';
import 'package:ajwad_v4/request/tourist/controllers/rating_controller.dart';
import 'package:ajwad_v4/reviews/allReviewsScreen.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/view/widgets/event_booking.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_aleart_widget.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/read_more_widget.dart';
import 'package:ajwad_v4/widgets/share_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';

import 'package:ajwad_v4/services/view/widgets/images_services_widget.dart';

import 'package:ajwad_v4/widgets/custom_policy_sheet.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LocalEventDetails extends StatefulWidget {
  const LocalEventDetails({
    Key? key,
    required this.eventId,
    this.isLocal = false,
    this.address = '',
    this.isHasBooking = false,
  }) : super(key: key);

  final String eventId;
  final bool isLocal;
  final String address;
  final bool isHasBooking;

  @override
  State<LocalEventDetails> createState() => _LocalEventDetailsState();
}

late double width, height;

class _LocalEventDetailsState extends State<LocalEventDetails> {
  final _eventController = Get.put(EventController());
  final _profileController = Get.put(ProfileController());
  final _rattingController = Get.put(RatingController());

  int _currentIndex = 0;
  bool isExpanded = false;
  bool isAviailable = false;
  List<DateTime> avilableDate = [];
  String address = '';
  var locLatLang = const LatLng(24.691846000000012, 46.68552199999999);

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

  late Event? event;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  initializeDateFormatting(); //very important
    getEventById();

    addCustomIcon();
  }

  void getEventById() async {
    event = (await _eventController.getEventById(
        context: context, id: widget.eventId));

    if (!widget.isLocal) {
      _fetchAddress(event!.coordinates!.latitude ?? '',
          event!.coordinates!.longitude ?? '');
    }
    for (var day in event!.daysInfo!) {
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

      _profileController.isEventBookmarked(_profileController.bookmarkList
          .any((bookmark) => bookmark.id == event!.id));
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
    } catch (e) {
      // Handle error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.of(context).size.height;

    return Obx(
      () => _eventController.isEventByIdLoading.value
          ? const Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: CustomAppBar(""),
              body: Center(child: CircularProgressIndicator.adaptive()),
            )
          : Scaffold(
              bottomNavigationBar: !widget.isLocal
                  ? SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(top: width * 0.025),
                        child: BottomEventBooking(
                          event: event!,
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
                            text: '${event!.price} ${'sar'.tr}',
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
                                  tripImageUrl: event!.image!,
                                  fromNetwork: true,
                                ));
                          },
                          child: event!.image!.isEmpty
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
                                  itemCount: event!.image!.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return ImagesServicesWidget(
                                      image: event!.image![index],
                                    );
                                  },
                                ),
                        ),
                        SizedBox(
                          height: height * 0.03,
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
                                    text: AppUtil.rtlDirection2(context)
                                        ? event!.nameAr ?? ''
                                        : event!.nameEn ?? '',
                                    fontSize: width * 0.07,
                                    fontWeight: FontWeight.w500,
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
                                            ? '${event!.regionAr}, ${widget.address}'
                                            : '${event!.regionEn}, ${widget.address}',
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
                              if (event!.daysInfo!.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/calendar.svg',
                                    ),
                                    SizedBox(
                                      width: width * 0.012,
                                    ),
                                    CustomText(
                                      text: AppUtil.formatSelectedDaysInfo(
                                          event!.daysInfo!, context),
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
                              if (event!.daysInfo!.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/Clock.svg",
                                      color: colorDarkGrey,
                                    ),
                                    SizedBox(
                                      width: width * 0.012,
                                    ),
                                    //time
                                    CustomText(
                                      text:
                                          '${AppUtil.formatTimeOnly(context, event!.daysInfo!.first.startTime)} -  ${AppUtil.formatTimeOnly(context, event!.daysInfo!.first.endTime)}',
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
                              ReadMoreWidget(
                                text: event == null
                                    ? "******"
                                    : AppUtil.rtlDirection2(context)
                                        ? event!.descriptionAr ?? ''
                                        : event!.descriptionEn ?? '',
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
                                    height: width * 0.5,
                                    width: width * 0.9,
                                    child: GoogleMap(
                                      scrollGesturesEnabled: false,
                                      zoomControlsEnabled: false,
                                      initialCameraPosition: CameraPosition(
                                        target: event == null
                                            ? locLatLang
                                            : LatLng(
                                                double.parse(event!
                                                    .coordinates!.latitude!),
                                                double.parse(event!
                                                    .coordinates!.longitude!)),
                                        zoom: 15,
                                      ),
                                      markers: {
                                        Marker(
                                          markerId: const MarkerId("marker1"),
                                          position: event == null
                                              ? locLatLang
                                              : LatLng(
                                                  double.parse(event!
                                                      .coordinates!.latitude!),
                                                  double.parse(event!
                                                      .coordinates!
                                                      .longitude!)),
                                          draggable: true,
                                          onDragEnd: (value) {
                                            // value is the new position
                                          },
                                          icon: markerIcon,
                                        ),
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: width * 0.028,
                              ),
                              const Divider(
                                color: lightGrey,
                              ),
                              SizedBox(
                                height: width * 0.025,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => CommonReviewsScreen(
                                        id: widget.eventId,
                                        ratingType: 'EVENT',
                                      ));
                                },
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
                                              text: '${"reviews".tr}',
                                              color: const Color(0xFF070708),
                                              fontSize: width * 0.0461,
                                              fontFamily: 'HT Rakik',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: starGreyColor,
                                          size: width * 0.046,
                                        )
                                      ],
                                    )),
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
                                SizedBox(
                                  height: width * 0.025,
                                ),
                                const Divider(
                                  color: lightGrey,
                                ),
                                SizedBox(
                                  height: width * 0.05,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.bottomSheet(
                                      const CustomPloicySheet(),
                                    );
                                  },
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
                                                fontSize: width * 0.046,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                height: width * 0.01,
                                              ),
                                              SizedBox(
                                                width: width * 0.8,
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
                        child: Row(
                          children: [
                            Obx(
                              () => GestureDetector(
                                onTap: () {
                                  _profileController.isEventBookmarked(
                                      !_profileController
                                          .isEventBookmarked.value);
                                  if (_profileController
                                      .isEventBookmarked.value) {
                                    final bookmark = Bookmark(
                                        isBookMarked: true,
                                        id: event!.id,
                                        titleEn: event!.nameEn ?? "",
                                        titleAr: event!.nameAr ?? "",
                                        image: event!.image!.first,
                                        type: 'event');
                                    BookmarkService.addBookmark(bookmark);
                                  } else {
                                    BookmarkService.removeBookmark(event!.id);
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
                                      _profileController.isEventBookmarked.value
                                          ? "assets/icons/bookmark_fill.svg"
                                          : "assets/icons/bookmark_icon.svg",
                                      height: 28,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.0205,
                            ),
                            ShareWidget(
                              id: event!.id,
                              type: 'event',
                            )
                          ],
                        ),
                      ),
                    ],
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
                    if (widget.isLocal)
                      Positioned(
                          top: height * 0.066,
                          right: AppUtil.rtlDirection2(context)
                              ? width * 0.82
                              : width * 0.072,
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
                                          Get.to(EditEvent(eventObj: event!));
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
                                id: event!.id,
                                type: 'event',
                              )
                            ],
                          )),
                    // Positioned(
                    //     top: height * 0.265,
                    //     right: width * 0.1,
                    //     left: width * 0.1,
                    //     // local profile
                    //     child: ServicesProfileCard(
                    //       onTap: () {
                    //         Get.to(() => ServicesLocalInfo(profileId: event!.id));
                    //       },
                    //       image: event!.user!.profileImage ?? '',
                    //       name: event!.user!.name ?? '',
                    //     )),
                    //indicator
                    Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: height * 0.26,
                          ), // Set the top padding to control vertical position
                          child: AnimatedSmoothIndicator(
                            effect: WormEffect(
                              // dotColor: starGreyColor,
                              dotWidth: width * 0.030,
                              dotHeight: width * 0.030,
                              activeDotColor: Colors.white,
                            ),
                            activeIndex: _currentIndex,
                            count: event!.image!.length >= 6
                                ? 6
                                : event!.image!.length,
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
