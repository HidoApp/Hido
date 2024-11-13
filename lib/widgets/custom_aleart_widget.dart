import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      content: SizedBox(
        width: double.infinity,
        height: height * 0.18,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: const Color(0xFFFBEAE9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: RepaintBoundary(
                child: SvgPicture.asset(
                  'assets/icons/warning.svg',
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomText(
              textAlign: TextAlign.center,
              color: black,
              fontSize: width * 0.038,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w500,
              text: AppUtil.rtlDirection2(context)
                  ? "توجد حجوزات لهذه التجربة "
                  : "Experience is currently booked",
            ),
            const SizedBox(height: 2),
            CustomText(
              textAlign: TextAlign.center,
              fontSize: width * 0.038,
              fontWeight: FontWeight.w400,
              maxlines: 100,
              color: black,
              text: AppUtil.rtlDirection2(context)
                  ? "سياحنا متحمسين للتجربة وحجزوا مقاعد فيها، لذلك تم إيقاف خاصيةالتعديل على التجربة"
                  : "Our tourists are excited for this experience and they booked it, so the edit option is disabled",
              fontFamily: AppUtil.SfFontType(context),
            ),
          ],
        ),
      ),
    );
  }
}
