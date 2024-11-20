import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LocalTile extends StatelessWidget {
  const LocalTile(
      {super.key,
      this.tripNumber,
      required this.subtitle,
      this.tripRate,
      this.isRating = false});
  final int? tripNumber;
  final double? tripRate;
  final String subtitle;
  final bool isRating;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Column(
      children: [
        Directionality(
          textDirection: AppUtil.rtlDirection2(context)
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Row(
            children: [
              CustomText(
                fontSize: width * 0.038,
                fontWeight: FontWeight.w500,
                text: (tripNumber?.toString() ?? tripRate?.toString()),
                color: black,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
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
        ),
        CustomText(
          text: subtitle,
          fontWeight: FontWeight.w500,
          fontSize: width * 0.038,
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
          color: black,
        )
      ],
    );
  }
}
