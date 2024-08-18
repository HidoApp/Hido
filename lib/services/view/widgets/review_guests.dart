import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ReviewGuestsTile extends StatelessWidget {
  const ReviewGuestsTile({super.key, required this.guest, required this.title});
  final int guest;
  final String title;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        CustomText(
          text: title,
          color: almostGrey,
          fontSize: width * 0.038,
          fontWeight: FontWeight.w400,
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
        ),
        const Spacer(),
        CustomText(
          text: guest.toString(),
          color: almostGrey,
          fontSize: width * 0.038,
          fontWeight: FontWeight.w400,
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
        ),
      ],
    );
  }
}
