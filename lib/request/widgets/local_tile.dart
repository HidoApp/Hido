import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LocalTile extends StatelessWidget {
  const LocalTile(
      {super.key,
      required this.tripNumber,
      required this.subtitle,
      this.isRating = false});
  final int tripNumber;
  final String subtitle;
  final bool isRating;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomText(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              text: tripNumber.toString(),
            ),
            if (isRating)
              const SizedBox(
                width: 4,
              ),
            if (isRating)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SvgPicture.asset("assets/icons/star.svg"),
              )
          ],
        ),
        CustomText(
          text: subtitle,
          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: almostGrey,
        )
      ],
    );
  }
}
