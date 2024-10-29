import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/explore/ajwadi/view/local_home_screen.dart';
import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/error_report_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ErrorScreenWidget extends StatelessWidget {
  const ErrorScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.041),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                  child: SvgPicture.asset('assets/images/hido_error.svg')),
              SizedBox(
                height: width * 0.0615,
              ),
              CustomText(
                text: 'errorScreenTitle'.tr,
                fontSize: width * 0.087,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text: 'errorScreenSubTitle'.tr,
                fontSize: width * 0.043,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w400,
                color: const Color(0xff52515D),
              ),
              SizedBox(
                height: width * 0.13,
              ),
              SizedBox(
                height: width * 0.107,
                width: width * 0.517,
                child: CustomButton(
                  title: 'errorScreenMainButton'.tr,
                  onPressed: () {
                    var userRole = GetStorage().read('userRole') ?? '';
                    if (userRole == 'tourist') {
                      Get.offAll(() => const TouristBottomBar());
                    } else if (userRole == 'local') {
                      Get.offAll(() => const AjwadiBottomBar());
                    } else {
                      Get.offAll(() => const OnboardingScreen());
                    }
                  },
                ),
              ),
              SizedBox(
                height: width * 0.038,
              ),
              GestureDetector(
                onTap: () => Get.bottomSheet(const ErrorReportSheet(),
                    isScrollControlled: true),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RepaintBoundary(
                      child: SvgPicture.asset("assets/icons/help_icon.svg"),
                    ),
                    SizedBox(
                      width: width * 0.0205,
                    ),
                    CustomText(
                      text: 'errorScreenReportButton'.tr,
                      fontFamily: AppUtil.SfFontType(context),
                      fontSize: width * 0.041,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
