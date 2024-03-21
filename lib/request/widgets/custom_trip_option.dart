import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/widgets/custom_checked_option.dart';
import 'package:ajwad_v4/request/widgets/custom_unchecked_option.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTripOption extends StatelessWidget {
  const CustomTripOption({
    super.key,
    this.isChecked = false,
    this.perPerson = false,
    this.isWhiteOption = false,
    required this.price,
    required this.time,
    required this.option,
    this.isTourist = false,
  });

  final bool isChecked;
  final bool perPerson;
  final bool isWhiteOption;
  final String price;
  final String time;
  final String option;
  final bool isTourist;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isChecked
            ? const CustomCheckedOption()
            : CustomUncheckedOption(
                isTourist: isTourist,
              ),
        const SizedBox(
          width: 28,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: price,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isTourist ? black : Colors.white,
            ),
            if (perPerson)
              CustomText(
                text: 'perPerson'.tr,
                fontSize: 8,
                fontWeight: FontWeight.w400,
                color: colorDarkGrey,
              ),
          ],
        ),
        const SizedBox(
          width: 22,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: option,
              fontSize: 14,
              fontWeight: isWhiteOption ? FontWeight.w600 : FontWeight.w400,
              color: isWhiteOption && isTourist
                  ? Colors.black
                  : isWhiteOption && !isTourist
                      ? Colors.white
                      : colorDarkGrey,
            ),
            CustomText(
              text: time,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff676767),
            ),
          ],
        ),
      ],
    );
  }
}
