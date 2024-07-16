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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      height: 220,
      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetIndicator(),
          SizedBox(
            height: 20,
          ),
          CustomText(
            text: "iban".tr,
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
          Form(
            key: _formKey,
            child: CustomTextField(
              hintText: AppUtil.maskIban(_profileController.profile.iban!),
              keyboardType: TextInputType.text,
              validator: false,
              validatorHandle: (iban) {
                if (iban == null || iban.isEmpty) {
                  return 'fieldRequired'.tr;
                }
                if (!isValid(iban) ||
                    iban.contains(' ') && iban.startsWith('SA')) {
                  return 'invalidIBAN'.tr;
                }
                return null;
              },
              onChanged: (value) => iban = value,
            ),
          ),
          SizedBox(
            height: 24,
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
                          iban: iban,
                          spokenLanguage:
                              _profileController.profile.spokenLanguage,
                        );
                        if (user != null) {
                          await _profileController.getProfile(context: context);
                          Get.back();
                        }
                      }
                    },
                  ),
          )
        ],
      ),
    );
  }
}
