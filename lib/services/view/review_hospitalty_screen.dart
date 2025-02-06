// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/view/payment_type_new.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:ajwad_v4/request/local_notification.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
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


class ReviewHospitalty extends StatefulWidget {
  const ReviewHospitalty(
      {super.key,
      required this.hospitality,
      required this.maleGuestNum,
      required this.femaleGuestNum,
      required this.servicesController});
  final Hospitality hospitality;
  final int maleGuestNum;
  final int femaleGuestNum;
  final HospitalityController servicesController;

  @override
  State<ReviewHospitalty> createState() => _ReviewHospitaltyState();
}

class _ReviewHospitaltyState extends State<ReviewHospitalty> {
  Invoice? invoice;
  bool isCheckingForPayment = false;
  double finalCost = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalCost = widget.hospitality.price *
        (widget.maleGuestNum + widget.femaleGuestNum).toDouble();
  }

  PaymentController paymentController = Get.put(PaymentController());
  void freeHospitaltyBooking() async {
    final isSucces = await widget.servicesController.checkAndBookHospitality(
      context: context,
      hospitalityId: widget.hospitality.id,
      date: widget.servicesController.selectedDate.value,
      dayId: widget.hospitality
          .daysInfo[widget.servicesController.selectedDateIndex.value].id,
      numOfMale: widget.maleGuestNum,
      numOfFemale: widget.femaleGuestNum,
      couponId: paymentController.couponId.value,
    );
    if (!mounted) return;
    log("isSucces");
    log(isSucces.toString());
    if (isSucces) {
      final updatedHospitality = await widget.servicesController
          .getHospitalityById(context: context, id: widget.hospitality.id);
      log(updatedHospitality!.booking!.last.guestInfo.male.toString());
      log(updatedHospitality.booking!.last.guestInfo.female.toString());
      log(updatedHospitality.booking!.last.guestInfo.dayId.toString());

      Get.offAll(() => const TouristBottomBar());

      Get.to(() => TicketDetailsScreen(
            hospitality: updatedHospitality,
            icon: SvgPicture.asset('assets/icons/hospitality.svg'),
            bookTypeText: "hospitality",
          ));

      AmplitudeService.amplitude.track(BaseEvent(
        'Get Hospitality Ticket',
      ));

      LocalNotification().showHospitalityNotification(
          context,
          updatedHospitality.booking?.last.id,
          widget.servicesController.selectedDate.value,
          updatedHospitality.mealTypeEn,
          updatedHospitality.mealTypeAr,
          updatedHospitality.titleEn,
          updatedHospitality.titleAr);
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    final height = MediaQuery.sizeOf(context).height;

    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: CustomAppBar(
          "reviewbooking".tr,
        ),
        body: Container(
          padding: EdgeInsets.all(width * 0.041),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "hospitalitydetails".tr,
                      fontSize: width * 0.043,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: width * 0.0205,
                    ),
                    ReviewDetailsTile(
                        title:
                            widget.servicesController.address.value.isNotEmpty
                                ? widget.servicesController.address.value
                                : AppUtil.rtlDirection2(context)
                                    ? widget.hospitality.regionAr ?? ""
                                    : widget.hospitality.regionEn ?? "",
                        image: "assets/icons/map_pin.svg"),
                    SizedBox(
                      height: width * 0.010,
                    ),
                    // Details
                    ReviewDetailsTile(
                        title:
                            '${AppUtil.formatTimeOnly(context, widget.hospitality.daysInfo.first.startTime)} - ${AppUtil.formatTimeOnly(context, widget.hospitality.daysInfo.first.endTime)} ',
                        image: "assets/icons/Clock.svg"),
                    SizedBox(
                      height: width * 0.010,
                    ),
                    ReviewDetailsTile(
                        title: AppUtil.rtlDirection2(context)
                            ? widget.hospitality.mealTypeAr
                            : AppUtil.capitalizeFirstLetter(
                                widget.hospitality.mealTypeEn),
                        image: 'assets/icons/meal.svg'),
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
                      text: "numberofpeople".tr,
                      fontSize: width * 0.043,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: width * 0.0205,
                    ),
                    if (widget.maleGuestNum != 0)
                      ReviewGuestsTile(
                        guest: widget.maleGuestNum,
                        title: 'male'.tr,
                      ),
                    if (widget.femaleGuestNum != 0)
                      ReviewGuestsTile(
                        guest: widget.femaleGuestNum,
                        title: 'female'.tr,
                      ),
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
                      text: "bookingdate".tr,
                      fontSize: width * 0.043,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: width * 0.0205,
                    ),
                    CustomText(
                      color: almostGrey,
                      text: AppUtil.formatBookingDate(context,
                          widget.servicesController.selectedDate.value),
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                    ),
                    SizedBox(
                      height: width * 0.041,
                    ),
                    const Divider(
                      color: lightGrey,
                    ),
                    SizedBox(
                      height: height * 0.110,
                    ),
                    //discount widget
                    PromocodeField(
                      price: finalCost,
                      type: 'HOSPITALITY',
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
                        Row(
                          children: [
                            CustomText(
                              // text: ' ${widget.hospitality.price.toString()} ',
                              text: ' ${finalCost.toString()} ',

                              fontSize: width * 0.051,
                            ),
                            CustomText(
                              text: 'sar'.tr,
                              fontSize: width * 0.051,
                            ),
                          ],
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
                    Obx(
                      () => widget.servicesController.isCheckAndBookLoading
                                  .value ||
                              widget.servicesController.isHospitalityByIdLoading
                                  .value ||
                              paymentController.isPaymenInvoiceLoading.value
                          ? const Center(
                              child: CircularProgressIndicator.adaptive())
                          : CustomButton(
                              onPressed: (() async {
                                final isValid = widget.servicesController
                                    .checkForOneHour(context: context);
                                if (!isValid) {
                                  return;
                                }
                                if (paymentController.isPriceFree.value) {
                                  freeHospitaltyBooking();
                                } else {
                                  Get.to(
                                    () => PaymentType(
                                      price: paymentController
                                                  .validateType.value ==
                                              'applied'
                                          ? paymentController.finalPrice.value
                                          : finalCost,
                                      type: "hospitality",
                                      hospitality: widget.hospitality,
                                      servicesController:
                                          widget.servicesController,
                                      male: widget.maleGuestNum,
                                      female: widget.femaleGuestNum,
                                    ),
                                  );

                                  AmplitudeService.amplitude.track(BaseEvent(
                                    'Go to payment screen',
                                  ));
                                }
                              }),
                              title: 'checkout'.tr),
                    ),
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
