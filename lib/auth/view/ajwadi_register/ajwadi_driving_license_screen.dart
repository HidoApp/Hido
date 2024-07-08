import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/phone_otp.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_ajwadi_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jhijri/jHijri.dart';

class AjwadiDrivingLicense extends StatefulWidget {
  const AjwadiDrivingLicense({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  State<AjwadiDrivingLicense> createState() => _AjwadiDrivingLicenseState();
}

class _AjwadiDrivingLicenseState extends State<AjwadiDrivingLicense> {
  late double width, height;

  final _formKey = GlobalKey<FormState>();

  final getStorage = GetStorage();

  late bool isBirthDateSelected;
  late bool isBirthInitiate = true;

  late bool isExpiryDateSelected;
  late bool isExpiryInitiate = true;

  DateTime? date1;
  DateTime? date2;
  String? birthDate;
  String? expiryDate;
  dynamic expiryDateHijriFormated;
  final authController = Get.put(AuthController());

  final _nationalIdController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          appBar: CustomAjwadiAppBar(
            "",
            isBack: false,
          ),
          body: SizedBox(
            // width: width*0.,
            child: Stack(
              children: [
                // Container(
                //   height: height,
                //   width: width,
                //   decoration: const BoxDecoration(
                //       image: DecorationImage(
                //     image: AssetImage("assets/images/background_ajwadi.png"),
                //     fit: BoxFit.fill,
                //   )),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.14,
                      left: width * 0.05,
                      right: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'licenseInformation'.tr,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: black,
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
                              hintText: 'idIqama'.tr,
                              textColor: Colors.grey,
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.grey,
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
                                          date1 = value;
                                          setState(() {
                                            isBirthDateSelected = true;
                                            String theMonth = date1!.month
                                                        .toString()
                                                        .length ==
                                                    1
                                                ? '0' + date1!.month.toString()
                                                : date1!.month.toString();
                                            String theDay = date1!.day
                                                        .toString()
                                                        .length ==
                                                    1
                                                ? '0' + date1!.day.toString()
                                                : date1!.day.toString();
                                            birthDate =
                                                '${date1!.year}-$theMonth-$theDay';
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
                                      color: isBirthInitiate
                                          ? Colors.grey
                                          : isBirthDateSelected
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
                                          : 'birthDate'.tr,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
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
                                          date2 = value;
                                          setState(() {
                                            isExpiryDateSelected = true;

                                            final expiryDateHijri = JHijri(
                                                fMonth: date2!.month,
                                                fYear: date2!.year,
                                                fDay: date2!.day,
                                                fDisplay:
                                                    DisplayFormat.YYYYMMDD);

                                            String theMonth = expiryDateHijri
                                                        .month
                                                        .toString()
                                                        .length ==
                                                    1
                                                ? '0' +
                                                    expiryDateHijri.month
                                                        .toString()
                                                : expiryDateHijri.month
                                                    .toString();
                                            String theDay = expiryDateHijri.day
                                                        .toString()
                                                        .length ==
                                                    1
                                                ? '0' +
                                                    expiryDateHijri.day
                                                        .toString()
                                                : expiryDateHijri.day
                                                    .toString();
                                            expiryDateHijriFormated =
                                                '${expiryDateHijri.year}-$theMonth-$theDay';
                                            print('HIJRI ${expiryDateHijri}');
                                            print(
                                                'HIJRI Formated : ${expiryDateHijriFormated}');
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
                                      color: isExpiryInitiate
                                          ? Colors.grey
                                          : isExpiryDateSelected
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
                                      text: expiryDateHijriFormated != null
                                          ? expiryDateHijriFormated!
                                          : 'licenceExpDate'.tr,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Obx(() => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: authController.isLienceseOTPLoading == true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: colorGreen),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    child: CustomButton(
                                      onPressed: () async {
                                        if (date1 == null || date2 == null) {
                                          print('EMPTY');

                                          if (date1 == null) {
                                            setState(() {
                                              isBirthDateSelected = false;
                                              isBirthInitiate = false;
                                            });

                                            // return;
                                          } else {
                                            isBirthDateSelected = true;
                                            isBirthInitiate = false;
                                          }

                                          if (date2 == null) {
                                            setState(() {
                                              isExpiryDateSelected = false;
                                              isExpiryInitiate = false;
                                            });

                                            // return;
                                          } else {
                                            isExpiryDateSelected = true;
                                            isExpiryInitiate = false;
                                          }
                                        }

                                        if (_formKey.currentState!.validate() &&
                                            isBirthDateSelected &&
                                            isExpiryDateSelected) {
                                          if (!AppUtil.isNationalIdValidate(
                                              _nationalIdController.text)) {
                                            AppUtil.errorToast(
                                                context,
                                                "National id must consist of 10 digits"
                                                    .tr);
                                            return;
                                          }
                                          String accessToken =
                                              getStorage.read('accessToken');

                                          print('ACCESS TOKEN : $accessToken');
                                          // bool isSuccess = await authController
                                          //     .drivingLinceseOTP(
                                          //         nationalID:
                                          //             _nationalIdController
                                          //                 .text,

                                          //         birthDate: birthDate!,
                                          //         context: context);
                                          print(true);
                                          if (true) {
                                            String accessToken =
                                                getStorage.read('accessToken');

                                            print(
                                                'expiryDate: $expiryDateHijriFormated');
                                            Get.to(() => PhoneOTPScreen(
                                                isAjwadi: true,
                                                authController: authController,
                                                birthDate: birthDate!,
                                                expiryDate:
                                                    expiryDateHijriFormated,
                                                isLiencese: true,
                                                nationalID:
                                                    _nationalIdController.text,
                                                accessToken: accessToken));
                                          }

                                          // Get.to(() => PhoneOTPScreen(
                                          //       isAjwadi: true,
                                          //       authController: authController,
                                          //       birthDate: birthDate!,
                                          //       expiryDate: expiryDateHijriFormated.toString(),
                                          //       nationalID:
                                          //           _nationalIdController.text,
                                          //     ));
                                        }
                                      },
                                      title: 'verify'.tr,
                                      icon: !AppUtil.rtlDirection(context)
                                          ? Icon(
                                              Icons.arrow_back_ios,
                                              size: 20,
                                            )
                                          : Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                            ),
                                    ),
                                  ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
