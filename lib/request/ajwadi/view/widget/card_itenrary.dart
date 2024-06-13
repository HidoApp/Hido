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
    return Obx(
      () => Container(
        height: widget.requestController.validSave.value ? 320 : 380,
        padding: EdgeInsets.only(left: 12, top: 20, bottom: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 18,
                    height: 10,
                    decoration: BoxDecoration(
                        color: colorGreen, shape: BoxShape.circle),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CustomText(
                    text: "Activity name ",
                    fontSize: 15,
                  )
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Obx(
                () => CustomTextField(
                  controller: _activityConroller,
                  keyboardType: TextInputType.text,
                  borderColor: widget.requestController.isActivtyValid.value
                      ? almostGrey
                      : colorRed,
                  onChanged: (value) {
                    print(value);
                  },
                  height: 42,
                  hintText: 'write the activity name',
                ),
              ),
              if (!widget.requestController.isActivtyValid.value)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: CustomText(
                    text: "*this field is requested",
                    color: colorRed,
                  ),
                ),
              SizedBox(
                height: 12,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: CustomText(text: "Price")),
              Obx(
                () => CustomTextField(
                  controller: _priceContorller,
                  height: 42,
                  keyboardType: TextInputType.number,
                  hintText: '00.00 SAR',
                  borderColor: widget.requestController.isPriceValid.value
                      ? almostGrey
                      : colorRed,
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
              if (!widget.requestController.isPriceValid.value)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: CustomText(
                    text: "*Please enter a price",
                    color: colorRed,
                  ),
                ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(text: "Start time"),
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
                                  DateFormat('h:mma').format(_dateTimeTo);
                              // widget.timeTO(_timeTo.value);
                              log("   timeTo.value  ${widget.requestController.startTime.value}");
                              // requestController.requestScheduleList[index].scheduleTime!
                              //     .to = _timeTo.value;
                              // log("to ${requestController.requestScheduleList[index].scheduleTime!.to}");
                              // setState(() {});
                            },
                          );
                        },
                        child: Container(
                          width: 144,
                          height: 34,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            border: Border.all(color: almostGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/icons/Arrows-s.svg'),
                              CustomText(
                                text: widget.requestController.startTime.isEmpty
                                    ? '00:00'.tr
                                    : widget.requestController.startTime.value,
                                color: almostGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!widget.requestController.isStartTimeValid.value)
                        CustomText(
                          text: "*time is required",
                          color: colorRed,
                        ),
                    ],
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "End time"),
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
                                  DateFormat('h:mma').format(_dateTimeFrom);
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
                          width: 144,
                          height: 34,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            border: Border.all(color: almostGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(children: [
                            SvgPicture.asset('assets/icons/Arrows-s.svg'),
                            CustomText(
                                color: almostGrey,
                                text: widget.requestController.endtime.isEmpty
                                    ? '00:00'.tr
                                    : widget.requestController.endtime.value),
                          ]),
                        ),
                      ),
                      if (!widget.requestController.isEndTimeValid.value)
                        CustomText(
                          text: "*time is required",
                          color: colorRed,
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.requestController.itineraryList
                          .removeAt(widget.indx!);
                      widget.requestController.intinraryCount.value--;
                    },
                    child: Container(
                      width: 130,
                      height: 34,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: colorRed, width: 1),
                      ),
                      child: CustomText(
                        text: 'delete'.tr,
                        textAlign: TextAlign.center,
                        color: colorRed,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 130,
                    height: 34,
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
                                  to: widget.requestController.startTime.value,
                                  from: widget.requestController.endtime.value),
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
                          AppUtil.errorToast(context, "empty field");
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
