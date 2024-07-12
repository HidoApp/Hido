import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/ajwadi_driving_license_screen.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/ajwadi_vehicle_info_screen.dart';
import 'package:ajwad_v4/auth/view/tourist_register/register/register_screen.dart';
import 'package:ajwad_v4/auth/view/tourist_register/reset_password.dart';

import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../utils/app_util.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key, this.isGuest = false}) : super(key: key);
  final bool isGuest;
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late double width, height;
  bool isSwitched = true;
  bool showPassword = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: const CustomAppBar(''),
          body: SingleChildScrollView(
            child: SizedBox(
              child: Stack(
                children: [
                  ScreenPadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "signInTitle".tr,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.051,
                        ),

                        CustomText(
                          text: 'signAsTourist'.tr,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.0435,
                          color: starGreyColor,
                          textAlign: !AppUtil.rtlDirection(context)
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: 'email'.tr),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.emailAddress,
                                hintText: 'yourEmail'.tr,
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
                              CustomText(text: 'password'.tr),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.text,
                                obscureText: !showPassword,
                                hintText: 'yourPassword'.tr,
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
                              )
                            ],
                          ),
                        ),
                        // const SizedBox(
                        //   height: 40,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPasswordScreen()));
                              },
                              child: CustomText(
                                text: "forgotPassword".tr,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _authController.isLoginLoading.value == true
                                ? const Center(
                                    child: CircularProgressIndicator.adaptive())
                                : CustomButton(
                                    icon:
                                        const Icon(Icons.keyboard_arrow_right),
                                    title: 'signIn'.tr,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (!AppUtil.isEmailValidate(
                                            _emailController.text)) {
                                          AppUtil.errorToast(
                                              context, "invalidEmail".tr);
                                          return;
                                        }

                                        final user =
                                            await _authController.login(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                                rememberMe: true,
                                                context: context);


                                        print('logged $user');

                                        if (user != null) {
                                          bool isTokenExpired =
                                              JwtDecoder.isExpired(
                                                  user.accessToken);

                                          print(
                                              'isTokenExpired : $isTokenExpired');

                                          final Token jwtToken =
                                              AuthService.jwtForToken(
                                                  user.accessToken)!;
                                          print("token.userRole loign");
                                          print(jwtToken.userRole);

                                          if (jwtToken.userRole == 'local') {
                                            final ajwadiInfo =
                                                await _authController
                                                    .checkLicenceAndVehicle(
                                                        user.accessToken);

                                            if (ajwadiInfo?.drivingLicense ==
                                                    false ||
                                                ajwadiInfo?.vehicle == false) {
                                              if (ajwadiInfo?.drivingLicense ==
                                                  false) {
                                                Get.to(
                                                    () => AjwadiDrivingLicense(
                                                          user: user,
                                                        ));
                                              } else if (ajwadiInfo?.vehicle ==
                                                  false) {
                                                Get.to(() =>
                                                    const AjwadiVehicleInfo());
                                              }
                                            } else {
                                              Get.off(() =>
                                                  const AjwadiBottomBar());
                                            }
                                          } else if (jwtToken.userRole ==
                                              'tourist') {
                                            Get.offAll(
                                                () => const TouristBottomBar());
                                          } else {
                                            print('NO USER ROLE');
                                          }
                                        }
                                      }
                                    },
                                  ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "haveAnAccount?".tr,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                            TextButton(
                              onPressed: ()
                                  // async
                                  {
                                Get.to(
                                  () => RegisterScreen(
                                    authController: _authController,
                                    //  countries: countries,
                                  ),
                                );
                              },
                              child: CustomText(
                                text: 'signUp'.tr,
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
                ],
              ),
            ),
          )),
    );
  }
}
