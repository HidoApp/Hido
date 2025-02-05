import 'package:flutter/cupertino.dart';

class IconBackground extends StatelessWidget {
  const IconBackground(
      {super.key, required this.backgroundColor, required this.child});
  final Color backgroundColor;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
