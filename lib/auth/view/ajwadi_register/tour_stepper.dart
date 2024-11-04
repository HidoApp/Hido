import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/driving_license.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/vehicle_license.dart';
import 'package:ajwad_v4/auth/view/sigin_in/phone_otp_new.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/cupertino.dart';
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
  final notificationController = Get.put(NotificationController());
  void sendVehcileDetails() async {
    if (!_authController.vehicleKey.currentState!.validate()) {
      AmplitudeService.amplitude
          .track(BaseEvent("Local doesn't enter a valid vehicle data "));

      return;
    }
    if (_authController.plateNumber1.value.isEmpty ||
        _authController.plateNumber2.value.isEmpty ||
        _authController.plateNumber3.value.isEmpty ||
        _authController.plateNumber4.value.isEmpty ||
        _authController.plateletter1.value.isEmpty ||
        _authController.plateletter2.value.isEmpty ||
        _authController.plateletter3.value.isEmpty ||
        _authController.selectedRide.value.isEmpty) {
      AppUtil.errorToast(context, 'errorFieldsAll'.tr);
      return;
    }
    var plateNumbers = _authController.plateNumber1.value +
        _authController.plateNumber2.value +
        _authController.plateNumber3.value +
        _authController.plateNumber4.value;
    AmplitudeService.amplitude.track(
      BaseEvent(
        "Local  enter a valid vehicle data ",
      ),
    );
    // eventProperties: {
    //   "plateNumber": plateNumbers,
    //   "plateletter1": _authController.plateletter1.value,
    //   "plateletter2": _authController.plateNumber2.value,
    //   "plateLetter3": _authController.plateNumber3.value,
    //   "vehicleType": _authController.selectedRide.value,
    //   "vehicleSerialNumber": _authController.vehicleLicense.value,
    // },
    final isSuccess = await _authController.sendVehcileDetails(
      context: context,
      plateletter1: _authController.plateletter1.value,
      plateletter2: _authController.plateNumber2.value,
      plateLetter3: _authController.plateNumber3.value,
      plateNumber: plateNumbers,
      vehicleType: _authController.selectedRide.value,
      vehicleSerialNumber: _authController.vehicleLicense.value,
    );
    if (isSuccess) {
      final isSuccess =
          await notificationController.sendDeviceToken(context: context);
      if (!isSuccess) {
        AmplitudeService.amplitude
            .track(BaseEvent('Local Sign up  Failed as tour guide'));
        return;
      }
      AmplitudeService.amplitude.track(
        BaseEvent(
          "Local add  vehicle details and create account as tour guide  successfully",
          eventProperties: {
            'vehicleSerialNumber': _authController.vehicleLicense.value,
            'plate number': plateNumbers,
            'plate letters': _authController.plateletter1.value +
                _authController.plateNumber2.value +
                _authController.plateNumber3.value,
            'vehicleType': _authController.selectedRide.value
          },
        ),
      );
      _authController.activeBar(1);
      Get.offAll(() => const AjwadiBottomBar());
      storage.remove('localName');
      storage.write('userRole', 'local');
    } else {
      AmplitudeService.amplitude.track(
        BaseEvent(
          "Local doesn't add vehicle details successfully",
        ),
      );
    }
  }

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
                vertical: width * 0.071,
              ),
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
                                _authController.isLienceseOTPLoading.value ||
                                _authController.isSendVehicleDetails.value ||
                                notificationController
                                    .isSendingDeviceToken.value
                            ? const Center(
                                child: CircularProgressIndicator.adaptive())
                            : CustomButton(
                                onPressed: () async {
                                  //Click Endpoint here
                                  if (validateScreens()) {
                                    switch (_authController.activeBar.value) {
                                      //contact info handle
                                      case 1:
                                        AmplitudeService.amplitude.track(BaseEvent(
                                            "Local  send iban & email  (as tour guide)"));
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
                                          AmplitudeService.amplitude.track(
                                            BaseEvent(
                                              "Local  send iban and email  successfully as tour guide",
                                              eventProperties: {
                                                'email':
                                                    _authController.email.value,
                                                "iban":
                                                    _authController.iban.value,
                                              },
                                            ),
                                          );
                                          _authController.activeBar(2);
                                        }

                                        break;
                                      case 2:
                                        AmplitudeService.amplitude.track(
                                          BaseEvent(
                                            "Local request otp for  driving license",
                                          ),
                                        );
                                        final isSuccess = await _authController
                                            .drivingLinceseOTP(
                                                expiryDate: _authController
                                                    .drivingDate.value,
                                                context: context);
                                        if (isSuccess != null) {
                                          Get.to(() => nextVerfiy());
                                        }
                                        break;
                                      case 3:
                                        sendVehcileDetails();
                                        // final isSuccess =
                                        //     await _authController.vehicleOTP(
                                        //         vehicleSerialNumber:
                                        //             _authController
                                        //                 .vehicleLicense.value,
                                        //         context: context);
                                        //      if (isSuccess != null) {
                                        //  Get.to(() => nextVerfiy());
                                        //   }
                                        break;
                                      default:
                                    }
                                  } else {
                                    AmplitudeService.amplitude.track(BaseEvent(
                                        "Local doesn't enter a valid data in step ${_authController.activeBar.value.toString()}  (as tour guide)"));
                                  }
                                },
                                title: _authController.activeBar.value != 1
                                    ? 'verfiy'.tr
                                    : 'next'.tr,
                                // icon: const Icon(
                                //   Icons.keyboard_arrow_right,
                                // ),
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
        return PhoneOTP(
          otp: '',
          type: 'stepper',
          resendOtp: () async {
            await _authController.drivingLinceseOTP(
              context: context,
              expiryDate: _authController.drivingDate.value,
            );
          },
        );

      case 3:
        return PhoneOTP(
          otp: '5555',
          type: 'stepper',
          resendOtp: () async {
            await _authController.vehicleOTP(
                vehicleSerialNumber: _authController.vehicleLicense.toString(),
                context: context);
          },
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
