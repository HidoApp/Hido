import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/provided_services.dart';
import 'package:ajwad_v4/auth/view/sigin_in/phone_otp_new.dart';
import 'package:ajwad_v4/auth/widget/sign_in_text.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jhijri/_src/_jHijri.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';

class LocalSignUpScreen extends StatefulWidget {
  const LocalSignUpScreen({super.key});

  @override
  State<LocalSignUpScreen> createState() => _LocalSignUpScreenState();
}

class _LocalSignUpScreenState extends State<LocalSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? birthDate;
  DateTime? date;
  final _authController = Get.put(AuthController());
  var nationalId = '';
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _authController.birthDate('');
  }

  Future<JPickerValue?> openDialog(BuildContext context) async {
    return await showGlobalDatePicker(
        context: context,
        startDate: JDateModel(dateTime: DateTime.parse("1960-12-24")),
        selectedDate: JDateModel(dateTime: DateTime.now()),
        endDate: JDateModel(dateTime: DateTime.parse("2030-09-20")),
        pickerMode: DatePickerMode.day,
        // selectedDate: JDateModel(jhijri: JHijri.now()),
        pickerType: PickerType.JHijri,
        okButtonText: 'ok'.tr,
        cancelButtonText: "cancel".tr,
        onChange: (datetime) {
          _authController.birthDate.value =
              AppUtil.formattedHijriDate(datetime.jhijri);
        },
        primaryColor: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar('signUp'.tr),
      body: ScreenPadding(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    text: 'welcometo'.tr,
                    color: black,
                    fontSize: width * 0.051,
                  ),
                  SizedBox(
                    width: width * 0.0128,
                  ),
                  CustomText(
                    text: 'hido'.tr,
                    color: colorGreen,
                    fontSize: width * 0.051,
                  )
                ],
              ),
              CustomText(
                text: 'signUpLocal'.tr,
                color: starGreyColor,
                fontSize: width * 0.043,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: width * 0.061,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'idIqama'.tr,
                      fontSize: width * 0.043,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: false,
                      hintText: 'idHint'.tr,
                      validatorHandle: (id) {
                        if (id!.isEmpty) {
                          return 'fieldRequired'.tr;
                        }
                        if (!AppUtil.isSaudiNationalId(id)) {
                          return 'invaild id';
                        }
                        return null;
                      },
                      onChanged: (id) => nationalId = id,
                    ),
                    SizedBox(
                      height: width * 0.061,
                    ),
                    CustomText(
                        text: 'phoneNum'.tr,
                        fontSize: width * 0.0435,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro'),
                    CustomTextField(
                      hintText: 'phoneHint'.tr,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ],
                      keyboardType: TextInputType.number,
                      validator: false,
                      validatorHandle: (number) {
                        if (number == null || number!.isEmpty) {
                          return 'fieldRequired'.tr;
                        }
                        if (!number.startsWith('05') || number.length != 10) {
                          return 'invalidPhone'.tr;
                        }
                        return null;
                      },
                      onChanged: (number) =>
                          _authController.phoneNumber(number),
                    ),
                    SizedBox(
                      height: width * .06,
                    ),
                    CustomText(
                      text: 'birthDate'.tr,
                      fontSize: width * 0.043,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await openDialog(context);
                        // await showCupertinoModalPopup<void>(
                        //   context: context,
                        //   builder: (_) {
                        //     final size = MediaQuery.of(context).size;
                        //     return Container(
                        //       decoration: const BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.only(
                        //           topLeft: Radius.circular(12),
                        //           topRight: Radius.circular(12),
                        //         ),
                        //       ),
                        //       height: size.height * 0.27,
                        //       child: CupertinoDatePicker(
                        //         mode: CupertinoDatePickerMode.date,
                        //         onDateTimeChanged: (value) {
                        //           date = value;
                        //           String theMonth =
                        //               date!.month.toString().length == 1
                        //                   ? '0${date!.month}'
                        //                   : date!.month.toString();
                        //           String theDay =
                        //               date!.day.toString().length == 1
                        //                   ? '0${date!.day}'
                        //                   : date!.day.toString();
                        //           birthDate = '${date!.year}-$theMonth-$theDay';
                        //           _authController.birthDate(birthDate);
                        //         },
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                      child: Obx(
                        () => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * .03, vertical: width * .020),
                          height: width * 0.123,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(
                                color: _authController.validBirthDay.value
                                    ? borderGrey
                                    : colorRed,
                              )),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: width * 0.05,
                              ),
                              Obx(
                                () => CustomText(
                                  text: _authController.birthDate.isNotEmpty
                                      ? _authController.birthDate.value
                                      : 'mm/dd/yyy'.tr,
                                  color: starGreyColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: width * .038,
                                  fontFamily: 'SF Pro',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => _authController.validBirthDay.value
                          ? Container()
                          : CustomText(
                              text: 'invalidDate'.tr,
                              color: colorRed,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SF Pro',
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Obx(
                () => _authController.isPersonInfoLoading.value
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : CustomButton(
                        onPressed: () async {
                          log(_authController.birthDate.value);
                          var isValid = _formKey.currentState!.validate();
                          _authController.validBirthDay(
                              _authController.birthDate.isNotEmpty);
                          if (isValid && _authController.birthDate.isNotEmpty) {
                            final isSuccess =
                                await _authController.personInfoOTP(
                                    nationalID: nationalId,
                                    birthDate: _authController.birthDate.value,
                                    context: context);
                            print('isSuccess UI $isSuccess');
                            if (isSuccess!=null) {
                              _authController.localID(nationalId);
                              Get.to(() => PhoneOTP(
                                    otp: '',
                                    type: 'signUp',
                                    resendOtp: () async {
                                      await _authController.personInfoOTP(
                                          nationalID: nationalId,
                                          birthDate:
                                              _authController.birthDate.value,
                                          context: context);
                                    },
                                  ));
                            }
                            // Get.to(() => const ProvidedServices());
                          }
                        },
                        title: 'next'.tr,
                        height: 48,
                        icon: const Icon(
                          Icons.keyboard_arrow_right,
                          size: 24,
                        ),
                      ),
              ),
              SizedBox(
                height: 12,
              ),
              const SignInText()
            ],
          ),
        ),
      ),
    );
  }
}
