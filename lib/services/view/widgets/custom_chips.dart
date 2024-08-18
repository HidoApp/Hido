import 'package:ajwad_v4/services/view/event_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomChips extends StatelessWidget {
  const CustomChips(
      {super.key,
      required this.title,
      required this.backgroundColor,
      required this.borderColor,
      required this.textColor});
  final String title;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.4, vertical: width * 0.01),
      // horizontal: width * 0.030, vertical: width * 0.01),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        border:
            Border.all(width: 1.50, color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(9999)),
      ),
      child: CustomText(
        text: title,
        fontSize: width * 0.038,
        fontWeight: FontWeight.w600,
        color: textColor,
        fontFamily: !AppUtil.rtlDirection2(context) ? 'SF Pro' : 'SF Arabic',
        textAlign: TextAlign.center,
      ),
    );
  }
}
