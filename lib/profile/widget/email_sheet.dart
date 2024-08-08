import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/widget/otp_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailSheet extends StatefulWidget {
  const EmailSheet({super.key});

  @override
  State<EmailSheet> createState() => _EmailSheetState();
}

class _EmailSheetState extends State<EmailSheet> {
  final _formKey = GlobalKey<FormState>();
  final _profileController = Get.put(ProfileController());
  final _authController = Get.put(AuthController());
  void editEmail() async {
    if (_formKey.currentState!.validate()) {
      var result =
          await _authController.sendEmailOTP(email: email, context: context);
      if (result != null) {
        Get.bottomSheet(
          OtpSheet(
            title: "emailConfirm".tr,
            subtitle: "otpPhone".tr,
            resendOtp: () async {
              result = await _authController.sendEmailOTP(
                  email: email, context: context);
            },
            onCompleted: (otp) async {
              if (result!['otp'] == otp) {
                var res = await _authController.resetEmail(
                    email: email, context: context);
                if (res) {
                  _authController.logOut();
                  // Get.offAll(() =>  AccountTypeScreen());
                  Get.offAll(() => const OnboardingScreen());
                  Get.to(() => const SignInScreen());
                }
              }
            },
          ),
        );
      } else {
        AppUtil.errorToast(context, result!['message']);
      }
    }
  }

  String email = '';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetIndicator(),
          SizedBox(
            height: width * 0.051,
          ),
          CustomText(
            text: 'updateEmail'.tr,
            fontSize: width * 0.056,
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            text: "emailEditSubtitle".tr,
            fontFamily: AppUtil.SfFontType(context),
            fontWeight: FontWeight.w400,
            fontSize: width * 0.0410,
            color: starGreyColor,
          ),
          SizedBox(
            height: width * 0.030,
          ),
          CustomText(
            text: "email".tr,
            fontSize: width * 0.043,
            fontFamily: AppUtil.SfFontType(context),
            fontWeight: FontWeight.w500,
          ),
          Form(
            key: _formKey,
            child: CustomTextField(
              hintText: _profileController.profile.email,
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
              onChanged: (newEmail) => email = newEmail,
            ),
          ),
          SizedBox(
            height: width * 0.061,
          ),
          CustomButton(
            title: 'confirm'.tr,
            onPressed: editEmail,
          )
        ],
      ),
    );
  }
}
