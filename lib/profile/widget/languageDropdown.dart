import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/widget/language_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({Key? key}) : super(key: key);

  @override
  _LanguageDropdownState createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  bool isDropdownOpen = false;
  String selectedLanguage = 'English'; // Default value; you can change this
  final int _currentIndex = 0; // Example index, adjust as necessary
  final List<String> languages = ['Arabic', 'English'];

  @override
  void initState() {
    super.initState();
    // Check the current locale and set the initial language
    if (Get.locale?.languageCode == 'ar') {
      selectedLanguage = 'Arabic';
    } else {
      selectedLanguage = 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Positioned(
      top: 60, // Adjust as needed
      right: AppUtil.rtlDirection2(context) ? null : 22,
      left: AppUtil.rtlDirection2(context) ? 22 : null,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isDropdownOpen = !isDropdownOpen;
              });
            },
            child: SizedBox(
              width: width * 0.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header of the dropdown
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/white_lang.svg',
                              color: _currentIndex == 0
                                  ? Colors.white
                                  : colorGreen,
                            ),
                            const SizedBox(width: 4),
                            CustomText(
                              text: selectedLanguage == 'Arabic'
                                  ? 'arabic'.tr
                                  : 'english'.tr,
                              color: _currentIndex == 0
                                  ? Colors.white
                                  : colorGreen,
                              fontSize: width * 0.041,
                              fontFamily: AppUtil.SfFontType(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        // const SizedBox(width: 4),
                        Icon(
                          isDropdownOpen
                              ? Icons.keyboard_arrow_up_outlined
                              : Icons.keyboard_arrow_down_outlined,
                          color: _currentIndex == 0 ? Colors.white : colorGreen,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  // Show dropdown items
                  if (isDropdownOpen)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: languages.map((language) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedLanguage = language;
                              isDropdownOpen = false;
                              // Update the locale based on selected language
                              if (Platform.isIOS) {
                                openAppSettings(); // For iOS, direct the user to settings
                              } else {
                                if (selectedLanguage == 'English') {
                                  Get.updateLocale(const Locale('en', 'US'));
                                  GetStorage().write('language', 'en');
                                } else if (selectedLanguage == 'Arabic') {
                                  Get.updateLocale(const Locale('ar', 'SA'));
                                  GetStorage().write('language', 'ar');
                                }
                              }
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _currentIndex == 0
                                    ? Colors.white.withOpacity(0.2)
                                    : babyGray,
                                borderRadius: language == languages.last
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      )
                                    : language == languages.first
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          )
                                        : null,
                              ),
                              child: CustomText(
                                text: language.tr,
                                textAlign: TextAlign.center,
                                color: _currentIndex == 0
                                    ? Colors.white
                                    : colorGreen,
                                fontSize: width * 0.039,
                                fontFamily: AppUtil.SfFontType(context),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
