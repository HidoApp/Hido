import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorReportSheet extends StatefulWidget {
  const ErrorReportSheet({super.key});

  @override
  State<ErrorReportSheet> createState() => _ErrorReportSheetState();
}

class _ErrorReportSheetState extends State<ErrorReportSheet> {
  final _profileController = Get.put(ProfileController());
  var _description = '';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      // height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      padding: EdgeInsets.only(
          left: width * 0.0615,
          right: width * 0.0615,
          top: width * 0.041,
          bottom: width * 0.082),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetIndicator(),
          SizedBox(
            height: width * 0.051,
          ),
          CustomText(
            text: 'errorSheetTitle'.tr,
            fontFamily: AppUtil.SfFontType(context),
            fontSize: width * 0.033,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
            height: width * 0.0302,
          ),
          CustomTextField(
            height: width * 0.205,
            maxLines: 10,
            hintText: 'errorSheetHint'.tr,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            onChanged: (value) => _description = value,
          ),
          SizedBox(
            height: width * 0.061,
          ),
          Obx(
            () => _profileController.isUserSendFeedBack.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : CustomButton(
                    title: 'send'.tr,
                    onPressed: () async {
                      if (_description.isEmpty) {
                        //  Get.offAll(() => const OnboardingScreen());
                        Get.back();
                        return;
                      }
                      await _profileController
                          .sendUserFeedBack(description: _description)
                          .then((val) {
                        Get.offAll(() => const OnboardingScreen());
                      });
                    },
                  ),
          )
        ],
      ),
    );
  }
}
