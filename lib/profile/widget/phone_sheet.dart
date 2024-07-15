import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PhoneSheet extends StatefulWidget {
  const PhoneSheet({super.key});

  @override
  State<PhoneSheet> createState() => _PhoneSheetState();
}

class _PhoneSheetState extends State<PhoneSheet> {
  final _formKey = GlobalKey<FormState>();
  final _profileController = Get.put(ProfileController());
  var mobile = '';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 308,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetIndicator(),
          SizedBox(
            height: 20,
          ),
          CustomText(
            text: "Edit phone number",
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            text: "We’ll text you code to verify your number ",
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: starGreyColor,
          ),
          SizedBox(
            height: 12,
          ),
          CustomText(
            text: "phoneNum".tr,
            fontSize: 17,
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w500,
          ),
          Form(
            key: _formKey,
            child: CustomTextField(
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
              onChanged: (number) => mobile = number,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Obx(
            () => _profileController.isMobileOtpLoading.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : CustomButton(
                    title: 'confirm'.tr,
                    onPressed: () async {
                      var isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        final isSuccess = await _profileController.otpForMobile(
                            context: context, mobile: mobile);
                        //TODO: otp handle
                        if (isSuccess) {}
                      }
                    },
                  ),
          )
        ],
      ),
    );
  }
}
