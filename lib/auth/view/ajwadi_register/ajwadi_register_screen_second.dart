import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/tourist_register/phone_otp.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_ajwadi_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/utils/app_util.dart';

class AjwadiRegisterSecondScreen extends StatefulWidget {
  const AjwadiRegisterSecondScreen({Key? key, required this.authController, required this.nationalId, required this.birthDate}) : super(key: key);

  final AuthController authController;
    final String nationalId;
  final String birthDate;

  @override
  State<AjwadiRegisterSecondScreen> createState() => _AjwadiRegisterSecondScreenState();
}

class _AjwadiRegisterSecondScreenState extends State<AjwadiRegisterSecondScreen> {
  late double width, height;
  bool isSwitched = false;

  final _formKey = GlobalKey<FormState>();

  late bool showPassword, showConfirmPassword;
  late bool isDateSelected;
  late bool isInaitla = true;
  DateTime? date;
  String? birthDate;
  final authController = Get.put(AuthController());

   final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswoedController = TextEditingController();
    final _phoneController = TextEditingController();


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
          appBar: CustomAjwadiAppBar(""),
          body: SingleChildScrollView(
            // width: width*0.,
            child: Padding(
              padding: EdgeInsets.only(
                  top: height * 0.14,
                  left: width * 0.05,
                  right: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'letsRegisterAccount'.tr,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.black,
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomText(text: 'fullName'.tr),
                          ),
                         const SizedBox(height: 5,),
                         
                        CustomTextField(
                          keyboardType: TextInputType.name,
                          controller: _nameController,
                          hintText: 'fullName'.tr,
                          // textColor: Colors.grey,
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomText(text: 'email'.tr),
                          ),
                         const SizedBox(height: 5,),
                        CustomTextField(
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'yourEmail'.tr,
                        //   textColor: Colors.grey,
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomText(text: 'password'.tr),
                          ),
                         const SizedBox(height: 5,),
                        CustomTextField(
                          keyboardType: TextInputType.text,
                          obscureText: !showPassword,
                         //  textColor: Colors.grey,
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomText(text: 'confirmPass'.tr),
                          ),
                         const SizedBox(height: 5,),
                        CustomTextField(
                          keyboardType: TextInputType.text,
                          obscureText: !showConfirmPassword,
                          hintText: 'confirmPass'.tr,
                         //  textColor: Colors.grey,
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
            
                         const SizedBox(
                          height: 20,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomText(text: 'phoneNum'.tr),
                          ),
                         const SizedBox(height: 5,),
                        CustomTextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          hintText: 'phoneNum'.tr,
                          prefixIcon: const Icon(
                            Icons.local_phone_outlined,
                            color: colorDarkGrey,
                          ),
                          onChanged: (String value) {},
                        ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                      ],
                    ),
                  ),
            
                  Obx(() => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: authController.isPersonInfoLoading == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: colorGreen),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: CustomButton(
                                  onPressed: () async {
                                   
            
                                    if (_formKey.currentState!.validate()) {
                                      if (!AppUtil.isEmailValidate(_emailController.text)) {
                                        AppUtil.errorToast(
                                            context,
                                            "invalidEmailuf"
                                                .tr);
                                        return;
                                      }
            
            
                                      if (!AppUtil
                                            .isPasswordLengthValidate(
                                                _passwordController.text)) {
                                          AppUtil.errorToast(context,
                                              "invalidPassword".tr);
                                          return;
                                        }
            
                                        if (_passwordController.text !=
                                            _confirmPasswoedController
                                                .text) {
                                          AppUtil.errorToast(
                                              context,
                                              "password & confirmation not matching"
                                                  .tr);
                                          return;
                                        }
            
                                      
            
                                    
            
                                 //   if (countries != null)  {
                                   
                                        final isSuccess = await widget
                                            .authController
                                            .personInfoOTP(
                                                nationalID:
                                                    widget.nationalId,
                                                birthDate: widget.birthDate,
                                                context: context);
                                        print('isSuccess UI $isSuccess');
            
            
                                           if (isSuccess) {
                                          Get.to(() => PhoneOTPScreen(
                                              authController: 
                                                  widget.authController,
                                              name: _nameController.text,
                                              password:
                                                  _passwordController.text,
                                              nationalID: widget.nationalId,
                                              email: _emailController.text,
                                              nationality:'saudi',
                                              phone:_phoneController.text,
                                              isAjwadi: true,
                                                 ));
                                        }
                                    //  }
                                    }
                                  },
                                  title: 'signUp'.tr,
                                  icon: !AppUtil.rtlDirection(context)
                                      ? Icon(Icons.arrow_back_ios)
                                      : Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                      )),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CustomText(
                  //       text: 'alreadyHaveAccount'.tr,
                  //       color: Colors.white,
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //     TextButton(
                  //       onPressed: () {
                  //         Get.to(() => const SignInScreen());
                  //       },
                  //       child: CustomText(
                  //         text: "signIn".tr,
                  //         color: colorGreen,
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.w400,
                  //       ),
                  //     )
                  //   ],
                  // )
               
                ],
              ),
            ),
          )),
    );
  }
}
