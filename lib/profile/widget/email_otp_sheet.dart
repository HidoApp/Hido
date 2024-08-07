import 'dart:async';
import 'dart:ffi';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/phone_otp.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_otp_field.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../new-onboarding/view/intro_screen.dart';

class EmailOTPSheet extends StatefulWidget {
  const EmailOTPSheet(
      {super.key,
      required this.profileController,
      required this.responseBody,
      required this.email});
  final ProfileController profileController;
  final Map responseBody;
  final String email;

  @override
  State<EmailOTPSheet> createState() => _EmailOTPSheetState();
}

class _EmailOTPSheetState extends State<EmailOTPSheet>
    with TickerProviderStateMixin {
  String code1 = '', code2 = '', code3 = '', code4 = '';
  late AnimationController _controller;

  int secondsRemaining = 30;
  bool enableResend = false;
  final _formKey = GlobalKey<FormState>();
  var time = "00:30";
  late Timer timer;
  var codeOTP = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    codeOTP = widget.responseBody['otp'];
    startTimer();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    _controller.forward();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining == 0) {
        setState(() {
          timer.cancel();
          enableResend = true;
          time = '00:30';
        });
      } else {
        setState(() {
          int minutes = secondsRemaining ~/ 60;
          int seconds = (secondsRemaining % 60);
          time =
              "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
          secondsRemaining--;
        });
      }
    });
  }

  final _authController = Get.put(AuthController());
  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: width * 1,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: width * 0.05,
            ),
            CustomText(
              text: "Confirm your email",
              fontSize: width * 0.056,
            ),
            SizedBox(
              height: width * 0.020,
            ),
            CustomText(
              text: 'Enter the code we sent over email to',
              fontSize: width * 0.04,
              fontWeight: FontWeight.w400,
            ),
            CustomText(
              text: widget.profileController.profile.email,
              fontSize: width * 0.04,
              fontWeight: FontWeight.w400,
              color: colorGreen,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomOTPField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            code1 = value;
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                      CustomOTPField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            code2 = value;
                            FocusScope.of(context).nextFocus();
                          } else {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                      CustomOTPField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            code3 = value;
                            FocusScope.of(context).nextFocus();
                          } else {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                      CustomOTPField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            code4 = value;
                            FocusScope.of(context).nextFocus();
                          } else {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: width * 0.03,
            ),
            enableResend
                ? Center(
                    child: TextButton(
                    child: CustomText(
                      text: "resendCode".tr,
                      color: colorDarkGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    onPressed: () async {
                      final result = await _authController.sendEmailOTP(
                          email: widget.email, context: context);
                      if (result != null) {
                        setState(() {
                          startTimer();
                          enableResend = false;
                          secondsRemaining = 30;
                          codeOTP = result['otp'];
                        });
                      } else {
                        AppUtil.errorToast(
                            context, 'Error to send otp code,try again later ');
                      }
                    },
                  ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "resendCodeIn".tr,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      CustomText(
                        text: time,
                        color: colorGreen,
                        fontSize: 15,
                      )
                    ],
                  ),
            Obx(
              () => _authController.isEmailUpadting.value
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : CustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          //     Get.off(const TouristBottomBar());

                          final fullOTP = code1 + code2 + code3 + code4;
                          print(fullOTP);

                          if (fullOTP == codeOTP) {
                            print('Matches');

                            var result = await _authController.resetEmail(
                                email: widget.email, context: context);
                            if (result) {
                              _authController.logOut();
                              // Get.offAll(() =>  AccountTypeScreen());
                              Get.offAll(() => const OnboardingScreen());
                              Get.to(() => const SignInScreen());
                            }
                          } else {
                            AppUtil.errorToast(context, 'OTP not matching ');
                          }
                        }
                      },
                      title: "confirm".tr),
            )
          ],
        ),
      ),
    );
  }
}
