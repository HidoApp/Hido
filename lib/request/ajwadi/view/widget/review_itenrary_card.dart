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
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReivewItentraryCard extends StatefulWidget {
  ReivewItentraryCard(
      {super.key,
      required this.requestController,
      this.indx,
      required this.schedule});
  int? indx;
  final RequestController requestController;
  final RequestSchedule schedule;
  @override
  State<ReivewItentraryCard> createState() => _ReivewItentraryCardState();
}

class _ReivewItentraryCardState extends State<ReivewItentraryCard> {
  DateTime _dateTimeFrom = DateTime.now();
  DateTime _dateTimeTo = DateTime.now();
  var activityName = '';
  var price = 0;
  var isPickedTimeTo = false;
  var isPickedTimeFrom = false;
  final RxString _timeFrom =
      RxString(DateFormat('HH:mm:ss').format(DateTime.now()).toString());
  final RxString _timeTo =
      RxString(DateFormat('HH:mm:ss').format(DateTime.now()).toString());
  late ExpandedTileController _controller;
  void initState() {
    // TODO: implement initState
    super.initState();
    // initialize controller
    _controller = ExpandedTileController(isExpanded: false);
  }

  void setSchecdule() {
    widget.schedule.price = price;
    widget.schedule.scheduleName = activityName;
    widget.schedule.scheduleTime!.to = _timeTo.value;
    widget.schedule.scheduleTime!.from = _timeFrom.value;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      surfaceTintColor: Colors.black12,
      shadowColor: Colors.black12,
      color: Colors.white,
      child: ExpandedTile(
        onTap: () {},
        trailing: null,
        leading: Container(
          width: 18,
          height: 10,
          decoration:
              const BoxDecoration(color: colorGreen, shape: BoxShape.circle),
        ),
        title: Row(
          children: [
            CustomText(text: widget.schedule.scheduleName),
            Spacer(),
            CustomText(
              text: "${widget.schedule.price.toString() + " " + "sar".tr}",
              color: colorGreen,
            )
          ],
        ),
        controller: _controller,
        expansionAnimationCurve: Curves.easeIn,
        disableAnimation: true,
        contentseparator: 0,
        theme: ExpandedTileThemeData(
            headerColor: Colors.white,
            titlePadding: EdgeInsets.symmetric(horizontal: 8),
            headerRadius: _controller.isExpanded ? 0 : 8,
            headerSplashColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            trailingPadding: EdgeInsets.zero),
        content: Container(
          height: 320,
          width: double.infinity,
          padding: EdgeInsets.only(left: 12, top: 20, bottom: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Activity name",
                fontSize: 15,
              ),
              SizedBox(
                height: 4,
              ),
              CustomTextField(
                // controller: _activityConroller,
                // controller: widget.activityName,
                initialValue: widget.schedule.scheduleName,
                onChanged: (value) {
                  activityName = value;
                },
                height: 42,

                hintText: 'write the activity name',
              ),
              SizedBox(
                height: 12,
              ),
              CustomText(text: "Price"),
              CustomTextField(
                initialValue: widget.schedule.price.toString(),
                height: 42,
                hintText: '00.00 SAR',
                onChanged: (value) {
                  price = int.parse(value);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            hintText: isPickedTimeTo
                                ? _timeTo.value
                                : widget.schedule.scheduleTime!.to,
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
                            hintText: isPickedTimeFrom
                                ? _timeFrom.value
                                : widget.schedule.scheduleTime!.from,
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.requestController.reviewItenrary
                          .removeAt(widget.indx!);
                    },
                    child: Container(
                      width: 147,
                      alignment: Alignment.center,
                      child: CustomText(
                        text: 'Cancel',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 147,
                    height: 34,
                    child: CustomButton(
                      raduis: 4,
                      title: 'save'.tr,
                      onPressed: () {
                        setSchecdule();
                        log(widget.schedule.scheduleName!);
                        widget.requestController.reviewItenrary[widget.indx!] =
                            widget.schedule;
                        _controller.collapse();
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
  }
}
