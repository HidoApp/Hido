import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/sigin_in/phone_otp_new.dart';
import 'package:ajwad_v4/auth/widget/local_calender.dart';
import 'package:ajwad_v4/auth/widget/sign_in_text.dart';
import 'package:ajwad_v4/auth/widget/terms_text.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
  void initState() {
    super.initState();
    _authController.agreeForTerms(false);
  }

  @override
  void dispose() {
    super.dispose();
    _authController.birthDate('');
    _authController.validBirthDay(true);
    _authController.isAgreeForTerms(true);
  }

  void showCalender() {
    showDialog(
        context: context,
        builder: (context) => LocalCalender(onPressed: () {
              _authController.birthDate.value = AppUtil.convertToHijriForRowad(
                  _authController.birthDateDay.value);
              log(_authController.birthDate.value);
              Get.back();
            }, onSelectionChanged: (value) {
              _authController.birthDateDay(value.value.toString());
              _authController.birthDateDay.value = AppUtil.formatDateForRowad(
                  _authController.birthDateDay.value);
              _authController.birthDate.value = AppUtil.convertToHijriForRowad(
                  _authController.birthDateDay.value);
            }));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                  maxlines: 10,
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
                        text: 'nationalId'.tr,
                        fontSize: width * 0.043,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: width * 0.0205,
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
                            return 'invaildId'.tr;
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
                        fontFamily: AppUtil.SfFontType(context),
                      ),
                      SizedBox(
                        height: width * 0.0205,
                      ),
                      CustomTextField(
                        hintText: 'phoneHint'.tr,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                        keyboardType: TextInputType.number,
                        validator: false,
                        validatorHandle: (number) {
                          if (number == null || number.isEmpty) {
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
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: width * 0.0205,
                      ),
                      GestureDetector(
                        onTap: () async {
                          showCalender();
                          // await openDialog(context);
                        },
                        child: Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * .03,
                              vertical: width * .020,
                              //  bottom: width * .020,
                            ),
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
                                // SizedBox(
                                //   width: width * 0.00,
                                // ),
                                Obx(
                                  () => CustomText(
                                    text: _authController.birthDate.isNotEmpty
                                        ? _authController.birthDateDay.value
                                        : 'mm/dd/yyy'.tr,
                                    color: Graytext,
                                    fontWeight: FontWeight.w400,
                                    fontSize: width * .038,
                                    fontFamily: AppUtil.SfFontType(context),
                                  ),
                                ),
                                const Spacer(),
                                SvgPicture.asset('assets/icons/Time (2).svg'),
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
                                fontFamily: AppUtil.SfFontType(context),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: width * 0.052,
                ),
                const TermsAndConditionsText(),
                SizedBox(
                  height: width * 0.102,
                ),
                Obx(
                  () => _authController.isPersonInfoLoading.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : CustomButton(
                          onPressed: () async {
                            if (!_authController.agreeForTerms.value) {
                              _authController.isAgreeForTerms(false);
                              return;
                            } else {
                              // AmplitudeService.amplitude.track(BaseEvent(
                              //     "User doesn't agree for our terms",
                              // ));
                              _authController.isAgreeForTerms(true);
                            }
                            log(_authController.birthDate.value);
                            var isValid = _formKey.currentState!.validate();
                            _authController.validBirthDay(
                                _authController.birthDate.isNotEmpty);
                            if (isValid &&
                                _authController.birthDate.isNotEmpty) {
                              AmplitudeService.amplitude.track(
                                BaseEvent(
                                  'User Request otp for sign up as local ',
                                ),
                              );
                              final isSuccess =
                                  await _authController.personInfoOTP(
                                      nationalID: nationalId,
                                      birthDate:
                                          _authController.birthDate.value,
                                      context: context);

                              if (isSuccess != null) {
                                AmplitudeService.amplitude.track(
                                  BaseEvent(
                                    'User going to otp screen for getting person info  ',
                                    eventProperties: {
                                      'nationalID': nationalId,
                                      'birthDate':
                                          _authController.birthDate.value,
                                    },
                                  ),
                                );
                                _authController.localID(nationalId);
                                log(_authController.birthDateDay.value);
                                log("enter to signup");

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
                              {
                                AmplitudeService.amplitude.track(
                                  BaseEvent(
                                    'User Request otp for sign up as local ',
                                  ),
                                );
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
                  height: width * 0.041,
                ),
                const SignInText()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
