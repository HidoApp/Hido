import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  const AccountTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onTap});
  final String title;
  final String subtitle;
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
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: title == "Phone number" ? 2 : 4,
            ),
            if (title == "Phone number")
              const CustomText(
                text: "For notification , remainder , and help login",
                fontSize: 14,
                color: almostGrey,
                fontWeight: FontWeight.w300,
              ),
            if (title == "Phone number")
              const SizedBox(
                height: 12,
              ),
            CustomText(
              text: subtitle,
              fontSize: 14,
              color: almostGrey,
              fontWeight: FontWeight.w300,
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
