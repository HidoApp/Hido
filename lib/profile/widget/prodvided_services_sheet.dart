import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/tour_stepper.dart';
import 'package:ajwad_v4/auth/widget/provided_services_card.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProdvidedServicesSheet extends StatefulWidget {
  const ProdvidedServicesSheet({super.key});

  @override
  State<ProdvidedServicesSheet> createState() => _ProdvidedServicesSheetState();
}

class _ProdvidedServicesSheetState extends State<ProdvidedServicesSheet> {
  RxBool tourSelected = false.obs;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        //  height: width * 0.794,
        padding: EdgeInsets.only(
            left: width * 0.0615,
            right: width * 0.0615,
            top: width * 0.041,
            bottom: width * 0.082),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: width * 0.051,
            ),
            CustomText(
              text: "addProvidedServices".tr,
              fontWeight: FontWeight.w500,
              fontSize: width * 0.056,
            ),
            SizedBox(
              height: width * 0.030,
            ),
            ProvidedServicesCard(
              onTap: () {
                tourSelected.value = !tourSelected.value;
              },
              textColor: tourSelected.value ? colorGreen : black,
              title: 'ajwady'.tr,
              // iconPath: 'tourProvide',
              subtitle: 'tourSub'.tr,
              color: tourSelected.value ? lightGreen : Colors.white,
              iconColor: tourSelected.value ? colorGreen : black,
              borderColor: tourSelected.value ? colorGreen : borderGrey,
              checkValue: tourSelected,
            ),
            SizedBox(
              height: width * 0.061,
            ),
            CustomButton(
              title: 'save'.tr,
              onPressed: () {
                if (tourSelected.value) {
                  final authController = Get.put(AuthController());
                  // authController.activeBar(2);
                  authController.activeBar(1);

                  Get.to((() => const TourStepper()));
                }
              },
            ),
          ],
        ));
  }
}
