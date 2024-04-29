import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/StackWidgets.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_policy_sheet.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../request/tourist/view/booking_sheet.dart';

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
  Place? thePlace;
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

    getPlaceBooking();

    _touristExploreController.isBookedMade(true);
  }

  void getPlaceBooking() async {
    thePlace = await _touristExploreController.getPlaceById(
        id: widget.place!.id!, context: context);
    List<Booking>? bookingList =
        await _touristExploreController.getTouristBooking(context: context);
    if (bookingList != null && bookingList.isNotEmpty) {
      _touristExploreController.isPlaceNotLocked(false);
    }
    if (bookingList != null) {
      for (var booking in bookingList) {
        if (booking.placeId == widget.place!.id) {
          isViewBooking.value = true;
          lockPlaces.value = false;
          print(
            'THIS USER HAS A BOOKING IN ${widget.place!.nameAr}',
          );
          print(isViewBooking.value);
        }
      }
    }
    print("locked");
    print(_touristExploreController.isPlaceNotLocked);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: widget.fromAjwady ? lightBlack : Colors.white,
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          widget.place == null
              ? 'tuwaik'.tr
              : !AppUtil.rtlDirection(context)
                  ? widget.place!.nameAr!
                  : widget.place!.nameEn!,
          color: Colors.white,
          iconColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Stack(children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(ViewTripImages(
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
                  height: height * 0.83,
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
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/map_pin.svg"),
                          const SizedBox(
                            width: 4,
                          ),
                          CustomText(
                            text: widget.place != null
                                ? !AppUtil.rtlDirection(context)
                                    ? widget.place!.regionAr!
                                    : widget.place!.regionEn!
                                : '',
                            color: dividerColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
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
                            color: dividerColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: !AppUtil.rtlDirection(context)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: CustomText(
                            text: "aboutTheTrip".tr,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 112,
                        child: SingleChildScrollView(
                          child: CustomText(
                              textDirection: AppUtil.rtlDirection(context)
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              textOverflow: TextOverflow.fade,
                              fontFamily: "Noto Kufi Arabic",
                              textAlign: TextAlign.center,
                              fontSize: 14,
                              //  text: "aboutTheTripBrief".tr),
                              text: widget.place == null
                                  ? "******"
                                  : !AppUtil.rtlDirection(context)
                                      ? widget.place!.descriptionAr!
                                      : widget.place!.descriptionEn!),
                        ),
                      ),
                      //  //   ),
                      //     isExpanded
                      //         ? Container()
                      //         : Align(
                      //             alignment: Alignment.bottomLeft,
                      //             child: TextButton(
                      //                 child: CustomText(
                      //                   text: "readMore".tr,
                      //                   color: colorGreen,
                      //                 ),
                      //                 onPressed: () =>
                      //                     setState(() => isExpanded = true)),
                      //           ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: lightGrey,
                          thickness: 1,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: "Site Location",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: almostGrey.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        height: height * 0.16,
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
                              markerId: MarkerId("marker1"),
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
                      const SizedBox(
                        height: 14,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: lightGrey,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: 326,
                                      child: CustomText(
                                        text: "cancellationPolicyBreif".tr,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        maxlines: 2,
                                        color: tileGreyColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: tileGreyColor,
                                  size: 18,
                                )
                              ],
                            )),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: tileGreyColor,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "startFrom".tr,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: almostGrey,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          const CustomText(
                            text: " / ",
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                          CustomText(
                            text: widget.place == null
                                ? '0${'sar'.tr}'
                                : '${widget.place!.price} ${'sar'.tr}',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ],
                      ),

                      Obx(
                        () => _touristExploreController.isBookingLoading.value
                            ? const CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical:7),
                                child: !AppUtil.isGuest() &&
                                        isViewBooking.value // true
                                    ? CustomButton(
                                        onPressed: () async {
                                          Place? thePlace =
                                              await _touristExploreController
                                                  .getPlaceById(
                                                      id: widget.place!.id!,
                                                      context: context);
                                          Get.to(
                                            () => FindAjwady(
                                              booking: thePlace!.booking![0],
                                              place: widget.place!,
                                              placeId: thePlace.id!,
                                            ),
                                          )?.then((value) async {
                                            return getPlaceBooking();
                                          });
                                        },
                                        title: "viewBooking".tr,
                                        //  icon: AppUtil.rtlDirection(context)
                                        // ? const Icon(Icons.arrow_back)
                                        // : const Icon(Icons.arrow_forward),
                                      )
                                    //TODO:fix the condition Ammar
                                    : _touristExploreController.isPlaceNotLocked
                                            .value // booking OR Empty button
                                        ? CustomButton(
                                            onPressed: () {
                                              AppUtil.isGuest()
                                                  ? Get.to(
                                                      () =>
                                                          const SignInScreen(),
                                                    )
                                                  : showModalBottomSheet(
                                                      useRootNavigator: true,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  30),
                                                          topLeft:
                                                              Radius.circular(
                                                                  30),
                                                        ),
                                                      ),
                                                      context: context,
                                                      builder: (context) {
                                                        return BookingSheet(
                                                          fromAjwady: false,
                                                          place: widget.place,
                                                          userLocation: widget
                                                              .userLocation,
                                                          touristExploreController:
                                                              _touristExploreController,
                                                        );
                                                      }).then((value) {
                                                      getPlaceBooking();
                                                      return;
                                                    });
                                            },
                                            title: "buyTicket".tr,
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
                                        : Container(),
                              ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
              top: height * 0.06,
              right:
                  !AppUtil.rtlDirection(context) ? width * 0.85 : width * 0.05,
              child: SvgPicture.asset(
                "assets/icons/white_bookmark.svg",
                height: 40,
              )),
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
