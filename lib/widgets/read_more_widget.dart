import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class ReadMoreWidget extends StatelessWidget {
  const ReadMoreWidget({
    super.key,
    required this.text,
    this.color = black,
    this.fontSize,
    this.moreColor,
    this.fontWeight = FontWeight.w400,
  });
  final String text;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color? moreColor;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: AppUtil.rtlDirection2(context)
          ? Alignment.bottomRight
          : Alignment.bottomLeft,
      child: ReadMoreText(
        text,
        textDirection: AppUtil.rtlDirection2(context)
            ? TextDirection.rtl
            : TextDirection.ltr,
        colorClickableText: moreColor ?? blue,
        moreStyle: TextStyle(
          color: moreColor ?? Color(0xFFA0A0A0),
          fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
        ),
        trimExpandedText: '  ${'showLess'.tr}',
        trimCollapsedText: 'readMore'.tr,
        textAlign: TextAlign.start,
        trimMode: TrimMode.Line,
        trimLines: 3,
        style: TextStyle(
          fontSize: fontSize ?? width * 0.038,
          fontFamily: AppUtil.SfFontType(context),
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}
