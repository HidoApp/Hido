import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/tour_stepper.dart';
import 'package:ajwad_v4/auth/widget/provided_services_card.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProvidedServices extends StatefulWidget {
  const ProvidedServices({super.key});

  @override
  State<ProvidedServices> createState() => _ProvidedServicesState();
}

class _ProvidedServicesState extends State<ProvidedServices> {
  final storage = GetStorage();
  // var tourSelected = false;
  // var experiencesSelected = false;
  final _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: CustomAppBar('providedServices'.tr),
      body: ScreenPadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: 'welcome'.tr,
                color: black,
                fontSize: width * 0.051,
              ),
              SizedBox(
                width: width * 0.0128,
              ),
              //Name
              CustomText(
                text: storage.read('localName') != null
                    ? AppUtil.getFirstName(
                        AppUtil.capitalizeFirstLetter(
                            storage.read('localName') ?? ""),
                      )
                    : "",
                color: colorGreen,
                fontSize: width * 0.051,
                fontWeight: FontWeight.w500,
              )
            ],
          ),
          CustomText(
            text: 'serviceHint'.tr,
            color: starGreyColor,
            fontSize: width * 0.038,
            fontFamily: AppUtil.SfFontType(context),
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            height: width * 0.06,
          ),
          Obx(
            () => ProvidedServicesCard(
              onTap: () {
                _authController.tourSelected.value =
                    !_authController.tourSelected.value;
              },
              textColor:
                  _authController.tourSelected.value ? colorGreen : black,
              title: 'ajwady'.tr,
              checkValue: _authController.tourSelected,
              subtitle: 'tourSub'.tr,
              color: _authController.tourSelected.value
                  ? extralightGreen
                  : Colors.white,
              iconColor:
                  _authController.tourSelected.value ? colorGreen : black,
              borderColor:
                  _authController.tourSelected.value ? colorGreen : borderGrey,
            ),
          ),
          SizedBox(
            height: width * .0307,
          ),
          Obx(
            () => ProvidedServicesCard(
              onTap: () {
                _authController.experiencesSelected.value =
                    !_authController.experiencesSelected.value;
              },
              textColor: _authController.experiencesSelected.value
                  ? colorGreen
                  : black,
              title: 'experiences'.tr,
              checkValue: _authController.experiencesSelected,
              subtitle: 'exprinceHint'.tr,
              color: _authController.experiencesSelected.value
                  ? extralightGreen
                  : Colors.white,
              iconColor: _authController.experiencesSelected.value
                  ? colorGreen
                  : black,
              borderColor: _authController.experiencesSelected.value
                  ? colorGreen
                  : borderGrey,
            ),
          )
        ],
      )),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.09, horizontal: width * 0.041),
        child: CustomButton(
          onPressed: () {
            if (_authController.experiencesSelected.value &&
                _authController.tourSelected.value) {
              AmplitudeService.amplitude
                  .track(BaseEvent('Local choose  to be tour guide'));
              // Get.to(() => const TourStepper());
              Get.to(() => const ContactInfo());
            } else if (_authController.experiencesSelected.value) {
              AmplitudeService.amplitude
                  .track(BaseEvent('Local choose  to be experience'));
              Get.to(() => const ContactInfo());
            } else if (_authController.tourSelected.value) {
              AmplitudeService.amplitude
                  .track(BaseEvent('Local choose  to be tour guide'));
              //  Get.to(() => const TourStepper());
              Get.to(() => const ContactInfo());
            } else {
              AppUtil.errorToast(context, 'pickService'.tr);
            }
          },
          raduis: 8,
          title: 'next'.tr,
          height: width * 0.123,
          icon: const Icon(
            Icons.keyboard_arrow_right,
          ),
        ),
      ),
    );
  }
}
