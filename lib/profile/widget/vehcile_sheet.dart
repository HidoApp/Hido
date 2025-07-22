import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/widget/pick-up-ride.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/widget/otp_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_otp_field.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
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
  late String plateNumber;

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
    _profileController.plateNumber1.value = '';
    _profileController.plateNumber2.value = '';
    _profileController.plateNumber3.value = '';
    _profileController.plateNumber4.value = '';
    _profileController.plateletter1.value = '';
    _profileController.plateletter2.value = '';
    _profileController.plateletter3.value = '';
    _profileController.selectedRide.value = '';

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        // height: width * 0.628,
        // width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        padding: EdgeInsets.only(
            left: width * 0.0615,
            right: width * 0.0615,
            top: width * 0.041,
            bottom: width * 0.082),
        child: Wrap(
          children: [
            Column(
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
                  fontFamily: AppUtil.SfFontType(context),
                ),
                SizedBox(
                  height: width * 0.0205,
                ),
                Form(
                  key: _formKey,
                  child: CustomTextField(
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
                    onChanged: (value) => _authController.updatedVehicle(value),
                  ),
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
                            ? _profileController.profile.vehicle?.plateText1 ??
                                ''
                            : 'A',
                        formatter: FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]')), // Only allow English letters
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
                            ? _profileController.profile.vehicle?.plateText2 ??
                                ''
                            : 'B',
                        formatter: FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]')), // Only allow English letters
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
                            ? _profileController.profile.vehicle?.plateText3 ??
                                ''
                            : 'C',
                        formatter: FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z]'),
                        ), // Only allow English letters
                      ),
                    ],
                  ),
                ),
                CustomText(
                    text: 'vehicleType'.tr,
                    fontSize: width * 0.044,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppUtil.SfFontType(context)),
                SizedBox(
                  height: width * 0.0205,
                ),
                const PickupRideWidget(),
                SizedBox(
                  height: width * 0.08,
                ),
                Obx(
                  () => _authController.isVicheleOTPLoading.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : CustomButton(
                          title: _profileController
                                  .profile.vehicleIdNumber!.isEmpty
                              ? 'Addtion'.tr
                              : 'update'.tr,
                          onPressed: () async {
                            final isValid = _formKey.currentState!.validate();
                            if (isValid) {
                              final isSuccess =
                                  await _authController.vehicleOTP(
                                      vehicleSerialNumber:
                                          _authController.updatedVehicle.value,
                                      context: context);
                              if (isSuccess != null) {
                                Get.bottomSheet(OtpSheet(
                                  title: 'otp'.tr,
                                  subtitle: 'otpPhone'.tr,
                                  resendOtp: () async {
                                    await _authController.vehicleOTP(
                                        vehicleSerialNumber: _authController
                                            .updatedVehicle.value,
                                        context: context);
                                  },
                                  onCompleted: (otpCode) async {
                                    final isDone = await _authController
                                        .getAjwadiVehicleInf(
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
          ],
        ),
      ),
    );
  }
}
