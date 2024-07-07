import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DrivingLicense extends StatefulWidget {
  const DrivingLicense({super.key});

  @override
  State<DrivingLicense> createState() => _DrivingLicenseState();
}

class _DrivingLicenseState extends State<DrivingLicense> {
  final _authController = Get.put(AuthController());

  String? drivingDate;
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        'drivinglicense'.tr,
        isBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(
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
                fontFamily: 'SF Pro'),
            Obx(
              () => GestureDetector(
                onTap: () async {
                  await showCupertinoModalPopup<void>(
                    context: context,
                    builder: (_) {
                      final size = MediaQuery.of(context).size;
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        height: size.height * 0.27,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (value) {
                            date = value;
                            setState(() {
                              String theMonth =
                                  date!.month.toString().length == 1
                                      ? '0${date!.month}'
                                      : date!.month.toString();
                              String theDay = date!.day.toString().length == 1
                                  ? '0${date!.day}'
                                  : date!.day.toString();
                              drivingDate = '${date!.year}-$theMonth-$theDay';
                            });
                            if (drivingDate != null) {
                              _authController.drivingDate(drivingDate);
                              log(_authController.drivingDate.value);
                            }
                          },
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      const Icon(
                        Icons.date_range,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      CustomText(
                        text: _authController.drivingDate.isNotEmpty
                            ? _authController.drivingDate.value
                            : 'mm/dd/yyy'.tr,
                        color: Colors.grey,
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
                      fontFamily: 'SF Pro',
                    ),
            ),

            // CustomButton(
            //     onPressed: () {
            //       log(AppUtil.validateBirthday(birthDate ?? '').toString());
            //     },
            //     title: 'press')
          ],
        ),
      ),
    );
  }
}
