import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProvidedServicesCard extends StatelessWidget {
  const ProvidedServicesCard(
      {super.key,
      this.onTap,
      required this.title,
      required this.subtitle,
      required this.iconPath,
      required this.color,
      required this.borderColor,
      this.height,
      required this.textColor,
      required this.iconColor});
  final void Function()? onTap;
  final String title;
  final String subtitle;
  final String iconPath;
  final Color color;
  final Color iconColor;
  final Color borderColor;
  final Color textColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: double.infinity,
        height: width * 0.282,
        padding: const EdgeInsets.all(12),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(12)),
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
                    width: width * 0.06,
                    height: width * 0.06,
                    child: RepaintBoundary(
                      child: SvgPicture.asset(
                        'assets/icons/$iconPath.svg',
                        color: iconColor,
                      ),
                    ), // Use SvgPicture for SVG icons
                  ),
                  SizedBox(width: width * 0.041),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: width * 0.056,
                          child: Padding(
                            padding: EdgeInsets.only(top: width * 0.025),
                            child: Text(
                              title,
                              style: TextStyle(
                                color: textColor,
                                fontSize: width * 0.043,
                                fontFamily: 'HT Rakik',
                                fontWeight: FontWeight.w500,
                                height: 0.10, // Adjust line height as needed
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: width * 0.010),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color:
                                textColor == black ? starGreyColor : textColor,
                            fontSize: width * 0.030,
                            fontFamily: AppUtil.SfFontType(context),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
