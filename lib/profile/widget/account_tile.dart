import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              fontSize: MediaQuery.of(context).size.width * .0435,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: titleHint != null ? 2 : 4,
            ),
            if (titleHint != null)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: CustomText(
                  text: titleHint,
                  fontSize: MediaQuery.of(context).size.width * 0.033,
                  fontFamily: AppUtil.SfFontType(context),
                  color: almostGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            if (title == "Phone number")
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.030,
              ),
            if (subtitle != null)
              CustomText(
                text: subtitle,
                fontSize: MediaQuery.of(context).size.width * 0.038,
                fontFamily: "SF Pro",
                color: almostGrey,
                fontWeight: FontWeight.w400,
              ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: CustomText(
            text: "edit".tr,
            fontSize: MediaQuery.of(context).size.width * 0.033,
            textDecoration: TextDecoration.underline,
            color: almostGrey,
            fontFamily: AppUtil.SfFontType(context),
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
