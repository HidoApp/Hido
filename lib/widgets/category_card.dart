import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {super.key, this.onPressed, this.title, this.icon, this.color});

  final VoidCallback? onPressed;
  final String? title;
  final String? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width * 0.44,
        height: width * 0.264,
        padding: EdgeInsets.all(width * 0.0051),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x3FC7C7C7),
              blurRadius: 15,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
          color: Colors.white,
          //  BoxBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          //),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                alignment: Alignment.center,
                child: RepaintBoundary(
                    child: SvgPicture.asset('assets/icons/$icon.svg')),
              ),

              const SizedBox(height: 12),
              // padding: const EdgeInsets.only(left: 4),

              CustomText(
                text: title!,
                color: const Color(0xFF070708),
                fontSize: 13,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
































// Container(
// width: double.infinity,
// decoration: BoxDecoration(
// boxShadow: [
// BoxShadow(
// color: Color(0x3FC7C7C7),
// blurRadius: 15,
// offset: Offset(0, 0),
// spreadRadius: 0,
// )
// ],
// ),
// child: Row(
// mainAxisSize: MainAxisSize.min,
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
  
// Expanded(
//   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),

// child: Container(
//   width: double.infinity,
// decoration: BoxDecoration(
// boxShadow: [
// BoxShadow(
// color: Color(0x3FC7C7C7),
// blurRadius: 15,
// offset: Offset(0, 0),
// spreadRadius: 0,
// )
// ],

