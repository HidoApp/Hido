import 'dart:async';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/view/offers_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ajwad_v4/request/widgets/CansleDialog.dart';

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
  final _touristExploreController = Get.put(TouristExploreController());
  late double width, height;

  bool isDetailsTapped = false;
  late Booking? checkBooking;

  Timer? countdownTimer;
  void getBookingForCountdown() async {
    checkBooking = await _touristExploreController.getTouristBookingById(
        context: context, bookingId: widget.booking.id!);
  }

  // void getOfferinfo() async {
  //   thePlace = await _touristExploreController.getPlaceById(
  //       id: widget.place!.id!, context: context);

  //   if (thePlace!.booking!.length != 0 &&
  //       thePlace!.booking!.first.orderStatus == 'PENDING') {
  //     isViewBooking.value = true;
  //     lockPlaces.value = true;
  //   } else if (thePlace!.booking!.length != 0 &&
  //       thePlace!.booking!.first.orderStatus == 'ACCEPTED') {
  //     isHasOffers.value = true;

  //     isViewBooking.value = true;

  //     theProfile = await _profileController.getProfile(
  //         context: context,
  //         profileId: thePlace!.booking!.first.profileId ?? '');
  //   } else {
  //     isViewBooking.value = false;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getBookingForCountdown();
    _offerController.getOffers(
      context: context,
      placeId: widget.placeId,
      bookingId: widget.booking.id!,
    );

    if (_offerController.offers != [] || _offerController.offers.isNotEmpty) {}
    if (_offerController.offers == [] || _offerController.offers.isEmpty) {}
    // AmplitudeService.initializeAmplitude();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: CustomAppBar(
        "findLocal".tr,
        action: true,
        onPressedAction: () async {
          AmplitudeService.amplitude.track(BaseEvent(
            'Click on Cancel Tour booking ',
          ));
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CancelBookingDialog(
                dialogWidth: 250,
                buttonWidth: 268,
                booking: widget.booking,
                offerController: _offerController,
              );
            },
          );
        },
      ),
      body: Obx(() {
        if (_offerController.isOffersLoading.value ||
            _touristExploreController.isBookingByIdLoading.value) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            getBookingForCountdown();
            await _offerController.getOffers(
              context: context,
              placeId: widget.placeId,
              bookingId: widget.booking.id!,
            );
          },
          child: Container(
            color: lightGreyBackground,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.04),
              child: ListView(
                children: [
                  Container(
                    width: 0.999 * width,
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
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
                            fontSize: width * 0.044,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                            color: black,
                          ),
                          trailing: Icon(
                            isDetailsTapped
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: black,
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
                                    SvgPicture.asset('assets/icons/date.svg'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      text: AppUtil.formatBookingDate(
                                          context, widget.booking.date),
                                      color: starGreyColor,
                                      fontSize: width * 0.03,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/time3.svg'),
                                    const SizedBox(
                                      width: 9,
                                    ),
                                    CustomText(
                                      text: AppUtil.rtlDirection2(context)
                                          ? 'من ${AppUtil.formatStringTimeWithLocale(context, widget.booking.timeToGo)} إلى ${AppUtil.formatStringTimeWithLocale(context, widget.booking.timeToReturn)} '
                                          : 'Pick up: ${AppUtil.formatStringTimeWithLocale(context, widget.booking.timeToGo)}, Drop off: ${AppUtil.formatStringTimeWithLocale(context, widget.booking.timeToReturn)}',
                                      color: starGreyColor,
                                      fontSize: width * 0.03,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/guests.svg'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      text:
                                          '${widget.booking.guestNumber} ${'guests'.tr}',
                                      color: starGreyColor,
                                      fontSize: width * 0.03,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
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
                                      color: starGreyColor,
                                      fontSize: width * 0.03,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppUtil.rtlDirection2(context)
                                          ? 'SF Arabic'
                                          : 'SF Pro',
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
                    height: 17,
                  ),
                  Obx(
                    () => Center(
                      child: Visibility(
                        visible: _offerController.offers.isEmpty,
                        child: Container(
                          height: height * 0.450,
                          width: 0.999 * width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Image.asset('assets/images/Loading.gif'),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomText(
                                  text: "searchforLocal".tr,
                                  color: colorGreen,
                                  fontWeight: FontWeight.w400,
                                  fontSize: width * 0.044,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                    child: CustomText(
                                  text: "WeSentYourRequestAndWaiteTillAccepted"
                                      .tr,
                                  color: starGreyColor,
                                  textAlign: TextAlign.center,
                                  fontSize: width * 0.03,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                )),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_offerController.offers.isEmpty) ...[
                    const SizedBox(
                      height: 17,
                    ),
                  ],
                  if (_offerController.offers.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Get.to(() => OfferScreen(
                              place: widget.place,
                              booking: widget.booking,
                            ));

                        AmplitudeService.amplitude.track(BaseEvent(
                          'Receive and view Offers',
                        ));
                      },
                      child: Container(
                        height: 0.08 * height,
                        width: 0.999 * width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(children: [
                          ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount:
                                  _offerController.firstThreeImages.isNotEmpty
                                      ? _offerController.firstThreeImages.length
                                      : 1,
                              itemBuilder: (context, index) {
                                String? image =
                                    _offerController.firstThreeImages[index] ??
                                        '';

                                return Align(
                                    widthFactor: 0.5,
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundImage: image.isNotEmpty
                                          ? CachedNetworkImageProvider(image)
                                          : const AssetImage(
                                                  'assets/images/profile_image.png')
                                              as ImageProvider,
                                    ));
                                //_offerController.offers.length,
                                // itemBuilder: (context, index) {
                                //   return const Align(
                                //     widthFactor: 0.5,
                                //     child: CircleAvatar(
                                //       radius: 22,
                                //       backgroundImage:
                                //       AssetImage(
                                //           'assets/images/ajwadi_image.png'),
                                //     ),
                                //   );
                              }),
                          Align(
                            widthFactor: 0.7,
                            child: Visibility(
                              visible: _offerController.offers.length >
                                  _offerController.firstThreeImages.length,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFFD4F2E0),
                                child: CustomText(
                                  text: (_offerController.offers.length -
                                          _offerController
                                              .firstThreeImages.length)
                                      .toString(),
                                  color: Colors.white,
                                  textAlign: TextAlign.center,
                                  fontFamily: 'Kufam',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 23,
                          ),
                          CustomText(
                            text:
                                "${_offerController.offers.length} ${"offers".tr}",
                            color: black,
                            fontSize: width * 0.044,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: black,
                            size: 15,
                          )
                        ]),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
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
