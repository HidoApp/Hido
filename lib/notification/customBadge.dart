import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
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
  final double top; // Height of the icon
  final double end; // Height of the icon
  final bool isHasContent;

  const CustomBadge(
      {Key? key,
      required this.onTap,
      required this.iconPath,
      required this.badgeCount,
      this.iconColor,
      this.badgeColor = Colors.red,
      this.width = 36,
      this.height = 26,
      this.end = 7,
      this.isHasContent = false,
      this.top = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Obx(
        () => badges.Badge(
          position: isHasContent
              ? badges.BadgePosition.topEnd(top: 0, end: 0)
              : badges.BadgePosition.topEnd(top: top, end: end),
          showBadge: badgeCount.value > 0,
          ignorePointer: false,
          badgeContent: isHasContent
              ? CustomText(
                  text: badgeCount.value.toString(),
                  color: Colors.white,
                  fontSize: 7,
                )
              : const SizedBox.shrink(),
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
