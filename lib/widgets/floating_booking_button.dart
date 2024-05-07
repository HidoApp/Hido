import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/serivces_controller.dart';
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
  final SrvicesController servicesController;
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
                fontSize: 12,
                color: colorDarkGrey,
              ),
              const CustomText(
                text: "/  ",
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
              CustomText(
                text: '${hospitalityObj!.price} ${'sar'.tr}',
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ],
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 32),
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
                icon: !AppUtil.rtlDirection(context)
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
