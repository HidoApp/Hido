import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
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

      // return 'tourCompletedSubtitle'.tr;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: width * .061,
      ),
      child: Obx(
        () => _touristExploreController.isActivityProgressLoading.value
            ? const Center(child: CircularProgressIndicator.adaptive())
            : ListView(
                shrinkWrap: true,
                children: [
                  CustomText(
                    text: getTitle(),
                    fontSize: width * 0.043,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomText(
                    text: getSubTitle(),
                    fontSize: width * 0.038,
                    fontFamily:
                        AppUtil.rtlDirection2(context) ? "SF Arabic" : 'SF Pro',
                    color: starGreyColor,
                    fontWeight: FontWeight.w500,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: width * 0.051),
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
                      stepRadius: width * 0.041,
                      padding: EdgeInsets.zero,
                      showStepBorder: false,
                      lineStyle: LineStyle(
                        lineType: LineType.normal,
                        lineThickness: 2,
                        unreachedLineColor: lightGrey,
                        activeLineColor: colorGreen,
                        lineWidth: width * 0.025,
                        lineSpace: width * 0.074,
                        lineLength: width * 0.2564,
                      ),
                      steps: [
                        EasyStep(
                            customStep: RepaintBoundary(
                              child: SvgPicture.asset(
                                'assets/icons/slider.svg',
                                color: _touristExploreController
                                            .activeStepProgres.value >=
                                        0
                                    ? colorGreen
                                    : lightGrey,
                                height: width * .061,
                                width: width * .061,
                              ),
                            ),
                            title: 'onTheWay'.tr),
                        EasyStep(
                          customStep: RepaintBoundary(
                            child: SvgPicture.asset(
                              'assets/icons/slider.svg',
                              color: _touristExploreController
                                          .activeStepProgres.value >=
                                      1
                                  ? colorGreen
                                  : lightGrey,
                              height: width * .061,
                              width: width * .061,
                            ),
                          ),
                          title: 'Arrived'.tr,
                        ),
                        EasyStep(
                          customStep: RepaintBoundary(
                            child: SvgPicture.asset(
                              'assets/icons/slider.svg',
                              color: _touristExploreController
                                          .activeStepProgres.value >=
                                      2
                                  ? colorGreen
                                  : lightGrey,
                              height: width * .061,
                              width: width * .061,
                            ),
                          ),
                          title: 'tourTime'.tr,
                        ),
                      ],
                      onStepReached: (index) {},
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
