import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget(
      {super.key,
      required this.title,
      this.image,
      this.subtitle = '',
      this.height,
      this.width});

  final String title;
  final String? subtitle;
  final String? image;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset('assets/images/$image.png'),
          if (image != null)
            SvgPicture.asset(
              'assets/icons/$image.svg',
              color: const Color(0xFFB9B8C1),
              width: width,
              height: height,
            ),
          SizedBox(
            height: 22, // Set a meaningful height for spacing
          ),
          CustomText(
            text: title,
            color: const Color(0xFFB9B8C1),
            fontSize: 17,
            fontFamily: 'HT Rakik',
            fontWeight: FontWeight.w500,
            height: 0.10,
            textAlign: TextAlign.center,
          ),
          if (subtitle != '' || subtitle != null) ...[
            SizedBox(
              height: 21, // Set a meaningful height for spacing
            ),
            CustomText(
              text: subtitle!,
              color: const Color(0xFFB9B8C1),
              maxlines: 3,
              fontSize: 16,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 0,
              textAlign: TextAlign.center,
            ),
          ] else ...[
            SizedBox(
              height: 0, // Set a meaningful height for spacing
            ),
          ],
        ],
      ),
    );
  }
}
