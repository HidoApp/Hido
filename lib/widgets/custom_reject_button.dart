import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomRejectButton extends StatelessWidget {
  const CustomRejectButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(colorRed),
        side: WidgetStateProperty.all(
          const BorderSide(
            color: colorRed,
          ),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
        ),
        fixedSize: WidgetStateProperty.all(const Size.fromHeight(36)),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/reject.svg'),
          const SizedBox(
            width: 12,
          ),
          CustomText(
            text: 'reject'.tr,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: colorRed,
          ),
        ],
      ),
    );
  }
}
