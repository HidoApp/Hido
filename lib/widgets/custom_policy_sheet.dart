import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
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
            horizontal: width * 0.06, vertical: width * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Icon(Icons.keyboard_arrow_down)),
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
              text: 'cancellationPolicyBreifAdventure'.tr,
              fontSize: width * 0.038,
              fontWeight: FontWeight.w300,
             fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',

            ),
            SizedBox(
              height: width * 0.038,
            ),
            CustomText(
              text: 'cancellationPolicyNote'.tr,
              fontSize: width * 0.038,
              fontWeight: FontWeight.w300,
              fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',

            ),
          ],
        ),
      ),
    );
  }
}
