import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/widget/local_calender.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/widget/otp_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:jhijri_picker/_src/_jWidgets.dart';

class DrivingSheet extends StatefulWidget {
  const DrivingSheet({super.key});

  @override
  State<DrivingSheet> createState() => _DrivingSheetState();
}

class _DrivingSheetState extends State<DrivingSheet> {
  final _formKey = GlobalKey<FormState>();
  var value = "";
  final _profileController = Get.put(ProfileController());
  final _authController = Get.put(AuthController());
  // Future<JPickerValue?> openDialog(BuildContext context) async {
  //   return await showGlobalDatePicker(
  //       context: context,
  //       startDate: JDateModel(jhijri: JHijri.now()),
  //       pickerMode: DatePickerMode.year,
  //       selectedDate: JDateModel(jhijri: JHijri.now()),
  //       pickerType: PickerType.JHijri,
  //       onChange: (datetime) {
  //         _authController.updatedDriving.value =
  //             AppUtil.formattedHijriDate(datetime.jhijri);
  //       },
  //       primaryColor: Colors.green);
  // }
  void showCalender() {
    showDialog(
      context: context,
      builder: (context) => LocalCalender(
        pastAvalible: false,
        onPressed: () {
          log(_authController.updatedDriving.value);
          Get.back();
        },
        onSelectionChanged: (value) {
          _authController.updatedDriving(value.value.toString());

          _authController.updatedDrivingWithoutHijri.value =
              AppUtil.formatDateForRowad(_authController.updatedDriving.value);

          _authController.updatedDriving.value = AppUtil.convertToHijriForRowad(
              _authController.updatedDriving.value);
          log(_authController.updatedDriving.value);
          log(_authController.updatedDrivingWithoutHijri.value);
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _authController.updatedDriving("");
    _authController.validUpdatedDriving(true);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: double.infinity,
      //  height: width * 0.628,
      padding: EdgeInsets.only(
          left: width * 0.0615,
          right: width * 0.0615,
          top: width * 0.041,
          bottom: width * 0.082),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetIndicator(),
          SizedBox(
            height: width * 0.0512,
          ),
          CustomText(
            text: 'drivinglicense'.tr,
            fontFamily: "SF Pro",
            fontSize: width * 0.043,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
            height: width * 0.0205,
          ),
          GestureDetector(
            onTap: () => showCalender(),
            child: Obx(
              () => Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.030, vertical: width * 0.020),
                height: width * 0.123,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(
                    color: _authController.validUpdatedDriving.value
                        ? borderGrey
                        : colorRed,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: width * 0.051,
                    ),
                    CustomText(
                      text:
                          _authController.updatedDrivingWithoutHijri.isNotEmpty
                              ? _authController.updatedDrivingWithoutHijri.value
                              : AppUtil.convertHijriToGregorian(
                                  AppUtil.convertIsoDateToFormattedDate(
                                      _profileController
                                          .profile.drivingLicenseExpiryDate!)),
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => _authController.validUpdatedDriving.value
                ? Container()
                : CustomText(
                    text: 'invalidDate'.tr,
                    color: colorRed,
                    fontSize: width * .028,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SF Pro',
                  ),
          ),
          SizedBox(
            height: width * 0.061,
          ),
          Obx(
            () => _authController.isLienceseOTPLoading.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : CustomButton(
                    title: 'save'.tr,
                    onPressed: () async {
                      if (_authController.updatedDriving.value.isEmpty) {
                        _authController.validUpdatedDriving(false);
                      } else {
                        log(_authController.updatedDriving.value);
                        final isSuccess =
                            await _authController.drivingLinceseOTP(
                                context: context,
                                expiryDate:
                                    _authController.updatedDriving.value);
                        if (isSuccess != null) {
                          Get.bottomSheet(OtpSheet(
                            title: 'otp'.tr,
                            subtitle: 'otpPhone'.tr,
                            resendOtp: () async {
                              await _authController.drivingLinceseOTP(
                                  expiryDate:
                                      _authController.updatedDriving.value,
                                  context: context);
                            },
                            onCompleted: (otpCode) async {
                              final isSuccess =
                                  await _authController.getAjwadiLinceseInfo(
                                      expiryDate:
                                          _authController.updatedDriving.value,
                                      transactionId: _authController
                                          .transactionIdDriving.value,
                                      otp: otpCode,
                                      context: context);
                              if (isSuccess) {
                                await _profileController.getProfile(
                                    context: context);
                                Get.back();
                                Get.back();
                              }
                            },
                          ));
                        }
                      }

                      // _formKey.currentState!.validate();
                    },
                  ),
          )
        ],
      ),
    );
  }
}
