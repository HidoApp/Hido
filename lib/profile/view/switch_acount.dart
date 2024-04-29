import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_util.dart';

class SwitchAcount extends StatelessWidget {
  const SwitchAcount({Key? key, this.fromAjwady = true}) : super(key: key);
  final bool fromAjwady;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      //height: 200,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
          color: fromAjwady ? lightBlack : Colors.white,
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: fromAjwady ? "becomeTourist".tr : "becomeAjwdy".tr,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: fromAjwady ? Colors.white : black,
          ),
          SizedBox(
            height: 20,
          ),
          CustomText(
            height: 1.3,
            text: fromAjwady ? " " : "becomeAjwadyBreif".tr,
            color: fromAjwady ? lightGrey : almostGrey,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: fromAjwady ? 2 : 40,
          ),
          CustomButton(
            onPressed: () {},
            title: "switch".tr.toUpperCase(),
            icon: Icon(AppUtil.rtlDirection(context)
                ? Icons.arrow_back_outlined
                : Icons.arrow_forward_outlined),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
