import 'dart:developer';

import 'package:ajwad_v4/auth/view/ajwadi_register/contact_info.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/tour_stepper.dart';
import 'package:ajwad_v4/auth/widget/provided_services_card.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/widget/experience_card.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/screen_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProvidedServices extends StatefulWidget {
  const ProvidedServices({super.key});

  @override
  State<ProvidedServices> createState() => _ProvidedServicesState();
}

class _ProvidedServicesState extends State<ProvidedServices> {
  var tourSelected = false;
  var experiencesSelected = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar('Provided Services'),
      body: ScreenPadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: 'welcome'.tr,
                color: black,
                fontSize: 20,
              ),
              SizedBox(
                width: 5,
              ),
              CustomText(
                text: 'Ammar',
                color: colorGreen,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              )
            ],
          ),
          CustomText(
            text:
                'What services are you planning to provide? (at least choose 1 or more)',
            color: starGreyColor,
            fontSize: 15,
            fontFamily: 'SF Pro',
          ),
          SizedBox(
            height: 24,
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
            height: 12,
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
            subtitle:
                'Share your culture through hospitality, adventure and local events .'
                    .tr,
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
            } else if (experiencesSelected) {
              Get.to(() => const ContactInfo());
            } else if (tourSelected) {
              Get.to(() => const TourStepper(
                    length: 3,
                  ));
            } else {
              AppUtil.errorToast(
                  context, 'You must pick at least one services');
            }
          },
          raduis: 8,
          title: 'next'.tr,
          height: 48,
          icon: const Icon(
            Icons.keyboard_arrow_right,
            size: 24,
          ),
        ),
      ),
    );
  }
}
