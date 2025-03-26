import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/app_constants.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/view/widgets/event_booking_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/sign_sheet.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class BottomEventBooking extends StatefulWidget {
  const BottomEventBooking({
    super.key,
    required this.event,
    required this.avilableDate,
    this.address = '',
  });
  final Event event;
  final List<DateTime> avilableDate;
  final String address;

  @override
  State<BottomEventBooking> createState() => _BottomEventBookingState();
}

class _BottomEventBookingState extends State<BottomEventBooking> {
  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;
  final _eventController = Get.put(EventController());

  @override
  void initState() {
    super.initState();
    _eventController.address(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.041),
      color: Colors.white,
      width: double.infinity,
      height: width * 0.38,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.01),
            child: Row(
              children: [
                CustomText(
                  text: "pricePerPerson".tr,
                  fontSize: width * 0.038,
                  color: colorDarkGrey,
                  fontWeight: FontWeight.w400,
                ),
                CustomText(
                  text: " /  ",
                  fontWeight: FontWeight.w900,
                  fontSize: width * 0.043,
                  color: Colors.black,
                ),
                CustomText(
                  text: widget.event.price != 0
                      ? '${widget.event.price} ${'sar'.tr}'
                      : "free".tr,
                  fontWeight: FontWeight.w900,
                  fontSize: width * 0.043,
                  fontFamily: 'HT Rakik',
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              //padding: const EdgeInsets.only(right: 16, left: 16, bottom: 32),
              padding: EdgeInsets.only(
                  right: width * 0.0025,
                  left: width * 0.0025,
                  bottom: width * 0.08),

              child: IgnorePointer(
                ignoring: widget.event.daysInfo!.isEmpty ||
                    widget.event.totalSeats == freeSeatCap,
                child: CustomButton(
                  onPressed: () {
                    _eventController.DateErrorMessage.value = false;

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
                                topRight: Radius.circular(width * 0.06)),
                          ));
                    } else {
                      Get.bottomSheet(
                          EventBookingSheet(
                            event: widget.event,
                            avilableDate: widget.avilableDate,
                            address: widget.address,
                          ),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(width * 0.06),
                                topRight: Radius.circular(width * 0.06)),
                          ));
                      AmplitudeService.amplitude.track(
                        BaseEvent('Click on "Book event" button'),
                      );
                    }
                  },
                  iconColor: darkPurple,
                  title: widget.event.daysInfo!.isEmpty
                      ? 'fullyBooked'.tr
                      : "book".tr,
                  icon: AppUtil.rtlDirection2(context)
                      ? const Icon(Icons.arrow_back_ios)
                      : const Icon(Icons.arrow_forward_ios),
                  buttonColor: widget.event.daysInfo!.isEmpty
                      ? colorlightGreen
                      : colorGreen,
                  borderColor: widget.event.daysInfo!.isEmpty
                      ? colorlightGreen
                      : colorGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
