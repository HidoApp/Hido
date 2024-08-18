import 'dart:developer';

import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
// import 'package:ajwad_v4/request/tourist/models/offer.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/StackWidgets.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_policy_sheet.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/home_icons_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../profile/models/profile.dart';
import '../../../request/ajwadi/controllers/request_controller.dart';
import '../../../request/tourist/view/booking_sheet.dart';
import '../../../request/tourist/view/local_offer_info.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({
    Key? key,
    this.fromAjwady = true,
    this.place,
    required this.distance,
    this.userLocation,
  }) : super(key: key);
  final bool fromAjwady;
  final Place? place;
  final double distance;
  final UserLocation? userLocation;

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

late double width, height;

class _TripDetailsState extends State<TripDetails> {
  final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());

  final RequestController _RequestController = Get.put(RequestController());

  final _profileController = Get.put(ProfileController());

  final List<String> _tripUrlImages = [
    'assets/images/twaik_image.png',
    'assets/images/twaik_image2.png',
    'assets/images/twaik_image3.png',
    'assets/images/twaik_image4.png',
    'assets/images/twaik_image5.png'
  ];

  final List<String> _ajwadiUrlImages = [
    'assets/images/ajwadi1.png',
    'assets/images/ajwadi2.png',
    'assets/images/ajwadi3.png',
    'assets/images/ajwadi4.png',
    'assets/images/ajwadi5.png',
  ];

  int _currentIndex = 0;
  var locLatLang = const LatLng(24.9470921, 45.9903698);
  bool isExpanded = false;
  RxBool isViewBooking = false.obs;
  RxBool lockPlaces = false.obs;
  // late List<Offer> offers;
  RxBool isHasOffers = false.obs;
  // late String offerId;

  Place? thePlace;
  Booking? theBooking;

  Profile? theProfile;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addCustomIcon();
    getOfferinfo();

    // getPlaceBooking();
    _touristExploreController.isBookedMade(true);
  }

  void getPlaceBooking() async {
    thePlace = await _touristExploreController.getPlaceById(
        id: widget.place!.id!, context: context);
    List<Booking>? bookingList =
        await _touristExploreController.getTouristBooking(context: context);

    if (bookingList != null && bookingList.isNotEmpty) {
      for (var booking in bookingList) {
        if (booking.place!.id == thePlace!.id) {
          isViewBooking.value = true;
          lockPlaces.value = true;
        }
      }
      // }
    }
  }

  void getOfferinfo() async {
    thePlace = await _touristExploreController.getPlaceById(
        id: widget.place!.id!, context: context);

    if (thePlace!.booking!.length != 0 &&
        thePlace!.booking!.first.orderStatus == 'PENDING') {
      isViewBooking.value = true;
      lockPlaces.value = true;
    } else if (thePlace!.booking!.length != 0 &&
        thePlace!.booking!.first.orderStatus == 'ACCEPTED') {
      isHasOffers.value = true;

      isViewBooking.value = true;

      theProfile = await _profileController.getProfile(
          context: context,
          profileId: thePlace!.booking!.first.profileId ?? '');
    } else {
      isViewBooking.value = false;
    }
  }

  // }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: widget.fromAjwady ? lightBlack : Colors.white,
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(
          '',
          color: Colors.white,
          iconColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Stack(children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => ViewTripImages(
                        tripImageUrl: widget.place == null
                            ? _tripUrlImages
                            : widget.place!.image!,
                        fromNetwork: widget.place == null ? false : true,
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
                  itemCount: widget.place == null
                      ? _tripUrlImages.length
                      : widget.place!.image!.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: widget.place == null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16)),
                              child: Image.asset(
                                _tripUrlImages[0],
                                fit: BoxFit.fill,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16)),
                              child: Image.network(
                                widget.place!.image![index],
                                fit: BoxFit.cover,
                              ),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  //here i fix the overflow

                  // height: height * 0.83,
                  child: Column(
                    children: [
                      Align(
                          alignment: !AppUtil.rtlDirection(context)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: CustomText(
                            text: widget.place == null
                                ? 'tuwaik'.tr
                                : !AppUtil.rtlDirection(context)
                                    ? widget.place!.nameAr!
                                    : widget.place!.nameEn!,
                            color: Color(0xFF070708),
                            fontSize: width * 0.072,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/map_pin.svg"),
                          SizedBox(
                            width: width * 0.015,
                          ),
                          CustomText(
                            text: widget.place != null
                                ? !AppUtil.rtlDirection(context)
                                    ? widget.place!.regionAr! +
                                        ", المملكة العربية السعودية"
                                    : widget.place!.regionEn! + ", Saudi Arabia"
                                : '',
                            color: starGreyColor,
                            fontSize: width * 0.03,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                          const SizedBox(
                            width: 28,
                          ),
                          SvgPicture.asset("assets/icons/Rating.svg"),
                          const SizedBox(
                            width: 4,
                          ),
                          CustomText(
                            text: widget.place != null
                                ? widget.place!.rating.toString()
                                : '',
                            color: Color(0xFF9392A0),
                            fontSize: width * 0.03,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),
                      Align(
                          alignment: !AppUtil.rtlDirection(context)
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
                      Align(
                        alignment: AppUtil.rtlDirection2(context)
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: isExpanded
                              ? const BoxConstraints()
                              : BoxConstraints(maxHeight: width * 0.2),
                          child: CustomText(
                              textDirection: AppUtil.rtlDirection(context)
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              textOverflow: isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.clip,
                              fontSize: width * 0.038,
                              color: starGreyColor,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w400,
                              text: widget.place == null
                                  ? "******"
                                  : !AppUtil.rtlDirection(context)
                                      ? widget.place!.descriptionAr!
                                      : widget.place!.descriptionEn!),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
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
                                  textDirection: AppUtil.rtlDirection2(context)
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  text: AppUtil.rtlDirection2(context)
                                      ? "القليل"
                                      : "Show less",
                                  color: blue,
                                  fontSize: 15,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          : Align(
                              alignment: AppUtil.rtlDirection2(context)
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                              child: GestureDetector(
                                onTap: () => setState(() => isExpanded = true),
                                child: CustomText(
                                  textDirection: AppUtil.rtlDirection2(context)
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  text: "readMore".tr,
                                  color: blue,
                                  fontSize: 15,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
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
                      const SizedBox(
                        height: 9,
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
                        height: width * 0.051,
                      ),
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(const CustomPloicySheet());
                        },
                        child: Align(
                            alignment: !AppUtil.rtlDirection(context)
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "cancellationPolicy".tr,
                                      color: Color(0xFF070708),
                                      fontSize: width * 0.0461,
                                      fontFamily: 'HT Rakik',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(
                                      height: 6,
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
                      const SizedBox(
                        height: 11,
                      ),
                      const Divider(
                        color: lightGrey,
                        thickness: 1,
                      ),

                      const SizedBox(
                        height: 25,
                      ),
                      // Row(
                      //   children: [
                      //     CustomText(
                      //       text: "startFrom".tr,
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w400,
                      //       color: almostGrey,
                      //     ),
                      //     const SizedBox(
                      //       width: 2,
                      //     ),
                      //     const CustomText(
                      //       text: " / ",
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 20,
                      //     ),
                      //     CustomText(
                      //       text: widget.place == null
                      //           ? '0${'sar'.tr}'
                      //           : '${widget.place!.price} ${'sar'.tr}',
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 20,
                      //     ),
                      //   ],
                      // ),

                      Obx(() => _RequestController.isBookingLoading.value
                          ? const CircularProgressIndicator.adaptive()
                          : !AppUtil.isGuest() && isViewBooking.value
                              ? (isHasOffers.value
                                  ? _RequestController
                                          .isRequestAcceptLoading.value
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : CustomButton(
                                          onPressed: () async {
                                            theBooking =
                                                await _RequestController
                                                    .getBookingById(
                                              context: context,
                                              bookingId:
                                                  thePlace!.booking!.first.id ??
                                                      '',
                                            );
                                            print(isHasOffers.value);

                                            Get.to(
                                              () => LocalOfferInfo(
                                                place: thePlace!,
                                                image:
                                                    theProfile?.profileImage ??
                                                        '',
                                                name: theProfile?.name ?? '',
                                                profileId: theProfile?.id ?? '',
                                                rating:
                                                    theProfile?.tourRating ?? 0,
                                                price: 0,
                                                tripNumber:
                                                    theProfile?.tourNumber ?? 0,
                                                booking: theBooking,
                                              ),
                                            );
                                          },
                                          title: AppUtil.rtlDirection2(context)
                                              ? "طلبك"
                                              : "Your Request",
                                          icon: !AppUtil.rtlDirection(context)
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
                                            booking: thePlace!.booking!.first,
                                            place: widget.place!,
                                            placeId: thePlace?.id ?? '',
                                          ),
                                        )?.then((value) async {
                                          return getOfferinfo();
                                        });
                                      },
                                      title: AppUtil.rtlDirection2(context)
                                          ? "العروض"
                                          : "View Offers",
                                      icon: !AppUtil.rtlDirection(context)
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
                                    // print(";lkjhgfdxzxcvbnm,");
                                    // print(isViewBooking.value);
                                    AppUtil.isGuest()
                                        ? Get.to(
                                            () => const SignInScreen(),
                                          )
                                        : showModalBottomSheet(
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
                                                userLocation:
                                                    widget.userLocation,
                                                touristExploreController:
                                                    _touristExploreController,
                                              );
                                            }).then((value) {
                                            getOfferinfo();
                                            return;
                                          });
                                  },
                                  // title: "buyTicket".tr,
                                  title: AppUtil.rtlDirection2(context)
                                      ? "اطلب"
                                      : "Request",
                                  icon: !AppUtil.rtlDirection(context)
                                      ? const Icon(
                                          Icons.arrow_back_ios,
                                          size: 20,
                                        )
                                      : const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                        ),
                                )),

                      const SizedBox(
                        height: 32,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),

          Positioned(
            top: height * 0.06,
            right: !AppUtil.rtlDirection(context) ? width * 0.85 : width * 0.09,
            child: HomeIconButton(
              icon: "assets/icons/white_bookmark.svg",
            ),
            height: 40,
          ),
          // Positioned(
          //     top: height * 0.265,
          //     right: width * 0.1,
          //     left: width * 0.1,
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 10),
          //       height: 60,
          //       width: 300,
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(Radius.circular(30)),
          //         boxShadow: [
          //           BoxShadow(
          //               color: almostGrey.withOpacity(0.2),
          //               spreadRadius: -3,
          //               blurRadius: 5,
          //               offset: Offset(4, 6))
          //         ],
          //       ),
          //       child: Row(
          //         children: [
          //           GestureDetector(
          //             onTap: () {
          //               // showModalBottomSheet(
          //               //     useRootNavigator: true,
          //               //     isScrollControlled: true,
          //               //     backgroundColor: Colors.transparent,
          //               //     shape: const RoundedRectangleBorder(
          //               //         borderRadius: BorderRadius.only(
          //               //       topRight: Radius.circular(30),
          //               //       topLeft: Radius.circular(30),
          //               //     )),
          //               //     context: context,
          //               //     builder: (context) {
          //               //       return ShareSheet(
          //               //         fromAjwady: false,
          //               //       );
          //               //     });
          //             },
          //             child: Container(
          //               padding: EdgeInsets.symmetric(horizontal: 7),
          //               height: 28,
          //               width: 80,
          //               decoration: const BoxDecoration(
          //                 color: colorGreen,
          //                 borderRadius: BorderRadius.all(Radius.circular(7)),
          //               ),
          //               child: Row(
          //                 children: [
          //                   CustomText(
          //                     text: "invite".tr,
          //                     color: Colors.white,
          //                     fontSize: 12,
          //                   ),
          //                   Spacer(),
          //                   SvgPicture.asset("assets/icons/share_icon.svg"),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           const Spacer(),
          //           ajwadiImages()
          //         ],
          //       ),
          //     )),

          Positioned(
            top: height * 0.25,
            left: width * 0.42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _tripUrlImages.map((imageUrl) {
                int index = _tripUrlImages.indexOf(imageUrl);
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    boxShadow: _currentIndex == index
                        ? [
                            const BoxShadow(
                                color: Colors.white,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ]
                        : [],
                  ),
                );
              }).toList(),
            ),
          ),
        ])));
  }

  Widget ajwadiImages() {
    // var items = _ajwadiUrlImages.map((url) => buildImage(url)).toList();
    var items = _ajwadiUrlImages.map((url) => buildImage(url)).toList();
    final emptyUrl = " ";
    items = items + [buildImage(emptyUrl)];
    return StackWidgets(
      items: items,
      size: 30,
    );
  }

  buildImage(String url) {
    return url == " "
        ? ClipOval(
            child: Container(
              color: colorGreen,
              child: Center(
                child: CustomText(
                  text: "23+",
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
          )
        : ClipOval(
            child: Image.asset(
            url,
            fit: BoxFit.fill,
          ));
  }
}
