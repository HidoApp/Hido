import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/payment/view/payment_type_new.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/view/widgets/review_details_tile.dart';
import 'package:ajwad_v4/services/view/widgets/review_guests.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:ajwad_v4/widgets/promocode_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventReview extends StatefulWidget {
  const EventReview({super.key, required this.event, required this.person});
  final Event event;
  final int person;

  @override
  State<EventReview> createState() => _EventReviewState();
}

class _EventReviewState extends State<EventReview> {
  final _eventController = Get.put(EventController());
  int finalCost = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalCost = widget.event.price! * widget.person;

    log(widget.person.toString());
    log(finalCost.toString());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        "reviewbooking".tr,
      ),
      extendBodyBehindAppBar: false,
      body: Container(
        padding: EdgeInsets.all(width * 0.041),
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "eventDetails".tr,
                  fontSize: width * 0.043,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: width * 0.0205,
                ),
                ReviewDetailsTile(
                    title: _eventController.address.isNotEmpty
                        ? _eventController.address.value
                        : AppUtil.rtlDirection2(context)
                            ? widget.event.regionAr ?? ""
                            : widget.event.regionEn ?? "",
                    image: "assets/icons/map_pin.svg"),
                SizedBox(
                  height: width * .010,
                ),
                // Details

                ReviewDetailsTile(
                    title: AppUtil.formatBookingDate(
                        context, _eventController.selectedDate.value),
                    image: 'assets/icons/calendar.svg'),
                SizedBox(
                  height: width * .010,
                ),

                ReviewDetailsTile(
                    title:
                        '${AppUtil.formatTimeOnly(context, widget.event.daysInfo![_eventController.selectedDateIndex.value].startTime)} -  ${AppUtil.formatTimeOnly(context, widget.event.daysInfo![_eventController.selectedDateIndex.value].endTime)}',

                    //  widget.adventure.times != null &&
                    //         widget.adventure.times!.isNotEmpty
                    //     ? widget.adventure.times!
                    //         .map((time) => AppUtil.formatStringTimeWithLocale(
                    //             context, time.startTime))
                    //         .join(', ')
                    //     : '5:00-8:00 AM',
                    image: "assets/icons/Clock.svg"),
                SizedBox(
                  height: width * 0.041,
                ),
                const Divider(
                  color: lightGrey,
                ),
                SizedBox(
                  height: width * 0.03,
                ),
                CustomText(
                  text: "numberOfPeople".tr,
                  fontSize: width * 0.043,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: width * 0.0205,
                ),
                ReviewGuestsTile(
                  guest: widget.person,
                  title: "person".tr,
                ),
                SizedBox(
                  height: width * .041,
                ),
                const Divider(
                  color: lightGrey,
                ),
                SizedBox(
                  height: width * 0.5,
                ),

                ///discount widget
                const PromocodeField(),
                SizedBox(
                  height: width * 0.061,
                ),
                DottedSeparator(
                  color: almostGrey,
                  height: width * 0.002,
                ),
                SizedBox(
                  height: width * 0.09,
                ),
                Row(
                  children: [
                    CustomText(
                      text: 'total'.tr,
                      fontSize: width * 0.051,
                    ),
                    const Spacer(),
                    CustomText(
                      // text: 'SAR ${widget.adventure.price.toString()}',
                      text: '${"sar".tr} ${finalCost.toString()}',

                      fontSize: width * 0.051,
                    )
                  ],
                ),
                SizedBox(
                  height: width * 0.051,
                ),
                Obx(() => _eventController.ischeckBookingLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onPressed: () async {
                          Get.to(
                            () => PaymentType(
                              event: widget.event,
                              type: 'event',
                              personNumber: widget.person,
                              price: widget.event.price! * widget.person,
                              eventController: _eventController,
                            ),
                          );
                        },
                        title: 'checkout'.tr))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
