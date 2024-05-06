import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeIconButton extends StatelessWidget {
  const HomeIconButton({super.key, required this.onTap, required this.icon});
  final void Function() onTap;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: SvgPicture.asset(icon),
      ),
    );
  }
}
