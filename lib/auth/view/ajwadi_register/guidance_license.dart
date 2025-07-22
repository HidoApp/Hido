import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/car_type.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/tour_stepper.dart';
import 'package:ajwad_v4/auth/widget/provided_services_card.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';

import 'package:ajwad_v4/profile/controllers/profile_controller.dart';

import 'package:file_picker/file_picker.dart';

class GuidanceLicense extends StatefulWidget {
  const GuidanceLicense({super.key});

  @override
  State<GuidanceLicense> createState() => _GuidanceLicenseState();
}

class _GuidanceLicenseState extends State<GuidanceLicense> {
  final storage = GetStorage();
  // var tourSelected = false;
  // var experiencesSelected = false;
  final _authController = Get.put(AuthController());
  final _profileController = Get.put(ProfileController());

  // File? pdfFile;
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

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   // _profileController.pdfName('');
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: CustomAppBar('GuidanceLicense'.tr),
      body: ScreenPadding(
          child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                _profileController.pdfFile.value = await pickPdfFile();
                //  pdfFile pdfFile = await pickPdfFile();
                if (_profileController.pdfFile.value == null) {
                  return;
                }
                _profileController.pdfName.value =
                    _profileController.pdfFile.value!.path.split('/').last;
                if (AppUtil.isImageValidate(
                    await _profileController.pdfFile.value!.length())) {
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
                    ? _profileController.profile.tourGuideLicense != ''
                        ? _profileController.profile.tourGuideLicense
                            ?.split('/')
                            .last
                        : "UploadFile".tr
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
          ],
        ),
      )),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.symmetric(
      //       vertical: width * 0.09, horizontal: width * 0.041),
      //   child: Obx(
      //     () => _profileController.isImagesLoading.value ||
      //             _profileController.isProfileLoading.value ||
      //             _profileController.isEditProfileLoading.value
      //         ? const Center(
      //             child: CircularProgressIndicator.adaptive(),
      //           )
      //         : CustomButton(
      //             title: 'next'.tr,
      //             onPressed: _profileController.isPdfValidSize.value &&
      //                     pdfFile != null
      //                 ? () async {
      //                     final file =
      //                         await _profileController.uploadProfileImages(
      //                             file: pdfFile!,
      //                             uploadOrUpdate: "upload",
      //                             context: context);
      //                     if (file == null) {
      //                       return;
      //                     }
      //                     _profileController.editProfile(
      //                         context: context,
      //                         tourGuideLicense: file.filePath,
      //                         spokenLanguage:
      //                             _profileController.profile.spokenLanguage);
      //                     // await _profileController.getProfile(context: context);
      //                     Get.to(() => const CarType());

      //                     // Get.back();
      //                   }
      //                 : null,
      //             raduis: 8,
      //             height: width * 0.123,
      //             buttonColor: !(_profileController.isPdfValidSize.value &&
      //                     pdfFile != null)
      //                 ? textlightGreen
      //                 : colorGreen,
      //             borderColor: !(_profileController.isPdfValidSize.value &&
      //                     pdfFile != null)
      //                 ? textlightGreen
      //                 : colorGreen,

      //             // icon: const Icon(
      //             //   Icons.keyboard_arrow_right,
      //             // ),
      //           ),
      //   ),
      // ),
    );
  }
}
