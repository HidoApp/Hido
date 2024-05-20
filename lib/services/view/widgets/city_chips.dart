import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CityChips extends StatelessWidget {
  const CityChips({super.key, required this.city});
  final String city;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.030, vertical: width * 0.01),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: width * 0.0025, color: colorDarkGreen),
        borderRadius: BorderRadius.all(Radius.circular(width * 0.051)),
      ),
      child: CustomText(
        text: city,
        fontSize: width * 0.038,
        fontWeight: FontWeight.w600,
        color: colorDarkGreen,
        textAlign: TextAlign.center,
      ),
    );
  }
}
