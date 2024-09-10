import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/terms&conditions.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndConditionsText extends StatefulWidget {
  const TermsAndConditionsText({super.key});

  @override
  State<TermsAndConditionsText> createState() => _TermsAndConditionsTextState();
}

class _TermsAndConditionsTextState extends State<TermsAndConditionsText> {
  final _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() => Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: const BorderSide(color: colorGreen, width: 2),
            // overlayColor: WidgetStateColor.transparent,
           overlayColor: MaterialStateProperty.all(Colors.transparent), // Updated line
            value: _authController.agreeForTerms.value,
            onChanged: (value) => _authController.agreeForTerms(value))),
        CustomText(
          fontFamily: AppUtil.SfFontType(context),
          fontWeight: FontWeight.w400,
          text: "termsText".tr,
          fontSize: MediaQuery.of(context).size.width * 0.033,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.0128,
        ),
        GestureDetector(
          child: CustomText(
            text: 'termsOfService'.tr,
            color: blue,
            fontFamily: AppUtil.SfFontType(context),
            fontWeight: FontWeight.w400,
            fontSize: MediaQuery.of(context).size.width * 0.033,
          ),
          onTap: () {
            Get.to(() => const TermsAndConditions(
                  fromAjwady: false,
                ));
          },
        ),
        Obx(
          () => _authController.isAgreeForTerms.value
              ? const SizedBox.shrink()
              : CustomText(
                  text: '*',
                  color: colorRed,
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.width * 0.051,
                  fontFamily: AppUtil.SfFontType(context),
                ),
        )
      ],
    );
  }
}
