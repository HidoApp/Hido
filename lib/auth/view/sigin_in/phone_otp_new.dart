import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/provided_services.dart';
import 'package:ajwad_v4/auth/widget/countdown_timer.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
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
  const PhoneOTP(
      {super.key, this.phoneNumber, required this.otp, this.type = 'stepper'});
  final String? phoneNumber;
  final String otp;
  final String? type;
  @override
  State<PhoneOTP> createState() => _PhoneOTPState();
}

class _PhoneOTPState extends State<PhoneOTP> {
  bool timerEnd = false;
  late String otp;
  final _authController = Get.put(AuthController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void stepper(String value) {
    if (value == otp) {
      Get.back();
      if (_authController.activeBar.value == 3) {
        log('Succes');
        // Get.offAll(() => OnboardingScreen());
      } else {
        _authController.activeBar.value++;
      }
    }
  }

  void signUp(String otpCode) async {
    final isSuccess = await _authController.signUpWithRowad(
        context: context,
        nationalId: _authController.localID.toString(),
        otp: otpCode,
        birthDate: _authController.birthDate.value);
    if (isSuccess) {
      Get.to(() => const ProvidedServices());
    }
  }

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
              text: widget.phoneNumber != null
                  ? "otpPhone".tr
                  : "We've sent code to your number ",
              fontSize: width * 0.043,
              color: starGreyColor,
              fontWeight: FontWeight.w500,
            ),
            if (widget.phoneNumber != null)
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
                length: 6,
                onCompleted: (value) {
                  switch (widget.type) {
                    case 'stepper':
                      stepper(value);
                      break;
                    case 'signIn':
                      break;
                    case 'signUp':
                      signUp(value);
                      break;
                    default:
                  }
                },
                // validator: (s) {
                //   return s == widget.otp ? null : '';
                // },
                //errorText: 'invalid code',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autofocus: true,
                keyboardType: TextInputType.number,
                separatorBuilder: (index) => SizedBox(
                  width: width * 0.030,
                ),
                followingPinTheme: PinTheme(
                  width: width * 0.1282,
                  height: width * 0.1282,
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
                  width: width * 0.1282,
                  height: width * 0.1282,
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
                  width: width * 0.1282,
                  height: width * 0.1282,
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
              height: width * 0.061,
            ),
            Center(
                child: Obx(() => _authController.isSignUpRowad.value
                    ? const CircularProgressIndicator.adaptive()
                    : const CountdownTimer())),
          ],
        ),
      ),
    );
  }
}
