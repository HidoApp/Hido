import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    this.borderColor,
    required this.title,
    this.icon,
    this.buttonColor,
    this.iconColor,
    this.customWidth,
    this.height,
    this.fontSize = 17,
    this.italic = false,
    this.textColor,
    this.raduis, // Default text color
  });

  final VoidCallback? onPressed;
  final title;
  final Widget? icon;
  final Color? buttonColor;
  final Color? iconColor;
  final double? customWidth;
  final double? height;
  final bool italic;
  final Color? textColor;
  final double? raduis;
  final Color? borderColor;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        overlayColor: buttonColor != null
            ? WidgetStateProperty.all(buttonColor)
            : WidgetStateProperty.all(colorGreen),
        backgroundColor: buttonColor != null
            ? WidgetStateProperty.all(buttonColor)
            : WidgetStateProperty.all(colorGreen),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(raduis ?? 8),
            ),
            side: BorderSide(
                color: borderColor == null
                    ? colorGreen
                    : borderColor ?? Colors.white),
          ),
        ),
        fixedSize:
            WidgetStateProperty.all(Size(customWidth ?? width, height ?? 48
                //56
                )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: [
          if (icon != null) const Spacer(),
          if (icon != null)
            const SizedBox(
              width: 30,
              height: 30,
            ),
          if (title != "")
            if (textColor == null)
              CustomText(
                text: title,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                textAlign: TextAlign.center,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              ),
          if (textColor != null)
            CustomText(
              text: title,
              textAlign: TextAlign.center,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: textColor!,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            ),
          if (icon != null) const Spacer(),
          if (icon != null)
            Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                // color: iconColor ?? colorDarkGreen,
              ),
              //child: icon,
            ),
          if (title == "") const Spacer(),
        ],
      ),
    );
  }
}
