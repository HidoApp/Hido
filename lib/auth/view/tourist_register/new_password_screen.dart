import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  String password = '';
  String confirmedPassword = '';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(''),
      body: ScreenPadding(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'newPassword'.tr,
                fontSize: width * 0.051,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text: 'typeNewPassword'.tr,
                fontSize: width * 0.043,
                color: starGreyColor,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: width * 0.041,
              ),
              CustomText(
                text: 'password'.tr,
                fontFamily: AppUtil.SfFontType(context),
                fontSize: width * 0.043,
                fontWeight: FontWeight.w500,
              ),
              Obx(
                () => CustomTextField(
                  keyboardType: TextInputType.text,
                  obscureText: !_authController.showResetPassword.value,
                  hintText: 'typeNewPassword'.tr,
                  validator: false,
                  validatorHandle: (newPassword) {
                    if (newPassword == null || newPassword.isEmpty) {
                      return 'fieldRequired'.tr;
                    }
                    if (newPassword.length < 8) {
                      return "you must enter at least 8 characters";
                    }
                    if (password != confirmedPassword) {
                      return 'ivalidPassAndConfirm'.tr;
                    }
                  },
                  onChanged: (String newPassword) => password = newPassword,
                  suffixIcon: GestureDetector(
                    child: Icon(
                        _authController.showResetPassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF969696)),
                    onTap: () {
                      _authController.showResetPassword.value =
                          !_authController.showResetPassword.value;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: width * 0.061,
              ),
              CustomText(
                text: 'confirmPass'.tr,
                fontFamily: AppUtil.SfFontType(context),
                fontSize: width * 0.043,
                fontWeight: FontWeight.w500,
              ),
              Obx(
                () => CustomTextField(
                  keyboardType: TextInputType.text,
                  obscureText:
                      !_authController.showResetConfirmedPassword.value,
                  hintText: 're-enterPassword'.tr,
                  validator: false,
                  validatorHandle: (newPassword) {
                    if (newPassword == null || newPassword.isEmpty) {
                      return 'fieldRequired'.tr;
                    }
                    if (newPassword.length < 8) {
                      return "you must enter at least 8 characters";
                    }
                    if (password != confirmedPassword) {
                      return 'ivalidPassAndConfirm'.tr;
                    }
                  },
                  onChanged: (String newPassword) =>
                      confirmedPassword = newPassword,
                  suffixIcon: GestureDetector(
                    child: Icon(
                        _authController.showResetConfirmedPassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF969696)),
                    onTap: () {
                      _authController.showResetConfirmedPassword.value =
                          !_authController.showResetConfirmedPassword.value;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: width * 0.092,
              ),
              Obx(
                () => _authController.isResetPasswordLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : CustomButton(
                        title: 'update'.tr,
                        icon: const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            log("inside");
                            final isSucces =
                                await _authController.resetPassword(
                                    newPassword: confirmedPassword,
                                    email: _authController
                                        .resetPasswordEmail.value,
                                    context: context);
                            if (isSucces) {
                              Get.offAll(() => const OnboardingScreen());
                              Get.to(() => const SignInScreen());
                            }
                          }
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
