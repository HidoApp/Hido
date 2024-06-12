import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItineraryTile extends StatelessWidget {
  const ItineraryTile({super.key, required this.title, required this.image});

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          image,
          width: width * 0.05,
        ),
        SizedBox(
          width: width * 0.0125,
        ),
        CustomText(
          text: title,
          color: const Color(0xFF9392A0),
          fontSize: width * 0.033,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
