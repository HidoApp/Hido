import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

class CustomSecondOnboarding extends StatelessWidget {
  const CustomSecondOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 313,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, right: 8, left: 18),
            child: CustomText(
              text: 'exploreSaudi'.tr,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.7,
              color: black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, right: 17, left: 17),
            child: CustomText(
              text: 'traditionalCrafts'.tr,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.896,
              color: black,
            ),
          ),
        ],
      ),
    );
  }
}
