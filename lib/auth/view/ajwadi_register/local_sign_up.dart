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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar('signUp'.tr),
      body: ScreenPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                  text: 'welcometo'.tr,
                  color: black,
                  fontSize: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                CustomText(
                  text: 'Hido!',
                  color: colorGreen,
                  fontSize: 20,
                )
              ],
            ),
            CustomText(
              text: 'signUpLocal'.tr,
              color: starGreyColor,
              fontSize: 17,
            ),
            const SizedBox(
              height: 24,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'idIqama'.tr,
                    fontSize: 17,
                  ),
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: false,
                    hintText: 'Enter your National Identity ',
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
                    height: 24,
                  ),
                  CustomText(
                    text: 'birthDate'.tr,
                    fontSize: 17,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showCupertinoModalPopup<void>(
                        context: context,
                        builder: (_) {
                          final size = MediaQuery.of(context).size;
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            height: size.height * 0.27,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              onDateTimeChanged: (value) {
                                date = value;
                                String theMonth =
                                    date!.month.toString().length == 1
                                        ? '0${date!.month}'
                                        : date!.month.toString();
                                String theDay = date!.day.toString().length == 1
                                    ? '0${date!.day}'
                                    : date!.day.toString();
                                birthDate = '${date!.year}-$theMonth-$theDay';
                                _authController.birthDate(birthDate);
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Obx(
                      () => Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        height: 48,
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
                              width: 20,
                            ),
                            Obx(
                              () => CustomText(
                                text: _authController.birthDate.isNotEmpty
                                    ? _authController.birthDate.value
                                    : 'mm/dd/yyy'.tr,
                                color: starGreyColor,
                                fontWeight: FontWeight.w400,
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
                  ? const CircularProgressIndicator.adaptive()
                  : CustomButton(
                      onPressed: () async {
                        var isValid = _formKey.currentState!.validate();
                        _authController.validBirthDay(
                            _authController.birthDate.isNotEmpty);
                        if (isValid && _authController.birthDate.isNotEmpty) {
                          // final isSuccess = await _authController.personInfoOTP(
                          //     nationalID: nationalId,
                          //     birthDate: _authController.birthDate.value,
                          //     context: context);
                          // print('isSuccess UI $isSuccess');
                          // if (isSuccess) {
                          //   _authController.localID(nationalId);
                          //   Get.to(() => const PhoneOTP(
                          //         otp: '',
                          //         type: 'signUp',
                          //       ));
                          // }
                          Get.to(() => const ProvidedServices());
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
    );
  }
}
