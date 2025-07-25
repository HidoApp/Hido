import 'dart:developer';
import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/provided_services.dart';
import 'package:ajwad_v4/auth/view/tourist_register/new_password_screen.dart';
import 'package:ajwad_v4/auth/widget/countdown_timer.dart';
import 'package:ajwad_v4/bottom_bar/local/view/local_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';

class PhoneOTP extends StatefulWidget {
  const PhoneOTP(
      {super.key,
      this.phoneNumber,
      required this.otp,
      this.type = 'stepper',
      required this.resendOtp});
  final String? phoneNumber;
  final String otp;
  final String? type;
  final Function() resendOtp;
  @override
  State<PhoneOTP> createState() => _PhoneOTPState();
}

class _PhoneOTPState extends State<PhoneOTP> {
  final storage = GetStorage();

  bool timerEnd = false;
  late String otp;
  final _authController = Get.put(AuthController());
  final notificationController = Get.put(NotificationController());
  final _profileController = Get.put(ProfileController());

  void stepper(String otpCode) async {
    if (_authController.activeBar.value == 3) {
      log('Succes');
      final isSuccess = await _authController.getAjwadiLinceseInfo(
          expiryDate: _profileController.drivingDate.value,
          transactionId: _authController.transactionIdDriving.value,
          otp: otpCode,
          context: context);
      if (isSuccess) {
        AmplitudeService.amplitude.track(
          BaseEvent(
            "Local add  driving license successfully",
            eventProperties: {
              'expiryDater': _profileController.drivingDate.value,
            },
          ),
        );
        _authController.activeBar(4);
        Get.back();
      } else {
        AmplitudeService.amplitude.track(
          BaseEvent(
            "Local doesn't add  driving license successfully",
          ),
        );
      }
    } else {
      final isSuccess = await _authController.getAjwadiVehicleInf(
          transactionId: _authController.transactionIdVehicle.value,
          otp: otpCode,
          context: context);
      if (isSuccess) {
        Get.back();
        // _authController.activeBar(1);
        // Get.offAll(() => const AjwadiBottomBar());
        //storage.remove('localName');
        // storage.write('userRole', 'local');
      }
    }
  }

  void resetPassword(otpCode) async {
    if (otpCode == _authController.passwordOtp.value) {
      Get.off(() => const NewPasswordScreen());
    } else {
      AppUtil.errorToast(context, 'msg');
    }
  }

  void signUp(String otpCode) async {
    log("enter signup");
    final isSuccess = await _authController.signUpWithRowad(
        context: context,
        transactionId: _authController.transactionIdInfo.value,
        nationalId: _authController.localID.toString(),
        number: _authController.phoneNumber.value,
        otp: otpCode,
        birthDate: _authController.birthDateDay.value);
    if (isSuccess) {
      final isSuccess =
          await notificationController.sendDeviceToken(context: context);
      if (!isSuccess) {
        AmplitudeService.amplitude.track(BaseEvent('Local Sign in Failed'));
        return;
      }
      AmplitudeService.amplitude.track(BaseEvent(
        'Local Signed up successfully ',
        eventProperties: {
          'phone number': _authController.phoneNumber.value,
          'local ID': _authController.localID.toString(),
        },
      ));
      Get.to(() => const ProvidedServices());
    }
  }

  void signIn(String otpCode) async {
    final isSuccess = await _authController.localSignInWithOtp(
        context: context, phoneNumber: widget.phoneNumber!, otp: otpCode);
    if (isSuccess) {
      final isSuccess =
          await notificationController.sendDeviceToken(context: context);
      if (!isSuccess) {
        AmplitudeService.amplitude.track(BaseEvent('Local Sign in Failed'));
        return;
      }
      AmplitudeService.amplitude.track(BaseEvent(
        'Local Signed in successfully ',
        eventProperties: {
          'phone number': widget.phoneNumber,
        },
      ));
      //if (!mounted) return; // Check if the widget is still mounted
      _authController.checkLocalWhenSignIn(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: const CustomAppBar(''),
      body: ScreenPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'otp'.tr,
              fontSize: width * 0.051,
              fontWeight: FontWeight.w500,
            ),
            CustomText(
              text: "otpPhone".tr,
              fontSize: width * 0.043,
              color: starGreyColor,
              fontWeight: FontWeight.w500,
            ),
            if (widget.phoneNumber != null)
              CustomText(
                text: widget.phoneNumber,
                fontSize: width * 0.043,
                color: colorGreen,
                fontWeight: FontWeight.w500,
              ),
            SizedBox(
              height: width * 0.061,
            ),
            Directionality(
              textDirection: AppUtil.rtlDirection2(context)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Center(
                child: Pinput(
                  length: 4,

                  onCompleted: (value) {
                    log("enter oncompleted");
                    switch (widget.type) {
                      case 'stepper':
                        stepper(value);
                        break;
                      case 'signIn':
                        signIn(value);
                        break;
                      case 'signUp':
                        signUp(value);
                        break;
                      case 'password':
                        resetPassword(value);
                        break;
                      default:
                    }
                  },
                  // validator: (s) {
                  //   return s == widget.otp ? null : '';
                  // },
                  //errorText: 'invalid code',
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
              height: width * 0.061,
            ),
            Center(
              child: Obx(
                () => _authController.isSignUpRowad.value ||
                        _authController.isVicheleLoading.value ||
                        _authController.isLienceseLoading.value ||
                        _authController.isCheckLocalLoading.value ||
                        _authController.isSignInWithOtpLoading.value ||
                        notificationController.isSendingDeviceToken.value
                    ? const CircularProgressIndicator.adaptive()
                    : CountdownTimer(
                        resendOtp: widget.resendOtp,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
