import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
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
  const ItineraryCard({
    super.key,
    this.index,
  });
  final int? index;

  @override
  State<ItineraryCard> createState() => _ItineraryCardState();
}

class _ItineraryCardState extends State<ItineraryCard> {
  DateTime _dateTimeFrom = DateTime.now();
  DateTime _dateTimeTo = DateTime.now();
  var isPickedTimeTo = false;
  var isPickedTimeFrom = false;

  RxString _timeFrom =
      RxString(DateFormat('HH:mm:ss').format(DateTime.now()).toString());
  RxString _timeTo =
      RxString(DateFormat('HH:mm:ss').format(DateTime.now()).toString());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
                text: "Activity name ${widget.index}",
                fontSize: 15,
              )
            ],
          ),
          SizedBox(
            height: 4,
          ),
          CustomTextField(
            onChanged: (value) {},
            height: 42,
            hintText: 'write the activity name',
          ),
          SizedBox(
            height: 12,
          ),
          CustomText(text: "Price"),
          CustomTextField(
            height: 42,
            hintText: '00.00 SAR',
            onChanged: (value) {},
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Start time"),
                  SizedBox(
                    width: 160,
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
                    width: 160,
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
            children: [
              SizedBox(
                width: 40,
              ),
              GestureDetector(
                onTap: () {},
                child: CustomText(text: 'Cancel'),
              ),
              Spacer(),
              SizedBox(
                width: 130,
                height: 34,
                child: CustomButton(
                  raduis: 4,
                  title: 'save'.tr,
                  onPressed: () {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
