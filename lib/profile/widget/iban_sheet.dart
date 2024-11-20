import 'dart:developer';

import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iban/iban.dart';

class IbanSheet extends StatefulWidget {
  const IbanSheet({super.key});

  @override
  State<IbanSheet> createState() => _IbanSheetState();
}

class _IbanSheetState extends State<IbanSheet> {
  final _profileController = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();
  var iban = "";
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

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
            text: "iban".tr,
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w500,
            fontSize: width * 0.0435,
          ),
          SizedBox(
            height: width * 0.0205,
          ),
          Form(
            key: _formKey,
            child: CustomTextField(
              hintText: AppUtil.maskIban(_profileController.profile.iban ??
                  "SA5480000246608016008348"),
              keyboardType: TextInputType.text,
              validator: false,
              validatorHandle: (iban) {
                if (iban == null || iban.isEmpty) {
                  return 'fieldRequired'.tr;
                }
                if (!isValid(AppUtil.removeSpaces(iban)) &&
                    AppUtil.removeSpaces(iban).startsWith('SA')) {
                  return 'invalidIBAN'.tr;
                }
                return null;
              },
              onChanged: (value) => iban = value,
            ),
          ),
          SizedBox(
            height: width * 0.0820,
          ),
          Obx(
            () => _profileController.isEditProfileLoading.value ||
                    _profileController.isProfileLoading.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : CustomButton(
                    title: "save".tr,
                    onPressed: () async {
                      var isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        final user = await _profileController.editProfile(
                          context: context,
                          name: _profileController.profile.name,
                          iban: AppUtil.removeSpaces(iban),
                          spokenLanguage:
                              _profileController.profile.spokenLanguage,
                        );
                        if (user != null) {
                          await _profileController.getProfile(context: context);
                          Get.back();
                        }
                      } else {
                        log(AppUtil.removeSpaces(iban));
                      }
                    },
                  ),
          )
        ],
      ),
    );
  }
}
