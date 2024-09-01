import 'package:ajwad_v4/auth/view/ajwadi_register/ajwadi_register_screen.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/local_sign_up.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpText extends StatelessWidget {
  const SignUpText({super.key, this.isLocal = true});
  final bool isLocal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: "haveAnAccount?".tr,
          fontFamily: AppUtil.SfFontType(context),
          fontWeight: FontWeight.w300,
          fontSize: MediaQuery.of(context).size.width * 0.038,
          
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.0128,
        ),
        GestureDetector(
            child: CustomText(
              text: 'signUp'.tr,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w500,
              color: colorGreen,
              fontSize: MediaQuery.of(context).size.width * 0.038,
            ),
            onTap: () {
              Get.back();
              if (isLocal) {
                Get.to(
                  () => const LocalSignUpScreen(),
                );
              } else {
                Get.off(() => const SignInScreen());
              }
            })
      ],
    );
  }
}
