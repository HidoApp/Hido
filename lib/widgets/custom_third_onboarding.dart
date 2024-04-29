import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

class CustomThirdOnboarding extends StatelessWidget {
  const CustomThirdOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 313,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 15,
              right: AppUtil.rtlDirection(context) ? 16 : 8,
              left: AppUtil.rtlDirection(context) ? 10 : 18,
            ),
            child: CustomText(
              text: 'experienceSaudi'.tr,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.7,
              color: black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 8,
              right: 17,
              left: 17,
            ),
            child: CustomText(
              text: 'connectAjwady'.tr,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.896,
              color: black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 24,
              right: 17,
              left: 17,
            ),
            child: CustomText(
              text: 'exploringSaudi'.tr,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.896,
              color: black,
            ),
          ),
        ],
      ),
    );
  }
}
