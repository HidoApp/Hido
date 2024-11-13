import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPloicySheet extends StatelessWidget {
  const CustomPloicySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(36)
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(width * 0.06),
          topRight: Radius.circular(width * 0.06),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.06, vertical: width * 0.035),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: width * 0.06,
            ),
            CustomText(
              text: 'cancellationPolicy'.tr,
              fontSize: width * 0.046,
              fontFamily: 'HT Rakik',
            ),
            SizedBox(
              height: width * 0.06,
            ),
            CustomText(
              text: 'cancellationPolicyBreif'.tr,
              fontSize: width * 0.038,
              color: starGreyColor,
              fontWeight: FontWeight.w400,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              maxlines: 200,
            ),
            SizedBox(
              height: width * 0.038,
            ),
            CustomText(
              text: 'cancellationPolicyBreifAdventure'.tr,
              color: starGreyColor,
              fontSize: width * 0.038,
              fontWeight: FontWeight.w400,
              maxlines: 200,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
            ),
            SizedBox(
              height: width * 0.038,
            ),
            CustomText(
              text: 'cancellationPolicyNote'.tr,
              color: starGreyColor,
              fontSize: width * 0.038,
              fontWeight: FontWeight.w400,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
            ),
            SizedBox(
              height: width * 0.038,
            ),
            CustomText(
              text: 'cancellationPolicySubNote'.tr,
              color: starGreyColor,
              fontSize: width * 0.038,
              fontWeight: FontWeight.w400,
              maxlines: 200,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
            ),
          ],
        ),
      ),
    );
  }
}
