import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomAcceptButton extends StatelessWidget {
  const CustomAcceptButton({
    super.key,
    required this.onPressed,
    this.title,
    this.icon,
  });

  final VoidCallback onPressed;
  final String? title;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(colorGreen),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
        ),
        fixedSize: MaterialStateProperty.all(const Size.fromHeight(36)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/${icon ?? 'accept'}.svg'),
          const SizedBox(
            width: 12,
          ),
          CustomText(
            text: title ?? 'accept'.tr,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
