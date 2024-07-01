import 'package:ajwad_v4/auth/view/sigin_in/local_sign_in.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignInText extends StatelessWidget {
  const SignInText({super.key});

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
              text: 'signIn'.tr,
              color: colorGreen,
              fontSize: MediaQuery.of(context).size.width * 0.038,
            ),
            onTap: () => Get.to(
                  // () =>  AccountTypeScreen(),
                  () => const LocalSignIn(),
                ))
      ],
    );
  }
}
