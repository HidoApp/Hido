import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';

class TextChip extends StatelessWidget {
  const TextChip({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.0205,
          vertical: MediaQuery.sizeOf(context).width * 0.0102),
      decoration: BoxDecoration(
        color: const Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width *
              0.4, // Adjust this value as needed
        ),
        child: CustomText(
          text: text,
          softWrap: true,
          textOverflow: TextOverflow.ellipsis,
          fontFamily: AppUtil.SfFontType(context),
          fontSize: MediaQuery.sizeOf(context).width * 0.028,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
