import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomOrderButton extends StatelessWidget {
  const CustomOrderButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.buttonColor,
    this.customWidth,
    this.height,
    this.borderColor,
    this.textColor,
  });

  final VoidCallback onPressed;
  final String title;
  final Color? buttonColor, borderColor, textColor;
  final double? customWidth;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        side: MaterialStateProperty.all(BorderSide(
            color: borderColor ?? Colors.transparent,
            width: 1.0,
            style: BorderStyle.solid)),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: buttonColor != null
            ? MaterialStateProperty.all(buttonColor)
            : MaterialStateProperty.all(colorGreen),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        fixedSize:
            MaterialStateProperty.all(Size(customWidth ?? width, height ?? 58)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: [
          if (title != "")
            CustomText(
              text: title,
              textAlign: TextAlign.center,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.white,
            ),
        ],
      ),
    );
  }
}
