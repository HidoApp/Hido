import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/ajwadi_explore_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_hospitality_calender_dialog.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SelectDateTime extends StatefulWidget {
  SelectDateTime({
    Key? key,
    required this.adventureController,
    required this.ajwadiExploreController,
  }) : super(key: key);

  final AdventureController adventureController;
  final AjwadiExploreController? ajwadiExploreController;

  @override
  _SelectDateTimeState createState() => _SelectDateTimeState();
}

class _SelectDateTimeState extends State<SelectDateTime> {
  final TextEditingController _textField1Controller = TextEditingController();
  int? _selectedRadio;

  final _formKey = GlobalKey<FormState>();

  late DateTime time, returnTime, newTimeToGo = DateTime.now();

  DateTime newTimeToReturn = DateTime.now();
  bool isNew = false;
  final String timeZoneName = 'Asia/Riyadh';
//  late tz.Location location;
  bool? DateErrorMessage;
  bool? TimeErrorMessage;
  bool? DurationErrorMessage;

  bool? GuestErrorMessage;
  bool? vehicleErrorMessage;
  int selectedChoice = 3;
  // final srvicesController = Get.put(HospitalityController());

// late final HospitalityController serviceController;
  // late final Hospitality? hospitality;

  //var locLatLang = const LatLng(24.9470921, 45.9903698);
  //late DateTime newTimeToGoInRiyadh;
  

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: width * 0.012,
              ),
              CustomText(
                text: 'AvailableDates'.tr,
                color: black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: AppUtil.rtlDirection2(context)?'SF Arabic'
                          : 'SF Pro',
              ),
              SizedBox(
                height: width * 0.02,
              ),
              Obx(
                () => Container(
                  width: double.infinity,
                  height: height * 0.063,
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1,
                          color: DateErrorMessage ?? false
                              ? Colors.red
                              : Color(0xFFB9B8C1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("object");
                          setState(() {
                            selectedChoice = 3;
                          });

                        showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return HostCalenderDialog(
                                  type: 'adv',
                                  advController: widget.adventureController,
                                  ajwadiExploreController: widget.ajwadiExploreController,
                                );
                              });
                        },
                        child: CustomText(
                          text:widget
                                .adventureController.isAdventureDateSelcted
                                 .value
                              ? AppUtil.formatBookingDate(
                                  context,
                                    widget.adventureController.selectedDate.value)
                              //formatSelectedDates(srvicesController.selectedDates,context)
                              // srvicesController.selectedDates.map((date) => intel.DateFormat('dd/MM/yyyy').format(date)).join(', ')
                              : 'DD/MM/YYYY'.tr,
                          fontWeight: FontWeight.w400,
                          color: Graytext,
                fontFamily:AppUtil.rtlDirection2(context)?'SF Arabic': 'SF Pro',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (DateErrorMessage ?? false)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    AppUtil.rtlDirection2(context)
                        ? "اختر التاريخ"
                        : "Select Date",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppUtil.rtlDirection2(context)
                            ? "وقت الذهاب"
                            : "Start Time",
                        color: black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                          fontFamily: AppUtil.rtlDirection2(context)?'SF Arabic'
                          : 'SF Pro',
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Align(
                        alignment: AppUtil.rtlDirection(context)
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          height: height * 0.06,
                          width: width * 0.41,
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: TimeErrorMessage ?? false
                                      ? Colors.red
                                      : DurationErrorMessage ?? false
                                          ? Colors.red
                                          : Color(0xFFB9B8C1)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xffffffff),
                                                border: Border(
                                                  bottom: BorderSide(
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
                                                      widget.
                                                          adventureController.isAdventureTimeSelcted
                                                         (
                                                              true);
                                                      setState(() {
                                                        Get.back();
                                                        time = newTimeToGo;
                                                        widget
                                                            .adventureController
                                                            .selectedStartTime
                                                            .value = newTimeToGo;
                                                        //  widget.hospitalityController.selectedStartTime= intel.DateFormat('HH:mm:ss')
                                                        //   .format(newTimeToGo) as RxString;
                                                      });
                                                    },
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 5.0,
                                                    ),
                                                    child: CustomText(
                                                      text: "confirm".tr,
                                                      color: colorGreen,
                                                      fontSize: 15,
                                                      fontFamily: AppUtil.rtlDirection2(context)?'SF Arabic'
                                                      : 'SF Pro',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 220,
                                              width: width,
                                              margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: Container(
                                                width: width,
                                                color: Colors.white,
                                                child: CupertinoDatePicker(
                                                  backgroundColor: Colors.white,
                                                  initialDateTime: newTimeToGo,
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  use24hFormat: false,
                                                  onDateTimeChanged:
                                                      (DateTime newT) {
                                                    setState(() {
                                                      newTimeToGo = newT;
                                                      widget
                                                          .adventureController
                                                          .selectedStartTime
                                                          .value = newT;
                                                      //    widget.hospitalityController.selectedStartTime= intel.DateFormat('HH:mm:ss')
                                                      // .format(newTimeToGo) as RxString;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: CustomText(
                                  text: !widget.adventureController.isAdventureTimeSelcted
                                          .value
                                      ? AppUtil.rtlDirection2(context)
                                          ? "00:00 مساء"
                                          : "00 :00 PM"
                                      : AppUtil.formatStringTimeWithLocale(
                                          context,
                                         DateFormat('HH:mm:ss').format(
                                              widget.adventureController
                                                  .selectedStartTime.value)),
                                  // : intel.DateFormat('hh:mm a').format(
                                  //     widget.hospitalityController
                                  //         .selectedStartTime.value),
                                  fontWeight: FontWeight.w400,
                                  color: Graytext,
                                  fontFamily: AppUtil.rtlDirection2(context)?'SF Arabic'
                                  : 'SF Pro',
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (TimeErrorMessage ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            AppUtil.rtlDirection2(context)
                                ? "اختر الوقت"
                                : "Select Time",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppUtil.rtlDirection2(context)
                            ? "وقت العودة"
                            : "End Time",
                        color: black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppUtil.rtlDirection2(context)?'SF Arabic'
                        : 'SF Pro',
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Align(
                        alignment: AppUtil.rtlDirection(context)
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          height: height * 0.06,
                          width: width * 0.41,
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: TimeErrorMessage ?? false
                                      ? Colors.red
                                      : DurationErrorMessage ?? false
                                          ? Colors.red
                                          : Color(0xFFB9B8C1)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xffffffff),
                                                border: Border(
                                                  bottom: BorderSide(
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
                                                      widget
                                                          .adventureController
                                                          .isAdventureTimeSelcted(
                                                              true);
                                                      print(widget
                                                          .adventureController
                                                          .isAdventureTimeSelcted
                                                          .value);
                                                      setState(() {
                                                        Get.back();
                                                        returnTime =
                                                            newTimeToReturn;
                                                        widget
                                                                .adventureController
                                                                .selectedEndTime
                                                                .value =
                                                            newTimeToReturn;
                                                        //      widget.hospitalityController.selectedStartTime= intel.DateFormat('HH:mm:ss')
                                                        // .format( newTimeToReturn) as RxString;
                                                      });
                                                    },
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 5.0,
                                                    ),
                                                    child: CustomText(
                                                      text: "confirm".tr,
                                                      color: colorGreen,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 220,
                                              width: width,
                                              margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: Container(
                                                width: width,
                                                color: Colors.white,
                                                child: CupertinoDatePicker(
                                                  backgroundColor: Colors.white,
                                                  initialDateTime:
                                                      newTimeToReturn,
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  use24hFormat: false,
                                                  onDateTimeChanged:
                                                      (DateTime newT) {
                                                    print(DateFormat(
                                                            'HH:mm:ss')
                                                        .format(
                                                            newTimeToReturn));
                                                    setState(() {
                                                      newTimeToReturn = newT;
                                                      widget
                                                          .adventureController
                                                          .selectedEndTime
                                                          .value = newT;

                                                      //  widget.hospitalityController.selectedStartTime= intel.DateFormat('HH:mm:ss')
                                                      //     .format( newTimeToReturn) as RxString;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: CustomText(
                                  text: !widget.adventureController.isAdventureTimeSelcted
                                         .value
                                      ? AppUtil.rtlDirection2(context)
                                          ? "00:00 مساء"
                                          : "00 :00 PM"
                                      : AppUtil.formatStringTimeWithLocale(
                                          context,
                                          DateFormat('HH:mm:ss').format(
                                              widget.adventureController
                                                  .selectedEndTime.value)),
                                  // : intel.DateFormat('hh:mm a').format(
                                  //     widget.hospitalityController
                                  //         .selectedEndTime.value),
                                  fontWeight: FontWeight.w400,
                                  color: Graytext,
                                  fontFamily: AppUtil.rtlDirection2(context)?'SF Arabic'
                                  :'SF Pro',
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (TimeErrorMessage ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            AppUtil.rtlDirection2(context)
                                ? "اختر الوقت"
                                : "Select Time",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
             
            ],
          ),
        ),
      ],
    );
  }
}