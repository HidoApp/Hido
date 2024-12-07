import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddInfo extends StatefulWidget {
  const AddInfo({
    Key? key,
    required this.textField1ControllerEN,
    required this.textField2ControllerEN,
    required this.textField1ControllerAR,
    required this.textField2ControllerAR,
  }) : super(key: key);

  final TextEditingController textField1ControllerEN;
  final TextEditingController textField2ControllerEN;
  final TextEditingController textField1ControllerAR;
  final TextEditingController textField2ControllerAR;

  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  // int _selectedLanguageIndex = 1; // 0 for AR, 1 for EN
  final FocusNode _focusNodeAr = FocusNode();
  final FocusNode _focusNodeEn = FocusNode();
  final AdventureController _AdventureController =
      Get.put(AdventureController());

  @override
  void dispose() {
    _focusNodeAr.dispose();
    _focusNodeEn.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    final TextEditingController textFieldTitleArController =
        widget.textField1ControllerAR;
    final TextEditingController textFieldTitleEnController =
        widget.textField1ControllerEN;
    final TextEditingController textFieldDescArController =
        widget.textField2ControllerAR;
    final TextEditingController textFieldDescEnController =
        widget.textField2ControllerEN;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'experienceTitleAr'.tr,
                    color: const Color(0xFF070708),
                    fontSize: 17,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                  SizedBox(height: width * 0.0205),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          r'[\u0600-\u06FF\s]')), // Allow only Arabic characters and spaces
                    ],
                    maxLength: 20,
                    controller: textFieldTitleArController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: 'مثال: منزل دانا',
                      hintStyle: TextStyle(
                        color: const Color(0xFFB9B8C1),
                        fontSize: 15,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0), // Adjust vertical padding for height
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xFFB9B8C1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 1,
                            color: Color(
                                0xFFB9B8C1)), // Same color to remove focus color
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'experienceTitleEn'.tr,
                    color: const Color(0xFF070708),
                    fontSize: 17,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                  SizedBox(height: width * 0.0205),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9\s]'),
                      ), // Allow only English letters and spaces
                    ],
                    maxLength: 20,
                    controller: textFieldTitleEnController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: 'example: Dana’s house',
                      hintStyle: TextStyle(
                        color: const Color(0xFFB9B8C1),
                        fontSize: 15,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0), // Adjust vertical padding for height
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xFFB9B8C1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 1,
                            color: Color(
                                0xFFB9B8C1)), // Same color to remove focus color
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'descriptionAr'.tr,
                    color: const Color(0xFF070708),
                    fontSize: 17,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                  SizedBox(height: width * 0.0205),
                  Container(
                    width: double.infinity,
                    height: width * 0.34,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFFB9B8C1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: TextField(
                        maxLines: 8,
                        // minLines: 1,
                        controller: textFieldDescArController,
                        focusNode: _focusNodeAr,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'[\u0600-\u06FF\s]')), // Allow only Arabic characters and spaces

                          TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                              if (newValue.text
                                      .split(RegExp(r'\s+'))
                                      .where((word) => word.isNotEmpty)
                                      .length >
                                  150) {
                                return oldValue;
                              }
                              return newValue;
                            },
                          ),
                        ],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: AppUtil.SfFontType(context),
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'أذكر أبرز ما يميزها ولماذا يجب على السياح زيارتها',
                          hintStyle: TextStyle(
                            color: const Color(0xFFB9B8C1),
                            fontSize: 15,
                            fontFamily: AppUtil.SfFontType(context),
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0, left: 8.0),
                    child: CustomText(
                      text: AppUtil.rtlDirection2(context)
                          ? '*يجب ألا يتجاوز الوصف 150 كلمة'
                          : '*the description must not exceed 150 words',
                      color: const Color(0xFFB9B8C1),
                      fontSize: 11,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'descriptionEn'.tr,
                color: const Color(0xFF070708),
                fontSize: 17,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w500,
                height: 0,
              ),
              SizedBox(height: width * 0.0205),
              Container(
                width: double.infinity,
                height: width * 0.34,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: TextField(
                    maxLines: 8,
                    // minLines: 1,
                    controller: textFieldDescEnController,
                    focusNode: _focusNodeEn,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9\s]'),
                      ), //
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          if (newValue.text
                                  .split(RegExp(r'\s+'))
                                  .where((word) => word.isNotEmpty)
                                  .length >
                              150) {
                            return oldValue;
                          }
                          return newValue;
                        },
                      ),
                    ],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: AppUtil.SfFontType(context),
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'highlight what makes it unique and why tourists should visit',
                      hintStyle: TextStyle(
                        color: const Color(0xFFB9B8C1),
                        fontSize: 15,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1.0, left: 8.0),
                child: CustomText(
                  text: AppUtil.rtlDirection2(context)
                      ? '*يجب ألا يتجاوز الوصف 150 كلمة'
                      : '*the description must not exceed 150 words',
                  color: const Color(0xFFB9B8C1),
                  fontSize: 11,
                  fontFamily: AppUtil.SfFontType(context),
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          // SizedBox(height: 20),
          // SizedBox(height: _selectedLanguageIndex == 0 ? 0 : 20),
        ],
      ),
    );
  }
}
