import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/bookmark.dart';
import 'package:ajwad_v4/profile/services/bookmark_services.dart';
import 'package:ajwad_v4/request/tourist/controllers/rating_controller.dart';
// import 'package:ajwad_v4/request/tourist/models/offer.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';
import 'package:ajwad_v4/reviews/allReviewsScreen.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_policy_sheet.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:ajwad_v4/widgets/read_more_widget.dart';
import 'package:ajwad_v4/widgets/sign_sheet.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../profile/models/profile.dart';
import '../../../request/ajwadi/controllers/request_controller.dart';
import '../../../request/tourist/view/booking_sheet.dart';
import '../../../request/tourist/view/local_offer_info.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({
    Key? key,
    this.fromAjwady = true,
    this.place,
    this.userLocation,
  }) : super(key: key);
  final bool fromAjwady;
  final Place? place;
  final UserLocation? userLocation;

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());

  final RequestController _RequestController = Get.put(RequestController());

  final _profileController = Get.put(ProfileController());
  final _rattingController = Get.put(RatingController());

  int _currentIndex = 0;
  var locLatLang = const LatLng(24.9470921, 45.9903698);
  bool isExpanded = false;
  RxBool isViewBooking = false.obs;
  RxBool lockPlaces = false.obs;
  // late List<Offer> offers;
  RxBool isHasOffers = false.obs;
  // late String offerId;

  //Place? thePlace;
  Booking? theBooking;

  Profile? theProfile;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  // void addCustomIcon() {
  //   BitmapDescriptor.fromAssetImage(
  //           const ImageConfiguration(), "assets/images/pin_marker.png")
  //       .then(
  //     (icon) {
  //       setState(() {
  //         markerIcon = icon;
  //       });
  //     },
  //   );
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // addCustomIcon();
    // AmplitudeService.initializeAmplitude();

    if (!AppUtil.isGuest() && _profileController.profile.id != '') {
      getOfferinfo();
      _profileController.bookmarkList(BookmarkService.getBookmarks());
      _profileController.isTourBookmarked(_profileController.bookmarkList
          .any((bookmark) => bookmark.id == widget.place!.id));
      // getPlaceBooking();
      _touristExploreController.isBookedMade(true);
    }
  }

  void getPlaceBooking() async {
    _touristExploreController.thePlace.value = await _touristExploreController
        .getPlaceById(id: widget.place!.id!, context: context);
    List<Booking>? bookingList =
        await _touristExploreController.getTouristBooking(context: context);

    if (bookingList != null && bookingList.isNotEmpty) {
      for (var booking in bookingList) {
        if (booking.place!.id == _touristExploreController.thePlace.value!.id) {
          isViewBooking.value = true;
          lockPlaces.value = true;
        }
      }
      // }
    }
  }

  void getOfferinfo() async {
    await _touristExploreController
        .getPlaceById(id: widget.place!.id!, context: context)
        .then((onValue) async {
      if (_touristExploreController.thePlace.value == null) {
        return;
      }
      if (_touristExploreController.thePlace.value!.booking!.isNotEmpty &&
          _touristExploreController
                  .thePlace.value!.booking!.first.orderStatus ==
              'PENDING') {
        isViewBooking.value = true;
        lockPlaces.value = true;
      } else if (_touristExploreController
              .thePlace.value!.booking!.isNotEmpty &&
          _touristExploreController
                  .thePlace.value!.booking!.first.orderStatus ==
              'ACCEPTED') {
        isHasOffers.value = true;

        isViewBooking.value = true;

        theProfile = await _profileController.getProfile(
            context: context,
            profileId: _touristExploreController
                    .thePlace.value!.booking!.first.profileId ??
                '');
      } else {
        isViewBooking.value = false;
      }
    });
  }

  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    log("Trip Details");
    return Scaffold(
        backgroundColor: widget.fromAjwady ? lightBlack : Colors.white,
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(
          '',
          color: Colors.white,
          iconColor: Colors.white,
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(right: 17, left: 17, bottom: width * 0.085),
              child: Obx(() => _RequestController.isBookingLoading.value ||
                      _touristExploreController.isPlaceIsLoading.value
                  ? const CircularProgressIndicator.adaptive()
                  : !AppUtil.isGuest() && isViewBooking.value
                      ? (isHasOffers.value
                          ? _RequestController.isRequestAcceptLoading.value
                              ? const CircularProgressIndicator.adaptive()
                              : CustomButton(
                                  onPressed: () async {
                                    theBooking =
                                        await _RequestController.getBookingById(
                                      context: context,
                                      bookingId: _touristExploreController
                                              .thePlace
                                              .value!
                                              .booking!
                                              .first
                                              .id ??
                                          '',
                                    );
                                    AmplitudeService.amplitude.track(BaseEvent(
                                      'Click on "View Your Request" button',
                                    ));
                                    Get.to(
                                      () => LocalOfferInfo(
                                        place: _touristExploreController
                                            .thePlace.value!,
                                        image: theProfile?.profileImage ?? '',
                                        name: theProfile?.name ?? '',
                                        profileId: theProfile?.id ?? '',
                                        userId: theProfile!.id ?? "",
                                        rating: theProfile?.tourRating ?? 0,
                                        price: 0,
                                        tripNumber: theProfile?.tourNumber ?? 0,
                                        booking: theBooking,
                                      ),
                                    );
                                  },
                                  title: AppUtil.rtlDirection2(context)
                                      ? "طلبك"
                                      : "Your Request",
                                  icon: AppUtil.rtlDirection2(context)
                                      ? const Icon(
                                          Icons.arrow_back_ios,
                                          size: 20,
                                        )
                                      : const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                        ),
                                )
                          : CustomButton(
                              onPressed: () async {
                                // Place? thePlace =
                                //     await _touristExploreController
                                //         .getPlaceById(
                                //             id: widget.place!.id!,
                                //             context: context);
                                // getOfferinfo();
                                Get.to(
                                  () => FindAjwady(
                                    booking: _touristExploreController
                                        .thePlace.value!.booking!.first,
                                    place: widget.place!,
                                    placeId: _touristExploreController
                                            .thePlace.value?.id ??
                                        '',
                                  ),
                                )?.then((value) async {
                                  return getOfferinfo();
                                });
                                AmplitudeService.amplitude.track(BaseEvent(
                                  'Click on "View Offers" button',
                                ));
                              },
                              title: AppUtil.rtlDirection2(context)
                                  ? "العروض"
                                  : "View Offers",
                              icon: AppUtil.rtlDirection2(context)
                                  ? const Icon(
                                      Icons.arrow_back_ios,
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
                            ))
                      : CustomButton(
                          onPressed: () {
                            if (AppUtil.isGuest()) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => const SignInSheet(),
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(width * 0.06),
                                        topRight:
                                            Radius.circular(width * 0.06)),
                                  ));
                            } else {
                              AmplitudeService.amplitude.track(
                                BaseEvent('Click on "Request" button'),
                              );
                              showModalBottomSheet(
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return BookingSheet(
                                      fromAjwady: false,
                                      place: widget.place,
                                      userLocation: widget.userLocation,
                                      touristExploreController:
                                          _touristExploreController,
                                    );
                                  }).then((value) {
                                getOfferinfo();
                                return;
                              });
                            }
                          },
                          // title: "buyTicket".tr,
                          title: AppUtil.rtlDirection2(context)
                              ? "اطلب"
                              : "Request",
                          icon: AppUtil.rtlDirection2(context)
                              ? const Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                )
                              : const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                ),
                        )),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Stack(children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => ViewTripImages(
                        tripImageUrl: widget.place!.image!,
                        fromNetwork: widget.place == null ? false : true,
                      ));
                },
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                      // enableInfiniteScroll: false,
                      height: height * 0.3,
                      viewportFraction: 1,
                      onPageChanged: (i, reason) {
                        setState(() {
                          _currentIndex = i;
                        });
                      }),
                  itemCount: widget.place!.image!.length,
                  itemBuilder: (context, index, realIndex) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16)),
                        child: ImageCacheWidget(
                          image: widget.place!.image![index],
                          //   fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: width * .061,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.051),
                child: SizedBox(
                  //here i fix the overflow

                  // height: height * 0.83,
                  child: Column(
                    children: [
                      Align(
                          alignment: AppUtil.rtlDirection2(context)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: CustomText(
                            text: widget.place == null
                                ? 'tuwaik'.tr
                                : AppUtil.rtlDirection2(context)
                                    ? widget.place!.nameAr!
                                    : widget.place!.nameEn!,
                            color: const Color(0xFF070708),
                            fontSize: width * 0.072,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          )),
                      SizedBox(
                        height: width * 0.015,
                      ),
                      Row(
                        children: [
                          RepaintBoundary(
                              child:
                                  SvgPicture.asset("assets/icons/map_pin.svg")),
                          SizedBox(
                            width: width * 0.015,
                          ),
                          CustomText(
                            text: widget.place != null
                                ? AppUtil.rtlDirection2(context)
                                    ? "${widget.place!.regionAr!}, المملكة العربية السعودية"
                                    : "${widget.place!.regionEn!}, Saudi Arabia"
                                : '',
                            color: starGreyColor,
                            fontSize: width * 0.03,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                          SizedBox(
                            width: width * 0.071,
                          ),
                          RepaintBoundary(
                              child: SvgPicture.asset('assets/icons/star.svg')),
                          SizedBox(
                            width: width * .0102,
                          ),
                          CustomText(
                            text: widget.place != null
                                ? widget.place!.rating.toString()
                                : '',
                            color: const Color(0xFF9392A0),
                            fontSize: width * 0.03,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: width * 0.046,
                      ),
                      Align(
                          alignment: AppUtil.rtlDirection2(context)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: CustomText(
                            text: AppUtil.rtlDirection2(context)
                                ? "نبذة عن الموقع"
                                : "About",
                            color: black,
                            fontSize: width * 0.044,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          )),
                      SizedBox(
                        height: width * 0.023,
                      ),
                      ReadMoreWidget(
                        text: widget.place == null
                            ? "******"
                            : AppUtil.rtlDirection2(context)
                                ? widget.place!.descriptionAr!
                                : widget.place!.descriptionEn!,
                      ),
                      SizedBox(
                        height: width * 0.026,
                      ),
                      const Divider(
                        color: lightGrey,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: width * 0.026,
                      ),
                      Align(
                        alignment: AppUtil.rtlDirection2(context)
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: CustomText(
                          text: AppUtil.rtlDirection2(context)
                              ? "الموقع"
                              : "Location".tr,
                          fontSize: width * 0.044,
                          fontWeight: FontWeight.w500,
                          color: black,
                          fontFamily: 'HT Rakik',
                        ),
                      ),
                      SizedBox(
                        height: width * 0.0230,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: almostGrey.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        height: height * 0.2,
                        width: width * 0.9,
                        child: GoogleMap(
                          scrollGesturesEnabled: false,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: widget.place == null
                                ? locLatLang
                                : LatLng(
                                    double.parse(
                                        widget.place!.coordinates!.latitude!),
                                    double.parse(
                                        widget.place!.coordinates!.longitude!)),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("marker1"),
                              position: widget.place == null
                                  ? locLatLang
                                  : LatLng(
                                      double.parse(
                                          widget.place!.coordinates!.latitude!),
                                      double.parse(widget
                                          .place!.coordinates!.longitude!)),
                              draggable: true,
                              onDragEnd: (value) {
                                // value is the new position
                              },
                              icon: markerIcon,
                            ),
                          },
                        ),
                      ),
                      SizedBox(
                        height: width * 0.026,
                      ),
                      const Divider(
                        color: lightGrey,
                      ),
                      SizedBox(
                        height: width * 0.026,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => CommonReviewsScreen(
                                id: widget.place!.id ?? '',
                                ratingType: 'PLACE',
                              ));
                        },
                        child: Align(
                            alignment: AppUtil.rtlDirection2(context)
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(
                        height: width * 0.028,
                      ),
                      const Divider(
                        color: lightGrey,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: width * 0.064,
                      ),
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(const CustomPloicySheet());
                        },
                        child: Align(
                            alignment: AppUtil.rtlDirection2(context)
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "cancellationPolicy".tr,
                                      color: const Color(0xFF070708),
                                      fontSize: width * 0.0461,
                                      fontFamily: 'HT Rakik',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      height: width * .015,
                                    ),
                                    SizedBox(
                                      width: width * 0.8,
                                      child: CustomText(
                                        text: "cancellationPolicyBreif".tr,
                                        fontSize: width * 0.038,
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
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
                                  color: starGreyColor,
                                  size: width * 0.046,
                                )
                              ],
                            )),
                      ),
                      SizedBox(
                        height: width * 0.028,
                      ),
                      const Divider(
                        color: lightGrey,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: width * 0.064,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          if (!AppUtil.isGuest() && _profileController.profile.id != '')
            Positioned(
              top: height * 0.066,
              right:
                  AppUtil.rtlDirection2(context) ? width * 0.85 : width * 0.09,
              height: 40,
              child: Obx(
                () => GestureDetector(
                  onTap: () {
                    _profileController.isTourBookmarked(
                        !_profileController.isTourBookmarked.value);
                    if (_profileController.isTourBookmarked.value) {
                      final bookmark = Bookmark(
                          isBookMarked: true,
                          id: widget.place!.id!,
                          titleEn: widget.place!.nameEn ?? "",
                          titleAr: widget.place!.nameAr ?? "",
                          image: widget.place!.image!.first,
                          type: 'tour');
                      BookmarkService.addBookmark(bookmark);
                    } else {
                      BookmarkService.removeBookmark(widget.place!.id!);
                    }
                  },
                  child: Container(
                      width: 35,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20000000298023224),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        _profileController.isTourBookmarked.value
                            ? "assets/icons/bookmark_fill.svg"
                            : "assets/icons/bookmark_icon.svg",
                        height: 28,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
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
                  count: widget.place!.image!.length >= 6
                      ? 6
                      : widget.place!.image!.length,
                ),
              ),
            ),
          ),
        ])));
  }
}
