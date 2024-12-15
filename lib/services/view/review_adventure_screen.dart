import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:ajwad_v4/request/local_notification.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
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

import '../../payment/view/payment_type_new.dart';

class ReviewAdventure extends StatefulWidget {
  const ReviewAdventure({
    super.key,
    required this.person,
    required this.adventure,
  });
  final int person;
  final Adventure adventure;

  @override
  State<ReviewAdventure> createState() => _ReviewAdventureState();
}

class _ReviewAdventureState extends State<ReviewAdventure> {
  final _adventureController = Get.put(AdventureController());
  final paymentController = Get.put(PaymentController());
  Invoice? invoice;
  bool isCheckingForPayment = false;
  double finalCost = 0;

  @override
  void initState() {
    super.initState();
    finalCost = (widget.adventure.price * widget.person).toDouble();
  }

  void freeAdventureBooking() async {
    final isSucces = await _adventureController.checkAdventureBooking(
      adventureID: widget.adventure.id,
      context: context,
      personNumber: widget.person,
      couponId: paymentController.couponId.value,
    );
    if (!mounted) return;

    if (isSucces) {
      final updatedAdventure = await _adventureController.getAdvdentureById(
          context: context, id: widget.adventure.id);
      if (!mounted) return;
      Get.offAll(() => const TouristBottomBar());
      Get.to(() => TicketDetailsScreen(
            adventure: updatedAdventure,
            icon: SvgPicture.asset('assets/icons/adventure.svg'),
            bookTypeText: "adventure",
          ));
      log("inside adventure");
      // log("${updatedAdventure!.booking?.last.id}");
      log(widget.adventure.date!);
      log(widget.adventure.nameEn!);
      log(widget.adventure.nameAr!);

      LocalNotification().showAdventureNotification(
          context,
          updatedAdventure!.booking?.last.id,
          updatedAdventure.date,
          updatedAdventure.nameEn,
          updatedAdventure.nameAr);

      AmplitudeService.amplitude.track(BaseEvent(
        'Get Adventure Ticket',
      ));
    }
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
                      text: "adventuredetails".tr,
                      fontSize: width * 0.043,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: width * 0.0205,
                    ),
                    ReviewDetailsTile(
                        title: _adventureController.address.value.isNotEmpty
                            ? _adventureController.address.value
                            : AppUtil.rtlDirection2(context)
                                ? widget.adventure.regionAr ?? ""
                                : widget.adventure.regionEn ?? "",
                        image: "assets/icons/map_pin.svg"),
                    SizedBox(
                      height: width * .010,
                    ),
                    // Details

                    ReviewDetailsTile(
                        title: AppUtil.formatBookingDate(
                            context, widget.adventure.date!),
                        image: 'assets/icons/calendar.svg'),
                    SizedBox(
                      height: width * .010,
                    ),

                    ReviewDetailsTile(
                        title: widget.adventure.times != null &&
                                widget.adventure.times!.isNotEmpty
                            ? '${widget.adventure.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.startTime)).join(', ')} - ${widget.adventure.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.endTime)).join(', ')}'
                            : '5:00-8:00 AM',
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
                      price:
                          (widget.adventure.price * widget.person).toDouble(),
                      type: 'ADVENTURE',
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
                    Obx(() => _adventureController
                                .ischeckBookingLoading.value ||
                            _adventureController.isAdventureByIdLoading.value ||
                            paymentController.isPaymenInvoiceLoading.value
                        ? const Center(
                            child: CircularProgressIndicator.adaptive())
                        : CustomButton(
                            onPressed: () async {
                              final isValid = _adventureController.checkForOneHour(
                                  context: context,
                                  date: widget.adventure.date,
                                  time:
                                      '${widget.adventure.date ?? ''} ${widget.adventure.times!.first.startTime}');
                              if (!isValid) {
                                return;
                              }
                              if (paymentController.isPriceFree.value) {
                                freeAdventureBooking();
                              } else {
                                Get.to(
                                  () => PaymentType(
                                    adventure: widget.adventure,
                                    type: 'adventure',
                                    personNumber: widget.person,
                                    price:
                                        paymentController.validateType.value ==
                                                'applied'
                                            ? paymentController.finalPrice.value
                                            : (widget.adventure.price *
                                                    widget.person)
                                                .toDouble(),
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
