import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/ajwadi_explore_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_event_calender_dialog.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class SelectDateTime extends StatefulWidget {
  const SelectDateTime({
    Key? key,
  }) : super(key: key);

  @override
  _SelectDateTimeState createState() => _SelectDateTimeState();
}

class _SelectDateTimeState extends State<SelectDateTime> {
  final TextEditingController _textField1Controller = TextEditingController();
  int? _selectedRadio;
  final EventController _EventrController = Get.put(EventController());
  final _formKey = GlobalKey<FormState>();

  late DateTime time, returnTime, newTimeToGo = DateTime.now();

  final AjwadiExploreController ajwadiExploreController =
      Get.put(AjwadiExploreController());

  DateTime newTimeToReturn = DateTime.now();
  bool isNew = false;
  final String timeZoneName = 'Asia/Riyadh';
//  late tz.Location location;

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
                text: 'EventDate'.tr,
                color: black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
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
                          color: _EventrController.DateErrorMessage.value &&
                                  _EventrController.isEventDateSelcted.value
                              ? colorRed
                              : const Color(0xFFB9B8C1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedChoice = 3;
                          });

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      textScaler: const TextScaler.linear(1.0)),
                                  child: EventCalenderDialog(
                                    type: 'event',
                                    eventController: _EventrController,
                                  ),
                                );
                              });
                        },
                        child: CustomText(
                          text: _EventrController.isEventDateSelcted.value
                              // ? AppUtil.formatBookingDate(
                              //     context,
                              //       _EventrController.selectedDate.value)
                              ? AppUtil.formatSelectedDates(
                                  _EventrController.selectedDates, context)
                              // srvicesController.selectedDates.map((date) => intel.DateFormat('dd/MM/yyyy').format(date)).join(', ')
                              : 'DD/MM/YYYY'.tr,
                          fontWeight: FontWeight.w400,
                          color: Graytext,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => _EventrController.DateErrorMessage.value &&
                        _EventrController.isEventDateSelcted.value
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: CustomText(
                          text: AppUtil.rtlDirection2(context)
                              ? "يجب اختيار تاريخ بعد 48 ساعة من الآن على الأقل"
                              : "*Please select a date at least 48 hours from now",
                          color: colorRed,
                          fontSize: width * 0.028,
                        ),
                      )
                    : Container(),
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
                            ? "وقت البداية"
                            : "Start Time",
                        color: black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
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
                                  color: DurationErrorMessage ?? false
                                      ? colorRed
                                      : const Color(0xFFB9B8C1)),
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
                                              decoration: const BoxDecoration(
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
                                                      _EventrController
                                                          .isEventTimeSelcted(
                                                              true);
                                                      setState(() {
                                                        Get.back();
                                                        time = newTimeToGo;
                                                        _EventrController
                                                            .selectedStartTime
                                                            .value = newTimeToGo;

                                                        _EventrController
                                                                .TimeErrorMessage
                                                                .value =
                                                            AppUtil.isEndTimeLessThanStartTime(
                                                                _EventrController
                                                                    .selectedStartTime
                                                                    .value,
                                                                _EventrController
                                                                    .selectedEndTime
                                                                    .value);
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
                                                      fontFamily:
                                                          AppUtil.rtlDirection2(
                                                                  context)
                                                              ? 'SF Arabic'
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
                                                      _EventrController
                                                          .selectedStartTime
                                                          .value = newT;
                                                      //    widget.hospitalityController.selectedStartTime= intel.DateFormat('HH:mm:ss')
                                                      // .format(newTimeToGo) as RxString;
                                                      _EventrController
                                                              .TimeErrorMessage
                                                              .value =
                                                          AppUtil.isEndTimeLessThanStartTime(
                                                              _EventrController
                                                                  .selectedStartTime
                                                                  .value,
                                                              _EventrController
                                                                  .selectedEndTime
                                                                  .value);
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
                                  text: !_EventrController
                                          .isEventTimeSelcted.value
                                      ? AppUtil.rtlDirection2(context)
                                          ? "00:00 مساء"
                                          : "00 :00 PM"
                                      : AppUtil.formatStringTimeWithLocale(
                                          context,
                                          DateFormat('HH:mm:ss').format(
                                              _EventrController
                                                  .selectedStartTime.value)),
                                  fontWeight: FontWeight.w400,
                                  color: Graytext,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () => _EventrController.TimeErrorMessage.value
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: CustomText(
                                  text: '',
                                  // AppUtil.rtlDirection2(context)
                                  //     ? "اختر الوقت"
                                  //     : "Select Time",
                                  color: colorRed,
                                  fontSize: width * 0.028,
                                ),
                              )
                            : Container(),
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
                            ? "وقت النهاية"
                            : "End Time",
                        color: black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
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
                                  color:
                                      _EventrController.TimeErrorMessage.value
                                          ? colorRed
                                          : DurationErrorMessage ?? false
                                              ? colorRed
                                              : const Color(0xFFB9B8C1)),
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
                                              decoration: const BoxDecoration(
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
                                                      _EventrController
                                                          .isEventTimeSelcted(
                                                              true);
                                                      print(_EventrController
                                                          .isEventTimeSelcted
                                                          .value);
                                                      setState(() {
                                                        Get.back();
                                                        returnTime =
                                                            newTimeToReturn;
                                                        _EventrController
                                                                .selectedEndTime
                                                                .value =
                                                            newTimeToReturn;

                                                        _EventrController
                                                                .TimeErrorMessage
                                                                .value =
                                                            AppUtil.isEndTimeLessThanStartTime(
                                                                _EventrController
                                                                    .selectedStartTime
                                                                    .value,
                                                                _EventrController
                                                                    .selectedEndTime
                                                                    .value);
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
                                                    print(DateFormat('HH:mm:ss')
                                                        .format(
                                                            newTimeToReturn));
                                                    setState(() {
                                                      newTimeToReturn = newT;
                                                      _EventrController
                                                          .selectedEndTime
                                                          .value = newT;

                                                      _EventrController
                                                              .TimeErrorMessage
                                                              .value =
                                                          AppUtil.isEndTimeLessThanStartTime(
                                                              _EventrController
                                                                  .selectedStartTime
                                                                  .value,
                                                              _EventrController
                                                                  .selectedEndTime
                                                                  .value);
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
                                  text: !_EventrController
                                          .isEventTimeSelcted.value
                                      ? AppUtil.rtlDirection2(context)
                                          ? "00:00 مساء"
                                          : "00:00 PM"
                                      : AppUtil.formatStringTimeWithLocale(
                                          context,
                                          DateFormat('HH:mm:ss').format(
                                              _EventrController
                                                  .selectedEndTime.value)),
                                  fontWeight: FontWeight.w400,
                                  color: Graytext,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () => _EventrController.TimeErrorMessage.value
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: CustomText(
                                  text: AppUtil.rtlDirection2(context)
                                      ? "يجب أن لايسبق وقت بدء التجربة"
                                      : "*Can’t be before start time",
                                  fontSize: width * 0.028,
                                  color: colorRed,
                                  fontFamily: AppUtil.SfFontType(context),
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : Container(),
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
