import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/view/share_sheet.dart';
import 'package:ajwad_v4/request/tourist/view/local_offer_info.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/StackWidgets.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';

import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';

import 'package:ajwad_v4/services/view/widgets/images_services_widget.dart';

import 'package:ajwad_v4/services/view/widgets/service_profile_card.dart';

import 'package:ajwad_v4/widgets/custom_policy_sheet.dart';
import 'package:ajwad_v4/widgets/floating_booking_button.dart';

import 'package:intl/intl.dart' hide TextDirection;

class AdventureDetails extends StatefulWidget {
  const AdventureDetails({
    Key? key,
    required this.adventureId,
  }) : super(key: key);

  final String adventureId;

  @override
  State<AdventureDetails> createState() => _AdventureDetailsState();
}

late double width, height;

class _AdventureDetailsState extends State<AdventureDetails> {
  final _adventureController = Get.put(AdventureController());
  int _currentIndex = 0;
  bool isExpanded = false;
  bool isAviailable = false;
  List<DateTime> avilableDate = [];
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

  late Adventure? adventure;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //    initializeDateFormatting(); //very important

    addCustomIcon();
    getAdventureById();
  }

  void getAdventureById() async {
    adventure = (await _adventureController.getAdvdentureById(
        context: context, id: widget.adventureId));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Obx(
      () => _adventureController.isAdventureByIdLoading.value
          ? const Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: CustomAppBar(""),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              bottomNavigationBar: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: BottomBookingWidgetAdventure(
                    adventure: adventure!,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              persistentFooterAlignment: AlignmentDirectional.bottomCenter,
              body: SingleChildScrollView(
                  child: Stack(children: [
                Column(
                  children: [
                    // images widget on top of screen
                    GestureDetector(
                      onTap: () {
                        Get.to(ViewTripImages(
                          tripImageUrl: adventure!.image!,
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
                        itemCount: adventure!.image!.length,
                        itemBuilder: (context, index, realIndex) {
                          return ImagesServicesWidget(
                            image: adventure!.image![index],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Align(
                              alignment: AppUtil.rtlDirection2(context)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: CustomText(
                                text: AppUtil.rtlDirection2(context)
                                    ? adventure!.nameAr!
                                    : adventure!.nameEn!,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/locationHos.svg",
                                color: starGreyColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                text: AppUtil.rtlDirection2(context)
                                    ? adventure!.regionAr!
                                    : adventure!.regionEn!,
                                color: colorDarkGrey,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/grey_calender.svg',
                                color: starGreyColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                text: DateFormat('E-dd-MMM')
                                    .format(DateTime.parse(adventure!.date!)),
                                color: colorDarkGrey,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/timeGrey.svg",
                                color: starGreyColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              // CustomText(
                              //   text:
                              //       '${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(hospitalityObj!.daysInfo[0].startTime))} ${'-'}  ${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(hospitalityObj!.daysInfo[0].endTime))}',
                              //   color: colorDarkGrey,
                              //   fontSize: 15,
                              //   fontWeight: FontWeight.w300,
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                              alignment: AppUtil.rtlDirection2(context)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: CustomText(
                                text: "About".tr,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          ConstrainedBox(
                            constraints: isExpanded
                                ? const BoxConstraints()
                                : const BoxConstraints(maxHeight: 40),
                            child: CustomText(
                              //   textAlign: AppUtil.rtlDirection(context) ? TextAlign.end : TextAlign.start ,
                              textDirection: AppUtil.rtlDirection2(context)
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              textOverflow: isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.clip,
                              fontFamily: "Noto Kufi Arabic",
                              fontSize: 14,
                              text: AppUtil.rtlDirection2(context)
                                  ? adventure!.descriptionAr!
                                  : adventure!.descriptionEn!,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          isExpanded
                              ? Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => isExpanded = false);
                                    },
                                    child: const CustomText(
                                      text: "Show less",
                                      color: blue,
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => isExpanded = true),
                                    child: CustomText(
                                      text: "readMore".tr,
                                      color: blue,
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: lightGrey,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: !AppUtil.rtlDirection(context)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: CustomText(
                                text: "whereWeWillBe".tr,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: almostGrey.withOpacity(0.2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                height: height * 0.2,
                                width: width * 0.9,
                                child: GoogleMap(
                                  scrollGesturesEnabled: false,
                                  zoomControlsEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                    target: adventure == null
                                        ? locLatLang
                                        : LatLng(
                                            double.parse(adventure!
                                                .coordinates!.latitude!),
                                            double.parse(adventure!
                                                .coordinates!.longitude!)),
                                    zoom: 15,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId("marker1"),
                                      position: adventure == null
                                          ? locLatLang
                                          : LatLng(
                                              double.parse(adventure!
                                                  .coordinates!.latitude!),
                                              double.parse(adventure!
                                                  .coordinates!.longitude!)),
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
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: lightGrey,
                          ),
                          const SizedBox(
                            height: 20,
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        SizedBox(
                                          width: 326,
                                          child: CustomText(
                                            text:
                                                "cancellationPolicyBreifAdventure"
                                                    .tr,
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
                          const Divider(
                            color: lightGrey,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                    top: height * 0.07,
                    right: AppUtil.rtlDirection2(context)
                        ? width * 0.85
                        : width * 0.05,
                    child: SvgPicture.asset(
                      "assets/icons/white_bookmark.svg",
                      height: 30,
                    )),
                Positioned(
                  top: height * 0.06,
                  left: AppUtil.rtlDirection2(context)
                      ? width * 0.85
                      : width * 0.06,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 24, color: Colors.white),
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
                          () => LocalOfferInfo(
                              fromService: true,
                              image: "",
                              name: "Abdllah alqurashi",
                              price: 400,
                              rating: 5,
                              tripNumber: 4,
                              place: Place(),
                              profileId:
                                  "447aad72-25f2-4f90-85fd-51743cf8c9ed"),
                        );
                      },
                      image: adventure!.user!.profileImage ?? '',
                      name: adventure!.user!.name!,
                    )),
                //indicator
                Positioned(
                  top: height * 0.22,
                  left: width * 0.36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: adventure!.image!.map((imageUrl) {
                      int index = adventure!.image!.indexOf(imageUrl);
                      return Container(
                        width: 10.0,
                        height: 10.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
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
              ]))),
    );
  }

  // return Scaffold(
  //     backgroundColor: Colors.white,
  //     extendBodyBehindAppBar: true,
  //     appBar: CustomAppBar(
  //       AppUtil.rtlDirection(context) ? 'ربع الخالي' : 'Empty Quarter',
  //       color: Colors.white,
  //       iconColor:  Colors.white,
  //     ),
  //     body: SingleChildScrollView(
  //         child: Stack(children: [
  //       Column(
  //         children: [
  //           GestureDetector(
  //             onTap: () {
  //               // Get.to(ViewTripImages(tripImageUrl: _AdventureUrlImages));
  //             },
  //             child: CarouselSlider.builder(
  //               options: CarouselOptions(
  //                   height: height * 0.3,
  //                   viewportFraction: 1,
  //                   onPageChanged: (i, reason) {
  //                     setState(() {
  //                       _currentIndex = i;
  //                     });
  //                   }),
  //               itemCount: _AdventureUrlImages.length,
  //               itemBuilder: (context, index, realIndex) {
  //                 return Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   child: Image.asset(
  //                     _AdventureUrlImages[0],
  //                     fit: BoxFit.fill,
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //           SizedBox(
  //             height: 40,
  //           ),
  //           SizedBox(
  //             height: height*0.6,
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 20),
  //               child: Column(
  //                 children: [
  //                   Align(
  //                       alignment: AppUtil.rtlDirection(context)
  //                           ? Alignment.centerRight
  //                           : Alignment.centerLeft,
  //                       child: CustomText(
  //                         text: AppUtil.rtlDirection(context)
  //                             ? 'ربع الخالي'
  //                             : 'Empty Quarter',
  //                         fontSize: 28,
  //                         fontWeight: FontWeight.w700,
  //                       )),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Row(
  //                     children: [
  //                       SvgPicture.asset(
  //                         "assets/icons/location_pin.svg",
  //                         color: pink,
  //                       ),
  //                       CustomText(
  //                         text: " riyadhSaudiArabia".tr,
  //                         color: dividerColor,
  //                       ),
  //                       Spacer(),
  //                       SvgPicture.asset(
  //                         "assets/icons/purple_calendar.svg",
  //                         height: 13,
  //                         color: pink,
  //                       ),
  //                       CustomText(
  //                         text: " Wed, Apr 28 ",
  //                         color: dividerColor,
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 15,
  //                   ),
  //                   Center(
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 Container(
  //                                     height: 40,
  //                                     width: 40,
  //                                     padding: const EdgeInsets.all(10),
  //                                     decoration: BoxDecoration(
  //                                         shape: BoxShape.circle,
  //                                         color: Colors.white,
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                               offset: Offset(2, 3),
  //                                               blurRadius: 3,
  //                                               color: dotGreyColor
  //                                                   .withOpacity(0.5),
  //                                               spreadRadius: 1)
  //                                         ]),
  //                                     child: SvgPicture.asset(
  //                                         "assets/icons/visit_icon.svg")),
  //                                 const SizedBox(
  //                                   width: 10,
  //                                 ),
  //                                 Column(
  //                                   children: [
  //                                     CustomText(
  //                                       text: "visit".tr,
  //                                       color: colorDarkGrey,
  //                                       fontWeight: FontWeight.w300,
  //                                     ),
  //                                     CustomText(
  //                                       text: "108 ",
  //                                       fontWeight: FontWeight.w300,
  //                                     )
  //                                   ],
  //                                 ),
  //                                 Spacer(),
  //                                 Container(
  //                                     height: 40,
  //                                     width: 40,
  //                                     padding: const EdgeInsets.all(10),
  //                                     decoration: BoxDecoration(
  //                                         shape: BoxShape.circle,
  //                                         color: Colors.white,
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                               offset: Offset(2, 3),
  //                                               blurRadius: 3,
  //                                               color: dotGreyColor
  //                                                   .withOpacity(0.5),
  //                                               spreadRadius: 1)
  //                                         ]),
  //                                     child: SvgPicture.asset(
  //                                         "assets/icons/distance_icon.svg")),
  //                                 const SizedBox(
  //                                   width: 10,
  //                                 ),
  //                                 Column(
  //                                   children: [
  //                                     CustomText(
  //                                       text: "distance".tr,
  //                                       color: colorDarkGrey,
  //                                       fontWeight: FontWeight.w300,
  //                                     ),
  //                                     CustomText(
  //                                       text: "3000 km",
  //                                       fontWeight: FontWeight.w300,
  //                                     )
  //                                   ],
  //                                 ),
  //                                 Spacer(),
  //                                 Container(
  //                                     height: 40,
  //                                     width: 40,
  //                                     padding: const EdgeInsets.all(10),
  //                                     decoration: BoxDecoration(
  //                                         shape: BoxShape.circle,
  //                                         color: Colors.white,
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                               offset: Offset(2, 3),
  //                                               blurRadius: 3,
  //                                               color: dotGreyColor
  //                                                   .withOpacity(0.5),
  //                                               spreadRadius: 1)
  //                                         ]),
  //                                     child: SvgPicture.asset(
  //                                         "assets/icons/rate_icon.svg")),
  //                                 const SizedBox(
  //                                   width: 10,
  //                                 ),
  //                                 Column(
  //                                   children: [
  //                                     CustomText(
  //                                       text: "rating".tr,
  //                                       color: colorDarkGrey,
  //                                       fontWeight: FontWeight.w300,
  //                                     ),
  //                                     CustomText(
  //                                       text: "4.8 (3.2k)",
  //                                       fontWeight: FontWeight.w300,
  //                                     )
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   Align(
  //                       alignment: AppUtil.rtlDirection(context)
  //                           ? Alignment.centerRight
  //                           : Alignment.centerLeft,
  //                       child: CustomText(
  //                         text: "aboutTheTrip".tr,
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.w400,
  //                       )),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   ConstrainedBox(
  //                     constraints: isExpanded
  //                         ? new BoxConstraints()
  //                         : new BoxConstraints(maxHeight: 50.0),
  //                     child: CustomText(

  //                         //   textAlign: AppUtil.rtlDirection(context) ? TextAlign.end : TextAlign.start ,
  //                         textDirection: AppUtil.rtlDirection(context)
  //                             ? TextDirection.ltr
  //                             : TextDirection.rtl,
  //                         textOverflow: TextOverflow.fade,
  //                         fontFamily: "Noto Kufi Arabic",
  //                         fontSize: 14,
  //                         text: "aboutTheTripBrief".tr),
  //                   ),
  //                   isExpanded
  //                       ? new Container()
  //                       : Align(
  //                           alignment: Alignment.bottomLeft,
  //                           child: new TextButton(
  //                               child: CustomText(
  //                                 text: "readMore".tr,
  //                                 color: pink,
  //                               ),
  //                               onPressed: () =>
  //                                   setState(() => isExpanded = true)),
  //                         ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Row(
  //                     children: [
  //                       CustomText(
  //                         text: "startFrom".tr,
  //                         fontSize: 12,
  //                       ),
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       CustomText(
  //                         text: " /  ",
  //                         fontWeight: FontWeight.w900,
  //                         fontSize: 17,
  //                       ),
  //                       CustomText(
  //                         text: " 150 SAR",
  //                         fontWeight: FontWeight.w900,
  //                         fontSize: 17,
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       color: almostGrey.withOpacity(0.2),
  //                       borderRadius: BorderRadius.all(Radius.circular(20)),
  //                     ),
  //                     height: height * 0.16,
  //                     width: width * 0.9,
  //                     child: GoogleMap(
  //                       initialCameraPosition: CameraPosition(
  //                         target: locLatLang,
  //                         zoom: 15,
  //                       ),
  //                       markers: {
  //                         Marker(
  //                           markerId: const MarkerId("marker1"),
  //                           position: locLatLang,
  //                           draggable: true,
  //                           onDragEnd: (value) {
  //                             // value is the new position
  //                           },
  //                           icon: markerIcon,
  //                         ),
  //                       },
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Spacer(),
  //                   Padding(
  //                     padding:
  //                         EdgeInsets.symmetric(horizontal: 30, vertical: 10),
  //                     child: CustomButton(
  //                       onPressed: () {
  //                      //   Get.to(() => CheckOutScreen());

  //                         // showReservationDetailsSheet(
  //                         //       context: context,
  //                         //       color: pink,
  //                         //       height: height,
  //                         //       width: width);
  //                       },
  //                       title: "join".tr.toUpperCase(),
  //                       icon: AppUtil.rtlDirection(context)
  //                           ? const Icon(Icons.arrow_back)
  //                           : const Icon(Icons.arrow_forward),
  //                       buttonColor: pink,
  //                       iconColor: darkPink,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //       Positioned(
  //           top: height * 0.06,
  //           right:
  //               AppUtil.rtlDirection(context) ? width * 0.85 : width * 0.05,
  //           //  left: AppUtil.rtlDirection(context) ?  width *0.05: 0,
  //           child: SvgPicture.asset(
  //             "assets/icons/white_bookmark.svg",
  //             height: 40,
  //           )),
  //       Positioned(
  //           top: height * 0.265,
  //           right: width * 0.1,
  //           left: width * 0.1,
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 10),
  //             height: 60,
  //             width: 300,
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.all(Radius.circular(30)),
  //               boxShadow: [
  //                 BoxShadow(
  //                     color: almostGrey.withOpacity(0.2),
  //                     spreadRadius: -3,
  //                     blurRadius: 5,
  //                     offset: Offset(4, 6))
  //               ],
  //             ),
  //             child: Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     showModalBottomSheet(
  //                         useRootNavigator: true,
  //                         isScrollControlled: true,
  //                         backgroundColor: Colors.transparent,
  //                         shape: const RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.only(
  //                           topRight: Radius.circular(30),
  //                           topLeft: Radius.circular(30),
  //                         )),
  //                         context: context,
  //                         builder: (context) {
  //                           return ShareSheet(
  //                             fromAjwady: false,
  //                           );
  //                         });
  //                   },
  //                   child: Container(
  //                     padding: EdgeInsets.symmetric(horizontal: 7),
  //                     height: 28,
  //                     width: 80,
  //                     decoration: const BoxDecoration(
  //                       color: pink,
  //                       borderRadius: BorderRadius.all(Radius.circular(7)),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         CustomText(
  //                           text: "invite".tr,
  //                           color: Colors.white,
  //                           fontSize: 12,
  //                         ),
  //                         Spacer(),
  //                         SvgPicture.asset("assets/icons/share_icon.svg"),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 const Spacer(),
  //                 ajwadiImages()
  //               ],
  //             ),
  //           )),
  //       Positioned(
  //         top: height * 0.22,
  //         left: width * 0.45,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: _AdventureUrlImages.map((imageUrl) {
  //             int index = _AdventureUrlImages.indexOf(imageUrl);
  //             return Container(
  //               width: 10.0,
  //               height: 10.0,
  //               margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: _currentIndex == index
  //                     ? Colors.white
  //                     : Colors.white.withOpacity(0.4),
  //                 boxShadow: _currentIndex == index
  //                     ? [
  //                         BoxShadow(
  //                             color: Colors.white,
  //                             blurRadius: 5,
  //                             spreadRadius: 1)
  //                       ]
  //                     : [],
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //     ])));
  // }
}
  // Widget ajwadiImages() {
  //   var items = _ajwadiUrlImages.map((url) => buildImage(url)).toList();
  //   final emptyUrl = " ";
  //   items = items + [buildImage(emptyUrl)];
  //   return StackWidgets(
  //     items: items,
  //     size: 30,
  //   );
  // }

  // buildImage(String url) {
  //   return url == " "
  //       ? ClipOval(
  //           child: Container(
  //             color: pink,
  //             child: Center(
  //               child: CustomText(
  //                 text: "23+",
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w900,
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ),
  //         )
  //       : ClipOval(
  //           child: Image.asset(
  //           url,
  //           fit: BoxFit.fill,
  //         ));
  // }

