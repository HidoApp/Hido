import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../utils/app_util.dart';

class ExperienceCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final String subtitle;
  final VoidCallback? onTap;

  const ExperienceCard({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: width * 0.28,
        padding: const EdgeInsets.all(12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: shadowColor,
              blurRadius: 15,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                        'assets/icons/$iconPath.svg'), // Use SvgPicture for SVG icons
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 22,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomText(
                                text: title,
                                color: black,
                                fontSize: 17,
                                fontFamily: 'HT Rakik',
                                fontWeight: FontWeight.w500,
                                height: 0.10, // Adjust line height as needed
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 294,
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                color: starGreyColor,
                                fontSize: 12,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
