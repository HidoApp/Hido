import 'package:ajwad_v4/auth/view/ajwadi_register/provided_services.dart';
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
  late bool isDateSelected;
  late bool isInaitla = true;
  DateTime? date;
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
                    onChanged: (value) {},
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
                                setState(() {
                                  isDateSelected = true;
                                  String theMonth =
                                      date!.month.toString().length == 1
                                          ? '0${date!.month}'
                                          : date!.month.toString();
                                  String theDay =
                                      date!.day.toString().length == 1
                                          ? '0${date!.day}'
                                          : date!.day.toString();
                                  birthDate = '${date!.year}-$theMonth-$theDay';
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: isInaitla
                                ? Colors.grey
                                : isDateSelected
                                    ? Colors.grey
                                    : colorDarkRed,
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
                          CustomText(
                            text:
                                birthDate != null ? birthDate! : 'mm/dd/yyy'.tr,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            CustomButton(
              onPressed: () {
                var isValid = _formKey.currentState!.validate();
                if (isValid) {
                  Get.to(() => const ProvidedServices());
                } else {}
              },
              title: 'next'.tr,
              height: 48,
              icon: const Icon(
                Icons.keyboard_arrow_right,
                size: 24,
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
