import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './email_otp.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late double width, height;
  bool isSwitched = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authController =  Get.put(AuthController());


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
                  
                  
                      CustomText(
                        text: "resetPassword".tr,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomText(
                        text: "passwordReset".tr,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        hintText: 'yourEmail'.tr,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: colorDarkGrey,
                        ),
                        onChanged: (String value) {},
                      ),),
                      const SizedBox(
                        height: 30,
                      ),
                      Obx(
                     () {
                      if ( _authController.isOTPLoading.value) {
                        return  const Center(child:  CircularProgressIndicator( color: colorGreen,));
                         }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Align(
                              alignment: Alignment.center,
                              child:
                                CustomElevatedButton(
                                title: 'send'.tr.toUpperCase(),
                                onPressed: () async{
                                  if(_formKey.currentState!.validate()){
                                    if(!AppUtil.isEmailValidate(_emailController.text)){
                                      AppUtil.errorToast(
                                            context, "invalidEmail".tr);
                                        return;
                                    }

                                  var result =  await _authController.sendEmailOTP(email: _emailController.text.toLowerCase(), context: context) ;
                                  print("result $result");



                                  if (result != null){
                                    print(result);
                                    print("data");
                                     Get.to(() =>  EmailOTPScreen(responseBody: result,));
                                  }


                                  }

                                 // Get.to(() => const EmailOTPScreen());
                                },
                              ),
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
