import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {Key? key,
      required this.text,
      this.fontSize = 14,
      this.textAlign,
      this.fontWeight = FontWeight.w500,
      this.color = black,
      this.textDecoration,
      this.maxlines,
      this.textOverflow,
      this.textDirection,
      this.height,
      this.fontFamily,
      this.fontStyle,
      this.shadows,
      this.textDecorationStyle})
      : super(key: key);

  final String? text;
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
  final List<Shadow>? shadows;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // data: MediaQuery.of(context)
      //     .copyWith(textScaler: const TextScaler.linear(1.0)),
       data: MediaQuery.of(context)
          .copyWith(textScaleFactor: 1.0),
      child: Text(
        text!,
        textAlign: textAlign ??
            (AppUtil.rtlDirection2(context) ? TextAlign.right : TextAlign.left),
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
            shadows: shadows,
            decorationColor: color,
            
            overflow:
                TextOverflow.ellipsis, // Add ellipsis if the text is too long
            decorationThickness: 0.3),
        textDirection: textDirection ??
            (AppUtil.rtlDirection2(context)
                ? TextDirection.rtl
                : TextDirection.ltr),
      ),
    );
  }
}
