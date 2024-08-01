import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/widgets/custom_request_text_field.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart' as book;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

class ItineraryCard extends StatefulWidget {
  ItineraryCard({
    super.key,
    this.indx,
    required this.requestController,
    required this.booking,
  });
  int? indx;
  final book.Booking booking;
  final RequestController requestController;

  @override
  State<ItineraryCard> createState() => _ItineraryCardState();
}

class _ItineraryCardState extends State<ItineraryCard> {
  DateTime _dateTimeFrom = DateTime.now();
  DateTime _dateTimeTo = DateTime.now();
  DateTime? _timeToGo;
  DateTime? _timeToReturn;
  var startTime = '';
  final _formKey = GlobalKey<FormState>();
  var price = 0;
  var activity = '';
  bool validItnrary = true;

  void itineraryValdiation() {
    _formKey.currentState!.validate();
    if (widget.requestController.startTime.value.isEmpty) {
      widget.requestController.isStartTimeValid(false);
    } else {
      widget.requestController.isStartTimeValid(true);
    }
    if (widget.requestController.endtime.value.isEmpty) {
      widget.requestController.isEndTimeValid(false);
    } else {
      widget.requestController.isEndTimeValid(true);
    }
    if (widget.requestController.endtime.value.isNotEmpty &&
        widget.requestController.startTime.value.isNotEmpty) {
      widget.requestController.validSave(true);
    } else {
      widget.requestController.validSave(false);
    }
  }

