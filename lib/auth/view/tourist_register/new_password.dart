import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key, required this.responseBody})
      : super(key: key);

  final Map responseBody;
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late double width, height;
  bool isSwitched = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswoedController = TextEditingController();
  final _authController = Get.put(AuthController());

  late bool showPassword, showConfirmPassword;

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
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
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
                      top: height * 0.18,
                      right: width * 0.05,
                      left: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                      CustomText(
                        text: "newPassword".tr,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomText(
                        text: "typeNewPassword".tr,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
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
                                      showConfirmPassword =
                                          !showConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      Obx(() {
                        if (_authController.isResetPasswordLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: colorGreen,
                          ));
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Align(
                            alignment: Alignment.center,
                            child: CustomElevatedButton(
                              title: 'send'.tr.toUpperCase(),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (!AppUtil.isPasswordLengthValidate(
                                      _passwordController.text)) {
                                    AppUtil.errorToast(
                                        context, "invalidPassword".tr);
                                    return;
                                  }
                                  if (_passwordController.text !=
                                      _confirmPasswoedController.text) {
                                    AppUtil.errorToast(
                                        context,
                                        "password & confirmation not matching"
                                            .tr);
                                    return;
                                  }

                                  var result = await _authController.resetPassword(
                                      newPassword: _passwordController.text,
                                      email: widget.responseBody['email'],
                                      context: context);
                                  print("result $result");
                                  print(result);

                                  if (result == true) {
                                     Get.offAll(() => const SignInScreen());
                                  }

                                  // var resul =
                                  //     await _authController.sendEmailOTP(
                                  //         email: _emailController.text,
                                  //         context: context);
                                  // print("result $result");

                                  // if (result != null) {
                                  //   print(result);
                                  //   print("data");
                                  //   Get.to(() => EmailOTPScreen(
                                  //         responseBody: result,
                                  //       ));
                                  // }
                                }

                                // Get.to(() => const EmailOTPScreen());
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
