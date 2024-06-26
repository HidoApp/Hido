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
        SvgPicture.asset(
          image,
         width: 20,

        ),
        SizedBox(
          width: width * 0.012,
        ),
        CustomText(
          text: title,
          color:Color(0xFF9392A0),
          fontSize: width * 0.037,
          fontWeight: FontWeight.w400,
        ),
       
      ],
    );
  }
}
