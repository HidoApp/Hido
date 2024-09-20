
import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/tour_stepper.dart';
import 'package:ajwad_v4/auth/widget/provided_services_card.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/cupertino.dart';
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
  var tourSelected = false;
  var experiencesSelected = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
                text: storage.read('localName') ?? "",
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
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            height: width * 0.06,
          ),
          ProvidedServicesCard(
            onTap: () {
              setState(() {
                tourSelected = !tourSelected;
              });
            },
            textColor: tourSelected ? colorGreen : black,
            title: 'ajwady'.tr,
            iconPath: 'tourProvide',
            subtitle: 'tourSub'.tr,
            color: tourSelected ? lightGreen : Colors.white,
            iconColor: tourSelected ? colorGreen : black,
            borderColor: tourSelected ? colorGreen : borderGrey,
          ),
          SizedBox(
            height: width * .0307,
          ),
          ProvidedServicesCard(
            onTap: () {
              setState(() {
                experiencesSelected = !experiencesSelected;
              });
            },
            textColor: experiencesSelected ? colorGreen : black,
            title: 'services'.tr,
            iconPath: 'serviceProvide',
            subtitle: 'exprinceHint'.tr,
            color: experiencesSelected ? lightGreen : Colors.white,
            iconColor: experiencesSelected ? colorGreen : black,
            borderColor: experiencesSelected ? colorGreen : borderGrey,
          )
        ],
      )),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.09, horizontal: width * 0.041),
        child: CustomButton(
          onPressed: () {
            if (experiencesSelected && tourSelected) {
              Get.to(() => const TourStepper());
            } else if (experiencesSelected) {
              Get.to(() => const ContactInfo());
            } else if (tourSelected) {
              Get.to(() => const TourStepper());
            } else {
              AppUtil.errorToast(
                  context, 'You must pick at least one services');
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
