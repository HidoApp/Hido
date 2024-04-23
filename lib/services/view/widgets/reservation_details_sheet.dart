import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/calender_dialog.dart';
import 'package:ajwad_v4/services/controller/serivces_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/payment/check_out_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_with_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';


void showReservationDetailsSheet({
  required BuildContext context,
  required Color color,
  required double height,
  required double width,
  Hospitality? hospitality,
  required SrvicesController serviceController,
  List<DateTime>? avilableDate,
}) {
 // late DateTime  newTime = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  int selectedChoice = 3;

  int guestNum = 0;
  int femaleGuestNum = 0;
  int maleGuestNum = 0;

  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Obx(
                  () => Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              const Align(
                                child: Icon(
                                  Icons.keyboard_arrow_up_outlined,
                                  size: 30,
                                ),
                              ),
                              CustomText(
                                text: "date".tr,
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Align(
                                alignment: AppUtil.rtlDirection(context)
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: CustomTextWithIconButton(
                                  onTap: () {
                                    print("object");
                                    setState(() {
                                      selectedChoice = 3;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CalenderDialog(
                                            fromAjwady: false,
                                            type: 'hospitality',
                                            avilableDate: avilableDate,
                                            srvicesController:
                                                serviceController,
                                            hospitality: hospitality,
                                          );
                                        });
                                  },
                                  height: height * 0.06,
                                  width: width * 0.65,
                                  title: serviceController
                                          .isHospatilityDateSelcted.value
                                      ? serviceController.selectedDate.value
                                          .toString()
                                          .substring(0, 10)
                                      : 'chooseFromCalender'.tr,
                                  borderColor: lightGreyColor,
                                  prefixIcon: SvgPicture.asset(
                                    "assets/icons/green_calendar.svg",
                                    color: color,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: color,
                                    size: 15,
                                  ),
                                  textColor: almostGrey,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              if (serviceController.selectedDateIndex.value !=
                                  -1)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                     CustomText(
                                              text: "time".tr,
                                              color:  Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      
                                    //   children: [
                                    //     Column(
                                    //       crossAxisAlignment: CrossAxisAlignment.start,
                                    //       children: [
                                    //         CustomText(
                                    //           text: "time".tr,
                                    //           color: Colors.black,
                                    //           fontSize: 14,
                                    //           fontWeight: FontWeight.w700,
                                    //         ),
                                    
                                    //          CustomText(
                                    //           text: DateFormat('hh:mm a')
                                    //         .format(DateTime.parse(hospitality!
                                    //                             .daysInfo[
                                    //                                 serviceController
                                    //                                     .selectedDateIndex
                                    //                                     .value]
                                    //                             .startTime)),
                                    //           color:darkGrey,
                                    //           fontSize: 12,
                                    //           fontWeight: FontWeight.w400,
                                    //         ),
                                    //       ],
                                    //     ),
                                    
                                    //  //   Spacer(),
                                    
                                    
                                    //      Column(
                                    //       crossAxisAlignment: CrossAxisAlignment.start,
                                    //       children: [
                                    //         CustomText(
                                    //           text: "endTime".tr,
                                    //           color: Colors.black,
                                    //           fontSize: 14,
                                    //           fontWeight: FontWeight.w700,
                                    //         ),
                                    
                                    //          CustomText(
                                    //           text: DateFormat('hh:mm a')
                                    //         .format(DateTime.parse(hospitality!
                                    //                             .daysInfo[
                                    //                                 serviceController
                                    //                                     .selectedDateIndex
                                    //                                     .value]
                                    //                             .endTime)),
                                    //            color:darkGrey,
                                    //           fontSize: 12,
                                    //           fontWeight: FontWeight.w400,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                     SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Align(
                                      alignment: AppUtil.rtlDirection(context)
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                      child: CustomTextWithIconButton(
                                        onTap: () {
                                          showCupertinoModalPopup<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xffffffff),
                                                        border: Border(
                                                          bottom: BorderSide(
                                                            color: Color(
                                                                0xff999999),
                                                            width: 0.0,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          CupertinoButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                Get.back();
                                                            //    serviceController.selectedTime.value = newTime.toString();
                                                              });
                                                            },
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 16.0,
                                                              vertical: 5.0,
                                                            ),
                                                            child: Text(
                                                                "confirm".tr),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 220,
                                                      width: width,
                                                      margin: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom,
                                                      ),
                                                      child:
                                                          CupertinoDatePicker(
                                                            
                                                        backgroundColor:
                                                            Colors.white,
                                                        initialDateTime: DateTime
                                                            .parse(hospitality!
                                                                .daysInfo[
                                                                    serviceController
                                                                        .selectedDateIndex
                                                                        .value]
                                                                .startTime),
                                                                minimumDate: DateTime.parse(hospitality
                                                                .daysInfo[
                                                                    serviceController
                                                                        .selectedDateIndex
                                                                        .value].startTime),
                                                                maximumDate:DateTime.parse(hospitality
                                                                .daysInfo[
                                                                    serviceController
                                                                        .selectedDateIndex
                                                                        .value].endTime) ,
                                                        // minimumDate: DateTime
                                                        //     .parse(hospitality
                                                        //         .daysInfo[
                                                        //             serviceController
                                                        //                 .selectedDateIndex
                                                        //                 .value]
                                                        //         .startTime),
                                                        // maximumDate: DateTime
                                                        //     .parse(hospitality
                                                        //         .daysInfo[
                                                        //             serviceController
                                                        //                 .selectedDateIndex
                                                        //                 .value]
                                                        //         .endTime),
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .time,
                                                        use24hFormat: false,
                                                        onDateTimeChanged:
                                                            (DateTime newT) {
                                                              // print(DateTime.parse(hospitality
                                                              //   .daysInfo[
                                                              //       serviceController
                                                              //           .selectedDateIndex
                                                              //           .value]
                                                              //   .startTime));
                                                        //  setState(() {
                                                         serviceController.selectedTime ( newT.toString());
                                                            // print(newT);
                                                          //   print(  serviceController.selectedTime );
                                                             print('PARSING');
                                                             print("PARSING ${ DateFormat('hh:mm:ss').format(DateTime.parse( newT.toString())) }");
                                                            //   print(newTime);
                                                        //  });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        height: height * 0.06,
                                        width: width * 0.4,
                                        title: serviceController.selectedTime.value == "" ? ""  :DateFormat('hh:mm a')
                                            .format( DateTime.parse(serviceController.selectedTime.value)),
                                        //  test,
                                        borderColor: lightGreyColor,
                                        prefixIcon: SvgPicture.asset(
                                          color == purple
                                              ? "assets/icons/Group 33763.svg"
                                              : 'assets/icons/Group 33780.svg',
                                          //  color: color,
                                        ),
                                        suffixIcon: Container(),
                                        textColor: almostGrey,
                                      ),
                                    ),
                                   
                                   
                                   
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    CustomText(
                                      text: "guests2".tr,
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    CustomText(
                                      text:
                                          "${"totalNumOfGeusts".tr} : $guestNum",
                                      color: almostGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Container(
                                      height: 64,
                                      width: 380,
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
                                      margin: EdgeInsets.only(
                                          top: height * 0.02, bottom: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: lightGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          CustomText(
                                            text: "male".tr,
                                            fontWeight: FontWeight.w700,
                                            color: textGreyColor,
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                              onTap: () {
                                                if (guestNum > 0 &&
                                                    maleGuestNum > 0) {
                                                  setState(() {
                                                    guestNum = guestNum - 1;
                                                    maleGuestNum =
                                                        maleGuestNum - 1;
                                                    if (guestNum <= 10) {}
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                  Icons
                                                      .horizontal_rule_outlined,
                                                  color: color)),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          CustomText(
                                            text: maleGuestNum.toString(),
                                            color: colorDarkGrey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                if (guestNum <=
                                                    hospitality!
                                                        .daysInfo[
                                                            serviceController
                                                                .selectedDateIndex
                                                                .value]
                                                        .seats) {
                                                  setState(() {
                                                    guestNum = guestNum + 1;
                                                    maleGuestNum =
                                                        maleGuestNum + 1;
                                                  });
                                                }
                                              },
                                              child: Icon(Icons.add,
                                                  color: color)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 64,
                                      width: 380,
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
                                      margin: EdgeInsets.only(
                                          top: height * 0.02, bottom: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: lightGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          CustomText(
                                            text: "female".tr,
                                            fontWeight: FontWeight.w700,
                                            color: textGreyColor,
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                              onTap: () {
                                                if (guestNum > 0 &&
                                                    femaleGuestNum > 0) {
                                                  setState(() {
                                                    guestNum = guestNum - 1;
                                                    femaleGuestNum =
                                                        femaleGuestNum - 1;
                                                    if (guestNum <= 10) {}
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                  Icons
                                                      .horizontal_rule_outlined,
                                                  color: color)),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          CustomText(
                                            text: femaleGuestNum.toString(),
                                            color: colorDarkGrey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                if (guestNum <=
                                                    hospitality!
                                                        .daysInfo[
                                                            serviceController
                                                                .selectedDateIndex
                                                                .value]
                                                        .seats) {
                                                  setState(() {
                                                    guestNum = guestNum + 1;
                                                    femaleGuestNum =
                                                        femaleGuestNum + 1;
                                                  });
                                                }
                                              },
                                              child: Icon(Icons.add,
                                                  color: color)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.1,
                                    ),
                                  ],
                                ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      CustomText(
                                        text: "preliminary cost".tr,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      CustomText(
                                        text: (hospitality!.price *guestNum ).toString() +
                                            ' ' +
                                            'sar'.tr,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 22,
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  CustomButton(
                                    buttonColor: color,
                                    iconColor:
                                        color == purple ? darkPurple : darkPink,
                                    title: "reserve".tr,
                                    onPressed: ()async {

                                   


                                      print(serviceController.selectedTime);
                                 if(guestNum == 0 || serviceController.isHospatilityDateSelcted.value == false) {
                                  AppUtil.errorToast(context, 'Enter all data');
                                 } else {

                                  
                                  
                               final isSuccess =  await  serviceController.checkAndBookHospitality(
                                    context: context, 
                                    check: false, 
                                    hospitalityId: hospitality.id, 
                                    date:serviceController.selectedDate.value, 
                                    dayId: hospitality.daysInfo[serviceController.selectedDateIndex.value].id, 
                                    numOfMale: maleGuestNum, 
                                    numOfFemale: femaleGuestNum, 
                                    cost: ( hospitality.price *guestNum  )
                                    );

                                    print("isSuccess : $isSuccess");

                                    if(isSuccess) {
                                      Get.to(() => GeneralCheckOutScreen(
                                        total: hospitality.price *guestNum ,
                                        serviceController: serviceController,
                                        hospitalityId: hospitality.id ,
                                        date: serviceController.selectedDate.value,  
                                    dayId: hospitality.daysInfo[serviceController.selectedDateIndex.value].id, 
                                    numOfMale: maleGuestNum, 
                                    numOfFemale: femaleGuestNum, 
                              
                                        ));
                                     // serviceController.hospitalityPayment(context: context, hospitalityId:  hospitality.id);
                                    }
                                 }
                                    },
                                    icon: !AppUtil.rtlDirection(context)
                                        ? const Icon(Icons.arrow_back_ios)
                                        : const Icon(Icons.arrow_forward_ios),
                                    customWidth: width * 0.5,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                            ]),
                      )),
                ),
              );
            }),
          ),
        );
      });
}
