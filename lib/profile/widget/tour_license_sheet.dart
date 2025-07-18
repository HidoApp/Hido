import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
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
  final _profileController = Get.put(ProfileController());

  File? pdfFile;
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
  void dispose() {
    // TODO: implement dispose
    _profileController.pdfName('');
    super.dispose();
  }

  @override
  void initState() {
    _profileController.pdfName.value = _profileController
            .profile.tourGuideLicense
            ?.split('/')
            .last
            .split('.')
            .first ??
        '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      //   height: width * 0.628,
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
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: width * 0.051,
            ),
            CustomText(
              text: 'tourLicense'.tr,
              fontFamily: AppUtil.SfFontType(context),
              fontSize: width * 0.0435,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: width * 0.0205,
            ),
            GestureDetector(
              onTap: () async {
                pdfFile = await pickPdfFile();
                if (pdfFile == null) {
                  return;
                }
                _profileController.pdfName.value =
                    pdfFile!.path.split('/').last;
                if (AppUtil.isImageValidate(await pdfFile!.length())) {
                  _profileController.isPdfValidSize(true);
                } else {
                  _profileController.isPdfValidSize(false);
                }
              },
              child: CustomTextField(
                enable: false,
                borderColor: _profileController.isPdfValidSize.value
                    ? borderGrey
                    : colorRed,
                suffixIcon: SvgPicture.asset(
                  'assets/icons/upload.svg',
                  fit: BoxFit.none,
                ),
                hintText: _profileController.pdfName.value.isEmpty
                    ? "UploadFile".tr
                    : _profileController.pdfName.value,
                onChanged: (val) {},
              ),
            ),

            if (!_profileController.isPdfValidSize.value)
              CustomText(
                text: 'fileValidSize'.tr,
                color: colorRed,
                fontSize: width * 0.028,
                fontFamily: AppUtil.SfFontType(context),
              ),
            //  if (!_profileController.isPdfValidNotEmpty.value)
            // CustomText(
            //   text: 'imageValidSize'.tr,
            //   color: colorRed,
            //   fontSize: width * 0.028,
            //   fontFamily: AppUtil.SfFontType(context),
            // ),
            SizedBox(
              height: width * 0.0820,
            ),
            Obx(
              () => _profileController.isImagesLoading.value ||
                      _profileController.isProfileLoading.value ||
                      _profileController.isEditProfileLoading.value
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : CustomButton(
                      title: 'update'.tr,
                      buttonColor: !(_profileController.isPdfValidSize.value &&
                              pdfFile != null)
                          ? colorlightGreen
                          : colorGreen,
                      borderColor: !(_profileController.isPdfValidSize.value &&
                              pdfFile != null)
                          ? textlightGreen
                          : colorGreen,
                      onPressed: _profileController.isPdfValidSize.value ||
                              pdfFile != null
                          ? () async {
                              final file =
                                  await _profileController.uploadProfileImages(
                                      file: pdfFile!,
                                      uploadOrUpdate: "upload",
                                      context: context);
                              if (file == null) {
                                return;
                              }
                              _profileController.editProfile(
                                  context: context,
                                  tourGuideLicense: file.filePath,
                                  spokenLanguage: _profileController
                                      .profile.spokenLanguage);
                              await _profileController.getProfile(
                                  context: context);

                              Get.back();
                            }
                          : null),
            )
          ],
        ),
      ),
    );
  }
}
