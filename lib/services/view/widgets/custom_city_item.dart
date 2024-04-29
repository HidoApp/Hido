import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomCityItem extends StatelessWidget {
  const CustomCityItem({
    super.key,
    required this.image,
    required this.title,
  });

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 33,
          backgroundImage: AssetImage(image),
        ),
        const SizedBox(
          height: 9,
        ),
        CustomText(
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
