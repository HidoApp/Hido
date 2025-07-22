import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/widget/local_calender.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jhijri/_src/_jHijri.dart';

class DrivingLicense extends StatefulWidget {
  const DrivingLicense({super.key});

  @override
  State<DrivingLicense> createState() => _DrivingLicenseState();
}

class _DrivingLicenseState extends State<DrivingLicense> {
  final _authController = Get.put(AuthController());
  final _profileController = Get.put(ProfileController());

  String? drivingDate;
  DateTime? date;
  late JHijri hijriDate;
  void showCalender() {
    showDialog(
      context: context,
      builder: (context) => LocalCalender(
        pastAvalible: false,
        onPressed: () {
          log(_profileController.drivingDate.value);
          Get.back();
        },
        onSelectionChanged: (value) {
          _profileController.drivingDateDay(value.value.toString());
          _profileController.drivingDateDay.value = AppUtil.formatDateForRowad(
              _profileController.drivingDateDay.value);
          _profileController.drivingDate.value = AppUtil.convertToHijriForRowad(
              _profileController.drivingDateDay.value);
          log(_profileController.drivingDate.value);
          log(_profileController.drivingDateDay.value);
        },
      ),
    );
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _authController.drivingDateDay.value = '';
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: CustomAppBar(
        'drivinglicense'.tr,
        isBack: true,
        isSkiped: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                text: "drivingExpire".tr,
                fontSize: width * 0.0435,
                fontWeight: FontWeight.w500,
                fontFamily: AppUtil.SfFontType(context)),
            SizedBox(
              height: width * 0.0205,
            ),
            Obx(
              () => GestureDetector(
                onTap: () => showCalender(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      color: _authController.validDriving.value
                          ? borderGrey
                          : colorRed,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/Time (2).svg',
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.039,
                      ),
                      CustomText(
                        text: _profileController.drivingDateDay.isNotEmpty
                            ? _profileController.drivingDateDay.value
                            : _profileController
                                    .profile.drivingLicenseExpiryDate!.isEmpty
                                ? 'mm/dd/yyy'.tr
                                : AppUtil.convertHijriToGregorian(
                                    AppUtil.convertIsoDateToFormattedDate(
                                        _profileController.profile
                                                .drivingLicenseExpiryDate ??
                                            '')),
                        color: Graytext,
                        fontSize: MediaQuery.of(context).size.width * 0.038,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => _authController.validDriving.value
                  ? Container()
                  : CustomText(
                      text: 'invalidDate'.tr,
                      color: colorRed,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppUtil.SfFontType(context),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
