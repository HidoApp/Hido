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
  bool tourSelected = false;
  @override
  Widget build(BuildContext context) {
    
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        height: 310,
        padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: 20,
            ),
            CustomText(
              text: "Add your provided services",
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
            SizedBox(
              height: 12,
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
              height: 24,
            ),
            CustomButton(
              title: 'confirm'.tr,
              onPressed: () {
                if (tourSelected) {
                  final authController = Get.put(AuthController());
                  authController.activeBar(2);

                  Get.to((() => const TourStepper()));
                }
              },
            ),
          ],
        ));
  }
}
