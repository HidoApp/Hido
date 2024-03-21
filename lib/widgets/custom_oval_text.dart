import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomOvalText extends StatelessWidget {
  CustomOvalText({
    super.key,
    required this.title,
    required this.index,
  });
  final String title;
  final int index;

  List colors = [yellow, colorGreen, colorRed, colorPurple];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: colors[index],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        child: CustomText(
          textAlign: TextAlign.center,
          text: title,
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
