import 'dart:developer';

import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/phone_otp.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/tour_stepper.dart';
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
  final _formKey = GlobalKey<FormState>();
  var number = '';
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
            CustomButton(
              onPressed: () {
                var isValid = _formKey.currentState!.validate();
                if (isValid) {
                  Get.to(() => PhoneOTP(
                        phoneNumber: number,
                        type: 'signIn',
                        otp: '9999',
                      ));
                }
              },
              title: 'signIn'.tr,
              icon: Icon(
                Icons.keyboard_arrow_right,
                size: width * 0.061,
              ),
            ),
            SizedBox(
              height: width * 0.030,
            ),
            const SignUpText()
          ],
        ),
      ),
    );
  }
}
