import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomTextWithIconButton extends StatelessWidget {
  const CustomTextWithIconButton(
      {Key? key,
      required this.height,
      required this.width,
      required this.borderColor,
      required this.prefixIcon,
      required this.suffixIcon,
      required this.textColor,
      this.title,
      this.onTap})
      : super(key: key);

  final double height, width;
  final Color borderColor, textColor;
  final prefixIcon, suffixIcon;
  final title;
  final onTap;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(
            size.width * 0.025,
          ),
          decoration: BoxDecoration(
              border: Border.all(width: 2,color: borderColor),

              borderRadius: BorderRadius.circular(
                size.width * 0.025,
              )),

          child: Row(
            children: [
              prefixIcon,
              //     SvgPicture.asset("assets/icons/purple_calendar.svg",),
              SizedBox(
                width: size.width * 0.025,
              ),
              CustomText(
                text: title,
                color: textColor,
                fontSize: size.width * 0.04,
              ),
              const Spacer(),
              suffixIcon
            ],
          ),
        ));
  }
}
