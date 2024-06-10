import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItineraryTile extends StatelessWidget {
  const ItineraryTile({super.key, required this.title, required this.image});
 final String title ;
 final String image ;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          
          image,
          width: 20,
        ),
        SizedBox(
          width: 5,
        ),
        CustomText(
          text: title,
          color: Color(0xFF9392A0),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
