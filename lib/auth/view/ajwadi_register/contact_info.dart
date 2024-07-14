import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
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
import 'package:get_storage/get_storage.dart';
import 'package:iban/iban.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo({super.key, this.isPageView = false});
  final bool isPageView;
  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.put(AuthController());
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        'contactInfo'.tr,
        isBack: widget.isPageView,
      ),
      body: ScreenPadding(
        child: Form(
          key: _authController.contactKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: 'email'.tr,
                  fontSize: width * 0.0435,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro'),
              CustomTextField(
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
                onChanged: (email) => _authController.email(email),
              ),
              SizedBox(
                height: width * .06,
              ),
              CustomText(
                  text: 'phoneNum'.tr,
                  fontSize: width * 0.0435,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro'),
              CustomTextField(
                hintText: 'phoneHint'.tr,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                keyboardType: TextInputType.number,
                validator: false,
                validatorHandle: (number) {
                  if (number == null || number!.isEmpty) {
                    return 'fieldRequired'.tr;
                  }
                  if (!number.startsWith('05') || number.length != 10) {
                    return 'invalidPhone'.tr;
                  }
                  return null;
                },
                onChanged: (number) => _authController.phoneNumber(number),
              ),
              SizedBox(
                height: width * .06,
              ),
              CustomText(
                text: 'iban'.tr,
                fontSize: width * 0.0435,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
              CustomTextField(
                hintText: 'ibanHint'.tr,
                keyboardType: TextInputType.text,
                validator: false,
                validatorHandle: (iban) {
                  if (iban == null || iban.isEmpty) {
                    return 'fieldRequired'.tr;
                  }
                  if (!isValid(iban) ||
                      iban.contains(' ') && iban.startsWith('SA')) {
                    //TODO:localize
                    return 'invalidIBAN'.tr;
                  }
                  return null;
                },
                onChanged: (iban) => _authController.iban(iban),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.09, horizontal: width * 0.041),
        child: widget.isPageView
            ? const SizedBox()
            : Obx(
                () => _authController.isCreateAccountLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : CustomButton(
                        onPressed: () async {
                          _authController.contactKey.currentState!.validate();
                          final isSuccess =
                              await _authController.createAccountInfo(
                                  context: context,
                                  email: _authController.email.value,
                                  phoneNumber:
                                      _authController.phoneNumber.value,
                                  iban: _authController.iban.value,
                                  type: 'EXPERIENCE');
                          log(isSuccess.toString());
                          if (isSuccess) {
                            storage.write('TourGuide', false);
                            Get.offAll(() => const AjwadiBottomBar());
                          }
                        },
                        title: 'signUp'.tr,
                        icon: Icon(
                          Icons.keyboard_arrow_right,
                          size: width * .06,
                        ),
                      ),
              ),
      ),
    );
  }
}
