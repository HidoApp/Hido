import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_elevated_button_with_arrow.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterNationalId extends StatefulWidget {
  const RegisterNationalId({
    Key? key,
    required this.authController,
    //  this.countries,
  }) : super(key: key);
  final AuthController authController;
  // final countries;

  @override
  State<RegisterNationalId> createState() => _RegisterNationalIdState();
}

class _RegisterNationalIdState extends State<RegisterNationalId> {
  final _formKey = GlobalKey<FormState>();

  late double width, height;
  bool isSwitched = false;
  late bool isDateSelected;
  late bool isInaitla = true;
  late bool showPassword, showConfirmPassword;

  final _nationalIdController = TextEditingController();

  DateTime? date;
  String? birthDate;

  // final _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    showPassword = false;
    showConfirmPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(""),
          body: SizedBox(
            // width: width*0.,
            child: Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/background_ajwadi.png"),
                    fit: BoxFit.fill,
                  )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.04,
                      right: width * 0.05,
                      left: width * 0.05),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [],
                      ),
                      CustomText(
                        text: "لنقم بإنشاء الحساب".tr,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        text:
                            'لأغراض الأمن والسلامة ، نحتاج إلى التحقق من هويتك. يرجى تزويدنا ببطاقة هوية صالحة صادرة عن جهة حكومية'
                                .tr,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              keyboardType: TextInputType.number,
                              controller: _nationalIdController,
                              hintText: 'هوية / إقامة/ جواز السفر '.tr,
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: colorDarkGrey,
                              ),
                              onChanged: (String value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (_) {
                                    final size = MediaQuery.of(context).size;
                                    return Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      height: size.height * 0.27,
                                      child: CupertinoDatePicker(
                                        mode: CupertinoDatePickerMode.date,
                                        onDateTimeChanged: (value) {
                                          date = value;
                                          setState(() {
                                            isDateSelected = true;
                                            String theMonth = date!.month.toString().length == 1 ? '0'+date!.month.toString() : date!.month.toString();
                                            String theDay = date!.day.toString().length == 1 ? '0'+date!.day.toString() : date!.day.toString();
                                            birthDate =
                                                '${date!.year}-$theMonth-$theDay';
                                          });
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                height: 60,
                                width: width * 0.85,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      color: isInaitla
                                          ? Colors.grey
                                          : isDateSelected
                                              ? Colors.grey
                                              : colorDarkRed,
                                    )),

                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    CustomText(
                                      text: birthDate != null
                                          ? birthDate!
                                          : 'تاريخ الميلاد',
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal:10.0),
                                child: CustomText(
                                  fontFamily: 'Noto Kufi Arabic',
                                  text: isInaitla
                                      ? ''
                                      : isDateSelected
                                          ? ''
                                          : 'هذا الحقل مطلوب',
                                  color: colorDarkRed,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: widget.authController.isCountryLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: colorGreen),
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: CustomElevatedButton(
                                      title: 'signUp'.tr,
                                      onPressed: () async {
                                        if (date == null
                                       
                                         ) {
                                          print('EMPTY');
                                          setState(() {
                                            isDateSelected = false;
                                            isInaitla = false;
                                          });

                                          return;
                                        } else {
                                          isDateSelected = true;
                                          isInaitla = false;
                                        }
                                        if (_formKey.currentState!.validate()) {
                                          if (!AppUtil.isNationalIdValidate(
                                              _nationalIdController.text)) {
                                            AppUtil.errorToast(
                                                context,
                                                "National id must consist of 10 digits"
                                                    .tr);
                                            return;
                                          }

                                          // if (!birthDate!.isEmpty) {
                                          //   print('EMPTY');
                                          //   setState(() {
                                          //     isDateSelected = false;
                                          //     isInaitla = false;
                                          //   });
                                          // } else {
                                          //   isDateSelected = true;
                                          //   isInaitla = false;
                                         // }

                                          var countries;
                                          var data = await widget.authController
                                              .getListOfCountries(context);
                                          if (data != null) {
                                            countries = data;
                                          }

                                          if (countries != null) {
                                          
                                          }

                                          // }
                                        }
                                      }),
                                ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "alreadyHaveAccount".tr,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: CustomText(
                              text: "signIn".tr,
                              color: colorGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
