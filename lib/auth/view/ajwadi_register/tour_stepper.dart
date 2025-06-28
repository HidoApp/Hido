import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/car_type.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/driving_license.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/guidance_license.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/vehicle_license.dart';
import 'package:ajwad_v4/auth/view/sigin_in/phone_otp_new.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/profle_screen.dart';
import 'package:ajwad_v4/request/widgets/AlertDialog.dart';
import 'package:ajwad_v4/request/widgets/confirm_dialog.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../widgets/custom_publish_widget.dart';

class TourStepper extends StatefulWidget {
  const TourStepper({
    super.key,
  });

  @override
  State<TourStepper> createState() => _TourStepperState();
}

class _TourStepperState extends State<TourStepper> {
  final _authController = Get.put(AuthController());
  final _profileController = Get.put(ProfileController());

  final notificationController = Get.put(NotificationController());
  void sendVehcileDetails() async {
    if (!_authController.vehicleKey.currentState!.validate()) {
      AmplitudeService.amplitude
          .track(BaseEvent("Local doesn't enter a valid vehicle data "));

      return;
    }
    if (_profileController.plateNumber1.value.isEmpty ||
        _profileController.plateNumber2.value.isEmpty ||
        _profileController.plateNumber3.value.isEmpty ||
        _profileController.plateNumber4.value.isEmpty ||
        _profileController.plateletter1.value.isEmpty ||
        _profileController.plateletter2.value.isEmpty ||
        _profileController.plateletter3.value.isEmpty ||
        _profileController.selectedRide.value.isEmpty) {
      AppUtil.errorToast(context, 'errorFieldsAll'.tr);
      return;
    }
    var plateNumbers = _profileController.plateNumber1.value +
        _profileController.plateNumber2.value +
        _profileController.plateNumber3.value +
        _profileController.plateNumber4.value;
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
      plateletter1: _profileController.plateletter1.value,
      plateletter2: _profileController.plateNumber2.value,
      plateLetter3: _profileController.plateNumber3.value,
      plateNumber: plateNumbers,
      vehicleType: _profileController.selectedRide.value,
      vehicleSerialNumber: _authController.vehicleLicense.value,
    );
    if (isSuccess) {
      // final isSuccess =
      //     await notificationController.sendDeviceToken(context: context);
      // if (!isSuccess) {
      //   AmplitudeService.amplitude
      //       .track(BaseEvent('Local Sign up  Failed as tour guide'));
      //   return;
      // }
      AmplitudeService.amplitude.track(
        BaseEvent(
          "Local add  vehicle details and create account as tour guide  successfully",
          eventProperties: {
            'vehicleSerialNumber': _authController.vehicleLicense.value,
            'plate number': plateNumbers,
            'plate letters': _profileController.plateletter1.value +
                _profileController.plateNumber2.value +
                _profileController.plateNumber3.value,
            'vehicleType': _profileController.selectedRide.value
          },
        ),
      );
      // // _authController.activeBar(1);
      // // Get.offAll(() => const AjwadiBottomBar());
      // storage.remove('localName');
      // storage.write('userRole', 'local');
    } else {
      AmplitudeService.amplitude.track(
        BaseEvent(
          "Local doesn't add vehicle details successfully",
        ),
      );
    }
  }

  bool _validateFields() {
    if (_authController.activeBar.value == 1) {
      return (_profileController.isPdfValidSize.value &&
              _profileController.pdfFile.value != null) ||
          _profileController.profile.tourGuideLicense != '';
    }

    if (_authController.activeBar.value == 2) {
      return ((_profileController.isNotDriveCar.value ||
              _profileController.isDriveCar.value) &&
          _profileController.agreeForTerms.value);
    }

    if (_authController.activeBar.value == 3) {
      return _profileController.drivingDateDay.value.isNotEmpty;
    }
    if (_authController.activeBar.value == 4) {
      return _profileController.plateletter1.value.isNotEmpty &&
          _profileController.plateNumber2.value.isNotEmpty &&
          _profileController.plateNumber3.value.isNotEmpty &&
          _profileController.plateNumber4.value.isNotEmpty &&
          _profileController.selectedRide.value != '' &&
          _authController.vehicleLicense.value != '';
    }

    return true;
  }

  Future<void> processTourGuideStepper(BuildContext context) async {
    try {
      UploadImage? file;

      if (_profileController.pdfFile.value != null) {
        // Step 1: Upload Profile PDF and Edit Profile
        file = await _profileController.uploadProfileImages(
          file: _profileController.pdfFile.value!,
          uploadOrUpdate: "upload",
          context: context,
        );

        if (file == null) {
          AppUtil.errorToast(context, "PDF upload failed");
          return;
        }
      }
      final result = await _profileController.editProfile(
        context: context,
        tourGuideLicense: _profileController.pdfFile.value != null
            ? file?.filePath
            : _profileController.profile.tourGuideLicense,
        transportationMethod: _profileController.transporationMethod.value,
        spokenLanguage: _profileController.profile.spokenLanguage,
      );

      if (result == null) {
        return;
      }

      // Step 3: Show Success Dialog
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/paymentSuccess.gif', width: 38),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                    Text(
                      'saveChange'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      ),
                      textDirection: AppUtil.rtlDirection2(context)
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            );
          }).then((_) async {
        _profileController.reset();
        _authController.activeBar(1);

        await Get.offAll(() => const AjwadiBottomBar());

        // await _profileController.getProfile(context: context);
        await _authController.checkLocalInfo(context: context);
      });
    } catch (e) {
      AppUtil.errorToast(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

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
              totalSteps: 4,
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
                        () =>
                            //_authController.isCreateAccountLoading.value ||
                            _authController.isVicheleOTPLoading.value ||
                                    _authController
                                        .isLienceseOTPLoading.value ||
                                    _authController
                                        .isSendVehicleDetails.value ||
                                    notificationController
                                        .isSendingDeviceToken.value ||
                                    _profileController.isImagesLoading.value ||
                                    _profileController.isProfileLoading.value ||
                                    _profileController
                                        .isEditProfileLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator.adaptive())
                                : IgnorePointer(
                                    ignoring: !_validateFields(),
                                    child: Opacity(
                                      opacity: _validateFields() ? 1.0 : 0.5,
                                      child: CustomButton(
                                        onPressed: () async {
                                          //Click Endpoint here

                                          if (validateScreens()) {
                                            switch (_authController
                                                .activeBar.value) {
                                              //contact info handle
                                              // case 1:
                                              //   AmplitudeService.amplitude.track(BaseEvent(
                                              //       "Local  send iban & email  (as tour guide)"));
                                              //   final isSuccess = await _authController
                                              //       .createAccountInfo(
                                              //           context: context,
                                              //           email:
                                              //               _authController.email.value,
                                              //           iban:
                                              //               _authController.iban.value,
                                              //           type: 'TOUR_GUID');
                                              //   log(isSuccess.toString());
                                              //   if (isSuccess) {
                                              //     AmplitudeService.amplitude.track(
                                              //       BaseEvent(
                                              //         "Local  send iban and email  successfully as tour guide",
                                              //         eventProperties: {
                                              //           'email':
                                              //               _authController.email.value,
                                              //           "iban":
                                              //               _authController.iban.value,
                                              //         },
                                              //       ),
                                              //     );
                                              //     _authController.activeBar(2);
                                              //   }

                                              //   break;
                                              // case 2:
                                              case 1:
                                                _authController.activeBar(2);

                                                break;
                                              case 2:
                                                _authController.activeBar(3);
                                                break;
                                              case 3:
                                                AmplitudeService.amplitude
                                                    .track(
                                                  BaseEvent(
                                                    "Local request otp for  driving license",
                                                  ),
                                                );
                                                final isSuccess =
                                                    await _authController
                                                        .drivingLinceseOTP(
                                                            expiryDate:
                                                                _profileController
                                                                    .drivingDate
                                                                    .value,
                                                            context: context);

                                                if (isSuccess != null) {
                                                  Get.to(() => nextVerfiy());
                                                }
                                                break;
                                              // case 3:
                                              case 4:
                                                final isSuccess =
                                                    await _authController
                                                        .vehicleOTP(
                                                            vehicleSerialNumber:
                                                                _authController
                                                                    .vehicleLicense
                                                                    .value,
                                                            context: context);
                                                if (isSuccess != null) {
                                                  Get.to(() => nextVerfiy())
                                                      ?.then((_) {
                                                    if (_authController
                                                        .isVehicleInfSucess
                                                        .value) {
                                                      sendVehcileDetails();
                                                      processTourGuideStepper(
                                                          context);
                                                    }
                                                  });
                                                }

                                                // AppUtil.showSaveChangesDialog(
                                                //     context, () {
                                                //   processTourGuideStepper(
                                                //       context);
                                                // });

                                                break;

                                              default:
                                            }
                                          } else {
                                            AmplitudeService.amplitude.track(
                                                BaseEvent(
                                                    "Local doesn't enter a valid data in step ${_authController.activeBar.value.toString()}  (as tour guide)"));
                                          }
                                        },
                                        title:
                                            _authController.activeBar.value != 4
                                                ? _authController
                                                            .activeBar.value ==
                                                        3
                                                    ? 'verfiy'.tr
                                                    : 'next'.tr
                                                : 'finish'.tr,

                                        // icon: const Icon(
                                        //   Icons.keyboard_arrow_right,
                                        // ),
                                      ),
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
        // return const ContactInfo(isPageView: true);
        return const GuidanceLicense();

      case 2:
        return const CarType();

      case 3:
        return const DrivingLicense();
      case 4:
        return const VehicleLicenseScreen();

      // return const DrivingLicense();
      // case 3:
      //   return const VehicleLicenseScreen();
      default:
        return Container(); // Replace with your actual widget
    }
  }

  Widget nextVerfiy() {
    switch (_authController.activeBar.value) {
      // case 2:
      case 3:
        return PhoneOTP(
          otp: '',
          type: 'stepper',
          resendOtp: () async {
            await _authController.drivingLinceseOTP(
              context: context,
              expiryDate: _profileController.drivingDate.value,
            );
          },
        );

      // case 3:
      case 4:
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
      // case 1:
      // return _authController.contactKey.currentState!.validate();
      // case 2:
      case 1:
        return _profileController.profile.tourGuideLicense != '' ||
            (_profileController.isPdfValidSize.value &&
                _profileController.pdfFile.value != null);
      case 2:
        return ((_profileController.isNotDriveCar.value ||
                _profileController.isDriveCar.value) &&
            _profileController.agreeForTerms.value);
      case 3:
        if (_profileController.drivingDate.value.isEmpty) {
          _authController.validDriving(false);
        } else {
          _authController.validDriving(true);
        }
        return _authController.validDriving.value;

      // case 3:
      case 4:
        return _authController.vehicleKey.currentState!.validate();

      default:
        log('default');
        return false; // Replace with your actual widget
    }
  }
}
