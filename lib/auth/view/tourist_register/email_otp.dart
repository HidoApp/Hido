import 'dart:async';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_otp_field.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailOTPScreen extends StatefulWidget {
  const EmailOTPScreen({Key? key, required this.responseBody})
      : super(key: key);

  final Map responseBody;
  @override
  State<EmailOTPScreen> createState() => _EmailOTPScreenState();
}

class _EmailOTPScreenState extends State<EmailOTPScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late double width, height;
  bool isSwitched = false;
  String code1 = '', code2 = '', code3 = '', code4 = '';

  late AnimationController _controller;

  int secondsRemaining = 20;
  bool enableResend = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(minutes: 1));
    _controller.forward();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(""),
          body: SizedBox(
            // width: width*0.,
            child: Stack(
              children: [
                // Container(
                //   height: height,
                //   width: width,
                //   decoration: const BoxDecoration(
                //       image: DecorationImage(
                //     image: AssetImage("assets/images/background_ajwadi.png"),
                //     fit: BoxFit.fill,
                //   )),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: AppUtil.rtlDirection(context)
                            ? const EdgeInsets.only(left: 20)
                            : const EdgeInsets.only(right: 20),
                        child: CustomText(
                          text: "verification".tr,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 50),
                        child: CustomText(
                          text: "sendVerification".tr,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
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
                                    }
                                  },
                                ),
                                CustomOTPField(
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      code3 = value;
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                                CustomOTPField(
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      code4 = value;
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomElevatedButton(
                            title: 'continue'.tr,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //     Get.off(const TouristBottomBar());

                                final fullOTP = code1 + code2 + code3 + code4;
                                print(fullOTP);

                                if (fullOTP == widget.responseBody['otp']) {
                                  print('Matches');
                                  // Get.to(() => NewPasswordScreen(
                                  //       responseBody: widget.responseBody,
                                  //     ));
                                  // _authController.resetPassword(newPassword: newPassword, email: email, context: context);
                                } else {
                                  AppUtil.errorToast(
                                      context, 'OTP not matching ');
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      !enableResend
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: "resendCodeIn".tr,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                Countdown(
                                  animation: StepTween(
                                    begin: 1 * 60,
                                    end: 0,
                                  ).animate(_controller),
                                )
                              ],
                            )
                          : Center(
                              child: TextButton(
                              child: CustomText(
                                text: "resendCode".tr,
                                color: colorDarkGreen,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              onPressed: () {
                                setState(() {
                                  enableResend = false;
                                  secondsRemaining = 20;
                                });
                              },
                            ))
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }
}

class Countdown extends AnimatedWidget {
  Countdown({required this.animation}) : super(listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return CustomText(
      text: timerText,
      fontSize: 15,
      color: colorGreen,
      fontWeight: FontWeight.w400,
    );
  }
}
