import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/widget/account_tile.dart';
import 'package:ajwad_v4/profile/widget/driving_sheet.dart';
import 'package:ajwad_v4/profile/widget/tour_license_sheet.dart';
import 'package:ajwad_v4/profile/widget/vehcile_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LegalDocument extends StatefulWidget {
  const LegalDocument({super.key});

  @override
  State<LegalDocument> createState() => _LegalDocumentState();
}

class _LegalDocumentState extends State<LegalDocument> {
  final _profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar('legalDoc'.tr),
      body: ScreenPadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => _profileController.isProfileLoading.value
                ? Container()
                : AccountTile(
                    title: 'drivinglicense'.tr,
                    subtitle: AppUtil.convertIsoDateToFormattedDate(
                        _profileController.profile.drivingLicenseExpiryDate!),
                    onTap: () {
                      Get.bottomSheet(const DrivingSheet());
                    },
                  ),
          ),
          const Divider(
            color: lightGrey,
          ),
          SizedBox(
            height: width * 0.051,
          ),
          Obx(
            () => _profileController.isProfileLoading.value
                ? Container()
                : AccountTile(
                    title: 'vehicleLicense'.tr,
                    subtitle: _profileController.profile.vehicleIdNumber,
                    onTap: () => Get.bottomSheet(const VehcileSheet()),
                  ),
          ),
          const Divider(
            color: lightGrey,
          ),
          SizedBox(
            height: width * 0.051,
          ),
          AccountTile(
              title: 'tourLicense'.tr,
              onTap: () => Get.bottomSheet(const TourLicenseSheet())),
        ],
      )),
    );
  }
}
