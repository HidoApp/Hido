import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/view_trip_images.dart';
import 'package:ajwad_v4/services/controller/serivces_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/widgets/reservation_details_sheet.dart';
import 'package:ajwad_v4/services/view/widgets/reservation_details_widget.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_policy_sheet.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' hide TextDirection;

class HospitalityDetails extends StatefulWidget {
  const HospitalityDetails({
    Key? key,
    required this.hospitalityId,
  }) : super(key: key);

  final String hospitalityId;

  @override
  State<HospitalityDetails> createState() => _HospitalityDetailsState();
}

late double width, height;

class _HospitalityDetailsState extends State<HospitalityDetails> {
  // final List<String> _hospitalityUrlImages = [
  //   'assets/images/farm_image.png',
  //   'assets/images/farm_image.png',
  //   'assets/images/farm_image.png',
  //   'assets/images/farm_image.png',
  //   'assets/images/farm_image.png',
  // ];

  SrvicesController _servicesController = Get.put(SrvicesController());

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

  late Hospitality? hospitalityObj;

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
    for (var day in hospitalityObj!.daysInfo) {
      print(day.startTime);
      avilableDate.add(DateTime.parse(day.startTime.substring(0, 10)));
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Obx(
      () => _servicesController.isHospitalityByIdLoading.value
          ? Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              body: SizedBox(
                height: height * 0.2,
                width: width,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: purple,
                  ),
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: CustomAppBar(
                !AppUtil.rtlDirection(context)
                    ? hospitalityObj!.titleAr
                    : hospitalityObj!.titleEn,
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
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              hospitalityObj!.images[index],
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: height * 0.92,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Align(
                                alignment: !AppUtil.rtlDirection(context)
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: CustomText(
                                  text: !AppUtil.rtlDirection(context)
                                      ? hospitalityObj!.titleAr
                                      : hospitalityObj!.titleEn,
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
                                  text: hospitalityObj!.region,
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
                                  color: almostGrey,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  text:
                                      '${'from'.tr}  ${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(hospitalityObj!.daysInfo[0].startTime))} ${'to'.tr}  ${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(hospitalityObj!.daysInfo[0].endTime))}',
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
                                  "assets/icons/meal_icon.svg",
                                  color: colorDarkGrey,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  text: AppUtil.rtlDirection(context)
                                      ? hospitalityObj!.mealTypeEn
                                      : hospitalityObj!.mealTypeAr,
                                  color: colorDarkGrey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            // Center(
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Container(
                            //           height: 40,
                            //           width: 40,
                            //           padding: const EdgeInsets.all(10),
                            //           decoration: BoxDecoration(
                            //               shape: BoxShape.circle,
                            //               color: Colors.white,
                            //               boxShadow: [
                            //                 BoxShadow(
                            //                     offset: Offset(2, 3),
                            //                     blurRadius: 3,
                            //                     color: dotGreyColor
                            //                         .withOpacity(0.5),
                            //                     spreadRadius: 1)
                            //               ]),
                            //           child: SvgPicture.asset(
                            //               "assets/icons/visit_icon.svg")),
                            //       const SizedBox(
                            //         width: 10,
                            //       ),
                            //       Column(
                            //         children: [
                            //           CustomText(
                            //             text: "visit".tr,
                            //             color: colorDarkGrey,
                            //             fontWeight: FontWeight.w300,
                            //           ),
                            //           CustomText(
                            //             text: '0',
                            //             fontWeight: FontWeight.w300,
                            //           )
                            //         ],
                            //       ),
                            //       Spacer(),
                            //       Container(
                            //           height: 40,
                            //           width: 40,
                            //           padding: const EdgeInsets.all(10),
                            //           decoration: BoxDecoration(
                            //               shape: BoxShape.circle,
                            //               color: Colors.white,
                            //               boxShadow: [
                            //                 BoxShadow(
                            //                     offset: Offset(2, 3),
                            //                     blurRadius: 3,
                            //                     color: dotGreyColor
                            //                         .withOpacity(0.5),
                            //                     spreadRadius: 1)
                            //               ]),
                            //           child: SvgPicture.asset(
                            //               "assets/icons/distance_icon.svg")),
                            //       const SizedBox(
                            //         width: 10,
                            //       ),
                            //       Column(
                            //         children: [
                            //           CustomText(
                            //             text: "distance".tr,
                            //             color: colorDarkGrey,
                            //             fontWeight: FontWeight.w300,
                            //           ),
                            //           CustomText(
                            //             text: "3000 km",
                            //             fontWeight: FontWeight.w300,
                            //           )
                            //         ],
                            //       ),
                            //       Spacer(),
                            //       // Container(
                            //       //     height: 40,
                            //       //     width: 40,
                            //       //     padding: const EdgeInsets.all(10),
                            //       //     decoration: BoxDecoration(
                            //       //         shape: BoxShape.circle,
                            //       //         color: Colors.white,
                            //       //         boxShadow: [
                            //       //           BoxShadow(
                            //       //               offset: Offset(2, 3),
                            //       //               blurRadius: 3,
                            //       //               color: dotGreyColor.withOpacity(0.5),
                            //       //               spreadRadius: 1)
                            //       //         ]),
                            //       //     child: SvgPicture.asset(
                            //       //         "assets/icons/rate_icon.svg")),
                            //       const SizedBox(
                            //         width: 10,
                            //       ),
                            //       // Column(
                            //       //   children: [
                            //       //     CustomText(
                            //       //       text: "rating".tr,
                            //       //       color: colorDarkGrey,
                            //       //       fontWeight: FontWeight.w300,
                            //       //     ),
                            //       //     CustomText(
                            //       //       text: "4.8 (3.2k)",
                            //       //       fontWeight: FontWeight.w300,
                            //       //     )
                            //       //   ],
                            //       // ),
                            //     ],
                            //   ),
                            // ),

                            // const SizedBox(
                            //   height: 20,
                            // ),
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

                            ConstrainedBox(
                              constraints: isExpanded
                                  ? new BoxConstraints()
                                  : new BoxConstraints(maxHeight: 50.0),
                              child: CustomText(

                                  //   textAlign: AppUtil.rtlDirection(context) ? TextAlign.end : TextAlign.start ,
                                  textDirection: AppUtil.rtlDirection(context)
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  textOverflow: TextOverflow.fade,
                                  fontFamily: "Noto Kufi Arabic",
                                  fontSize: 14,
                                  text: !AppUtil.rtlDirection(context)
                                      ? hospitalityObj!.bioAr
                                      : hospitalityObj!.bioEn),
                            ),

                            // isExpanded
                            //     ? new Container()
                            //     : Align(
                            //         alignment: Alignment.bottomLeft,
                            //         child: new TextButton(
                            //             child: CustomText(
                            //               text: "readMore".tr,
                            //               color: purple,
                            //             ),
                            //             onPressed: () =>
                            //                 setState(() => isExpanded = true)),
                            //       ),
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
                                  fontWeight: FontWeight.w400,
                                )),
                            const SizedBox(
                              height: 10,
                            ),

                           
                            //     ? Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.center,
                            //         children: [
                            //           Container(
                            //             decoration: BoxDecoration(
                            //               color: almostGrey.withOpacity(0.2),
                            //               borderRadius: const BorderRadius.all(
                            //                   Radius.circular(20)),
                            //             ),
                            //             height: height * 0.16,
                            //             width: width * 0.9,
                            //             child: GoogleMap(
                            //               scrollGesturesEnabled: false,
                            //               zoomControlsEnabled: false,
                            //               initialCameraPosition: CameraPosition(
                            //                 target: locLatLang,
                            //                 zoom: 15,
                            //               ),
                            //               markers: {
                            //                 Marker(
                            //                   markerId: MarkerId("marker1"),
                            //                   position: locLatLang,
                            //                   draggable: true,
                            //                   onDragEnd: (value) {
                            //                     // value is the new position
                            //                   },
                            //                   icon: markerIcon,
                            //                 ),
                            //               },
                            //             ),
                            //           ),
                            //           const SizedBox(
                            //             height: 10,
                            //           ),
                            //           Center(
                            //               child: CustomText(
                            //             text: 'approximateLocation'.tr,
                            //             textAlign: TextAlign.center,
                            //             fontSize: 10,
                            //             color: almostGrey,
                            //           )),
                            //         ],
                            //       )
                            //     : 
                                
                                
                                Stack(
                                  children: [
                                  
                                    Container(
                                        decoration: BoxDecoration(
                                          color: almostGrey.withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        height:  height * 0.2,
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

                                      if( hospitalityObj!.booking!.isEmpty)

                                        Container(  height: height * 0.2,
                                        width: width * 0.9,
                                        
                                        color: textGreyColor.withOpacity(0.7),
                                        child: Center(child: CustomText(text: 'locationWillBeAvailableAfterBooking'.tr,color: Colors.white,fontWeight: FontWeight.w300,),),
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
                              onTap: (){
                                Get.bottomSheet(CustomPloicySheet());
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
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: width * 0.85,
                                            child: CustomText(
                                              text: "cancellationPolicyBreif".tr,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              maxlines: 1,
                                              color: tileGreyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: tileGreyColor,
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Spacer(),
                            Row(
                              children: [
                                CustomText(
                                  text: "startFrom".tr,
                                  fontSize: 12,
                                  color: colorDarkGrey,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const CustomText(
                                  text: " /  ",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                                CustomText(
                                  text: '${hospitalityObj!.price} ${'sar'.tr}',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),

                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 30, left: 30, bottom: 32),
                                child: CustomButton(
                                  onPressed: () {
                                    AppUtil.isGuest()
                                        ? Get.to(() => const SignInScreen())
                                        : Get.bottomSheet(
                                            ReservaationDetailsWidget(
                                                color: purple,
                                                context: context,
                                                hospitality: hospitalityObj,
                                                avilableDate: avilableDate,
                                                serviceController:
                                                    _servicesController),
                                            backgroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          );
                                  },
                                  buttonColor: purple,
                                  iconColor: darkPurple,
                                  title: "book".tr,
                                  icon: !AppUtil.rtlDirection(context)
                                      ? const Icon(Icons.arrow_back_ios)
                                      : const Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                    top: height * 0.08,
                    right: !AppUtil.rtlDirection(context)
                        ? width * 0.85
                        : width * 0.05,
                    child: SvgPicture.asset(
                      "assets/icons/white_bookmark.svg",
                      height: 40,
                    )),
                Positioned(
                    top: height * 0.265,
                    right: width * 0.1,
                    left: width * 0.1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: almostGrey.withOpacity(0.2),
                              spreadRadius: -3,
                              blurRadius: 5,
                              offset: Offset(4, 6))
                        ],
                      ),
                      child: Row(
                        children: [
                          hospitalityObj!.familyImage != null
                              ? CircleAvatar(
                                  radius: 25.5,
                                  backgroundImage:
                                      NetworkImage(hospitalityObj!.familyImage),
                                )
                              : const CircleAvatar(
                                  radius: 25.5,
                                  backgroundImage: AssetImage(
                                      'assets/images/profile_image.png'),
                                ),
                          SizedBox(
                            width: 30,
                          ),
                          CustomText(
                            text: hospitalityObj!.familyName,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          )
                        ],
                      ),
                    )),
                Positioned(
                  top: height * 0.22,
                  left: width * 0.45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: hospitalityObj!.images.map((imageUrl) {
                      int index = hospitalityObj!.images.indexOf(imageUrl);
                      return Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(
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
}
