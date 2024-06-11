import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomChips extends StatelessWidget {
  const CustomChips(
      {super.key,
      required this.title,
      required this.backgroundColor,
      this.borderColor,
      required this.textColor});
  final String title;
  final Color backgroundColor;
  final Color? borderColor;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.030, vertical: width * 0.01),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
            width: width * 0.0025, color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(width * 0.051)),
      ),
      child: CustomText(
        text: title,
        fontSize: width * 0.038,
        fontWeight: FontWeight.w600,
        color: textColor,
        textAlign: TextAlign.center,
      ),
    );
  }
}
