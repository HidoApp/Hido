import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: lightGreyBackground),
                child: RepaintBoundary(
                  child: SvgPicture.asset('assets/icons/no_internet.svg'),
                )),
            CustomText(
              text: 'offlineTitle'.tr,
              fontSize: MediaQuery.of(context).size.width * 0.056,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.030,
            ),
            CustomText(
              text: 'offlineSubTitle'.tr,
              fontSize: MediaQuery.of(context).size.width * 0.043,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
