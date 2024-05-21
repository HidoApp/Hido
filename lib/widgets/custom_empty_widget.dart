import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({
    super.key,
    required this.title,
    required this.image,
     this.subtitle,
  });

  final String title;
  final String? subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
   
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/$image.png'),
        CustomText(
          text: title,
          color: Color(0xFF9392A0),
          fontSize: 18,
          fontFamily: 'HT Rakik',
         fontWeight: FontWeight.w700,
         height: 0.10,
          textAlign: TextAlign.center,
        ),
        if (subtitle != '' || subtitle != null) ...[
      SizedBox(
        height: 10, // Set a meaningful height for spacing
      ),
      CustomText(
        text: subtitle!,
        color: Color(0xFFB9B8C1),
        fontSize: 17,
        fontFamily: 'SF Pro',
        fontWeight: FontWeight.w500,
        height: 1.0, // Use a meaningful height if necessary
        textAlign: TextAlign.center,
      ),
        
      ],
      ],
    );
  }
}
