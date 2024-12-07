import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/view/payment_type_new.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:ajwad_v4/request/local_notification.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/view/widgets/review_details_tile.dart';
import 'package:ajwad_v4/services/view/widgets/review_guests.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:ajwad_v4/widgets/promocode_field.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  final paymentController = Get.put(PaymentController());

  double finalCost = 0;
  @override
  void initState() {
    super.initState();
    finalCost = (widget.event.price! * widget.person).toDouble();
    log(widget.person.toString());
    log(finalCost.toString());
  }

  void freeEventBooking() async {
    await _eventController.checkAndBookEvent(
        context: context,
        eventId: widget.event.id,
        couponId: paymentController.couponId.value,
        dayId:
            widget.event.daysInfo![_eventController.selectedDateIndex.value].id,
        person: widget.person,
        date: _eventController.selectedDate.value);
    if (!mounted) return;

    final updatedEvent = await _eventController.getEventById(
        context: context, id: widget.event.id);
    if (!mounted) return;
    Get.offAll(() => const TouristBottomBar());
    log("inside adventure");
    log("${updatedEvent!.booking?.last.id}");
    LocalNotification().showEventNotification(
        context,
        updatedEvent.booking?.last.id,
        _eventController.selectedDate.value,
        updatedEvent.nameEn,
        updatedEvent.nameAr);
    Get.to(() => TicketDetailsScreen(
          event: updatedEvent,
          icon: SvgPicture.asset('assets/icons/event.svg'),
          bookTypeText: "event",
        ));

    AmplitudeService.amplitude.track(BaseEvent(
      'Get Event Ticket',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          "reviewbooking".tr,
        ),
        extendBodyBehindAppBar: false,
        body: Container(
          padding: EdgeInsets.all(width * 0.041),
          child: SizedBox(
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
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
                    PromocodeField(
                      type: 'EVENT',
                      price: (widget.event.price! * widget.person).toDouble(),
                    ),
                    if (paymentController.isUnderMinSpend.value)
                      CustomText(
                        text:
                            '${'couponMiSpend'.tr}  ${paymentController.coupon.value.minSpend} ${'orAbove'.tr}',
                        fontSize: width * 0.028,
                        color: starGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
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
                    if (paymentController.validateType.value == 'applied') ...[
                      SizedBox(
                        height: width * 0.0102,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: 'discount'.tr,
                            fontSize: width * 0.038,
                            fontFamily: AppUtil.SfFontType(context),
                            color: starGreyColor,
                          ),
                          const Spacer(),
                          CustomText(
                            text:
                                '${"sar".tr} ${paymentController.discountPrice.toString()}-',
                            fontSize: width * 0.038,
                            fontFamily: AppUtil.SfFontType(context),
                            color: starGreyColor,
                          )
                        ],
                      ),
                    ],
                    SizedBox(
                      height: width * 0.051,
                    ),
                    Obx(() => _eventController.ischeckBookingLoading.value ||
                            _eventController.isEventByIdLoading.value
                        ? const Center(
                            child: CircularProgressIndicator.adaptive())
                        : CustomButton(
                            onPressed: () async {
                              final isValid = _eventController.checkForOneHour(
                                  context: context);
                              if (!isValid) {
                                return;
                              }
                              if (paymentController.isPriceFree.value) {
                                freeEventBooking();
                              } else {
                                Get.to(
                                  () => PaymentType(
                                    event: widget.event,
                                    type: 'event',
                                    personNumber: widget.person,
                                    price: paymentController
                                                .validateType.value ==
                                            'applied'
                                        ? paymentController.finalPrice.value
                                        : (widget.event.price! * widget.person)
                                            .toDouble(),
                                    eventController: _eventController,
                                  ),
                                );
                                AmplitudeService.amplitude.track(BaseEvent(
                                  'Go to payment screen',
                                ));
                              }
                            },
                            title: 'checkout'.tr))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
