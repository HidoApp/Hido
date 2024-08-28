import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/widget/countdown_timer.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpSheet extends StatefulWidget {
  const OtpSheet(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.resendOtp,
      required this.onCompleted});
  final String title;
  final String subtitle;
  final void Function() resendOtp;
  final void Function(String otpCode) onCompleted;
  @override
  State<OtpSheet> createState() => _OtpSheetState();
}

class _OtpSheetState extends State<OtpSheet> {
  final _profileController = Get.put(ProfileController());
  final _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      //height: width * .769,
      width: double.infinity,
      padding: EdgeInsets.only(
          left: width * 0.0615,
          right: width * 0.0615,
          top: width * 0.041,
          bottom: width * 0.082),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), topLeft: Radius.circular(24))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetIndicator(),
          SizedBox(
            height: width * 0.051,
          ),
          CustomText(
            text: widget.title,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            text: widget.subtitle,
            fontSize: width * 0.043,
            color: starGreyColor,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Pinput(
                length: 4,
                onCompleted: (otpCode) async {
                  widget.onCompleted(otpCode);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autofocus: true,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                keyboardType: TextInputType.number,
                separatorBuilder: (index) => SizedBox(
                  width: width * .097,
                ),
                followingPinTheme: PinTheme(
                  width: width * 0.143,
                  height: width * 0.143,
                  textStyle: TextStyle(
                      fontSize: width * 0.038,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppUtil.SfFontType(context),
                      color: colorGreen),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                defaultPinTheme: PinTheme(
                  width: width * 0.143,
                  height: width * 0.143,
                  textStyle: TextStyle(
                      fontSize: width * 0.038,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppUtil.SfFontType(context),
                      color: colorGreen),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorGreen),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                errorPinTheme: PinTheme(
                  width: width * 0.143,
                  height: width * 0.143,
                  textStyle: TextStyle(
                      fontSize: width * 0.038,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppUtil.SfFontType(context),
                      color: colorRed),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: width * 0.030,
          ),
          Center(
            child: Obx(
              () => _profileController.isMobileOtpLoading.value ||
                      _profileController.isUpdatingMobileLoading.value ||
                      _profileController.isProfileLoading.value ||
                      _authController.isLienceseLoading.value ||
                      _authController.isOTPLoading.value ||
                      _authController.isVicheleLoading.value
                  ? const CircularProgressIndicator.adaptive()
                  : CountdownTimer(resendOtp: widget.resendOtp),
            ),
          )
        ],
      ),
    );
  }
}
