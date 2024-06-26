import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/widget/card_date_formater.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Cardholder name",
          fontSize: 17,
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 48,
          child: Obx(
            () => TextFormField(
              controller: cardHolder,
              cursorHeight: 20,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: 'Enter the holder name of this card',
                helperStyle: const TextStyle(
                  color: borderGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  fontSize: 11,
                ),
        ),
        SizedBox(
          height: 12,
        ),
        CustomText(
          text: "Card number",
          fontSize: 17,
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: cardNumber,
            cursorHeight: 20,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16)
            ],
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintText: 'Enter 12 digital card number',
              helperStyle: const TextStyle(
                color: borderGrey,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  fontSize: 11,
                ),
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Expiration Date",
                    fontSize: 17,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 48,
                    width: 171,
                    child: TextFormField(
                      controller: cardDate,
                      cursorHeight: 20,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        hintText: 'MM/YYYY',
                        helperStyle: const TextStyle(
                          color: borderGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                            fontSize: 11,
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "CVV",
                    fontSize: 17,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 48,
                    width: 171,
                    child: Obx(
                      () => TextFormField(
                        controller: cardCvv,
                        obscureText: !paymentController.showCvv.value,
                        cursorHeight: 20,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4)
                        ],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          hintText: 'CVV',
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
                          helperStyle: const TextStyle(
                            color: borderGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                            fontSize: 11,
                          ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
