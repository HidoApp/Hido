import 'package:ajwad_v4/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBadge extends StatelessWidget {
  final VoidCallback onTap; // Action when the badge is tapped
  final String iconPath; // Path to the icon asset
  final RxInt badgeCount; // Observable badge count
  final Color badgeColor; // Color of the badge
  final Color? iconColor; // Color of the badge
  final double width; // Width of the icon
  final double height; // Height of the icon

  const CustomBadge({
    Key? key,
    required this.onTap,
    required this.iconPath,
    required this.badgeCount,
    this.iconColor,
    this.badgeColor = Colors.red,
    this.width = 36,
    this.height = 26,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Obx(
        () => badges.Badge(
          position: badges.BadgePosition.topEnd(top: 2, end: 7),
          showBadge: badgeCount.value > 0,
          ignorePointer: false,
          badgeStyle: badges.BadgeStyle(
            shape: badges.BadgeShape.circle,
            badgeColor: badgeColor,
            padding: const EdgeInsets.all(4),
            borderRadius: BorderRadius.circular(8),
            elevation: 0,
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: SvgPicture.asset(
              iconPath,
              color: iconColor ?? black,
            ),
          ),
        ),
      ),
    );
  }
}
