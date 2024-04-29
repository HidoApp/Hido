import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {Key? key,
      required this.text,
      this.fontSize = 14,
      this.textAlign,
      this.fontWeight = FontWeight.w400,
      this.color = black,
      this.textDecoration,
      this.maxlines,
      this.textOverflow,
      this.textDirection,
      this.height,
      this.fontFamily,
      this.fontStyle,
      this.textDecorationStyle}) 
      : super(key: key);




  final String text;
  final double fontSize;
  final TextAlign? textAlign;
  final FontWeight fontWeight;
  final Color color;
  final TextDecoration? textDecoration;
  final int? maxlines;
  final TextOverflow? textOverflow;
  final TextDirection? textDirection;
  final double? height;
  final String? fontFamily;
  final FontStyle? fontStyle;
  final TextDecorationStyle? textDecorationStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ??
          (!AppUtil.rtlDirection(context) ? TextAlign.right : TextAlign.left),
      maxLines: maxlines,
      overflow: textOverflow,
      style: TextStyle(
          fontFamily: fontFamily ?? 'HT Rakik',
          color: color,
          fontSize: fontSize,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          decoration: textDecoration,
          decorationStyle: textDecorationStyle,
          height: height,
          decorationColor: color,
          decorationThickness: 0.3),
      textDirection: textDirection ??
          (!AppUtil.rtlDirection(context)
              ? TextDirection.rtl
              : TextDirection.ltr),
    );
  }
}
