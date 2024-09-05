import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.title,
    required this.leading,
    required this.onTap,
    this.iconColor,
  }) : super(key: key);
  final String title, leading;
  final Color? iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        minLeadingWidth: 1,
        title: CustomText(
          textAlign: TextAlign.start,
          text: title,
          color: black,
          fontFamily: AppUtil.SfFontType(context),
          fontSize: width * 0.0410,
          fontWeight: FontWeight.w400,
        ),
        leading: RepaintBoundary(
          child: SvgPicture.asset(
            leading,
            color: iconColor ?? null,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: const Color(0xff070708),
          size: width * 0.046,
        ),
      ),
    );
  }
}
