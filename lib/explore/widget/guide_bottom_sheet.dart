import 'dart:developer';

import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class GuideBottomSheet extends StatefulWidget {
  const GuideBottomSheet({super.key});

  @override
  State<GuideBottomSheet> createState() => _GuideBottomSheetState();
}

class _GuideBottomSheetState extends State<GuideBottomSheet> {
  final _sheetController = SolidController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _sheetController.dispose();
    log("sheet guide close");
  }

  final _touristExploreController = Get.put(TouristExploreController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), topLeft: Radius.circular(24))),
      child: Obx(
        () => SolidBottomSheet(
          canUserSwipe: false,
          autoSwiped: false,
          // elevation: isAppear ? 0 : 5,
          draggableHeader: false,
          showOnAppear: _touristExploreController.isGuideAppear.value,
          toggleVisibilityOnTap: true,
          maxHeight: width * 0.48,
          controller: _sheetController,
          onHide: () {
            _touristExploreController.isGuideAppear.value = false;
            // _touristExploreController.showSheet.value = false;
          },
          onShow: () {
            _touristExploreController.isGuideAppear.value = true;
          },
          headerBar: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24))),
            height: 50,
            child: const BottomSheetIndicator(),
          ),
          body: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            //   mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.041, vertical: 0.061),
                child: CustomText(
                  text: 'guideTitle'.tr,
                  fontSize: width * 0.043,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.041, vertical: 0.061),
                child: CustomText(
                  text: 'guideSubtilte'.tr,
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.w400,
                  //   color: starGreyColor,
                  fontFamily: AppUtil.SfFontType(context),
                ),
              ),
              Container(
                margin: AppUtil.rtlDirection2(context)
                    ? EdgeInsets.only(right: width * 0.102, top: width * 0.021)
                    : EdgeInsets.only(
                        left: width * 0.110,
                      ),
                child: Image.asset(
                  AppUtil.rtlDirection2(context)
                      ? 'assets/images/guide.png'
                      : 'assets/images/guideEn.png',
                  height: width * 0.35,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
