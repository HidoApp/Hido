import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/ajwadi_register_screen_second.dart';

import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/utils/app_util.dart';

import '../../../new-onboarding/view/intro_screen.dart';

class AjwadiRegisterScreen extends StatefulWidget {
  const AjwadiRegisterScreen({Key? key}) : super(key: key);

  @override
  State<AjwadiRegisterScreen> createState() => _AjwadiRegisterScreenState();
}

class _AjwadiRegisterScreenState extends State<AjwadiRegisterScreen> {
  late double width, height;
  bool isSwitched = false;

  final _formKey = GlobalKey<FormState>();

  late bool showPassword, showConfirmPassword;
  late bool isDateSelected;
  late bool isInaitla = true;
  DateTime? date;
  String? birthDate;
  final authController = Get.put(AuthController());

  final _nationalIdController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showPassword = false;
    showConfirmPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar('signUp'.tr),
          body: SizedBox(
            // width: width*0.,
            child: ScreenPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  CustomText(
                    text: 'letsRegisterAccount'.tr,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: black,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          keyboardType: TextInputType.number,
                          controller: _nationalIdController,
                          hintText: "idIqama".tr,
                          textColor: Colors.grey,
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Colors.grey,
                          ),
                          onChanged: (String value) {},
                        ),
                        const SizedBox(
                          height: 20,
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
                                        birthDate =
                                            '${date!.year}-$theMonth-$theDay';
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: 60,
                            width: width * 0.85,
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
                                  text: birthDate != null
                                      ? birthDate!
                                      : 'birthDate'.tr,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: CustomText(
                              fontFamily: 'Noto Kufi Arabic',
                              text: isInaitla
                                  ? ''
                                  : isDateSelected
                                      ? ''
                                      : 'هذا الحقل مطلوب',
                              color: colorDarkRed,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: authController.isCountryLoading == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: colorGreen),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: CustomButton(
                                  onPressed: () async {
                                    if (date == null) {
                                      print('EMPTY');
                                      setState(() {
                                        isDateSelected = false;
                                        isInaitla = false;
                                      });

                                      return;
                                    } else {
                                      isDateSelected = true;
                                      isInaitla = false;
                                    }

                                    if (_formKey.currentState!.validate()) {
                                      if (!AppUtil.isNationalIdValidate(
                                          _nationalIdController.text)) {
                                        AppUtil.errorToast(
                                            context,
                                            "National id must consist of 10 digits"
                                                .tr);
                                        return;
                                      }

                                      var countries;
                                      var data = await authController
                                          .getListOfCountries(context);
                                      if (data != null) {
                                        countries = data;
                                      }

                                      if (countries != null) {
                                        Get.to(() => AjwadiRegisterSecondScreen(
                                              authController: authController,
                                              nationalId:
                                                  _nationalIdController.text,
                                              birthDate: birthDate!,
                                            ));
                                      }
                                    }
                                  },
                                  title: 'signUp'.tr,
                                  icon: !AppUtil.rtlDirection(context)
                                      ? Icon(Icons.arrow_back_ios)
                                      : Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'alreadyHaveAccount'.tr,
                        color: black,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const SignInScreen());
                        },
                        child: CustomText(
                          text: "signIn".tr,
                          color: colorGreen,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
