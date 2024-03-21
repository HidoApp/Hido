import 'package:flutter/material.dart';

class DottedSeparator extends StatelessWidget {
  const DottedSeparator({Key? key, required this.height, required this.color}) : super(key: key);

  final double height;
  final Color color;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context , constrain) {
      final boxWidth = constrain.constrainWidth();
      const dashWidth = 7.0;
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        children: List.generate(dashCount,(_){
          return SizedBox(
            height: height,
            width: dashWidth,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          );
        }),

      );
    });
  }
}
