import 'dart:async';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/ajwadi_vehicle_info_screen.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_otp_field.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneOTPScreen extends StatefulWidget {
  const PhoneOTPScreen(
      {Key? key,
      this.isAjwadi = false,
      required this.authController,
      required this.nationalID,
      this.birthDate,
      this.expiryDate,
      this.isLiencese = true,
      this.accessToken,
      this.vehicleSerialNumber})
      : super(key: key);
  final bool isAjwadi;
  final AuthController authController;
  final String nationalID;
  final String? birthDate;
  final String? expiryDate;
  final String? accessToken;
  final String? vehicleSerialNumber;
  final bool isLiencese;

  @override
  State<PhoneOTPScreen> createState() => _PhoneOTPScreenState();
}

class _PhoneOTPScreenState extends State<PhoneOTPScreen>
    with TickerProviderStateMixin {
  late double width, height;
  bool isSwitched = false;
  String code1 = '', code2 = '', code3 = '', code4 = '', code5 = '', code6 = '';
  String fullOTP = '';

  late AnimationController _controller;

  int secondsRemaining = 20;
  bool enableResend = false;
  late Timer timer;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    print('widget.isAjwadi : ${widget.isAjwadi}');
    print('National Id : ${widget.nationalID}');
    print('Birth Date : ${widget.birthDate}');
    print('Expirity Date : ${widget.expiryDate}');
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
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            "",
            isAjwadi: widget.isAjwadi,
          ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomText(
                          text: "verification".tr,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: black,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomText(
                          text: '${"sendVerification".tr}',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: black,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                CustomOTPField(
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      code5 = value;
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                                CustomOTPField(
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      code6 = value;
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child:
                                widget.authController.isSigininwithRowad == true
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                            color: colorGreen),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: CustomElevatedButton(
                                            title: 'continue'.tr,
                                            onPressed: () async {
                                              //   Get.offAll(()=> const TouristBottomBar());
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  fullOTP = code1 +
                                                      code2 +
                                                      code3 +
                                                      code4 +
                                                      code5 +
                                                      code6;
                                                  print(fullOTP);
                                                });

                                                print('accessToken : ' +
                                                    widget.accessToken!);

                                                final isSuccess;

                                                if (widget.isLiencese) {
                                                  // isSuccess = await widget
                                                  //     .authController
                                                  //     .getAjwadiLinceseInfo(
                                                  //         otp: fullOTP,
                                                  //         expiryDate:
                                                  //             widget.expiryDate!,
                                                  //         nationalID:
                                                  //             widget.nationalID,
                                                  //         accessToken:
                                                  //             widget.accessToken!,
                                                  //         context: context);
                                                } else {
                                                  // isSuccess = await widget
                                                  //     .authController
                                                  //     .getAjwadiVehicleInf(
                                                  //         otp: fullOTP,
                                                  //         context: context);
                                                }
                                                if (true) {
                                                  // print(isSuccess);
                                                  // widget.isLiencese
                                                  //     ? Get.offAll(() =>
                                                  //         const AjwadiVehicleInfo())
                                                  //     : Get.offAll(() =>
                                                  //         const AjwadiBottomBar());
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                          )),
                      // !enableResend
                      //     ? Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           CustomText(
                      //             text: "resendCodeIn".tr,
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.w400,
                      //           ),
                      //           Countdown(
                      //             animation: StepTween(
                      //               begin: 1 * 60,
                      //               end: 0,
                      //             ).animate(_controller),
                      //           )
                      //         ],
                      //       )
                      //     : Center(
                      //         child: TextButton(
                      //         child: CustomText(
                      //           text: "resendCode".tr,
                      //           color: colorDarkGreen,
                      //           fontSize: 15,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //         onPressed: () {
                      //           setState(() {
                      //             enableResend = false;
                      //             secondsRemaining = 20;
                      //           });
                      //         },
                      //       ))
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
        '${clockTimer.inMinutes.remainder(30).toString()}:${(clockTimer.inSeconds.remainder(30) % 30).toString().padLeft(2, '0')}';

    return CustomText(
      text: timerText,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: colorGreen,
    );
  }
}
