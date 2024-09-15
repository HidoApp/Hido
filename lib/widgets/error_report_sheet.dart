import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorReportSheet extends StatelessWidget {
  const ErrorReportSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
            onChanged: (value) {},
          ),
          SizedBox(
            height: width * 0.061,
          ),
          CustomButton(
            title: 'send'.tr,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
