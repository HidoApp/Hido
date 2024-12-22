import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';

class TextChip extends StatelessWidget {
  const TextChip({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomText(
        text: text,
        fontFamily: AppUtil.SfFontType(context),
        fontSize: MediaQuery.sizeOf(context).width * 0.028,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
