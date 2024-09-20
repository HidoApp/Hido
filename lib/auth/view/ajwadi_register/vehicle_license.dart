
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
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

class VehicleLicenseScreen extends StatefulWidget {
  const VehicleLicenseScreen({super.key});

  @override
  State<VehicleLicenseScreen> createState() => _VehicleLicenseScreenState();
}

class _VehicleLicenseScreenState extends State<VehicleLicenseScreen> {
  final _authController = Get.put(AuthController());

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
  void dispose() {
    // TODO: implement dispose
    _authController.plateNumber1.value = '';
    _authController.plateNumber2.value = '';
    _authController.plateNumber3.value = '';
    _authController.plateNumber4.value = '';
    _authController.plateletter1.value = '';
    _authController.plateletter2.value = '';
    _authController.plateletter3.value = '';
    _authController.selectedRide.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          'registerVehicle'.tr,
          isBack: true,
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
                      fontSize: width * 0.0435,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SF Pro'),
                  CustomTextField(
                    hintText: 'vehicleHint'.tr,
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
                      text: 'لوحة المركبة',
                      fontSize: width * 0.0435,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SF Pro'),
                  Form(
                    // key: _authController.vehicleKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _authController.plateNumber1(value);
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          validator: (p0) {},
                          hint: '1',
                          keyboardType: TextInputType.number,
                          formatter: FilteringTextInputFormatter.digitsOnly,
                        ),
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _authController.plateNumber2(value);
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          validator: (p0) {},
                          keyboardType: TextInputType.number,
                          hint: '2',
                          formatter: FilteringTextInputFormatter.digitsOnly,
                        ),
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _authController.plateNumber3(value);
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          validator: (p0) {},
                          hint: '3',
                          formatter: FilteringTextInputFormatter.digitsOnly,
                        ),
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _authController.plateNumber4(value);
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          validator: (p0) {},
                          hint: '4',
                          formatter: FilteringTextInputFormatter.digitsOnly,
                        ),

                        // lETTERS
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _authController.plateletter1(value);
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          validator: (p0) {},

                          hint: 'A',
                          formatter: FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z]')), // Only allow English letters
                        ),
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _authController.plateletter2(value);
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          validator: (p0) {},
                          hint: 'B',
                          formatter: FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z]')), // Only allow English letters
                        ),
                        CustomOTPField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _authController.plateletter3(value);
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          validator: (p0) {},
                          hint: 'C',
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
                      text: 'نوع المركبة',
                      fontSize: width * 0.0435,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SF Pro'),
                  SizedBox(
                    height: width * 0.03,
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
            margin: EdgeInsets.only(left: 2),
            child: GestureDetector(
              onTap: () {
                _authController.selectedRide.value = key;
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _authController.selectedRide.value == key
                        ? colorGreen
                        : almostGrey,
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: lightGreyColor.withOpacity(0.4),
                  //       blurRadius: 9,
                  //       spreadRadius: 8)
                  // ],
                  color: _authController.selectedRide.value == key
                      ? lightGreen
                      : Colors.white,
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    RepaintBoundary(
                      child: SvgPicture.asset(
                        _authController.selectedRide.value == key
                            ? values[0]
                            : values[1],
                      ),
                    ),
                    const Spacer(),
                    CustomText(
                      text: "$key".tr,
                      color: _authController.selectedRide.value == key
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
