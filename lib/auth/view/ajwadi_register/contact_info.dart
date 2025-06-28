import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iban/iban.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo({super.key, this.isPageView = false});
  final bool isPageView;
  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.put(AuthController());
  final notificationController = Get.put(NotificationController());
  final _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: CustomAppBar(
        'contactInfo'.tr,
        isBack: widget.isPageView,
      ),
      body: ScreenPadding(
        child: Form(
          key: _authController.contactKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: 'email'.tr,
                  fontSize: width * 0.0435,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppUtil.SfFontType(context)),
              SizedBox(height: width * 0.02),
              CustomTextField(
                hintText: 'yourEmail'.tr,
                keyboardType: TextInputType.emailAddress,
                validator: false,
                validatorHandle: (email) {
                  if (email == null || email.isEmpty) {
                    return 'fieldRequired'.tr;
                  }
                  if (!AppUtil.isEmailValidate(email)) {
                    return 'invalidEmail'.tr;
                  }
                  return null;
                },
                onChanged: (email) => _authController.email(email),
              ),
              SizedBox(
                height: width * .06,
              ),
              CustomText(
                text: 'iban'.tr,
                fontSize: width * 0.0435,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: width * 0.02),
              CustomTextField(
                hintText: 'ibanHint'.tr,
                keyboardType: TextInputType.text,
                validator: false,
                validatorHandle: (iban) {
                  if (iban == null || iban.isEmpty) {
                    return 'fieldRequired'.tr;
                  }
                  if (!isValid(AppUtil.removeSpaces(iban)) &&
                      AppUtil.removeSpaces(iban).startsWith('SA')) {
                    return 'invalidIBAN'.tr;
                  }
                  return null;
                },
                onChanged: (iban) =>
                    _authController.iban(AppUtil.removeSpaces(iban)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.09, horizontal: width * 0.041),
        child: widget.isPageView
            ? const SizedBox()
            : Obx(
                () => _authController.isCreateAccountLoading.value ||
                        notificationController.isSendingDeviceToken.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : CustomButton(
                        onPressed: () async {
                          final isValid = _authController
                              .contactKey.currentState!
                              .validate();
                          if (!isValid) {
                            AmplitudeService.amplitude.track(BaseEvent(
                                "Local doesn't enter valid iban & email (as experience)"));
                            return;
                          }
                          AmplitudeService.amplitude.track(BaseEvent(
                              "Local  send iban & email  (as experience)"));
                          final isSuccess =
                              await _authController.createAccountInfo(
                            context: context,
                            email: _authController.email.value,
                            iban: _authController.iban.value,
                            type: (_authController.tourSelected.value &&
                                    _authController.experiencesSelected.value)
                                ? 'TOUR_GUID'
                                : _authController.experiencesSelected.value
                                    ? 'EXPERIENCES'
                                    : 'TOUR_GUID',
                          );
                          log(isSuccess.toString());
                          if (isSuccess) {
                            final isSuccess = await notificationController
                                .sendDeviceToken(context: context);
                            if (!isSuccess) {
                              AmplitudeService.amplitude.track(BaseEvent(
                                  'Local Sign up  Failed as exprinces'));
                              return;
                            }
                            AmplitudeService.amplitude.track(
                              BaseEvent(
                                  "Local create account as experience successfully "),
                            );
                            Get.offAll(() => const AjwadiBottomBar());
                            _storage.remove('localName');
                            storage.write('userRole', 'local');
                            // if (!mounted)
                            //   return; // Check if the widget is still mounted
                            // _authController.checkLocalInfo(context: context);
                          } else {
                            return;
                          }
                        },
                        title: 'signUp'.tr,
                        icon: Icon(
                          Icons.keyboard_arrow_right,
                          size: width * .06,
                        ),
                      ),
              ),
      ),
    );
  }
}
