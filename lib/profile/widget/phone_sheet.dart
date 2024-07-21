import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/widget/otp_sheet.dart';
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
    final hieht = MediaQuery.of(context).size.height;
    return Container(
      height: width * 0.76,
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
        children: [
          const BottomSheetIndicator(),
          SizedBox(
            height: width * 0.051,
          ),
          CustomText(
            text: "editPhoneNumber".tr,
            fontSize: width * 0.056,
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            text: "phoneEditSubtitle".tr,
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w400,
            fontSize: width * 0.0410,
            color: starGreyColor,
          ),
          SizedBox(
            height: width * 0.030,
          ),
          CustomText(
            text: "phoneNum".tr,
            fontSize: width * 0.043,
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
            height: width * 0.061,
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
                        _profileController.updatedMobile = mobile;
                        //TODO: otp handle
                        if (isSuccess) {
                          //    Get.back();
                          Get.bottomSheet(OtpSheet(
                            title: "OTP phone number",
                            subtitle: "otpPhone".tr,
                            onCompleted: (otpCode) async {
                              final user =
                                  await _profileController.updateMobile(
                                      context: context,
                                      otp: otpCode,
                                      mobile: _profileController.updatedMobile);
                              if (user != null) {
                                await _profileController.getProfile(
                                    context: context);
                                Get.back();
                                Get.back();
                              }
                            },
                            resendOtp: () async {
                              await _profileController.otpForMobile(
                                  context: context,
                                  mobile: _profileController.updatedMobile);
                            },
                          ));
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
