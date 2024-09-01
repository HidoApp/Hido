import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/terms&conditions.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomText(
          fontFamily: AppUtil.SfFontType(context),
          fontWeight: FontWeight.w400,
          text: "termsText".tr,
          fontSize: MediaQuery.of(context).size.width * 0.033,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.0128,
        ),
        GestureDetector(
          child: CustomText(
            text: 'termsOfService'.tr,
            color: blue,
            fontFamily: AppUtil.SfFontType(context),
            fontWeight: FontWeight.w400,
            fontSize: MediaQuery.of(context).size.width * 0.033,
          ),
          onTap: () {
            Get.to(() => const TermsAndConditions(
                  fromAjwady: false,
                ));
          },
        )
      ],
    );
  }
}
