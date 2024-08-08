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
    this.widthh=0,
  });
  final String title;
  final String image;
  final double widthh;

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
          child:
         widthh!=0
         ? SvgPicture.asset(image,width: widthh,)
         : SvgPicture.asset(image),

        ),
        SizedBox(
          width: width*0.026,
        ),
        CustomText(
          text: title,
          color: starGreyColor,
          fontSize: width * 0.038,
         fontFamily:  AppUtil.rtlDirection2(context)?'SF Arabic':'SF Pro',
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
