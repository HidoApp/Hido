import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/profile/widget/phone_sheet.dart';
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
  final _touristExploreController = Get.put(TouristExploreController());
  String getTitle() {
    switch (_touristExploreController.activeStepProgres.value) {
      case -1:
        return 'pendingProgress'.tr;

      case 0:
        return 'localOnway'.tr;

      case 1:
        return 'localArrived'.tr;

      case 2:
        return 'tourStarted'.tr;
      default:
        return '';
    }
  }

  String getSubTitle() {
    switch (_touristExploreController.activeStepProgres.value) {
      case -1:
        if (_touristExploreController.activityProgres.value!.activityProgress ==
            'PENDING') {
          return '';
        } else {
          return 'localOnwaySubtitle'.tr;
        }
      case 0:
        return 'localOnwaySubtitle'.tr;

      case 1:
        return 'localArrivedSubtitle'.tr;
      case 2:
        return 'tourStartedSubtitle'.tr;

        return 'tourCompletedSubtitle'.tr;
      default:
        return '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, bottom: 0),
        child: Obx(
          () => _touristExploreController.isActivityProgressLoading.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: getTitle(),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    CustomText(
                      text: getSubTitle(),
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? "SF Arabic"
                          : 'SF Pro',
                      color: starGreyColor,
                      fontWeight: FontWeight.w500,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: EasyStepper(
                        enableStepTapping: false,
                        activeStep:
                            _touristExploreController.activeStepProgres.value,
                        activeStepBackgroundColor: Colors.white,
                        finishedStepBackgroundColor: Colors.white,
                        activeStepTextColor: Colors.black87,
                        finishedStepTextColor: Colors.black87,
                        unreachedStepTextColor: lightGrey,
                        internalPadding: 0,
                        showLoadingAnimation: false,
                        stepRadius: 20,
                        padding: EdgeInsets.zero,
                        showStepBorder: false,
                        lineStyle: const LineStyle(
                            lineType: LineType.normal,
                            lineThickness: 2,
                            unreachedLineColor: lightGrey,
                            activeLineColor: colorGreen,
                            lineWidth: 10,
                            lineSpace: 29,
                            lineLength: 100),
                        steps: [
                          EasyStep(
                              customStep: SvgPicture.asset(
                                'assets/icons/slider.svg',
                                color: _touristExploreController
                                            .activeStepProgres.value >=
                                        0
                                    ? colorGreen
                                    : lightGrey,
                                height: 24,
                                width: 24,
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
                              'assets/icons/slider.svg',
                              color: _touristExploreController
                                          .activeStepProgres.value >=
                                      1
                                  ? colorGreen
                                  : lightGrey,
                              height: 24,
                              width: 24,
                            ),
                            title: 'tourTime'.tr,
                          ),
                          EasyStep(
                            customStep: SvgPicture.asset(
                              'assets/icons/slider.svg',
                              color: _touristExploreController
                                          .activeStepProgres.value >=
                                      2
                                  ? colorGreen
                                  : lightGrey,
                              height: 24,
                              width: 24,
                            ),
                            title: 'completeTour'.tr,
                          ),
                        ],
                        onStepReached: (index) {},
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
