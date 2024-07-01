import 'package:ajwad_v4/constants/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 110,
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
            Container(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      'assets/icons/$iconPath.svg',
                      color: iconColor,
                    ), // Use SvgPicture for SVG icons
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
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 17,
                                  fontFamily: 'HT Rakik',
                                  fontWeight: FontWeight.w500,
                                  height: 0.10, // Adjust line height as needed
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 294,
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                color: textColor == black
                                    ? starGreyColor
                                    : textColor,
                                fontSize: 12,
                                fontFamily: 'SF Pro',
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
    ;
  }
}
