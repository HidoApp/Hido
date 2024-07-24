import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/widgets/custom_request_text_field.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
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
  });
  int? indx;
  final RequestController requestController;
  @override
  State<ItineraryCard> createState() => _ItineraryCardState();
}

class _ItineraryCardState extends State<ItineraryCard> {
  DateTime _dateTimeFrom = DateTime.now();
  DateTime _dateTimeTo = DateTime.now();
  final _activityConroller = TextEditingController();
  final _priceContorller = TextEditingController();
  bool validItnrary = true;

  void itineraryValdiation() {
    if (_activityConroller.text.isEmpty) {
      widget.requestController.isActivtyValid(false);
    } else {
      widget.requestController.isActivtyValid(true);
    }
    if (_priceContorller.text.isEmpty) {
      widget.requestController.isPriceValid(false);
    } else {
      widget.requestController.isPriceValid(true);
    }
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
    if (_activityConroller.text.isNotEmpty &&
        _priceContorller.text.isNotEmpty &&
        widget.requestController.endtime.value.isNotEmpty &&
        widget.requestController.startTime.value.isNotEmpty) {
      widget.requestController.validSave(true);
    } else {
      widget.requestController.validSave(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => Container(
        height: widget.requestController.validSave.value
            ? width * 0.75
            : width * 0.97,
        padding: EdgeInsets.only(
            left: width * 0.030,
            top: width * 0.05,
            bottom: width * 0.05,
            right: width * 0.030),
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
                      fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',

                    ),
                  )
                ],
              ),
              SizedBox(
                height: width * 0.01,
              ),
              Obx(
                () => Padding(
                  padding:AppUtil.rtlDirection2(context)?EdgeInsets.only( right: width * 0.04): EdgeInsets.only( left: width * 0.04),
                  child: CustomTextField(
                    controller: _activityConroller,
                    keyboardType: TextInputType.text,
                    borderColor: widget.requestController.isActivtyValid.value
                        ? almostGrey
                        : colorRed,
                    onChanged: (value) {},
                    height: width * 0.09,
                    hintText: 'activityHint'.tr,
                    
                  ),
                ),
              ),
              if (!widget.requestController.isActivtyValid.value)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.053),
                  child: CustomText(
                    text: "activityError".tr,
                    color: colorRed,
                    fontSize: width * 0.028,
                     fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  ),
                ),
              SizedBox(
                height: width * 0.03,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.053),
                  child: CustomText(
                    text: "price".tr,
                    fontSize: width * 0.038,
                    fontWeight: FontWeight.w500,
                     fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  )),
              Obx(
                () => Padding(
                  padding:AppUtil.rtlDirection2(context)?EdgeInsets.only( right: width * 0.04): EdgeInsets.only( left: width * 0.04),
                  child: CustomTextField(
                    controller: _priceContorller,
                    height: width * 0.09,
                    keyboardType: TextInputType.number,
                    hintText: '00.00 ${'sar'.tr}',
                    borderColor: widget.requestController.isPriceValid.value
                        ? almostGrey
                        : colorRed,
                    onChanged: (value) {},
                  ),
                ),
              ),
              if (!widget.requestController.isPriceValid.value)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.053),
                  child: CustomText(
                    text: "priceError".tr,
                    color: colorRed,
                    fontSize: width * 0.028,
                     fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  ),
                ),
              SizedBox(
                height: width * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                         padding: EdgeInsets.symmetric(horizontal: width * 0.053),
                        child: CustomText(
                          text: "startTime".tr,
                          fontSize: width * 0.038,
                          fontWeight: FontWeight.w500,
                           fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await DatePickerBdaya.showTime12hPicker(
                            context,
                            showTitleActions: true,
                            currentTime: _dateTimeTo,
                            onConfirm: (time) {
                              _dateTimeTo = time;
                              widget.requestController.isStartTimeValid(true);
                              widget.requestController.startTime.value =
                                  DateFormat(
                                'h:mma',
                              ).format(_dateTimeTo);
                              // widget.timeTO(_timeTo.value);
                              log("   timeTo.value  ${widget.requestController.startTime.value}");
                              // requestController.requestScheduleList[index].scheduleTime!
                              //     .to = _timeTo.value;
                              // log("to ${requestController.requestScheduleList[index].scheduleTime!.to}");
                              // setState(() {});
                            },
                          );
                        },
                        child: Padding(
                  padding:AppUtil.rtlDirection2(context)?EdgeInsets.only( right: width * 0.04): EdgeInsets.only( left: width * 0.04),
                          child: Container(
                            width: width * 0.39,
                            height: width * 0.087,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.030,
                              vertical: width * 0.012,
                              
                            ),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: !widget.requestController
                                          .isStartTimeValid.value
                                      ? colorRed
                                      : almostGrey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                               // SvgPicture.asset('assets/icons/Arrows-s.svg'),
                                CustomText(
                                 fontSize: width * 0.03,

                                  text: widget.requestController.startTime.isEmpty
                                      ? ' 00:00'.tr
                                      :  AppUtil.formatStringTimeWithLocale(
                                          context,
                                         DateFormat('HH:mm:ss').format(
                                             _dateTimeTo)),
                                  color: almostGrey,
                                  fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!widget.requestController.isStartTimeValid.value)
                        Padding(
                           padding: EdgeInsets.symmetric(horizontal: width * 0.053),
                          child: CustomText(
                            text: "timeErorr".tr,
                            color: colorRed,
                            fontSize: width * 0.028,
                             fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                         padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: CustomText(
                          text: "endTime".tr,
                          fontSize: width * 0.038,
                          fontWeight: FontWeight.w500,
                           fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                        ),
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
                              setState(() {
                                // widget.timeFrom(_timeTo.value);
                                // requestController.requestScheduleList[index].scheduleTime!
                                //     .to = _timeTo.value;
                                // log("to ${requestController.requestScheduleList[index].scheduleTime!.to}");
                              });
                            },
                          );
                        },
                        child: Container(
                          width: width * 0.39,
                          height: width * 0.087,
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
                                    : almostGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(children: [
                           // SvgPicture.asset('assets/icons/Arrows-s.svg'),
                            CustomText(
                                color: almostGrey,
                                fontSize: width * 0.03,

                                 fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                                text: widget.requestController.endtime.isEmpty
                                    ? ' 00:00'.tr
                                    :  AppUtil.formatStringTimeWithLocale(
                                          context,
                                         DateFormat('HH:mm:ss').format(
                                             _dateTimeFrom))),
                          ]),
                        ),
                      ),
                      if (!widget.requestController.isEndTimeValid.value)
                        CustomText(
                          text: "timeErorr".tr,
                          color: colorRed,
                          fontSize: width * 0.028,
                           fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.requestController.itineraryList
                          .removeAt(widget.indx!);
                      widget.requestController.intinraryCount.value--;
                      widget.requestController.isActivtyValid(true);
                      widget.requestController.isPriceValid(true);
                      widget.requestController.isStartTimeValid(true);
                      widget.requestController.isEndTimeValid(true);
                      widget.requestController.validSave(true);
                      widget.requestController.endtime('');
                      widget.requestController.startTime('');
                    },
                    child: Padding(
                  padding:AppUtil.rtlDirection2(context)?EdgeInsets.only( right: width * 0.04): EdgeInsets.only( left: width * 0.04),
                      child: Container(
                        width: width * 0.36,
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
                  ),
                  // SizedBox(
                  //   width: width * 0.02,
                  // ),
                  SizedBox(
                    width: width * 0.37,
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
                              price: int.parse(_priceContorller.text),
                              scheduleName: _activityConroller.text,
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
                            _activityConroller.clear();
                            _priceContorller.clear();
                            widget.requestController.endtime('');
                            widget.requestController.startTime('');

                            widget.requestController.itineraryList
                                .add(ItineraryCard(
                              requestController: widget.requestController,
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
