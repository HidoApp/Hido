import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/tourist_register/register/last_step.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
    required this.authController,
    //  this.countries,
  }) : super(key: key);
  final AuthController authController;
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

  // final _authController = Get.put(AuthController());

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
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(""),
          body: SizedBox(
            // width: width*0.,
            child: Stack(
              children: [
                // Container(
                //   height: height,
                //   width: width,
                //   decoration: const BoxDecoration(
                //       image: DecorationImage(
                //     image: AssetImage("assets/images/background_ajwadi.png"),
                //     fit: BoxFit.fill,
                //   )),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.04,
                      right: width * 0.05,
                      left: width * 0.05),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [],
                      ),
                      CustomText(
                        text: "letsSignUp".tr,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: CustomText(text: 'fullName'.tr),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.name,
                              controller: _nameController,
                              hintText: 'fullName'.tr,
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: colorDarkGrey,
                              ),
                              onChanged: (String value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: CustomText(text: 'yourEmail'.tr),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'email'.tr,
                              controller: _emailController,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: colorDarkGrey,
                              ),
                              onChanged: (String value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: CustomText(text: 'password'.tr),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.text,
                              obscureText: !showPassword,
                              hintText: 'password'.tr,
                              controller: _passwordController,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: colorDarkGrey,
                              ),
                              onChanged: (String value) {},
                              suffixIcon: GestureDetector(
                                child: Icon(
                                    showPassword == true
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF969696)),
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: CustomText(text: 'confirmPass'.tr),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.text,
                              obscureText: !showConfirmPassword,
                              hintText: 'confirmPass'.tr,
                              controller: _confirmPasswoedController,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: colorDarkGrey,
                              ),
                              onChanged: (String value) {},
                              suffixIcon: GestureDetector(
                                child: Icon(
                                    showConfirmPassword == true
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF969696)),
                                onTap: () {
                                  setState(() {
                                    showConfirmPassword = !showConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: widget.authController.isCountryLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: colorGreen),
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: CustomElevatedButton(
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
                                          var data = await widget.authController
                                              .getListOfCountries(context);
                                          if (data != null) {
                                            countries = data;
                                          }

                                          if (countries != null) {
                                            Get.to(() => LastStepScreen(
                                                  name: _nameController.text,
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                  authController:
                                                      widget.authController,
                                                  countries: countries,
                                                ));
                                          }

                                          // }
                                        }
                                      }),
                                ),
                        ),
                      ),
                      // Align(
                      //     alignment: Alignment.center,
                      //     child: CustomText(
                      //       text: "or".tr,
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 16,
                      //       color: colorDarkGrey,
                      //     )),
                      // CustomSocialMediaCard(
                      //   title: 'LoginGoogle'.tr,
                      //   imagePath: 'assets/images/google_logo.png',
                      //   onCardTap: () {},
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      //   CustomSocialMediaCard(
                      //     title: 'LoginApple'.tr,
                      //     imagePath: 'assets/icons/apple_icon.png',
                      //     onCardTap: () {},
                      //   ),
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "alreadyHaveAccount".tr,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: CustomText(
                              text: "signIn".tr,
                              color: colorGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
