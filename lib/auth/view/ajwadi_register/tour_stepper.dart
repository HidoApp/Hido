import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/driving_license.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/vehicle_license.dart';
import 'package:ajwad_v4/auth/view/sigin_in/phone_otp_new.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/widget/buttomProgress.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TourStepper extends StatefulWidget {
  const TourStepper({
    super.key,
  });

  @override
  State<TourStepper> createState() => _TourStepperState();
}

class _TourStepperState extends State<TourStepper> {
  final _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Obx(() => nextStep()),
      bottomNavigationBar: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StepProgressIndicator(
              size: width * 0.011,
              roundedEdges: const Radius.circular(30),
              padding: 2,
              totalSteps: 3,
              currentStep: _authController.activeBar.value,
              selectedColor: colorGreen,
              unselectedColor: almostGrey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: width * 0.071, horizontal: width * 0.041),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: width * 0.030, horizontal: width * 0.041),
                        child: GestureDetector(
                          onTap: () {
                            if (_authController.activeBar.value == 1) {
                              Get.back();
                            } else {
                              setState(() {
                                _authController.activeBar.value--;
                              });
                            }
                          },
                          child: CustomText(
                            text: 'Back'.tr,
                            fontSize: width * 0.043,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: width * 0.030, horizontal: width * .041),
                      child: Obx(
                        () => _authController.isCreateAccountLoading.value ||
                                _authController.isVicheleOTPLoading.value ||
                                _authController.isLienceseOTPLoading.value
                            ? const Center(
                                child: CircularProgressIndicator.adaptive())
                            : CustomButton(
                                onPressed: () async {
                                  if (validateScreens()) {
                                    switch (_authController.activeBar.value) {
                                      //contact info handle
                                      case 1:
                                        final isSuccess = await _authController
                                            .createAccountInfo(
                                                context: context,
                                                email:
                                                    _authController.email.value,
                                                iban:
                                                    _authController.iban.value,
                                                type: 'TOUR_GUID');
                                        log(isSuccess.toString());
                                        if (isSuccess) {
                                          _authController.activeBar(2);
                                        }

                                        break;
                                      case 2:
                                        final isSuccess = await _authController
                                            .drivingLinceseOTP(
                                                context: context);
                                        if (isSuccess) {
                                          Get.to(() => nextVerfiy());
                                        }
                                        break;
                                      case 3:
                                        final isSuccess =
                                            await _authController.vehicleOTP(
                                                vehicleSerialNumber:
                                                    _authController
                                                        .vehicleLicense
                                                        .toString(),
                                                context: context);
                                        if (isSuccess) {
                                          Get.to(() => nextVerfiy());
                                        }
                                        break;
                                      default:
                                    }
                                  }
                                },
                                title: _authController.activeBar.value != 1
                                    ? 'verfiy'.tr
                                    : 'next'.tr,
                                icon: const Icon(
                                  Icons.keyboard_arrow_right,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget nextStep() {
    switch (_authController.activeBar.value) {
      case 1:
        return const ContactInfo(isPageView: true);
      case 2:
        return const DrivingLicense();
      case 3:
        return const VehicleLicenseScreen();
      default:
        return Container(); // Replace with your actual widget
    }
  }

  Widget nextVerfiy() {
    switch (_authController.activeBar.value) {
      case 2:
        return const PhoneOTP(
          otp: '',
          type: 'stepper',
        );

      case 3:
        return const PhoneOTP(
          otp: '5555',
          type: 'stepper',
        );
      default:
        return Container(); // Replace with your actual widget
    }
  }

  bool validateScreens() {
    switch (_authController.activeBar.value) {
      case 1:
        return _authController.contactKey.currentState!.validate();
      case 2:
        if (_authController.drivingDate.value.isEmpty) {
          _authController.validDriving(false);
        } else {
          _authController.validDriving(true);
        }
        return _authController.validDriving.value;

      case 3:
        return _authController.vehicleKey.currentState!.validate();

      default:
        log('default');
        return false; // Replace with your actual widget
    }
  }
}
