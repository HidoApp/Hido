import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeIconButton extends StatelessWidget {
  const HomeIconButton({
    Key? key,
    this.onTap,
    required this.icon,
    this.badgeCount, // Optional badge count
    this.badgeColor = Colors.red, // Default badge color
  }) : super(key: key);

  final void Function()? onTap;
  final String icon;
  final RxInt? badgeCount; // Add this for badge support
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The base icon container
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.1)
                ],
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: RepaintBoundary(
              child: SvgPicture.asset(icon),
            ),
          ),
          // Badge layer (if badgeCount is provided and greater than 0)
          if (badgeCount != null)
            Obx(
              () => badgeCount!.value > 0
                  ? Positioned(
                      top: 7,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
