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
  //var activeBar = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => nextStep()),
      bottomNavigationBar: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StepProgressIndicator(
              size: 4.5,
              roundedEdges: Radius.circular(30),
              padding: 2,
              totalSteps: 3,
              currentStep: _authController.activeBar.value,
              selectedColor: colorGreen,
              unselectedColor: almostGrey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: CustomButton(
                        onPressed: () {
                          if (validateScreens()) {
                            Get.to(() => nextVerfiy());
                          }
                        },
                        title: 'verfiy'.tr,
                        icon: Icon(
                          Icons.keyboard_arrow_right,
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
        return const ContactInfo(
          isPageView: true,
        );
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
      case 1:
        return const PhoneOTP(
          otp: '1234',
        );
      case 2:
        return const PhoneOTP(
          otp: '0000',
        );

      case 3:
        return const PhoneOTP(
          otp: '5555',
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
