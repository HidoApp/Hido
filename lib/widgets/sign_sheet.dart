import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/tourist_register/reset_password.dart';
import 'package:ajwad_v4/auth/widget/sign_up_text.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/state_manager.dart';

import '../new-onboarding/view/intro_screen.dart';

class SignInSheet extends StatefulWidget {
  const SignInSheet({super.key});

  @override
  State<SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends State<SignInSheet> {
  final _formKey = GlobalKey<FormState>();

  final _authController = Get.put(AuthController());
  var _email = '';
  var _password = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 471,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        padding: EdgeInsets.only(
            left: width * 0.0615,
            right: width * 0.0615,
            top: width * 0.041,
            bottom: width * 0.082),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetIndicator(),
              SizedBox(
                height: width * 0.051,
              ),
              CustomText(
                text: "signAsTourist".tr,
                fontSize: 22,
              ),
              SizedBox(
                height: 12,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'email'.tr,
                      fontSize: 17,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    CustomTextField(
                      height: 48,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'yourEmail'.tr,
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
                      onChanged: (value) => _email = value,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    CustomText(
                      text: 'password'.tr,
                      fontSize: 17,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Obx(
                      () => CustomTextField(
                        height: 48,
                        isPassword: true,
                        hintText: 'yourPassword'.tr,
                        obscureText: _authController.hidePassword.value,
                        validator: true,
                        onChanged: (value) => _password = value,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _authController.hidePassword.value =
                                !_authController.hidePassword.value;
                          },
                          child: Icon(
                            _authController.hidePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: borderGrey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Align(
                      alignment: AppUtil.rtlDirection2(context)
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Get.to(() => const ResetPasswordScreen()),
                        child: CustomText(
                          text: 'forgotPassword'.tr,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Obx(
                      () => _authController.isLoginLoading.value
                          ? const Center(
                              child: CircularProgressIndicator.adaptive())
                          : CustomButton(
                              onPressed: () async {
                                final user = await _authController.login(
                                    email: _email,
                                    password: _password,
                                    rememberMe: true,
                                    context: context);
                                if (user != null) {
                                  Get.back();
                                }
                              },
                              title: "signIn".tr),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    const SignUpText(
                      isLocal: false,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
