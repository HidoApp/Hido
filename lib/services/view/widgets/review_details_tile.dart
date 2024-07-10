import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReviewDetailsTile extends StatelessWidget {
  const ReviewDetailsTile({
    super.key,
    required this.title,
    required this.image,
  });
  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // margin: EdgeInsets.only(
          //     left: image == 'assets/icons/meal.svg' ? 3 : 0,
          //     right: image == 'assets/icons/meal.svg' ? 2 : 0),
          child: SvgPicture.asset(
            image,
          ),
        ),
        SizedBox(
          width: width * 0.012,
        ),
        CustomText(
          text: title,
          color: const Color(0xFF9392A0),
          fontSize: width * 0.038,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
