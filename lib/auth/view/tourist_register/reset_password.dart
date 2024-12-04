import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/sigin_in/phone_otp_new.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late double width, height;
  bool isSwitched = false;
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.put(AuthController());
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(""),
        body: Padding(
          padding: EdgeInsets.only(
              top: width * 0.02, right: width * 0.041, left: width * 0.041),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "resetPassword".tr,
                fontWeight: FontWeight.w500,
                fontSize: width * 0.051,
              ),
              SizedBox(
                height: width * 0.03,
              ),
              CustomText(
                text: "passwordReset".tr,
                fontWeight: FontWeight.w500,
                fontSize: width * 0.043,
                color: starGreyColor,
              ),
              SizedBox(
                height: width * 0.041,
              ),
              Form(
                key: _formKey,
                child: CustomTextField(
                  hintText: 'yourEmail'.tr,
                  keyboardType: TextInputType.emailAddress,
                  validator: false,
                  validatorHandle: (email) {
                    if (email == null || email.isEmpty) {
                      return 'fieldRequired'.tr;
                    }
                    if (!AppUtil.isEmailValidate(email)) {
                      return 'invalidEmail'.tr;
                    }
                    return null;
                  },
                  onChanged: (email) =>
                      _authController.resetPasswordEmail(email),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Obx(
                () => _authController.isResetPasswordOtpLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : CustomButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                        title: 'send'.tr,
                        onPressed: () async {
                          final isValid = _formKey.currentState!.validate();
                          if (isValid) {
                            var result = await _authController.sendPasswordOTP(
                                email: _authController.resetPasswordEmail.value,
                                context: context);
                            log("result $result");

                            if (result != null) {
                              _authController.passwordOtp(result['otp']);
                              Get.to(() => PhoneOTP(
                                  type: 'password',
                                  otp: result['otp'],
                                  resendOtp: () async {
                                    // resend otp
                                    var result =
                                        await _authController.sendPasswordOTP(
                                            email: _authController
                                                .resetPasswordEmail.value,
                                            context: context);
                                    if (result != null) {
                                      _authController
                                          .passwordOtp(result['otp']);
                                    }
                                  }));
                            }
                          }
                        }),
              ),
            ],
          ),
        ));
  }
}
