import 'dart:async';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/local_sign_up.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:ajwad_v4/auth/view/sigin_in/phone_otp_new.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LocalSignIn extends StatefulWidget {
  const LocalSignIn({super.key});

  @override
  State<LocalSignIn> createState() => _LocalSignInState();
}

class _LocalSignInState extends State<LocalSignIn> {
  // final _controller = CountdownController(autoStart: true);
  StreamSubscription? _internetConnection;
  void setInternetConnection() {
    _internetConnection = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          _authController.isInternetConnected(true);
          break;
        case InternetStatus.disconnected:
          _authController.isInternetConnected(false);
          break;
        default:
          _authController.isInternetConnected(false);
          break;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setInternetConnection();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _internetConnection!.cancel();
  }

  final _formKey = GlobalKey<FormState>();
  var number = '';
  final _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(''),
        body: ScreenPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'welcomeBack'.tr,
                fontWeight: FontWeight.w500,
                fontSize: width * 0.051,
                textAlign: !AppUtil.rtlDirection(context)
                    ? TextAlign.right
                    : TextAlign.left,
              ),
              CustomText(
                text: 'signInLocal'.tr,
                color: starGreyColor,
                fontSize: width * 0.043,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: width * .061,
              ),
              CustomText(
                text: 'phoneNum'.tr,
                fontSize: width * 0.043,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: width * .01,
              ),
              Form(
                key: _formKey,
                child: CustomTextField(
                  hintText: 'phoneHint'.tr,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (value) => number = value,
                  validator: false,
                  validatorHandle: (value) {
                    if (value!.isEmpty) {
                      return 'fieldRequired'.tr;
                    }
                    if (!value.startsWith('05') || value.length != 10) {
                      return 'invalidPhone'.tr;
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: width * 0.102,
              ),
              Obx(() => _authController.isCreateOtpLoading.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : CustomButton(
                          onPressed: () async {
                            if (!_authController.isInternetConnected.value) {
                              AppUtil.connectionToast(
                                  context, 'offlineTitle'.tr);
                              return;
                            }
                            var isValid = _formKey.currentState!.validate();
                            if (isValid) {
                              AmplitudeService.amplitude.track(BaseEvent(
                                  'Local Request otp  for sign in',
                                  eventProperties: {
                                    'phoneNumber': number,
                                  }));
                              final isSuccess = await _authController.createOtp(
                                  context: context, phoneNumber: number);
                              if (isSuccess) {
                                _authController.isResendOtp(false);
                                Get.to(() => PhoneOTP(
                                      phoneNumber: number,
                                      type: 'signIn',
                                      otp: '',
                                      resendOtp: () async {
                                        await _authController.createOtp(
                                            context: context,
                                            phoneNumber: number);
                                      },
                                    ));
                              }
                            } else {
                              AmplitudeService.amplitude.track(BaseEvent(
                                  'Local enter unvalid number ',
                                  eventProperties: {
                                    'phoneNumber': number,
                                  }));
                            }
                          },
                          title: 'signIn'.tr,
                          icon: Icon(
                            Icons.keyboard_arrow_right,
                            size: width * 0.061,
                          ),
                        )
                  // : Center(
                  //     child: Countdown(
                  //       seconds: 180,
                  //       controller: _controller,
                  //       build: (BuildContext context, double time) =>
                  //           CustomText(
                  //         text: AppUtil.countdwonFormat(time),
                  //         color: colorGreen,
                  //       ),
                  //       interval: const Duration(seconds: 1),
                  //       onFinished: () {
                  //         _authController.isResendOtp(true);
                  //       },
                  //     ),
                  //   ),
                  ),
              SizedBox(
                height: width * 0.041,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "haveAnAccount?".tr,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * 0.038,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.0128,
                  ),
                  GestureDetector(
                      child: CustomText(
                        text: 'signUp'.tr,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w500,
                        color: colorGreen,
                        fontSize: MediaQuery.of(context).size.width * 0.038,
                      ),
                      onTap: () {
                        if (!_authController.isInternetConnected.value) {
                          AppUtil.connectionToast(context, 'offlineTitle'.tr);
                          return;
                        }
                        Get.back();
                        Get.to(
                          () => const LocalSignUpScreen(),
                        );
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
