import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/widget/sign_in_text.dart';
import 'package:ajwad_v4/auth/widget/terms_text.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  TextEditingController controller = TextEditingController();

  var _number = '';
  final _countryCode = '+966'.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.authController.agreeForTerms(false);

    generateCountries();
    // AmplitudeService.initializeAmplitude();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    widget.authController.isAgreeForTerms(true);
  }

  final _controller = MultiSelectController();
  final notificationController = Get.put(NotificationController());
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
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        //  resizeToAvoidBottomInset: true,
        appBar: const CustomAppBar(""),
        body: ScreenPadding(
          child: SingleChildScrollView(
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
                  textAlign: AppUtil.rtlDirection2(context)
                      ? TextAlign.right
                      : TextAlign.left,
                ),
                SizedBox(
                  height: width * 0.041,
                ),
                CustomText(
                  text: 'phoneNum'.tr,
                  fontSize: 17,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: width * .0205,
                ),
                Obx(
                  () => Form(
                    key: _formKey,
                    child: CustomTextField(
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CountryCodePicker(
                            initialSelection: 'SA',
                            showFlagDialog: false,

                            searchStyle: TextStyle(
                                fontSize: width * 0.038,
                                fontFamily: AppUtil.SfFontType(context),
                                color: black,
                                fontWeight: FontWeight.w400),
                            searchDecoration: InputDecoration(
                              hintText: 'search'.tr,
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide:
                                      BorderSide(color: borderGrey, width: 1)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide:
                                      BorderSide(color: borderGrey, width: 1)),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide:
                                      BorderSide(color: borderGrey, width: 1)),
                            ),
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            showFlag: false,
                            onChanged: (value) {
                              _countryCode.value = value.dialCode!;
                              log(_countryCode.value);
                            },
                            // optional. aligns the flag and the Text left
                            alignLeft: false, padding: EdgeInsets.zero,
                            textStyle: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                color: colorGreen,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: width * 0.123,
                            child: const VerticalDivider(
                              color: borderGrey,
                            ),
                          ),
                        ],
                      ),
                      hintText: 'phoneHint'.tr,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _countryCode.value == '+966'
                            ? LengthLimitingTextInputFormatter(9)
                            : LengthLimitingTextInputFormatter(
                                15 - _countryCode.value.length)
                      ],
                      keyboardType: TextInputType.number,
                      validator: false,
                      validatorHandle: (number) {
                        if (number == null || number.isEmpty) {
                          return 'fieldRequired'.tr;
                        }
                        var fullNumber = _countryCode + number;
                        if (_countryCode.value == '+966') {
                          if (!number.startsWith('5') || number.length != 9) {
                            return 'invalidPhone'.tr;
                          }
                        }
                        if (fullNumber.length < 9 || fullNumber.length > 15) {
                          log('length issue');
                          return 'invalidPhone'.tr;
                        }
                        return null;
                      },
                      onChanged: (number) => _number = number,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomText(
                  text: 'nationality'.tr,
                  fontSize: 17,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
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
                      SizedBox(
                        width: double.infinity,
                        height: width * 0.12,
                        child: SearchField<ValueItem>(
                          hint: 'chooseNationality'.tr,
                          searchStyle: TextStyle(
                            color: black,
                            fontSize: 15,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
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
                            FocusScope.of(context)
                                .unfocus(); // Close the dropdown
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
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                          suggestionItemDecoration: SuggestionDecoration(
                            border: null,
                          ),
                          searchInputDecoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: black,
                              fontSize: 15,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                            hintStyle: TextStyle(
                              color: borderGrey,
                              fontSize: 14,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
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
                              borderSide:
                                  const BorderSide(color: borderGrey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: borderGrey, width: 1),
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
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: width * 0.061,
                ),
                const TermsAndConditionsText(),
                SizedBox(
                  height: width * 0.092,
                ),
                Obx(
                  () => widget.authController.isRegisterLoading.value ||
                          notificationController.isSendingDeviceToken.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : CustomButton(
                          title: 'signUp'.tr,
                          onPressed: () async {
                            if (!widget.authController.agreeForTerms.value) {
                              widget.authController.isAgreeForTerms(false);
                              return;
                            } else {
                              widget.authController.isAgreeForTerms(true);
                            }
                            final numberValid =
                                _formKey.currentState!.validate();

                            if (_selectedNationality.isEmpty) {
                              setState(() {
                                isNatSelected = false;
                              });
                              return;
                            }

                            if (numberValid && isNatSelected) {
                              log(_countryCode + _number);
                              bool isSuccess = await widget.authController
                                  .touristRegister(
                                      email: widget.email,
                                      password: widget.password,
                                      name: widget.name,
                                      phoneNumber: _countryCode + _number,
                                      nationality: _selectedNationality,
                                      rememberMe: true,
                                      context: context);

                              if (isSuccess) {
                                final isSuccess = await notificationController
                                    .sendDeviceToken(context: context);
                                if (!isSuccess) {
                                  AmplitudeService.amplitude.track(
                                      BaseEvent('Tourist Sign up Failed'));
                                  return;
                                }
                                Get.offAll(() => const TouristBottomBar());
                                AmplitudeService.amplitude.track(BaseEvent(
                                    'Tourist Completed Sign Up ',
                                    eventProperties: {
                                      'name': widget.name,
                                      'email': widget.email,
                                    }));
                              } else {
                                AmplitudeService.amplitude
                                    .track(BaseEvent('Tourist Sign up Failed'));
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
          ),
        ));
  }
}
