
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jhijri/_src/_jHijri.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';

class DrivingLicense extends StatefulWidget {
  const DrivingLicense({super.key});

  @override
  State<DrivingLicense> createState() => _DrivingLicenseState();
}

class _DrivingLicenseState extends State<DrivingLicense> {
  final _authController = Get.put(AuthController());

  String? drivingDate;
  DateTime? date;
  late JHijri hijriDate;
  Future<JPickerValue?> openDialog(BuildContext context) async {
    return await showGlobalDatePicker(
        context: context,
        startDate: JDateModel(dateTime: DateTime.parse("1960-12-24")),
        selectedDate: JDateModel(dateTime: DateTime.now()),
        endDate: JDateModel(dateTime: DateTime.parse("2100-09-20")),
        pickerMode: DatePickerMode.year,
        // selectedDate: JDateModel(jhijri: JHijri.now()),
        pickerType: PickerType.JHijri,
        okButtonText: 'ok'.tr,
        cancelButtonText: "cancel".tr,
        onChange: (datetime) {
          _authController.drivingDate.value =
              AppUtil.formattedHijriDate(datetime.jhijri);
          _authController.drivingDateDay.value =
              AppUtil.formattedHijriDateDay(datetime.jhijri);
        },
        primaryColor: Colors.green);
  }

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
                  openDialog(context);
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
                        text: _authController.drivingDateDay.isNotEmpty
                            ? _authController.drivingDateDay.value
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
          ],
        ),
      ),
    );
  }
}
