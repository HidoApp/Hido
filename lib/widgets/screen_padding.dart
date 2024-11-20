import 'package:flutter/material.dart';

class ScreenPadding extends StatelessWidget {
  const ScreenPadding({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Padding(
        // horzintal 16 , vertical 12
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.041,
          vertical: width * 0.030,
        ),
        child: child);
  }
}
