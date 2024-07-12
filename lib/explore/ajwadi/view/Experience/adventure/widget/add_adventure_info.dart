import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddInfo extends StatefulWidget {
  AddInfo({
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
  int _selectedLanguageIndex = 1; // 0 for AR, 1 for EN
  FocusNode _focusNode = FocusNode();
   AdventureController _AdventureController =
      Get.put(AdventureController());
      
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final TextEditingController textField1Controller =
        _selectedLanguageIndex == 0
            ? widget.textField1ControllerAR
            : widget.textField1ControllerEN;
    final TextEditingController textField2Controller =
        _selectedLanguageIndex == 0
            ? widget.textField2ControllerAR
            : widget.textField2ControllerEN;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ToggleSwitch(
                minWidth: 55,
                cornerRadius: 12,
                activeBgColors: [
                  [Colors.white],
                  [Colors.white]
                ],
                activeBorders: [
                  Border.all(color: Color(0xFFF5F5F5), width: 2.0),
                  Border.all(color: Color(0xFFF5F5F5), width: 2.0),
                ],
                activeFgColor: Color(0xFF070708),
                inactiveBgColor: Color(0xFFF5F5F5),
                inactiveFgColor: Color(0xFF9392A0),
                initialLabelIndex: _selectedLanguageIndex,
                totalSwitches: 2,
                labels: _selectedLanguageIndex == 0
                    ? ['عربي', 'إنجليزي']
                    : ['AR', 'EN'],
                radiusStyle: true,
                customTextStyles: [
                  TextStyle(
                    fontSize: _selectedLanguageIndex == 0 ? 11 : 13,
                    fontFamily:
                        _selectedLanguageIndex == 0 ? 'SF Arabic' : 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                  TextStyle(
                    fontSize: _selectedLanguageIndex == 0 ? 11 : 13,
                    fontFamily:
                        _selectedLanguageIndex == 0 ? 'SF Arabic' : 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ],
                customHeights: [90, 90],
                onToggle: (index) {
                  setState(() {
                    _selectedLanguageIndex = index!;
                  });
                  print('switched to: $index');
                },
              ),
            ]),
        Directionality(
          textDirection: _selectedLanguageIndex == 0
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedLanguageIndex == 0
                          ? 'عنوان التجربة'
                          : 'Experience title',
                      style: TextStyle(
                        color: Color(0xFF070708),
                        fontSize: 17,
                        fontFamily: _selectedLanguageIndex == 0
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: _selectedLanguageIndex == 0 ? 8 : 9),
                    Container(
                      width: double.infinity,
                      height: 54,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 0),
                        child: TextField(
                          controller: textField1Controller,
                           style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: _selectedLanguageIndex == 0
                            ? 'SF Arabic'
                            : 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: _selectedLanguageIndex == 0
                                ? 'مثال: منزل دانا'
                                : 'example: Dana’s house',
                            hintStyle: TextStyle(
                              color: Color(0xFFB9B8C1),
                              fontSize: 15,
                              fontFamily: _selectedLanguageIndex == 0
                            ? 'SF Arabic'
                            : 'SF Pro',
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
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedLanguageIndex == 0 ? 'الوصف' : 'Description',
                      style: TextStyle(
                        color: Color(0xFF070708),
                        fontSize: 17,
                        fontFamily: _selectedLanguageIndex == 0
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: 
                             FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: _selectedLanguageIndex == 0 ? 8 : 9),
                    Container(
                      width: double.infinity,
                      height: 133,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: TextField(
                          maxLines: 8,
                          // minLines: 1,
                          controller: textField2Controller,
                          focusNode: _focusNode,
                          inputFormatters: [
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
                            fontFamily: _selectedLanguageIndex == 0
                          ? 'SF Arabic'
                          : 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: _selectedLanguageIndex == 0
                              ? 'ما هي التجارب الفريدة التي لا يمكن العثور عليها في أي مكان آخر؟'
                              : 'highlight what makes it unique and why tourists should visit',
                          hintStyle: TextStyle(
                            color: Color(0xFFB9B8C1),
                            fontSize: 15,
                            fontFamily: _selectedLanguageIndex == 0
                          ? 'SF Arabic'
                          : 'SF Pro',
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
                      child: Text(
                        _selectedLanguageIndex == 0
                            ? '*يجب ألا يتجاوز الوصف 150 كلمة'
                            : '*the description must not exceed 150 words',
                        style: TextStyle(
                          color: Color(0xFFB9B8C1),
                          fontSize: 11,
                           fontFamily: _selectedLanguageIndex == 0
                          ? 'SF Arabic'
                          : 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // SizedBox(height: 20),
              // SizedBox(height: _selectedLanguageIndex == 0 ? 0 : 20),
            ],
          ),
        ),
      ],
    );
  }
}
