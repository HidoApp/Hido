import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';

class FilterTextChip extends StatelessWidget {
  const FilterTextChip(
      {super.key, required this.text, this.textColor, this.backgroundColor});
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.0205,
          vertical: MediaQuery.sizeOf(context).width * 0.0102),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomText(
        text: text,
        color: textColor ?? black,
        fontFamily: AppUtil.SfFontType(context),
        fontSize: MediaQuery.sizeOf(context).width * 0.028,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
