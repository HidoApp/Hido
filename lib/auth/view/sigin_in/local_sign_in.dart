import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:ajwad_v4/auth/view/sigin_in/phone_otp_new.dart';
import 'package:ajwad_v4/auth/widget/sign_up_text.dart';
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
  final _controller = CountdownController(autoStart: true);

  final _formKey = GlobalKey<FormState>();
  var number = '';
  final _authController = Get.put(AuthController());
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
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : CustomButton(
                        onPressed: () async {
                          var isValid = _formKey.currentState!.validate();
                          if (isValid) {
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
              height: width * 0.075,
            ),
            const SignUpText()
          ],
        ),
      ),
    );
  }
}
