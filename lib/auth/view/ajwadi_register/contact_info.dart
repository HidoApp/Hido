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
import 'package:iban/iban.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo({super.key, this.isPageView = false});
  final bool isPageView;
  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  final _formKey = GlobalKey<FormState>();
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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: 'email'.tr,
                  fontSize: width * 0.0435,
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
                onChanged: (value) {},
              ),
              SizedBox(
                height: width * .06,
              ),
              CustomText(
                  text: 'phoneNum'.tr,
                  fontSize: width * 0.0435,
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
                onChanged: (value) {},
              ),
              SizedBox(
                height: width * .06,
              ),
              CustomText(
                  text: 'IBAN', fontSize: width * 0.0435, fontFamily: 'SF Pro'),
              CustomTextField(
                hintText: 'Enter IBAN number',
                keyboardType: TextInputType.text,
                validator: false,
                validatorHandle: (iban) {
                  if (iban == null || iban.isEmpty) {
                    return 'fieldRequired'.tr;
                  }
                  if (!isValid(iban)) {
                    return 'invalidIBAN'.tr;
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.09, horizontal: width * 0.041),
        child: widget.isPageView
            ? SizedBox()
            : CustomButton(
                onPressed: () {
                  _formKey.currentState!.validate();
                },
                title: 'signUp'.tr,
                icon: Icon(
                  Icons.keyboard_arrow_right,
                  size: width * .06,
                ),
              ),
      ),
    );
  }
}