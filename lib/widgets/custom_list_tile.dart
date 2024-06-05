import 'package:ajwad_v4/constants/colors.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        minLeadingWidth: 1,
        title: CustomText(
          textAlign: TextAlign.start,
          text: title,
          color: black,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        leading: SvgPicture.asset(
          leading,
          width: 20,
          height: 20,
          color: iconColor ?? null,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFF454545),
          size: 18,
        ),
      ),
    );
  }
}
