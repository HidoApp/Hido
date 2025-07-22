import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/bottom_bar/local/view/local_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_otp_field.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:win32/win32.dart';

class VehicleLicenseScreen extends StatefulWidget {
  const VehicleLicenseScreen({super.key});

  @override
  State<VehicleLicenseScreen> createState() => _VehicleLicenseScreenState();
}

class _VehicleLicenseScreenState extends State<VehicleLicenseScreen> {
  final _authController = Get.put(AuthController());
  final _profileController = Get.put(ProfileController());
  late String plateNumber;

  final Map _pickupRide = {
    'sedan': [
      'assets/icons/selected_sedan_icon.svg',
      'assets/icons/unselected_sedan_icon.svg'
    ],
    'suv': [
      'assets/icons/selected_suv_car.svg',
      'assets/icons/unselected_suv_icon.svg'
    ],
    '4x4': [
      'assets/icons/selected_4x4_icon.svg',
      'assets/icons/unselected_4x4_icon.svg'
    ],
    'van': [
      'assets/icons/selected_van_icon.svg',
      'assets/icons/unselected_van_icon.svg'
    ]
  };
  // var selectedRide = "";
  @override
  void initState() {
    super.initState();
    _profileController.selectedRide.value =
        _profileController.profile.vehicle?.vehicleClassDescEn.toLowerCase() ??
            '';
    plateNumber =
        _profileController.profile.vehicle?.plateNumber.toString() ?? '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _authController.plateNumber1.value = '';
    // _authController.plateNumber2.value = '';
    // _authController.plateNumber3.value = '';
    // _authController.plateNumber4.value = '';
    // _authController.plateletter1.value = '';
    // _authController.plateletter2.value = '';
    // _authController.plateletter3.value = '';
    // _authController.selectedRide.value = '';

    super.dispose();
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
        transportationMethod: _profileController.transporationMethod.isEmpty
            ? _profileController.profile.transportationMethod
            : _profileController.transporationMethod,
        spokenLanguage: _profileController.profile.spokenLanguage,
      );

      if (result == null) {
        return;
      }
      if (!mounted) return;

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

        Get.offAll(() => const LocalBottomBar());
        // await _profileController.getProfile(context: context);
        if (!mounted) return;

        await _authController.checkLocalInfo(context: context);
      });
    } catch (e) {
      if (!mounted) return;

      AppUtil.errorToast(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          'registerVehicle'.tr,
          isBack: true,
          isSkiped: true,
          onPressedAction: () {
            AppUtil.showSaveChangesDialog(context, () {
              processTourGuideStepper(context);
            });
          },
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: width * 0.041,
              right: width * 0.041,
              top: width * 0.0307,
              bottom: width * 0.082),
          child: Form(
            key: _authController.vehicleKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: "vehicleLicense".tr,
                      fontSize: width * 0.044,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppUtil.SfFontType(context)),
                  SizedBox(
                    height: width * 0.0205,
                  ),
                  CustomTextField(
                    hintText: _profileController.profile.vehicle
                                ?.vehicleSequenceNumber.isEmpty ??
                            true
                        ? 'vehicleHint'.tr
                        : _profileController
                            .profile.vehicle?.vehicleSequenceNumber,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _authController.vehicleLicense(value);
                    },
                  ),
                  SizedBox(
                    height: width * 0.051,
                  ),
                  CustomText(
                      text: 'vehiclePlate'.tr,
                      fontSize: width * 0.044,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppUtil.SfFontType(context)),
                  SizedBox(
                    height: width * 0.0205,
                  ),
                  Form(
                    // key: _authController.vehicleKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _profileController.plateNumber1(value);
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          validator: (p0) {
                            return null;
                          },
                          hint: plateNumber.isNotEmpty ? plateNumber[0] : '1',
                          keyboardType: TextInputType.number,
                          formatter: FilteringTextInputFormatter.digitsOnly,
                        ),
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _profileController.plateNumber2(value);
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          validator: (p0) {
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          hint: plateNumber.length > 1 ? plateNumber[1] : '2',
                          formatter: FilteringTextInputFormatter.digitsOnly,
                        ),
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _profileController.plateNumber3(value);
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          validator: (p0) {
                            return null;
                          },
                          hint: plateNumber.length > 2 ? plateNumber[2] : '3',
                          formatter: FilteringTextInputFormatter.digitsOnly,
                        ),
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _profileController.plateNumber4(value);
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          validator: (p0) {
                            return null;
                          },
                          hint: plateNumber.length > 3 ? plateNumber[3] : '4',
                          formatter: FilteringTextInputFormatter.digitsOnly,
                        ),

                        // lETTERS
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _profileController.plateletter1(value);
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          validator: (p0) {
                            return null;
                          },
                          hint: _profileController
                                      .profile.vehicle?.plateText1.isNotEmpty ??
                                  false
                              ? _profileController
                                      .profile.vehicle?.plateText1 ??
                                  ''
                              : 'A',
                          formatter: FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z]')), // Only allow English letters
                        ),
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _profileController.plateletter2(value);
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          validator: (p0) {
                            return null;
                          },
                          hint: _profileController
                                      .profile.vehicle?.plateText1.isNotEmpty ??
                                  false
                              ? _profileController
                                      .profile.vehicle?.plateText2 ??
                                  ''
                              : 'B',
                          formatter: FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z]')), // Only allow English letters
                        ),
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _profileController.plateletter3(value);
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          validator: (p0) {
                            return null;
                          },
                          hint: _profileController
                                      .profile.vehicle?.plateText1.isNotEmpty ??
                                  false
                              ? _profileController
                                      .profile.vehicle?.plateText3 ??
                                  ''
                              : 'C',
                          formatter: FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]'),
                          ), // Only allow English letters
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: width * 0.051,
                  ),
                  CustomText(
                      text: 'vehicleType'.tr,
                      fontSize: width * 0.044,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppUtil.SfFontType(context)),
                  SizedBox(
                    height: width * 0.0205,
                  ),
                  Obx(() => pickupRide()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget pickupRide() {
    final button = _pickupRide
        .map((key, values) {
          final value = Container(
            margin: const EdgeInsets.only(left: 2),
            child: GestureDetector(
              onTap: () {
                _profileController.selectedRide.value = key;
                log(_profileController.selectedRide.value);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _profileController.selectedRide.value == key
                        ? colorGreen
                        : almostGrey,
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: lightGreyColor.withOpacity(0.4),
                  //       blurRadius: 9,
                  //       spreadRadius: 8)
                  // ],
                  color: _profileController.selectedRide.value == key
                      ? lightGreen
                      : Colors.white,
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    RepaintBoundary(
                      child: SvgPicture.asset(
                        _profileController.selectedRide.value == key
                            ? values[0]
                            : values[1],
                      ),
                    ),
                    const Spacer(),
                    CustomText(
                      text: "$key".tr,
                      color: _profileController.selectedRide.value == key
                          ? colorGreen
                          : dividerColor,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                  ],
                ),
              ),
            ),
          );
          return MapEntry(key, value);
        })
        .values
        .toList();

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: button);
  }
}
