import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/widget/card_date_formater.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreditForm extends StatelessWidget {
  const CreditForm(
      {super.key,
      required this.paymentController,
      required this.cardHolder,
      required this.cardDate,
      required this.cardNumber,
      required this.cardCvv});
  final PaymentController paymentController;
  final TextEditingController cardHolder;
  final TextEditingController cardDate;
  final TextEditingController cardNumber;
  final TextEditingController cardCvv;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Form(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "cardholderName".tr,
            fontSize: width * 0.043,
          ),
          SizedBox(
            height: width * .0205,
          ),
          SizedBox(
            height: width * 0.123,
            child: Obx(
              () => TextFormField(
                controller: cardHolder,
                cursorHeight: width * .051,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: width * 0.030, vertical: width * 0.020),
                  hintText: 'hintHolder'.tr,
                  helperStyle: TextStyle(
                    color: borderGrey,
                    fontSize: width * 0.038,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: paymentController.isNameValid.value
                              ? borderGrey
                              : colorRed,
                          width: 1)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: paymentController.isNameValid.value
                            ? borderGrey
                            : colorRed,
                        width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => paymentController.isNameValid.value
                ? const SizedBox()
                : CustomText(
                    text: 'activityError'.tr,
                    color: colorRed,
                    fontSize: width * .028,
                  ),
          ),
          SizedBox(
            height: width * 0.030,
          ),
          CustomText(
            text: "cardNumber".tr,
            fontSize: width * 0.043,
          ),
          SizedBox(
            height: width * 0.02,
          ),
          SizedBox(
            height: width * 0.123,
            child: TextFormField(
              controller: cardNumber,
              cursorHeight: width * 0.051,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16)
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: width * 0.030, vertical: width * 0.020),
                hintText: 'enter12digitCardNumber'.tr,
                helperStyle: TextStyle(
                  color: borderGrey,
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.w400,
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: borderGrey, width: 1)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: paymentController.isCardNumberValid.value
                          ? borderGrey
                          : colorRed,
                      width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Obx(
            () => paymentController.isCardNumberValid.value
                ? const SizedBox()
                : CustomText(
                    text: 'invalidNumber'.tr,
                    color: colorRed,
                    fontSize: width * 0.028,
                  ),
          ),
          SizedBox(
            height: width * .03,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "expirationDate".tr,
                      fontSize: width * .043,
                    ),
                    SizedBox(
                      height: width * 0.020,
                    ),
                    SizedBox(
                      height: width * 0.123,
                      width: width * 0.438,
                      child: TextFormField(
                        controller: cardDate,
                        cursorHeight: width * 0.0512,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          CardMonthInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.0307,
                              vertical: width * .02),
                          hintText: 'dateHint'.tr,
                          helperStyle: TextStyle(
                            color: borderGrey,
                            fontSize: width * 0.038,
                            fontWeight: FontWeight.w400,
                          ),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide:
                                  BorderSide(color: borderGrey, width: 1)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: paymentController.isDateValid.value
                                    ? borderGrey
                                    : colorRed,
                                width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => paymentController.isDateValid.value
                          ? const SizedBox()
                          : CustomText(
                              text: 'invalidDate'.tr,
                              color: colorRed,
                              fontSize: width * 0.028,
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width * 0.0410,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "cvv".tr,
                      fontSize: width * .0435,
                    ),
                    SizedBox(
                      height: width * 0.02,
                    ),
                    SizedBox(
                      height: width * 0.123,
                      width: width * 0.438,
                      child: Obx(
                        () => TextFormField(
                          controller: cardCvv,
                          obscureText: !paymentController.showCvv.value,
                          cursorHeight: width * 0.051,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4)
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: width * 0.0307,
                                vertical: width * .02),
                            hintText: "cvv".tr,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                paymentController.showCvv.value =
                                    !paymentController.showCvv.value;
                              },
                              child: Icon(
                                paymentController.showCvv.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: almostGrey,
                              ),
                            ),
                            helperStyle: TextStyle(
                              color: borderGrey,
                              fontSize: width * 0.038,
                              fontWeight: FontWeight.w400,
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide:
                                    BorderSide(color: borderGrey, width: 1)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: paymentController.isCvvValid.value
                                      ? borderGrey
                                      : colorRed,
                                  width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => paymentController.isCvvValid.value
                          ? const SizedBox()
                          : CustomText(
                              text: 'invalidCvv'.tr,
                              color: colorRed,
                              fontSize: width * 0.028,
                            ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
