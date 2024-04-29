import 'package:ajwad_v4/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomUncheckedOption extends StatelessWidget {
  const CustomUncheckedOption({
    super.key,
    this.isTourist = false,
  });

  final bool isTourist;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isTourist ? Colors.white : darkBlack,
        shape: BoxShape.circle,
        border: Border.all(
          color: colorGreen,
          width: 2,
        ),
      ),
    );
  }
}
