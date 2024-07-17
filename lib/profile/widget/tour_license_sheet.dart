import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
 import 'package:file_picker/file_picker.dart';

class TourLicenseSheet extends StatefulWidget {
  const TourLicenseSheet({super.key});

  @override
  State<TourLicenseSheet> createState() => _TourLicenseSheetState();
}

class _TourLicenseSheetState extends State<TourLicenseSheet> {
  Future<File?> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: width * 0.628,
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
        children: [
          const BottomSheetIndicator(),
          SizedBox(
            height: width * 0.051,
          ),
          CustomText(
            text: 'tourLicense'.tr,
            fontFamily: "SF Pro",
            fontSize: width * 0.0435,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
            height: width * 0.020,
          ),
          GestureDetector(
            onTap: () async {
              final pdfFile = await pickPdfFile();
            },
            child: CustomTextField(
              enable: false,
              suffixIcon: SvgPicture.asset(
                'assets/icons/upload.svg',
                fit: BoxFit.none,
              ),
              hintText: "MyguideLicense.PDF",
              onChanged: (val) {},
            ),
          ),
          SizedBox(
            height: width * 0.0820,
          ),
          CustomButton(
            title: 'save'.tr,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
