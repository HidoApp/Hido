import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class LanguageSheet extends StatefulWidget {
  const LanguageSheet({super.key});

  @override
  _LanguageSheetState createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  String _selectedLanguage = Get.locale?.languageCode == 'ar'
      ? 'Arabic'
      : 'English'; // To store the selected language

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: 268,
      padding: const EdgeInsets.only(
        top: 16,
        left: 24,
        right: 24,
        bottom: 32,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x3FC7C7C7),
            blurRadius: 16,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetIndicator(),

          const SizedBox(height: 18),
          // Language preference text
          Text(
            'preferLang'.tr,
            style: TextStyle(
              color: black,
              fontSize: width * 0.044,
              fontFamily: 'HT Rakik',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<String>(
                value: 'Arabic',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
                activeColor: Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                'arabic'.tr,
                style: TextStyle(
                  color: black,
                  fontSize: width * 0.044,
                  fontFamily: AppUtil.SfFontType(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // English option
          Row(
            children: [
              Radio<String>(
                value: 'English',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
                activeColor: Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                'english'.tr,
                style: TextStyle(
                  color: black,
                  fontSize: width * 0.044,
                  fontFamily: AppUtil.SfFontType(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const Spacer(),
          // Confirm button
          Center(
              child: CustomButton(
            title: 'confirm'.tr,
            onPressed: (() async {
              if (_selectedLanguage.isNotEmpty) {
                if (_selectedLanguage == 'English') {
                  // Update to English Locale
                  Get.updateLocale(const Locale('en', 'US'));
                  GetStorage().write('language', 'en');
                  Get.back();
                } else if (_selectedLanguage == 'Arabic') {
                  // Update to Arabic Locale
                  Get.updateLocale(const Locale('ar', 'SA'));
                  GetStorage().write('language', 'ar');

                  Get.back();
                }
              }
            }),
          )),
        ],
      ),
    );
  }
}

void openAppSettings() async {
  final url = Uri.parse('app-settings:');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    print("Could not open app settings.");
  }
}
