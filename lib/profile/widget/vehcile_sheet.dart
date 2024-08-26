import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/widget/otp_sheet.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VehcileSheet extends StatefulWidget {
  const VehcileSheet({super.key});

  @override
  State<VehcileSheet> createState() => _VehcileSheetState();
}

class _VehcileSheetState extends State<VehcileSheet> {
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.put(AuthController());
  final _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      // height: width * 0.628,
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
            text: "vehicleLicense".tr,
            fontWeight: FontWeight.w500,
            fontSize: width * 0.043,
            fontFamily: "SF Pro",
          ),
          SizedBox(
            height: width * 0.0205,
          ),
          Form(
            key: _formKey,
            child: CustomTextField(
              hintText: 'vehicleHint'.tr,
              inputFormatters: [
                LengthLimitingTextInputFormatter(9),
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (value) => _authController.updatedVehicle(value),
            ),
          ),
          SizedBox(
            height: width * 0.061,
          ),
          Obx(
            () => _authController.isVicheleOTPLoading.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : CustomButton(
                    title: 'save'.tr,
                    onPressed: () async {
                      final isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        final isSuccess = await _authController.vehicleOTP(
                            vehicleSerialNumber:
                                _authController.updatedVehicle.value,
                            context: context);
                        if (isSuccess != null) {
                          Get.bottomSheet(OtpSheet(
                            title: 'otp'.tr,
                            subtitle: 'otpPhone'.tr,
                            resendOtp: () async {
                              await _authController.vehicleOTP(
                                  vehicleSerialNumber:
                                      _authController.updatedVehicle.value,
                                  context: context);
                            },
                            onCompleted: (otpCode) async {
                              final isDone =
                                  await _authController.getAjwadiVehicleInf(
                                      transactionId: _authController
                                          .transactionIdVehicle.value,
                                      otp: otpCode,
                                      context: context);
                              if (isDone) {
                                await _profileController.getProfile(
                                    context: context);
                                Get.back();
                                Get.back();
                              }
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
