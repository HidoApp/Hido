import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/profile/widget/account_edit_sheet.dart';
import 'package:ajwad_v4/profile/widget/account_tile.dart';
import 'package:ajwad_v4/profile/widget/email_otp_sheet.dart';
import 'package:ajwad_v4/profile/widget/email_sheet.dart';
import 'package:ajwad_v4/profile/widget/iban_sheet.dart';
import 'package:ajwad_v4/profile/widget/otp_sheet.dart';
import 'package:ajwad_v4/profile/widget/phone_sheet.dart';
import 'package:ajwad_v4/profile/widget/prodvided_services_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';

class MyAccount extends StatefulWidget {
  const MyAccount(
      {super.key, required this.profileController, this.isLocal = false});
  final ProfileController profileController;
  final bool isLocal;
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  late Profile profile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String getPhoneNumber() {
    //to secure phone number
    final String number = widget.profileController.profile.phoneNumber!;
    String firstDigit = number.substring(0, 2);

    // Last two digits
    String lastTwoDigits = number.substring(number.length - 2);

    // Number of asterisks needed between the first digit and last two digits
    String maskedSection = '*' * (number.length - 3);

    // Combine the sections
    log(firstDigit + maskedSection + lastTwoDigits);
    if (AppUtil.rtlDirection2(context)) {
      return '\u202A' + (firstDigit + maskedSection + lastTwoDigits) + '\u202C';
      //  return String.fromCharCodes((firstDigit + maskedSection + lastTwoDigits).runes.toList().reversed);
    } else {
      return firstDigit + maskedSection + lastTwoDigits;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar("account".tr),
      body: ScreenPadding(
        child: Column(
          children: [
            Obx(
              () => widget.profileController.isProfileLoading.value
                  ? Container()
                  : AccountTile(
                      title: 'email'.tr,
                      subtitle: widget.profileController.profile.email!,
                      onTap: () => Get.bottomSheet(const EmailSheet()),
                    ),
            ),
            const Divider(
              color: lightGrey,
            ),
            SizedBox(
              height: width * 0.051,
            ),
            Obx(
              () => widget.profileController.isProfileLoading.value
                  ? Container()
                  : AccountTile(
                      title: "phoneNum".tr,
                      titleHint: "accountNumberHint".tr,
                      subtitle: getPhoneNumber(),
                      onTap: () => Get.bottomSheet(const PhoneSheet()),
                    ),
            ),
            const Divider(
              color: lightGrey,
            ),
            SizedBox(
              height: width * 0.051,
            ),
            if (widget.isLocal)
              Column(
                children: [
                  AccountTile(
                    title: 'iban'.tr,
                    subtitle: AppUtil.maskIban(
                      //  widget.profileController.profile.iban ??
                      "SA5480000246608016008348",
                    ),
                    onTap: () => Get.bottomSheet(const IbanSheet()),
                  ),
                  const Divider(
                    color: lightGrey,
                  ),
                  SizedBox(
                    height: width * 0.051,
                  ),
                  if (widget.profileController.profile.accountType != null)
                    if (widget.isLocal &&
                        widget.profileController.profile.accountType ==
                            'TOUR_GUID')
                      AccountTile(
                        title: 'providedServices'.tr,
                        onTap: () =>
                            Get.bottomSheet(const ProdvidedServicesSheet()),
                      ),
                  if (widget.profileController.profile.accountType != null)
                    if (widget.isLocal &&
                        widget.profileController.profile.accountType ==
                            'TOUR_GUID')
                      SizedBox(
                        height: width * 0.051,
                      ),
                  if (widget.profileController.profile.accountType != null)
                    if (widget.isLocal &&
                        widget.profileController.profile.accountType ==
                            'TOUR_GUID')
                      const Divider(
                        color: lightGrey,
                      ),
                  if (widget.profileController.profile.accountType != null)
                    if (widget.isLocal &&
                        widget.profileController.profile.accountType ==
                            'TOUR_GUID')
                      SizedBox(
                        height: width * .061,
                      ),
                ],
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Container(
                          width: double.infinity,
                           padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                  textAlign: TextAlign.center,
                                  fontSize: 20,
                                  maxlines: 2,
                                  fontWeight: FontWeight.w500,
                                  color: black,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? "SF Arabic"
                                      : 'SF Pro',
                                  text: "youWantDeleteYourAccount".tr),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: CustomButton(
                                  height: 25,
                                  buttonColor: colorRed,
                                  borderColor: colorRed,
                                  title: "deleteAccount".tr.tr,
                                  onPressed: () async {
                                    final authController =
                                        Get.put(AuthController());
                                    final isSuccess = await authController
                                        .deleteAccount(context: context);

                                    if (isSuccess) {
                                      Get.offAll(
                                          () => const OnboardingScreen());
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: CustomButton(
                                  height: 25,
                                  borderColor: colorRed,
                                  buttonColor: Colors.white,
                                  textColor: colorRed,
                                  title: "cancel".tr,
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Align(
                  alignment: AppUtil.rtlDirection2(context)
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: CustomText(
                    text: "delAccount".tr,
                    color: colorRed,
                    fontSize: width * .0435,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                    textDecoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
