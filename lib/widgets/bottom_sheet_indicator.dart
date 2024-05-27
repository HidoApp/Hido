import 'package:ajwad_v4/constants/colors.dart';
import 'package:flutter/material.dart';

class BottomSheetIndicator extends StatelessWidget {
  const BottomSheetIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Align(
        child: Container(
      width: width * 0.16,
      height: width * 0.010,
      decoration: BoxDecoration(
          color: lightGreyColor,
          borderRadius: BorderRadius.circular(width * 0.051)),
    ));
  }
}
