import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/auth/view/tourist_register/register/last_step.dart';
import 'package:ajwad_v4/auth/widget/sign_in_text.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:amplitude_flutter/amplitude.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
    //  this.countries,
  }) : super(key: key);
  // final countries;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  late double width, height;
  bool isSwitched = false;
  late bool showPassword, showConfirmPassword;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswoedController = TextEditingController();

   final _authController = Get.put(AuthController());

  @override
  void initState() {
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
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: const CustomAppBar(
              '',
            ),
            body: SizedBox(
              // width: width*0.,
              child: Stack(
                children: [
                  ScreenPadding(
                    child: ListView(
                      children: [
                        CustomText(
                          text: "signInTitle".tr,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.051,
                        ),
                        CustomText(
                          text: 'createTourist'.tr,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.0435,
                          color: starGreyColor,
                          textAlign: !AppUtil.rtlDirection(context)
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                        SizedBox(
                          height: width * 0.041,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: 'fullName'.tr),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.name,
                                controller: _nameController,
                                hintText: 'fullName'.tr,
                                // prefixIcon: const Icon(
                                //   Icons.person_outline,
                                //   color: colorDarkGrey,
                                // ),
                                onChanged: (String value) {},
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomText(text: 'email'.tr),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.emailAddress,
                                hintText: 'yourEmail'.tr,
                                controller: _emailController,
                                // prefixIcon: const Icon(
                                //   Icons.email_outlined,
                                //   color: colorDarkGrey,
                                // ),
                                onChanged: (String value) {},
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomText(text: 'password'.tr),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.text,
                                obscureText: !showPassword,
                                hintText: 'password'.tr,
                                isPassword: true,
                                controller: _passwordController,
                                // prefixIcon: const Icon(
                                //   Icons.lock_outline_rounded,
                                //   color: colorDarkGrey,
                                // ),
                                onChanged: (String value) {},
                                suffixIcon: GestureDetector(
                                  child: Icon(
                                    showConfirmPassword == true
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: borderGrey,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomText(text: 'confirmPass'.tr),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.text,
                                obscureText: !showConfirmPassword,
                                hintText: 'confirmPass'.tr,
                                isPassword: true,
                                controller: _confirmPasswoedController,
                                // prefixIcon: const Icon(
                                //   Icons.lock_outline_rounded,
                                //   color: colorDarkGrey,
                                // ),
                                onChanged: (String value) {},
                                suffixIcon: GestureDetector(
                                  child: Icon(
                                      showConfirmPassword == true
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: borderGrey),
                                  onTap: () {
                                    setState(() {
                                      showConfirmPassword =
                                          !showConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: width * 0.2,
                        ),
                        Obx(
                          () => Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: width * .030),
                            child: _authController.isCountryLoading ==
                                    true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: colorGreen),
                                  )
                                : CustomButton(
                                    icon: const Icon(Icons.keyboard_arrow_right,
                                        color: Colors.white),
                                    title: 'signUp'.tr,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (!AppUtil.isEmailValidate(
                                            _emailController.text)) {
                                          AppUtil.errorToast(
                                              context, "invalidEmail".tr);
                                          return;
                                        }

                                        if (_passwordController.text.length <
                                            6) {
                                          AppUtil.errorToast(
                                              context, 'invalidPass'.tr);
                                          return;
                                        }

                                        if (_passwordController.text !=
                                            _confirmPasswoedController.text) {
                                          AppUtil.errorToast(context,
                                              'ivalidPassAndConfirm'.tr);
                                          return;
                                        }
                                        var countries;
                                        var data = await _authController
                                            .getListOfCountries(context);

                                        if (data != null) {
                                          countries = data;

                                          print('DONEEE');
                                        }
                                        if (countries != null) {
                                    Amplitude.getInstance().logEvent('complete fist sign up step', eventProperties: {
                                   'name': _nameController.text,
                                  'email': _emailController.text,
                                        });
                                          Get.to(() => LastStepScreen(
                                                name: _nameController.text,
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                                authController:
                                                    _authController,
                                                countries: countries,
                                              ));
                                              Amplitude.getInstance().logEvent('Next step of tourist sign up');

                                        }

                                        // }
                                      }
                                    }),
                          ),
                        ),
                        SizedBox(
                          height: width * 0.03,
                        ),
                        const SignInText(
                          isLocal: false,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
