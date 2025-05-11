import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomPublishDialog extends StatelessWidget {
  final String? icon;
  final Color? iconColor;
  final Color? bgIconColor;
  final String title;
  final String? description;

  const CustomPublishDialog({
    Key? key,
    this.icon,
    this.iconColor,
    this.bgIconColor,
    this.title = '',
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      content: SizedBox(
        width: double.infinity,
        // height: height * 0.18,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            icon != null
                ? Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: (bgIconColor != null) ? bgIconColor : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: RepaintBoundary(
                      child: SvgPicture.asset(
                        'assets/icons/$icon',
                        color: (iconColor != null) ? iconColor : null,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            if (title.isNotEmpty)
              CustomText(
                textAlign: TextAlign.center,
                color: black,
                fontSize: width * 0.038,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w500,
                text: title,
              ),
            const SizedBox(height: 2),
            CustomText(
              textAlign: TextAlign.center,
              fontSize: width * 0.038,
              fontWeight: FontWeight.w400,
              maxlines: 100,
              color: black,
              text: description,
              fontFamily: AppUtil.SfFontType(context),
            ),
          ],
        ),
      ),
    );
  }
}
