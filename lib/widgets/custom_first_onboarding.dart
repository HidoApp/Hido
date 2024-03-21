import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

class CustomFirstOnboarding extends StatelessWidget {
  const CustomFirstOnboarding({super.key});

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
              right: AppUtil.rtlDirection(context) ? 21 : 33,
              left: AppUtil.rtlDirection(context) ? 27 : 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'ajwad'.tr,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  height: 1.416,
                  color: black,
                ),
                CustomText(
                  text: 'noun'.tr,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 2.833,
                  color: colorDarkGrey,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 8,
              right: AppUtil.rtlDirection(context) ? 21 : 9,
              left: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'societyGenerosity'.tr,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 1.525,
                  color: black,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    CustomText(
                      text: 'singler'.tr,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 2.295,
                      color: black,
                    ),
                    const SizedBox(width: 5),
                    CustomText(
                      text: 'ajwady'.tr,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.525,
                      color: black,
                    ),
                  ],
                ),
                CustomText(
                  text: 'familySaudi'.tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.525,
                  color: black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
