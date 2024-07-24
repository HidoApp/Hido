import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProgressSheet extends StatefulWidget {
  const ProgressSheet({super.key});

  @override
  State<ProgressSheet> createState() => _ProgressSheetState();
}

class _ProgressSheetState extends State<ProgressSheet> {
  String getTitle() {
    switch (activeStep) {
      case -1:
        return 'localOnway'.tr;
      case 0:
        return 'localArrived'.tr;
      case 1:
        return 'pickUpTitle'.tr;
      case 2:
        return 'tourStarted'.tr;
      case 3:
        return 'tourCompleted'.tr;
      default:
        return '';
    }
  }

  String getSubTitle() {
    switch (activeStep) {
      case -1:
        return 'localOnwaySubtitle'.tr;
      case 0:
        return 'localArrivedSubtitle'.tr;
      case 1:
        return 'pickUpSubtitle'.tr;
      case 2:
        return 'tourStartedSubtitle'.tr;
      case 3:
        return 'tourCompletedSubtitle'.tr;
      default:
        return '';
    }
  }

  int activeStep = -1;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (activeStep != 3) {
                  setState(() {
                    activeStep++;
                  });
                }
              },
              child: CustomText(
                text: getTitle(),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            CustomText(
              text: getSubTitle(),
              fontSize: 15,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? "SF Arabic" : 'SF Pro',
              color: starGreyColor,
              fontWeight: FontWeight.w500,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: EasyStepper(
                activeStep: activeStep,
                activeStepBackgroundColor: Colors.white,
                finishedStepBackgroundColor: Colors.white,
                activeStepTextColor: Colors.black87,
                finishedStepTextColor: Colors.black87,
                unreachedStepTextColor: lightGrey,
                internalPadding: 0,
                showLoadingAnimation: false,
                stepRadius: 13,
                showStepBorder: false,
                lineStyle: const LineStyle(
                    lineType: LineType.normal,
                    lineThickness: 2,
                    unreachedLineColor: lightGrey,
                    activeLineColor: colorGreen,
                    lineWidth: 10,
                    lineSpace: 29,
                    lineLength: 120),
                steps: [
                  EasyStep(
                      customStep: SvgPicture.asset(
                        'assets/icons/slider_touriest.svg',
                        color: activeStep >= 0 ? colorGreen : lightGrey,
                      ),
                      title: 'Arrived'.tr),
                  // EasyStep(
                  //   customStep: SvgPicture.asset(
                  //     'assets/icons/slider_touriest.svg',
                  //     color: activeStep >= 1 ? colorGreen : lightGrey,
                  //   ),
                  //   title: 'PickUp'.tr,
                  // ),
                  EasyStep(
                    customStep: SvgPicture.asset(
                      'assets/icons/slider_touriest.svg',
                      color: activeStep >= 1 ? colorGreen : lightGrey,
                    ),
                    title: 'tourTime'.tr,
                  ),
                  EasyStep(
                    customStep: SvgPicture.asset(
                      'assets/icons/slider_touriest.svg',
                      color: activeStep >= 2 ? colorGreen : lightGrey,
                    ),
                    title: 'completeTour'.tr,
                  ),
                ],
                onStepReached: (index) => setState(() => activeStep = index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
