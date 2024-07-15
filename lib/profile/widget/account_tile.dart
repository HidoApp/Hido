import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  const AccountTile(
      {super.key,
      required this.title,
      this.subtitle,
      this.titleHint,
      required this.onTap});
  final String title;
  final String? titleHint;
  final String? subtitle;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              fontSize: 17,
              fontFamily: "SF Pro",
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: titleHint != null ? 2 : 4,
            ),
            if (titleHint != null)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 350),
                child: CustomText(
                  text: titleHint,
                  fontSize: 13,
                  fontFamily: "SF Pro",
                  color: almostGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            if (title == "Phone number")
              const SizedBox(
                height: 12,
              ),
            if (subtitle != null)
              CustomText(
                text: subtitle,
                fontSize: 15,
                fontFamily: "SF Pro",
                color: almostGrey,
                fontWeight: FontWeight.w400,
              ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: const CustomText(
            text: "Edit",
            fontSize: 14,
            textDecoration: TextDecoration.underline,
            color: almostGrey,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
