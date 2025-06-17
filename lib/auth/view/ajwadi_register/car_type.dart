import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/tour_stepper.dart';
import 'package:ajwad_v4/auth/widget/provided_services_card.dart';
import 'package:ajwad_v4/auth/widget/terms_text.dart';
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

class CarType extends StatefulWidget {
  const CarType({super.key});

  @override
  State<CarType> createState() => _CarTypeState();
}

class _CarTypeState extends State<CarType> {
  final storage = GetStorage();
  // var tourSelected = false;
  // var experiencesSelected = false;
  final _profileController = Get.put(ProfileController());
  // final _authController = Get.put(AuthController());

  // @override
  // void dispose() {
  //   _profileController.isDriveCar(false);
  //   _profileController.isNotDriveCar(false);
  //   _authController.agreeForTerms(false);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: CustomAppBar('Transportation'.tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.040),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'TransportationMethod'.tr,
              fontFamily: AppUtil.SfFontType(context),
              fontSize: width * 0.0435,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: width * 0.0205,
            ),
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: const BorderSide(color: colorGreen, width: 1),
                    visualDensity: const VisualDensity(
                        horizontal: -4), // removes extra space

                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    value: _profileController.isDriveCar.value,
                    onChanged: (value) {
                      _profileController.isDriveCar(value);
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                CustomText(
                  text: 'CarDriveing'.tr,
                  fontFamily: AppUtil.SfFontType(context),
                  fontSize: width * 0.044,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: const BorderSide(color: colorGreen, width: 1),
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    visualDensity: const VisualDensity(
                        horizontal: -4), // removes extra space

                    value: _profileController.isNotDriveCar.value,
                    onChanged: (value) {
                      _profileController.isNotDriveCar(value);
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                CustomText(
                  text: 'CarNotDriveing'.tr,
                  fontFamily: AppUtil.SfFontType(context),
                  fontSize: width * 0.044,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: width * 0.11),
              child: TermsAndConditionsText(title: "pledge_responsibility".tr),
            ),
          ],
        ),
      ),
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
      //             onPressed: (_profileController.isNotDriveCar.value ||
      //                         _profileController.isDriveCar.value) &&
      //                     _authController.agreeForTerms.value
      //                 ? () async {
      //                     // await _profileController.getProfile(context: context);
      //                     Get.to(() => const TourStepper());
      //                     // Get.back();
      //                   }
      //                 : null,
      //             raduis: 8,
      //             height: width * 0.123,
      //             buttonColor: (!(_profileController.isNotDriveCar.value ||
      //                         _profileController.isDriveCar.value) ||
      //                     !_authController.agreeForTerms.value)
      //                 ? textlightGreen
      //                 : colorGreen,
      //             borderColor: (!(_profileController.isNotDriveCar.value ||
      //                         _profileController.isDriveCar.value) ||
      //                     !_authController.agreeForTerms.value)
      //                 ? textlightGreen
      //                 : colorGreen,

      //             // icon: const Icon(
      //             //   Icons.keyboard_arrow_right,
      //             // ),
      //           ),
      //   ),
      //   //   ],
      //   // ),
      // ),
    );
  }
}
