import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton(
      {super.key,
      required this.title,
      required this.buttonColor,
      this.titleColor = colorRed,
      required this.onTap});
  final String title;
  final Color buttonColor;
  final Color? titleColor;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
        final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: buttonColor,
            ),
            borderRadius: BorderRadius.circular(4)),
        child: CustomText(
          text: title,
          color: titleColor!,
                fontFamily: 'HT Rakik',
            fontSize: width*0.038,
           fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
