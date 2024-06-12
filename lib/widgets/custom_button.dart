import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
    this.buttonColor,
    this.iconColor,
    this.customWidth,
    this.height,
    this.italic = false,
    this.textColor,
    this.raduis, // Default text color
  });

  final VoidCallback onPressed;
  final title;
  final Widget? icon;
  final Color? buttonColor;
  final Color? iconColor;
  final double? customWidth;
  final double? height;
  final bool italic;
  final Color? textColor;
  final double? raduis;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: buttonColor != null
            ? MaterialStateProperty.all(buttonColor)
            : MaterialStateProperty.all(colorGreen),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(raduis ?? 12),
            ),
          ),
        ),
        fixedSize:
            MaterialStateProperty.all(Size(customWidth ?? width, height ?? 48
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
                textAlign: TextAlign.center,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              ),
          if (textColor != null)
            CustomText(
              text: title,
              textAlign: TextAlign.center,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: textColor!,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            ),
          if (icon != null) const Spacer(),
          if (icon != null)
            Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: iconColor ?? colorDarkGreen,
              ),
              child: icon,
            ),
          if (title == "") const Spacer(),
        ],
      ),
    );
  }
}
