import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/tourist_register/reset_password.dart';
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

class SignInSheet extends StatefulWidget {
  const SignInSheet({super.key});

  @override
  State<SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends State<SignInSheet> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.put(AuthController());
  @override
  void dispose() {
    log("DISPOSE");
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void loginValidate() {
    if (!AppUtil.isPasswordLengthValidate(_passwordController.text)) {
      _authController.isPasswordValid(false);
    } else {
      _authController.isPasswordValid(true);
    }
    if (!AppUtil.isEmailValidate(_emailController.text)) {
      _authController.isEmailValid(false);
    } else {
      _authController.isEmailValid(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: width * 1.32,
        padding: EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: 20,
            ),
            CustomText(
              text: "signAsTourist".tr,
              fontSize: 22,
            ),
            SizedBox(
              height: 12,
            ),
            Form(
              // onPopInvoked: (didPop) {
              //   _authController.isEmailValid(true);
              //   _authController.isPasswordValid(true);
              // },
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
                  Obx(
                    () => CustomTextField(
                      height: 48,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'yourEmail'.tr,
                      controller: _emailController,
                      borderColor: !_authController.isEmailValid.value
                          ? colorRed
                          : almostGrey,
                      onChanged: (value) {},
                    ),
                  ),
                  if (!_authController.isEmailValid.value)
                    SizedBox(
                      height: 5,
                    ),
                  Obx(() => !_authController.isEmailValid.value
                      ? Padding(
                          padding: AppUtil.rtlDirection2(context)
                              ? const EdgeInsets.only(right: 10)
                              : const EdgeInsets.only(left: 10),
                          child: CustomText(
                            text: "*Enter a valid email",
                            color: colorRed,
                          ),
                        )
                      : Container()),
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
                      controller: _passwordController,
                      hintText: 'yourPassword'.tr,
                      borderColor: !_authController.isPasswordValid.value
                          ? colorRed
                          : almostGrey,
                      obscureText: _authController.hidePassword.value,
                      onChanged: (value) {},
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _authController.hidePassword.value =
                              !_authController.hidePassword.value;
                        },
                        child: Icon(
                          _authController.hidePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: almostGrey,
                        ),
                      ),
                    ),
                  ),
                  if (!_authController.isPasswordValid.value)
                    SizedBox(
                      height: 5,
                    ),
                  Obx(() => !_authController.isPasswordValid.value
                      ? Padding(
                          padding: AppUtil.rtlDirection2(context)
                              ? const EdgeInsets.only(right: 10)
                              : const EdgeInsets.only(left: 10),
                          child: CustomText(
                            text: "*Enter at least 8 characters",
                            color: colorRed,
                          ),
                        )
                      : Container()),
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
                    height: 47,
                  ),
                  Obx(
                    () => _authController.isLoginLoading.value
                        ? const Center(
                            child: CircularProgressIndicator.adaptive())
                        : CustomButton(
                            onPressed: () async {
                              loginValidate();
                              if (_authController.isEmailValid.value &&
                                  _authController.isPasswordValid.value) {
                                _authController.isEmailValid.value = true;
                                _authController.isPasswordValid.value = true;
                                final user = await _authController.login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    rememberMe: true,
                                    context: context);
                                if (user != null) {
                                  Get.back();
                                }
                              } else {
                                print("_authController.isEmailValid.value");
                                print(_authController.isEmailValid.value);
                                print("_authController.isPasswordValid.value");
                                print(_authController.isPasswordValid.value);
                              }
                            },
                            title: "signIn".tr),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "haveAnAccount?".tr,
                        fontSize: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          child: CustomText(
                            text: 'signUp'.tr,
                            color: colorGreen,
                            fontSize: 15,
                          ),
                          onTap: () => Get.offAll(
                                () => AccountTypeScreen(),
                              ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
