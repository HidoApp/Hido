import 'package:ajwad_v4/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomPageIndicator extends StatelessWidget {
  const CustomPageIndicator({super.key, required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      textDirection: TextDirection.ltr,
      activeIndex: activeIndex,
      count: 3,
      effect: const CustomizableEffect(
        spacing: 5,
        dotDecoration: DotDecoration(
          color: dotColor,
          width: 5,
          height: 5,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        activeDotDecoration: DotDecoration(
          color: activeDotColor,
          width: 7,
          height: 7,
          borderRadius: BorderRadius.all(Radius.circular(7)),
          dotBorder: DotBorder(
            color: activeDotColor,
            padding: 2,
          ),
        ),
      ),
    );
  }
}
