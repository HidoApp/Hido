import 'dart:developer';

import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/view/offers_screen.dart';
import 'package:ajwad_v4/request/tourist/view/select_ajwady_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/StackWidgets.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:ajwad_v4/request/widgets/CansleDialog.dart';
import 'package:ajwad_v4/request/local_notification.dart';

class FindAjwady extends StatefulWidget {
  const FindAjwady({
    Key? key,
    required this.booking,
    required this.place,
    required this.placeId,
  }) : super(key: key);

  final Booking booking;
  final Place place;
  final String placeId;

  @override
  State<FindAjwady> createState() => _FindAjwadyState();
}

class _FindAjwadyState extends State<FindAjwady> {
  final _offerController = Get.put(OfferController());
  late double width, height;

  bool isDetailsTapped = false;

  final List<String> _ajwadiUrlImages = [
    'assets/images/ajwadi1.png',
    'assets/images/ajwadi2.png',
    'assets/images/ajwadi3.png',
    'assets/images/ajwadi4.png',
    'assets/images/ajwadi5.png',
  ];

  @override
  void initState() {
    super.initState();
    showCancelDialogAfterDelay();
    _offerController.getOffers(
      context: context,
      placeId: widget.placeId,
      bookingId: widget.booking.id!,
    );
  }

  void showCancelDialogAfterDelay() {
     if (_offerController.offers.isEmpty){
    Future.delayed(const Duration(minutes: 5), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const CustomText(
                    textAlign: TextAlign.center,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                    text: "Oops! "),
                const CustomText(
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: almostGrey,
                    text:
                        "It looks like there aren't any available guides in your area right now"),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 40,
                      width: 357,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const CustomText(
                        text: "Try again",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => _offerController.isBookingCancelLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.black))
                    : GestureDetector(
                        onTap: () async {
                          log("End Trip Taped ${widget.booking.id}");

                          bool bookingCancel =
                              await _offerController.bookingCancel(
                                      context: context,
                                      bookingId: widget.booking.id!) ??
                                  false;
                          if (bookingCancel) {
                            if (context.mounted) {
                              AppUtil.successToast(context, 'EndTrip'.tr);
                              await Future.delayed(const Duration(seconds: 1));
                            }
                            Get.offAll(
                              const TouristBottomBar(),
                            );
                          }
                        },
                        child: const CustomText(
                            textAlign: TextAlign.center,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: black,
                            text: "Cancel Tour"),
                      )),
              ],
            ),
          );
        },
      );
    });
     }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        "findLocal".tr,
        action: true,
        onPressedAction: () async {
          // await showBottomSheetCancelBooking(height: height, width: width);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CancelBookingDialog(
                dialogWidth: MediaQuery.of(context).size.width * 0.588,
                buttonWidth: MediaQuery.of(context).size.width * 1.191,
                booking: widget.booking,
                offerController: _offerController,
              );
            },
          );
          // showModalBottomSheet(
          //     isScrollControlled: true,
          //     backgroundColor: Colors.transparent,
          //     shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.only(
          //       topRight: Radius.circular(30),
          //       topLeft: Radius.circular(30),
          //     )),
          //     context: context,
          //     builder: (context) {
          //       return SelectAjwadySheet(
          //         place: widget.place,
          //         // booking: widget.booking,
          //       );
          //     });
        },
      ),
      body: Obx(() {
        if (_offerController.isOffersLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          color: lightGreyBackground,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Visibility(
                 visible: _offerController.offers.isEmpty,
                  child: Container(
                    height: height * 0.2,
                    width: 0.84 * width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      
                      child: Column(
                        
                        children: [
                          const SizedBox(
                            height: 5,
                          ),

                          SvgPicture.asset(
                            'assets/icons/findLocal.svg',
                            height: 40,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomText(
                            text: "searchforLocal".tr,
                            color: colorGreen,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                              child: CustomText(
                            text: "WeSentYourRequestAndWaiteTillAccepted".tr,
                            color: almostGrey,
                            textAlign: TextAlign.center,
                            fontSize: 12,
                          )),
                        ],
                      ),
                    ),
                  ),
                  ),
                ),
                 
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 0.84 * width,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () {

                          setState(() {
                            isDetailsTapped = !isDetailsTapped;
                          });
                        },
                        title: CustomText(
                          text: 'tripDetails'.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        trailing: Icon(
                          isDetailsTapped
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: darkGrey,
                          size: 24,
                        ),
                      ),
                      if (isDetailsTapped)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/guests.svg'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                    text:
                                        '${widget.booking.guestNumber} ${'guests'.tr}',
                                    color: almostGrey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/date.svg'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                    text:
                                        '${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.booking.date!))} - ${widget.booking.timeToGo}',
                                    color: almostGrey,
                                    fontSize: 10,
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
                                    'assets/icons/unselected_${widget.booking.vehicleType!}_icon.svg',
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                    text: widget.booking.vehicleType!,
                                    color: almostGrey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                if (_offerController.offers.isNotEmpty)
                  GestureDetector(
                    //TODO: offer screen will be there
                    onTap: () {
                      Get.to(() => OfferScreen(
                            place: widget.place,
                          ));
                      // showModalBottomSheet(
                      //     isScrollControlled: true,
                      //     backgroundColor: Colors.transparent,
                      //     shape: const RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.only(
                      //       topRight: Radius.circular(30),
                      //       topLeft: Radius.circular(30),
                      //     )),
                      //     context: context,
                      //     builder: (context) {
                      //       return SelectAjwadySheet(
                      //         place: widget.place,
                      //         // booking: widget.booking,
                      //       );
                      //     });
                    },
                    child: Container(
                      height: 60,
                      width: 0.84 * width,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipOval(
                              child: Container(
                                height: 30,
                                width: 30,
                                color: colorGreen,
                                child: Center(
                                  child: CustomText(
                                    text: "${_offerController.offers.length}",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            CustomText(
                              text:
                                  "${_offerController.offers.length} ${"offers".tr}",
                              color: black,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 22,
                            )
                          ]),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Future<void> showBottomSheetCancelBooking({
  //   required double width,
  //   required double height,
  // }) async {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       backgroundColor: Colors.white,
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, setState) {
  //           return Container(
  //             height: 240,
  //             padding: const EdgeInsets.symmetric(horizontal: 34),
  //             clipBehavior: Clip.antiAlias,
  //             decoration: ShapeDecoration(
  //               color: const Color(0xFFF8F8F8),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(24),
  //               ),
  //             ),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   width: double.infinity,
  //                   decoration: ShapeDecoration(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                   ),
  //                   child: Text(
  //                     "ContactTheHedoTeam".tr,
  //                     textAlign: TextAlign.center,
  //                     style: const TextStyle(
  //                         color: Colors.black,
  //                         fontSize: 16,
  //                         fontFamily: 'HT Rakik',
  //                         fontWeight: FontWeight.w500),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Obx(
  //                   () => _offerController.isBookingCancelLoading.value
  //                       ? const Center(
  //                           child: CircularProgressIndicator(
  //                               color: Color(0xFFD75051)))
  //                       : InkWell(
  //                           onTap: () async {
  //                             log("End Trip Taped ${widget.booking.id}");

  //                             bool bookingCancel =
  //                                 await _offerController.bookingCancel(
  //                                         context: context,
  //                                         bookingId: widget.booking.id!) ??
  //                                     false;
  //                             if (bookingCancel) {
  //                               if (context.mounted) {
  //                                 AppUtil.successToast(context, 'EndTrip'.tr);
  //                                 await Future.delayed(
  //                                     const Duration(seconds: 1));
  //                               }
  //                               Get.offAll(const TouristBottomBar());
  //                             }
  //                           },
  //                           child: Container(
  //                             height: 40,
  //                             width: 251,
  //                             alignment: Alignment.center,
  //                             decoration: BoxDecoration(
  //                               borderRadius:
  //                                   const BorderRadius.all(Radius.circular(8)),
  //                               border: Border.all(
  //                                 color: const Color(0xFFD33030),
  //                               ),
  //                             ),
  //                             child: Text(
  //                               "EndTrip".tr,
  //                               textAlign: TextAlign.center,
  //                               style: const TextStyle(
  //                                   color: Color(0xFFD75051),
  //                                   fontSize: 16,
  //                                   fontFamily: 'HT Rakik',
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                           ),
  //                         ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         });
  //       });
  // }
//   Future<void> showDialogCancelBooking() async {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(32.0)),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//           const SizedBox(height: 30),

//           GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: Container(
//                 height: 40,
//                 width: 357,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: colorGreen,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                    "ContactTheHedoTeam".tr,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Obx(() => _offerController.isBookingCancelLoading.value
//                 ? const Center(
//                     child: CircularProgressIndicator(color: Colors.black),
//                   )
//                 : GestureDetector(
//                     onTap: () async {
//                       log("End Trip Taped ${widget.booking.id}");

//                       bool bookingCancel =
//                           await _offerController.bookingCancel(
//                                   context: context,
//                                   bookingId: widget.booking.id!) ??
//                               false;
//                       if (bookingCancel) {
//                         if (context.mounted) {
//                           AppUtil.successToast(context, 'EndTrip'.tr);
//                           await Future.delayed(const Duration(seconds: 1));
//                         }
//                         Get.offAll(const TouristBottomBar());
//                       }
//                     },
//                     child: Text(
//                       "EndTrip".tr,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                   )),
//           ],
//         ),
//       );
//     },
//   );
// }

// Future<void> showDialogCancelBooking() async {
//   double dialogWidth = MediaQuery.of(context).size.width * 0.588; // 76.6% of screen width
// double buttonWidth = MediaQuery.of(context).size.width * 1.191;
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//         ),
//         content: Container(
//           width: dialogWidth,
//           height: 118,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return ContactDialog();
//     },
//   );
// },
//                 child: Container(
//                   height: 40,
//                 width: buttonWidth,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: const Color(0xFF37B268)),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     "Contact Hido Team",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: const Color(0xFF37B268),
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               Obx(() => _offerController.isBookingCancelLoading.value
//                   ? const Center(
//                       child: CircularProgressIndicator(color: Colors.black),
//                     )
//                   : GestureDetector(
//                       onTap: () async {
//                         log("End Trip Taped ${widget.booking.id}");

//                         bool bookingCancel =
//                             await _offerController.bookingCancel(
//                                     context: context,
//                                     bookingId: widget.booking.id!) ??
//                                 false;
//                         if (bookingCancel) {
//                           if (context.mounted) {
//                             AppUtil.successToast(context, 'EndTrip'.tr);
//                             await Future.delayed(const Duration(seconds: 1));
//                           }
//                           Get.offAll(const TouristBottomBar());
//                         }
//                       },

//                         child: Text(
//                           "Cancel Tour",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: const Color(0xFFDC362E),
//                           ),
//                         ),
//                     )),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// void _showContactDialog(BuildContext context) {
//   double dialogWidth = MediaQuery.of(context).size.width * 0.788; // 80% of screen width

//   showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return Center(
//         child: Container(
//           width: 360,
//           height: 400,
//           child: AlertDialog(
//             backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(8.0)),
//             ),
//             // title: Row(
//             //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //   children: [
//             //     GestureDetector(
//             //       onTap: () {
//             //         Get.back();
//             //       },
//             //       child: Icon(Icons.close),
//             //     ),
//             //   ],
//             // ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 MouseRegion(
//                   cursor: SystemMouseCursors.click,
//                   child: GestureDetector(
//                     onTap: () async {
//                 Uri uri = Uri.parse(
//                   'mailto:info@hido.app?subject=Hido tourists complaint&body=Hi, Flutter developer',
//                 );
//                 if (!await launcher.launchUrl(uri)) {
//                   debugPrint(
//                       "Could not launch the uri"); // because the simulator doesn't has the email app
//                 }
//               },
//                     child: Container(
//                       width: 251,
//                       height: 40,
//                       margin: EdgeInsets.only(bottom: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: const Color(0xFF37B268)),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Send email",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: const Color(0xFF37B268),
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 MouseRegion(
//                   cursor: SystemMouseCursors.click,
//                   child: GestureDetector(
//                     onTap: () async {
//                 Uri uri = Uri.parse('tel:0541804358');
//                 if (!await launcher.launchUrl(uri)) {
//                   debugPrint(
//                       "Could not launch the uri"); // because the simulator doesn't has the phone app
//                 }
//               },

//                     child: Container(
//                       width: 251,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: const Color(0xFF37B268)),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Call",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: const Color(0xFF37B268),
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

  Widget ajwadiImages() {
    var items =
        _ajwadiUrlImages.map((url) => buildImage(url)).toList().sublist(0, 3);
    const emptyUrl = " ";
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
              child: const Center(
                child: CustomText(
                  text: "+2",
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
