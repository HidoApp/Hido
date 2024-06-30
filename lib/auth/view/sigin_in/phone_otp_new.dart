import 'dart:developer';

import 'package:ajwad_v4/auth/widget/countdown_timer.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PhoneOTP extends StatefulWidget {
  const PhoneOTP({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  State<PhoneOTP> createState() => _PhoneOTPState();
}

class _PhoneOTPState extends State<PhoneOTP> {
  bool timerEnd = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(''),
      body: ScreenPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'otp'.tr,
              fontSize: width * 0.051,
              fontWeight: FontWeight.w500,
            ),
            CustomText(
              text: "otpPhone".tr,
              fontSize: width * 0.043,
              color: starGreyColor,
              fontWeight: FontWeight.w500,
            ),
            CustomText(
              text: widget.phoneNumber,
              fontSize: width * 0.043,
              color: colorGreen,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: width * 0.061,
            ),
            Center(
              child: Pinput(
                onCompleted: (value) => log(value),
                validator: (s) {
                  return s == '2222' ? null : '';
                },
                //errorText: 'invalid code',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autofocus: true,
                keyboardType: TextInputType.number,
                separatorBuilder: (index) => SizedBox(
                  width: width * 0.102,
                ),
                followingPinTheme: PinTheme(
                  width: width * 0.153,
                  height: width * 0.153,
                  textStyle: TextStyle(
                      fontSize: width * 0.038,
                      fontWeight: FontWeight.w400,
                      color: colorGreen),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                defaultPinTheme: PinTheme(
                  width: width * 0.153,
                  height: width * 0.153,
                  textStyle: TextStyle(
                      fontSize: width * 0.038,
                      fontWeight: FontWeight.w400,
                      color: colorGreen),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorGreen),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                errorPinTheme: PinTheme(
                  width: width * 0.153,
                  height: width * 0.153,
                  textStyle: TextStyle(
                      fontSize: width * 0.038,
                      fontWeight: FontWeight.w400,
                      color: colorRed),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: width * 0.102,
            ),
            const Center(child: CountdownTimer()),
          ],
        ),
      ),
    );
  }
}
