import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class ReadMoreWidget extends StatelessWidget {
  const ReadMoreWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.topRight,
      child: ReadMoreText(
        text,
        colorClickableText: starGreyColor,
        trimExpandedText: 'showLess'.tr,
        trimCollapsedText: 'readMore'.tr,
        textAlign: TextAlign.start,
        trimMode: TrimMode.Line,
        trimLines: 4,
        style: TextStyle(
          fontSize: width * 0.038,
          fontFamily: AppUtil.SfFontType(context),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
