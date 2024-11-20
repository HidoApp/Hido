import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_util.dart';

class CustomBookmarkCard extends StatefulWidget {
  const CustomBookmarkCard({Key? key}) : super(key: key);

  @override
  State<CustomBookmarkCard> createState() => _CustomBookmarkCardState();
}

class _CustomBookmarkCardState extends State<CustomBookmarkCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      // shape: const RoundedRectangleBorder(
      //     bord

      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                offset: const Offset(1, 1),
                blurRadius: 10,
                color: colorDarkGrey.withOpacity(0.3))
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8).copyWith(
          right: AppUtil.rtlDirection(context) ? 10 : 30,
          left: AppUtil.rtlDirection(context) ? 30 : 10,
        ),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.asset('assets/images/place.png')),
            SizedBox(
              width: width * 0.05,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'حافة العالم',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Arabic',
                  color: black,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/map_pin.svg'),
                    const SizedBox(
                      width: 4,
                    ),
                    CustomText(
                      text: AppUtil.rtlDirection2(context)
                          ? 'الرياض، المملكة العربية السعودية'
                          : 'Riyadh, Saudi Arabia',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: textGreyColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
