import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:ajwad_v4/request/widgets/ContactDialog.dart';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

class CustomAlertDialog extends StatelessWidget {
  final double dialogWidth;
  final double dialogHight;
  final String? title;
  final String? buttonTitle1;
  final String? buttonTitle2;
  final Color? buttonColor1;
  final Color? buttonColor2;
  final String? icon;

  const CustomAlertDialog(
      {Key? key,
      this.title,
      required this.dialogWidth,
      required this.dialogHight,
      this.buttonTitle1,
      this.buttonTitle2,
      this.buttonColor1,
      this.buttonColor2,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AmplitudeService.initializeAmplitude();

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      content: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 6),
            icon != null
                ? Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: Color(0xFFF6F6F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: RepaintBoundary(
                      child: SvgPicture.asset(
                        'assets/icons/$icon',
                        color: Graytext,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            CustomText(
              textAlign: TextAlign.center,
              color: const Color(0xFF0B1215),
              fontSize: 15,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w400,
              text: title,
            ),
            const SizedBox(
              height: 16,
            ),
            CustomButton(
                onPressed: () {
                  Get.back();
                },
                title: buttonTitle1,
                buttonColor: buttonColor1,
                borderColor: buttonColor1,
                textColor: Colors.white),
            const SizedBox(height: 6),
            CustomButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ContactDialog(
                          dialogWidth: dialogWidth, buttonWidth: dialogHight);
                    },
                  );
                },
                title: buttonTitle2,
                buttonColor: buttonColor2,
                borderColor: buttonColor2,
                textColor: const Color(0xFF070708)),
          ],
        ),
      ),
    );
  }
}
