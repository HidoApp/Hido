import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/widget/sign_in_text.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:get/get.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:searchfield/searchfield.dart';

class LastStepScreen extends StatefulWidget {
  const LastStepScreen(
      {Key? key,
      required this.name,
      required this.email,
      required this.password,
      required this.authController,
      required this.countries})
      : super(key: key);

  final String name;
  final String email;
  final String password;
  final AuthController authController;
  final List<String> countries;

  @override
  State<LastStepScreen> createState() => _LastStepScreenState();
}

class _LastStepScreenState extends State<LastStepScreen> {
  late double width, height;
  bool isSwitched = false;
  final _formKey = GlobalKey<FormState>();
  String _selectedNationality = "";
  bool isNatSelected = true;
  List<ValueItem> countries = [];

  var _number = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.email);
    print(widget.password);
    print(widget.name);
    generateCountries();
  }

  final _controller = MultiSelectController();
  void generateCountries() {
    countries = List.generate(
        widget.countries.length,
        (index) => ValueItem(
            label: widget.countries[index], value: widget.countries[index]));
  }

  // Callback when a suggestion is tapped
  // Callback when a suggestion is tapped
  void onSuggestionTap(SearchFieldListItem<ValueItem<dynamic>> tappedItem) {
    setState(() {
      _selectedNationality = tappedItem.item?.value!;
    });
    if (_selectedNationality.isNotEmpty) {
      setState(() {
        isNatSelected = true;
      });
    } else {
      setState(() {
        isNatSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(""),
        body: ScreenPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "signInTitle".tr,
                fontWeight: FontWeight.w500,
                fontSize: width * 0.051,
              ),
              CustomText(
                text: 'createTourist'.tr,
                fontWeight: FontWeight.w500,
                fontSize: width * 0.0435,
                color: starGreyColor,
                textAlign: !AppUtil.rtlDirection(context)
                    ? TextAlign.right
                    : TextAlign.left,
              ),
              SizedBox(
                height: width * 0.041,
              ),
              CustomText(
                text: 'phoneNum'.tr,
                fontSize: 17,
                fontFamily: "SF Pro",
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: width * .0205,
              ),
              Form(
                key: _formKey,
                child: CustomTextField(
                  hintText: 'phoneHint'.tr,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  keyboardType: TextInputType.number,
                  validator: false,
                  validatorHandle: (number) {
                    if (number == null || number!.isEmpty) {
                      return 'fieldRequired'.tr;
                    }
                    if (!number.startsWith('05') || number.length != 10) {
                      return 'invalidPhone'.tr;
                    }
                    return null;
                  },
                  onChanged: (number) => _number = number,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              CustomText(
                text: 'nationality'.tr,
                fontSize: 17,
                fontFamily: "SF Pro",
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: width * .0205,
              ),
             SingleChildScrollView(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        height: width * 0.12,
        child: SearchField<ValueItem>(
          hint: 'chooseNationality'.tr,
          searchStyle: TextStyle(
            color: black,
            fontSize: 15,
            fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
            fontWeight: FontWeight.w400,
          ),
          onSaved: (options) {
            _selectedNationality = options!;
            setState(() {
              isNatSelected = _selectedNationality.isNotEmpty;
            });
            log('selected $_selectedNationality');
          },
          onSuggestionTap: (tappedItem) {
            onSuggestionTap(tappedItem);
            FocusScope.of(context).unfocus(); // Close the dropdown
            log('selected $_selectedNationality');
          },
          onSubmit: (options) {
            _selectedNationality = options;
            setState(() {
              isNatSelected = _selectedNationality.isNotEmpty;
            });
            log('selected $_selectedNationality');
          },
          suggestionStyle: TextStyle(
            color: black,
            fontSize: 15,
            fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
            fontWeight: FontWeight.w400,
          ),
          suggestionItemDecoration: SuggestionDecoration(
            border: null,
          ),
          searchInputDecoration: InputDecoration(
            labelStyle: TextStyle(
              color: black,
              fontSize: 15,
              fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w400,
            ),
            hintStyle: TextStyle(
              color: borderGrey,
              fontSize: 14,
              fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w400,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isNatSelected ? borderGrey : colorRed,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderGrey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderGrey, width: 1),
            ),
          ),
         
          suggestions: countries
              .map((e) => SearchFieldListItem<ValueItem>(
                    e.label,
                    item: e,
                  ))
              .toList(),
        ),
      ),
      isNatSelected
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                text: 'fieldRequired'.tr,
                color: colorRed,
                fontSize: 11,
                fontFamily: "SF Pro",
                fontWeight: FontWeight.w400,
              ),
            ),
    ],
  ),
),

                      // child: SearchField(
                      //   hint: 'jjkkk',
                      //   searchInputDecoration: InputDecoration(
                      //     enabledBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color:Colors.black45,
                      //       )
                      //     )
                      //   ),
                      //   itemHeight: 50,
                      //   maxSuggestionsInViewPort: 6,
              
                      //   suggestions: [
                      //     'list1',
                      //     'list2',
                      //   ],
              
                      //   ),
                    
                 
                // MultiSelectDropDown(
                //   controller: _controller,
                //   dropdownHeight: 250,
                //   inputDecoration: BoxDecoration(
                //       border: Border.all(
                //           color: isNatSelected ? borderGrey : colorRed),
                //       borderRadius: BorderRadius.circular(11)),
                //   hint: 'chooseNationality'.tr,
                //   borderRadius: 8,
                //   hintPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                //   searchEnabled: true,
                //   searchLabel: 'search'.tr,
                //   suffixIcon: const Icon(Icons.keyboard_arrow_up),
                //   clearIcon: null,
                //   singleSelectItemStyle: const TextStyle(
                //       fontSize: 15,
                //       fontFamily: "SF Pro",
                //       color: black,
                //       fontWeight: FontWeight.w500),
              
                //   onOptionSelected: (options) {
                //     _selectedNationality = options.first.value;
                //     if (_selectedNationality.isNotEmpty) {
                //       setState(() {
                //         isNatSelected = true;
                //       });
                //     }
                //   },
                //   options: countries,
                //   // searchEnabled: true,
                //   selectionType: SelectionType.single,
                //   chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                //   // dropdownHeight: 300,
                //   optionTextStyle: const TextStyle(
                //       fontSize: 15,
                //       fontFamily: "SF Pro",
                //       color: starGreyColor,
                //       fontWeight: FontWeight.w500),
              
                //   // selectedOptionIcon:
                //   //     const Icon(Icons.check_circle),
                // ),
                
                // isNatSelected
                //     ? Container()
                //     : Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: CustomText(
                //           text: 'fieldRequired'.tr,
                //           color: colorRed,
                //           fontSize: 11,
                //           fontFamily: "SF Pro",
                //           fontWeight: FontWeight.w400,
                //         ),
                //     ),
                //      ],
                // ),
            //  ),
              // const SizedBox(
              //   height: 30,
              // ),
              SizedBox(
                height: 36,
              ),
              Obx(
                () => widget.authController.isRegisterLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: colorGreen,
                        ),
                      )
                    : CustomButton(
                        title: 'signUp'.tr,
                        onPressed: () async {
                          final numberValid = _formKey.currentState!.validate();

                          if (_selectedNationality.isEmpty) {
                            setState(() {
                              isNatSelected = false;
                            });
                            return;
                          }

                          if (numberValid && isNatSelected) {
                            bool isSuccess = await widget.authController
                                .touristRegister(
                                    email: widget.email,
                                    password: widget.password,
                                    name: widget.name,
                                    phoneNumber: _number,
                                    nationality: _selectedNationality,
                                    rememberMe: true,
                                    context: context);
                            print(isSuccess);
                            if (isSuccess) {
                              Get.offAll(() => const TouristBottomBar());
                            }
                          }
                        },
                      ),
              ),
              SizedBox(
                height: width * 0.03,
              ),
              const SignInText(
                isLocal: false,
              )
            ],
          ),
        ));
  }
}
