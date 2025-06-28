import 'dart:async';
import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/auth/view/tourist_register/register/register_screen.dart';
import 'package:ajwad_v4/auth/view/tourist_register/reset_password.dart';

import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
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
  final notificationController = Get.put(NotificationController());
  StreamSubscription? _internetConnection;
  void setInternetConnection() {
    _internetConnection = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          _authController.isInternetConnected(true);
          break;
        case InternetStatus.disconnected:
          _authController.isInternetConnected(false);
          break;
        default:
          _authController.isInternetConnected(false);
          break;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _internetConnection!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setInternetConnection();
    // AmplitudeService.initializeAmplitude();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
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
                          textAlign: AppUtil.rtlDirection2(context)
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
                                validator: false,
                                validatorHandle: (email) {
                                  if (email == null || email.isEmpty) {
                                    return 'fieldRequired'.tr;
                                  }
                                  if (!AppUtil.isEmailValidate(email)) {
                                    return 'invalidEmail'.tr;
                                  }
                                  return null;
                                },
                                onChanged: (String value) {},
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomText(
                                text: 'password'.tr,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.text,
                                obscureText: !showPassword,
                                hintText: 'yourPassword'.tr,
                                controller: _passwordController,
                                isPassword: true, validator: true,

                                // prefixIcon: const Icon(
                                //   Icons.lock_outline_rounded,
                                //   color: colorDarkGrey,
                                // ),
                                onChanged: (String value) {},
                                suffixIcon: GestureDetector(
                                  child: Icon(
                                    showPassword == true
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
                                text: 'forgotPassword'.tr,
                                fontSize: width * 0.038,
                                fontFamily: AppUtil.SfFontType(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _authController.isLoginLoading.value ==
                                        true ||
                                    notificationController
                                        .isSendingDeviceToken.value
                                ? const Center(
                                    child: CircularProgressIndicator.adaptive())
                                : CustomButton(
                                    icon:
                                        const Icon(Icons.keyboard_arrow_right),
                                    title: 'signIn'.tr,
                                    onPressed: () async {
                                      if (!_authController
                                          .isInternetConnected.value) {
                                        AppUtil.connectionToast(
                                            context, 'offlineTitle'.tr);
                                        return;
                                      }
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

                                        if (user != null) {
                                          bool isTokenExpired =
                                              JwtDecoder.isExpired(
                                                  user.accessToken);

                                          log('isTokenExpired : $isTokenExpired');

                                          final Token jwtToken =
                                              AuthService.jwtForToken(
                                                  user.accessToken)!;

                                          if (jwtToken.userRole == 'local') {
                                            final ajwadiInfo =
                                                await _authController
                                                    .checkLicenceAndVehicle(
                                                        user.accessToken);

                                            if (ajwadiInfo?.drivingLicense ==
                                                    false ||
                                                ajwadiInfo?.vehicle == false) {
                                              // if (ajwadiInfo?.drivingLicense ==
                                              //     false) {
                                              // } else if (ajwadiInfo?.vehicle ==
                                              //     false) {}
                                            } else {
                                              AmplitudeService.amplitude
                                                  .track(BaseEvent(
                                                'Local Sign in',
                                              ));

                                              Get.off(() =>
                                                  const AjwadiBottomBar());
                                            }
                                          } else if (jwtToken.userRole ==
                                              'tourist') {
                                            AmplitudeService.amplitude.track(
                                                BaseEvent('Tourist Sign in',
                                                    eventProperties: {
                                                  'Tourist email':
                                                      _emailController.text,
                                                }));

                                            final isSuccess =
                                                await notificationController
                                                    .sendDeviceToken(
                                                        context: context);
                                            if (!isSuccess) {
                                              AmplitudeService.amplitude.track(
                                                  BaseEvent(
                                                      'Tourist Sign in Failed'));
                                              return;
                                            }
                                            Get.offAll(
                                                () => const TouristBottomBar());
                                          } else {
                                            AppUtil.errorToast(
                                                context, 'invalidSingIn'.tr);
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
                              fontWeight: FontWeight.w500,
                              fontFamily: AppUtil.SfFontType(context),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.0128,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!_authController
                                    .isInternetConnected.value) {
                                  AppUtil.connectionToast(
                                      context, 'offlineTitle'.tr);
                                  return;
                                }
                                Get.off(() => const RegisterScreen());
                              },
                              child: CustomText(
                                text: 'signUp'.tr,
                                color: colorGreen,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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
