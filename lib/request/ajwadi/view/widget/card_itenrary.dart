import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/widgets/custom_request_text_field.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ItineraryCard extends StatefulWidget {
  ItineraryCard({
    super.key,
    this.indx,
    required this.requestController,
  });
  int? indx;
  final RequestController requestController;
  // final void Function() onAccepted;
  // final void Function() onCanceld;
  // final TextEditingController activityName;
  // final TextEditingController price;
  // final Function(String timeTo) timeTO;
  // final Function(String timeFrom) timeFrom;

  @override
  State<ItineraryCard> createState() => _ItineraryCardState();
}

class _ItineraryCardState extends State<ItineraryCard> {
  DateTime _dateTimeFrom = DateTime.now();
  DateTime _dateTimeTo = DateTime.now();
  var isPickedTimeTo = false;
  var isPickedTimeFrom = false;
  final _activityConroller = TextEditingController();
  final _priceContorller = TextEditingController();

  final _timeFrom =
      RxString(DateFormat('HH:mm:ss').format(DateTime.now()).toString());
  final _timeTo =
      RxString(DateFormat('HH:mm:ss').format(DateTime.now()).toString());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      padding: EdgeInsets.only(left: 12, top: 20, bottom: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 10,
                decoration:
                    BoxDecoration(color: colorGreen, shape: BoxShape.circle),
              ),
              SizedBox(
                width: 8,
              ),
              CustomText(
                text: "Activity name ${widget.indx}",
                fontSize: 15,
              )
            ],
          ),
          SizedBox(
            height: 4,
          ),
          CustomTextField(
            controller: _activityConroller,
            onChanged: (value) {
              print(value);
            },
            height: 42,
            hintText: 'write the activity name',
          ),
          SizedBox(
            height: 12,
          ),
          CustomText(text: "Price"),
          CustomTextField(
            controller: _priceContorller,
            height: 42,
            hintText: '00.00 SAR',
            onChanged: (value) {
              print(value);
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Start time"),
                  SizedBox(
                    width: 144,
                    height: 42,
                    child: GestureDetector(
                      onTap: () async {
                        await DatePickerBdaya.showTimePicker(
                          context,
                          showTitleActions: true,
                          currentTime: _dateTimeTo,
                          onConfirm: (time) {
                            setState(() {
                              _dateTimeTo = time;
                              isPickedTimeTo = true;
                              _timeTo.value =
                                  DateFormat('HH:mm').format(_dateTimeTo);
                              // widget.timeTO(_timeTo.value);
                              log("   timeTo.value  ${_timeTo.value}");
                              // requestController.requestScheduleList[index].scheduleTime!
                              //     .to = _timeTo.value;
                              // log("to ${requestController.requestScheduleList[index].scheduleTime!.to}");
                            });
                          },
                        );
                      },
                      child: CustomTextField(
                        enable: false,
                        hintText: isPickedTimeTo ? _timeTo.value : '00:00'.tr,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "End time"),
                  SizedBox(
                    width: 144,
                    height: 42,
                    child: GestureDetector(
                      onTap: () async {
                        await DatePickerBdaya.showTimePicker(
                          context,
                          showTitleActions: true,
                          currentTime: _dateTimeFrom,
                          onConfirm: (time) {
                            setState(() {
                              _dateTimeFrom = time;
                              isPickedTimeFrom = true;
                              _timeFrom.value =
                                  DateFormat('HH:mm').format(_dateTimeFrom);
                              log("   timeTo.value  ${_timeFrom.value}");
                              // widget.timeFrom(_timeTo.value);
                              // requestController.requestScheduleList[index].scheduleTime!
                              //     .to = _timeTo.value;
                              // log("to ${requestController.requestScheduleList[index].scheduleTime!.to}");
                            });
                          },
                        );
                      },
                      child: CustomTextField(
                        enable: false,
                        hintText:
                            isPickedTimeFrom ? _timeFrom.value : '00:00'.tr,
                        onChanged: (value) {},
                      ),
                    ),
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
                onTap: () {},
                child: Align(
                  child: CustomText(
                    text: 'Cancel',
                    textAlign: TextAlign.center,
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
                    if (_activityConroller.text.isEmpty ||
                        _timeTo.value.isEmpty ||
                        _priceContorller.text.isEmpty ||
                        _timeFrom.value.isEmpty) {
                      AppUtil.errorToast(context, "empty field");
                      return;
                    }
                    widget.requestController.reviewItenrary.add(
                      RequestSchedule(
                        price: int.parse(_priceContorller.text),
                        scheduleName: _activityConroller.text,
                        scheduleTime: ScheduleTime(
                            to: _timeTo.value, from: _timeFrom.value),
                      ),
                    );
                    log("${widget.requestController.reviewItenrary.length}");
                    widget.requestController.itineraryList
                        .removeAt(widget.indx!);
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
    // : Container(
    //     height: 50,
    //     width: 360,
    //     color: colorGreen,
    //   );
  }
}
