import 'dart:io';

import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionDialog extends StatelessWidget {
  const AppVersionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(width * 0.0205),
            decoration: const BoxDecoration(
                color: Color(0xffE7F5EC), shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/icons/Alerts.svg',
              height: width * 0.082,
              width: width * 0.082,
              color: Colors.green,
            ),
          ),
          SizedBox(
            height: width * 0.03,
          ),
          CustomText(
            textAlign: TextAlign.center,
            fontSize: width * 0.043,
            fontFamily: AppUtil.SfFontType(context),
            fontWeight: FontWeight.w500,
            text: 'updateApp'.tr,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            textAlign: TextAlign.center,
            fontSize: width * 0.035,
            maxlines: 3,
            fontFamily: AppUtil.SfFontType(context),
            fontWeight: FontWeight.w400,
            text: 'updateAppContent'.tr,
          ),
          SizedBox(
            height: width * 0.07,
          ),
          CustomButton(
              title: "update".tr,
              onPressed: () async {
                // Define the app URLs for each store
                const String iosUrl =
                    'https://apps.apple.com/app/hido-%D9%87%D8%A7%D9%8A%D8%AF%D9%88/id6477162077';
                const String androidUrl =
                    'https://play.google.com/store/apps/details?id=com.hido.hidoapp';

                final url = Platform.isIOS ? iosUrl : androidUrl;

                if (await launchUrl(Uri.parse(url))) {
                  //  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              })
        ],
      ),
    );
  }
}
