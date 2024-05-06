import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CityChips extends StatelessWidget {
  const CityChips({super.key, required this.city});
  final String city;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: colorDarkGreen),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: CustomText(
        text: city,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: colorDarkGreen,
        textAlign: TextAlign.center,
      ),
    );
  }
}