  bool compareTime(DateTime time, DateTime dateTimeFromPicker) {
    // Parse the 24-hour format time string to DateTime
    // DateTime parsedStringTime = DateFormat('HH:mm:ss').parse(stringTime24);

    String pickerTime24 = DateFormat('HH:mm:ss').format(dateTimeFromPicker);
    DateTime parsedPickerTime = DateFormat('HH:mm:ss').parse(pickerTime24);

    log(_timeToGo!.hour.toString());
    log(_timeToGo!.minute.toString());
    log(parsedPickerTime.hour.toString());
    log(parsedPickerTime.minute.toString());
    // Extract hour and minute from both DateTime objects
    int stringTimeHour = _timeToGo!.hour;
    int stringTimeMinute = _timeToGo!.minute;

    int pickerTimeHour = parsedPickerTime.hour;
    int pickerTimeMinute = parsedPickerTime.minute;

    // Compare hour and minute
    if (stringTimeHour >= pickerTimeHour) {
      if (stringTimeMinute >= pickerTimeMinute) {
        return true;
      }
      return false; // time to go is after pickerTime
    } else {
      return false; // time to go is before or the same as pickerTime
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timeToGo = DateFormat('HH:mm:ss').parse(widget.booking.timeToGo!);

    _timeToReturn = DateFormat('HH:mm:ss').parse(widget.booking.timeToReturn!);
  }

  @override
  Widget build(BuildContext context) {
    log(widget.booking.timeToGo ?? "");
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => Container(
        height:
            widget.requestController.validSave.value ? width * 0.86 : width * 1,
        padding: EdgeInsets.only(
          left: width * 0.030,
          top: width * 0.05,
          bottom: width * 0.05,
          right: width * 0.05,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0x3FC7C7C7),
                blurRadius: 15,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ]),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: width * 0.025,
                    height: width * 0.025,
                    decoration: const BoxDecoration(
                        color: colorGreen, shape: BoxShape.circle),
                  ),
                  // SizedBox(
                  //   width: width * .0205,
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.028),
                    child: CustomText(
                      text: "activityName".tr,
                      fontSize: width * 0.038,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                    ),
                  )
                ],
              ),
              SizedBox(
                height: width * 0.01,
              ),
              CustomTextField(
                keyboardType: TextInputType.text,
                onChanged: (value) => activity = value,
                validator: false,
                validatorHandle: (activity) {
                  if (activity == null || activity.isEmpty) {
                    return "activityError".tr;
                  }
                },
                //  height: 40,
                //  height: width * 0.09,
                hintText: 'activityHint'.tr,
              ),
              SizedBox(
                height: width * 0.03,
              ),
              CustomText(
                text: "price".tr,
                fontSize: width * 0.038,
                fontWeight: FontWeight.w500,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              ),
              CustomTextField(
                validator: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                hintText: '00.00 ${'sar'.tr}',
                validatorHandle: (price) {
                  if (price == null || price.isEmpty) {
                    return 'fieldRequired'.tr;
                  }
                  if (int.parse(price) < 30) {
                    return '*TheMinimumPrice'.tr;
                  }
                },
                onChanged: (value) => price = int.parse(value),
              ),
              SizedBox(
                height: width * 0.035,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "startTime".tr,
                        fontSize: width * 0.038,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      ),
                      GestureDetector(
                        onTap: () async {
                          await DatePickerBdaya.showTime12hPicker(
                            context,
                            showTitleActions: true,
                            currentTime: _dateTimeTo,
                            onConfirm: (time) {
                              _dateTimeTo = time;
                              log(compareTime(_timeToGo!, time).toString());

                              widget.requestController.startTime.value =
                                  DateFormat(
                                'h:mm a',
                              ).format(_dateTimeTo);
                              // widget.timeTO(_timeTo.value);
                              log("   timeTo.value  ${widget.requestController.startTime.value}");

                              // requestController.requestScheduleList[index].scheduleTime!
                              //     .to = _timeTo.value;
                              // log("to ${requestController.requestScheduleList[index].scheduleTime!.to}");
                              // setState(() {});
                              widget.requestController.isStartTimeValid(true);
                            },
                          );
                        },
                        child: Container(
                          width: width * 0.39,
                          height: width * 0.11,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.030,
                            vertical: 0,
                          ),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: widget.requestController.isStartTimeValid
                                        .value
                                    ? colorRed
                                    : borderGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              // SvgPicture.asset('assets/icons/Arrows-s.svg'),
                              CustomText(
                                fontSize: width * 0.03,
                                text: widget.requestController.startTime.isEmpty
                                    ? ' 00:00'.tr
                                    : AppUtil.formatStringTimeWithLocale(
                                        context,
                                        DateFormat('HH:mm:ss')
                                            .format(_dateTimeTo)),
                                color: almostGrey,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!widget.requestController.isStartTimeValid.value)
                        CustomText(
                          text: "timeError".tr,
                          color: colorRed,
                          fontSize: width * 0.028,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                        ),
                    ],
                  ),
                  // SizedBox(
                  //   width: width * 0.04,
                  // ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "endTime".tr,
                        fontSize: width * 0.038,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      ),
                      GestureDetector(
                        onTap: () async {
                          await DatePickerBdaya.showTime12hPicker(
                            context,
                            showTitleActions: true,
                            currentTime: _dateTimeFrom,
                            onConfirm: (time) {
                              _dateTimeFrom = time;
                              widget.requestController.isEndTimeValid(true);
                              widget.requestController.endtime.value =
                                  DateFormat(
                                'h:mma',
                              ).format(_dateTimeFrom);
                              log("   timeTo.value  ${widget.requestController.endtime.value}");
                            },
                          );
                        },
                        child: Container(
                          width: width * 0.40,
                          height: width * 0.11,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.030,
                            vertical: width * 0.012,
                          ),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: !widget
                                        .requestController.isEndTimeValid.value
                                    ? colorRed
                                    : borderGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(children: [
                            // SvgPicture.asset('assets/icons/Arrows-s.svg'),
                            CustomText(
                                color: almostGrey,
                                fontSize: width * 0.03,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                text: widget.requestController.endtime.isEmpty
                                    ? ' 00:00'.tr
                                    : AppUtil.formatStringTimeWithLocale(
                                        context,
                                        DateFormat('HH:mm:ss')
                                            .format(_dateTimeFrom))),
                          ]),
                        ),
                      ),
                      if (!widget.requestController.isEndTimeValid.value)
                        CustomText(
                          text: "timeError".tr,
                          color: colorRed,
                          fontSize: width * 0.028,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.06,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.requestController.itineraryList
                          .removeAt(widget.indx!);
                      widget.requestController.intinraryCount.value--;
                      widget.requestController.isStartTimeValid(true);
                      widget.requestController.isEndTimeValid(true);
                      widget.requestController.validSave(true);
                      widget.requestController.endtime('');
                      widget.requestController.startTime('');
                    },
                    child: Container(
                      width: width * 0.38,
                      height: width * 0.088,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: width * .0410),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: colorRed, width: 1),
                      ),
                      child: CustomText(
                        text: 'delete'.tr,
                        textAlign: TextAlign.center,
                        color: colorRed,
                        fontSize: width * 0.038,
                        fontFamily: 'HT Rakik',
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: width * 0.02,
                  // ),
                  Spacer(),
                  SizedBox(
                    width: width * 0.38,
                    height: width * 0.088,
                    child: CustomButton(
                      raduis: 4,
                      title: 'save'.tr,
                      onPressed: () {
                        itineraryValdiation();
                        log(widget.requestController.validSave.value
                            .toString());
                        if (widget.requestController.validSave.value) {
                          widget.requestController.reviewItenrary.add(
                            RequestSchedule(
                              price: price,
                              scheduleName: activity,
                              scheduleTime: ScheduleTime(
                                  to: widget.requestController.endtime.value,
                                  from:
                                      widget.requestController.startTime.value),
                            ),
                          );

                          log("${widget.requestController.reviewItenrary.length}");
                          widget.requestController.itineraryList.removeLast();
                          widget.requestController.intinraryCount--;
                          if (widget.requestController.reviewItenrary.length <
                              3) {
                            activity = '';
                            price = 0;
                            widget.requestController.endtime('');
                            widget.requestController.startTime('');

                            widget.requestController.itineraryList
                                .add(ItineraryCard(
                              requestController: widget.requestController,
                              booking: widget.booking,
                              indx:
                                  widget.requestController.intinraryCount.value,
                            ));
                            widget.requestController.intinraryCount++;
                          }
                        } else {
                          // AppUtil.errorToast(context, "empty field");
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    // : Container(
    //     height: 50,
    //     width: 360,
    //     color: colorGreen,
    //   );
  }
}
