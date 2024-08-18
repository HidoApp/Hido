import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeIconButton extends StatelessWidget {
  const HomeIconButton({super.key, this.onTap, required this.icon});
  final void Function()? onTap;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: RepaintBoundary(child: SvgPicture.asset(icon)),
      ),
    );
  }
}
