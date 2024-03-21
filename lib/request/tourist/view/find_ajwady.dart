import 'dart:developer';

import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/view/select_ajwady_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/StackWidgets.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    _offerController.getOffers(
      context: context,
      placeId: widget.placeId,
      bookingId: widget.booking.id!,
    );
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
          await showBottomSheetCancelBooking(height: height, width: width);
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
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
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
                                    color: tileGreyColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
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
                                        '${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.booking.date!))} - ${widget.booking.time}',
                                    color: tileGreyColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/unselected_${ widget.booking.vehicleType! }_icon.svg',width: 20,),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                    text: widget.booking.vehicleType!,
                                    color: tileGreyColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
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
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          )),
                          context: context,
                          builder: (context) {
                            return SelectAjwadySheet(
                              place: widget.place,
                              // booking: widget.booking,
                            );
                          });
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
                                child:  Center(
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

  Future<void> showBottomSheetCancelBooking({
    required double width,
    required double height,
  }) async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 240,
              padding: const EdgeInsets.symmetric(horizontal: 34),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFF8F8F8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    decoration: ShapeDecoration(
                      color: colorGreen,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1.50,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: colorGreen,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (!AppUtil.rtlDirection(context))
                          SvgPicture.asset('assets/icons/message-circle.svg'),
                        Text(
                          "ContactTheHedoTeam".tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'HT Rakik',
                              fontWeight: FontWeight.w500),
                        ),
                        if (AppUtil.rtlDirection(context))
                          SvgPicture.asset('assets/icons/message-circle.svg')
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),
                  Obx(
                    () => _offerController.isBookingCancelLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFFD75051)))
                        : InkWell(
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
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                }
                                Get.offAll(const TouristBottomBar());
                              }
                            },
                            child: Text(
                              "EndTrip".tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Color(0xFFD75051),
                                  fontSize: 16,
                                  fontFamily: 'HT Rakik',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                  ),
                ],
              ),
            );
          });
        });
  }

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
