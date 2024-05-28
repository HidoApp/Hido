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
import 'package:ajwad_v4/widgets/sign_sheet.dart';
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
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.041),
      color: Colors.white,
      width: double.infinity,
      height: width * 0.38,
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                text: "pricePerPerson".tr,
                fontSize: width * 0.038,
                color: colorDarkGrey,
                fontWeight: FontWeight.w400,
              ),
              CustomText(
                text: " /  ",
                fontWeight: FontWeight.w900,
                fontSize: width * 0.043,
                color: Colors.black,
              ),
              CustomText(
                text: '${hospitalityObj!.price} ${'sar'.tr}',
                fontWeight: FontWeight.w900,
                fontSize: width * 0.043,
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
              padding: EdgeInsets.only(
                  right: width * 0.0025,
                  left: width * 0.0025,
                  bottom: width * 0.08),

              child: CustomButton(
                onPressed: () {
                  AppUtil.isGuest()
                      ? showModalBottomSheet(
                          context: context,
                          builder: (context) => const SignInSheet(),
                          isScrollControlled: true,
                          enableDrag: true,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(width * 0.06),
                                topRight: Radius.circular(width * 0.06)),
                          ))
                      : Get.bottomSheet(
                          HospitalityBookingSheet(
                              color: Colors.green,
                              hospitality: hospitalityObj,
                              avilableDate: avilableDate,
                              serviceController: servicesController),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(width * 0.06),
                                topRight: Radius.circular(width * 0.06)),
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
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.041),
      color: Colors.white,
      width: double.infinity,
      height: width * 0.38,
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                text: "pricePerPerson".tr,
                fontSize: width * 0.038,
                color: colorDarkGrey,
                fontWeight: FontWeight.w400,
              ),
              CustomText(
                text: " /  ",
                fontWeight: FontWeight.w900,
                fontSize: width * 0.043,
                color: Colors.black,
              ),
              CustomText(
                //text: '400 ${'sar'.tr}',
               text: '${widget.adventure.price} ${'sar'.tr}',
                fontWeight: FontWeight.w900,
                fontSize: width * 0.043,
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
              padding: EdgeInsets.only(
                  right: width * 0.0025,
                  left: width * 0.0025,
                  bottom: width * 0.08),

              child: CustomButton(
                onPressed: () {
                  AppUtil.isGuest()
                      ? showModalBottomSheet(
                          context: context,
                          builder: (context) => const SignInSheet(),
                          isScrollControlled: true,
                          enableDrag: true,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(width * 0.06),
                                topRight: Radius.circular(width * 0.06)),
                          ))
                      : Get.bottomSheet(
                          StatefulBuilder(
                            builder: (context, setState) => Container(
                              height: width * 0.687,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.06,
                                vertical: width * 0.05,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'numberofpeorson'.tr,
                                    fontSize: width * 0.043,
                                  ),
                                  Container(
                                    height: width * 0.123,
                                    width: width * 0.87,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.025),
                                    margin: EdgeInsets.only(
                                        top: height * 0.02,
                                        bottom: width * 0.012),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.02),
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
                                        SizedBox(width: width * 0.038),
                                        CustomText(
                                          text: person.toString(),
                                          color: tileGreyColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        SizedBox(width: width * 0.038),
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
                                  SizedBox(
                                    height: width * 0.06,
                                  ),
                                  CustomButton(
                                      onPressed: () {
                                        Get.to(() => ReviewAdventure(
                                                  adventure: widget.adventure,
                                                  person: person,
                                                ))!
                                            .then(
                                          (value) {
                                            // person = 0;
                                            // print(value);
                                            // Get.back();
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(width * 0.06),
                                topRight: Radius.circular(width * 0.06)),
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
