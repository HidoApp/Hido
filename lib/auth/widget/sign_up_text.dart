import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpText extends StatelessWidget {
  const SignUpText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: "haveAnAccount?".tr,
          fontSize: MediaQuery.of(context).size.width * 0.038,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.0128,
        ),
        GestureDetector(
            child: CustomText(
              text: 'signUp'.tr,
              color: colorGreen,
              fontSize: MediaQuery.of(context).size.width * 0.038,
            ),
            onTap: () => Get.offAll(
                  // () =>  AccountTypeScreen(),
                  () => const OnboardingScreen(),
                ))
      ],
    );
  }
}
