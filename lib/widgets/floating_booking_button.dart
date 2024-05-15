import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/widgets/reservation_details_widget.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBookingWidget extends StatelessWidget {
  const BottomBookingWidget(
      {super.key,
      required this.hospitalityObj,
      required this.servicesController,
      required this.avilableDate});
  final Hospitality hospitalityObj;
  final List<DateTime> avilableDate;
  final HospitalityController servicesController;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      width: double.infinity,
      height: 150,
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                text: "pricePerPerson".tr,
                fontSize: 15,
                color: colorDarkGrey,
                fontWeight: FontWeight.w400,
              ),
              const CustomText(
                text: " /  ",
                fontWeight: FontWeight.w900,
                fontSize: 17,
                color: Colors.black,
              ),
              CustomText(
                text: '${hospitalityObj!.price} ${'sar'.tr}',
                fontWeight: FontWeight.w900,
                fontSize: 17,
                fontFamily: 'HT Rakik',
              ),
            ],
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              //padding: const EdgeInsets.only(right: 16, left: 16, bottom: 32),
              padding: const EdgeInsets.only(right: 1, left: 1, bottom: 32),

              child: CustomButton(
                onPressed: () {
                  AppUtil.isGuest()
                      ? Get.to(() => const SignInScreen())
                      : Get.bottomSheet(
                          ReservaationDetailsWidget(
                              color: Colors.green,
                              hospitality: hospitalityObj,
                              avilableDate: avilableDate,
                              serviceController: servicesController),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        );
                },
                iconColor: darkPurple,
                title: "book".tr,
                icon: AppUtil.rtlDirection2(context)
                    ? const Icon(Icons.arrow_back_ios)
                    : const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBookingWidgetAdventure extends StatelessWidget {
  const BottomBookingWidgetAdventure({
    super.key,
    required this.hospitalityObj,
    required this.adventureController,
  });
  final Adventure hospitalityObj;

  final AdventureController adventureController;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      width: double.infinity,
      height: 150,
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                text: "pricePerPerson".tr,
                fontSize: 15,
                color: colorDarkGrey,
                fontWeight: FontWeight.w400,
              ),
              const CustomText(
                text: " /  ",
                fontWeight: FontWeight.w900,
                fontSize: 17,
                color: Colors.black,
              ),
              CustomText(
                text: '${hospitalityObj!.price} ${'sar'.tr}',
                fontWeight: FontWeight.w900,
                fontSize: 17,
                fontFamily: 'HT Rakik',
              ),
            ],
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              //padding: const EdgeInsets.only(right: 16, left: 16, bottom: 32),
              padding: const EdgeInsets.only(right: 1, left: 1, bottom: 32),

              child: CustomButton(
                onPressed: () {
                  // AppUtil.isGuest()
                  //     ? Get.to(() => const SignInScreen())
                  //     : Get.bottomSheet(
                  //         ReservaationDetailsAdventureWidget(
                  //             color: Colors.green,
                  //             hospitality: hospitalityObj,
                  //             serviceController: adventureController),
                  //         backgroundColor: Colors.white,
                  //         elevation: 0,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(24),
                  //         ),
                  //       );
                },
                iconColor: darkPurple,
                title: "book".tr,
                icon: AppUtil.rtlDirection2(context)
                    ? const Icon(Icons.arrow_back_ios)
                    : const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
