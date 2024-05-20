import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/view/review_adventure_screen.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/widgets/hospitality_booking_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BottomHospitalityBooking extends StatelessWidget {
  const BottomHospitalityBooking(
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
                          HospitalityBookingSheet(
                              color: Colors.green,
                              hospitality: hospitalityObj,
                              avilableDate: avilableDate,
                              serviceController: servicesController),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ));
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

class BottomAdventureBooking extends StatefulWidget {
  const BottomAdventureBooking({
    super.key,
    required this.adventure,
  });
  final Adventure adventure;
  @override
  State<BottomAdventureBooking> createState() => _BottomAdventureBookingState();
}

class _BottomAdventureBookingState extends State<BottomAdventureBooking> {
  var person = 0;
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
                text: '400 ${'sar'.tr}',
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
                          StatefulBuilder(
                            builder: (context, setState) => Container(
                              height: 268,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomText(
                                    text: 'Number of People ',
                                    fontSize: 17,
                                  ),
                                  Container(
                                    height: 48,
                                    width: 342,
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    margin: EdgeInsets.only(
                                        top: height * 0.02, bottom: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: lightGreyColor,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        CustomText(
                                          text: "guests2".tr,
                                          fontWeight: FontWeight.w200,
                                          color: textGreyColor,
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (person > 0) {
                                                person = person - 1;
                                              }
                                            });
                                          },
                                          child: const Icon(
                                            Icons.horizontal_rule_outlined,
                                            color: darkGrey,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        CustomText(
                                          text: person.toString(),
                                          color: tileGreyColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        const SizedBox(width: 15),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              person = person + 1;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            color: darkGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  CustomButton(
                                      onPressed: () {
                                        Get.to(() => ReviewAdventure(
                                                  adventure: widget.adventure,
                                                  person: person,
                                                ))!
                                            .then(
                                          (value) {
                                            person = 0;
                                            print(value);
                                            Get.back();
                                          },
                                        );
                                      },
                                      title: 'confirm'.tr)
                                ],
                              ),
                            ),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24)),
                          ),
                        ).then((value) => person = 0);
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
