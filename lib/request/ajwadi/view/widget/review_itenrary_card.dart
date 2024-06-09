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
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class ReivewItentraryCard extends StatefulWidget {
  ReivewItentraryCard(
      {super.key,
      required this.requestController,
      required this.indx,
      required this.schedule});
  final int indx;
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
  final _activityConroller = TextEditingController();
  final _priceContorller = TextEditingController();

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
    _activityConroller.text = widget.schedule.scheduleName!;
    _priceContorller.text = widget.schedule.price.toString();
    _controller = ExpandedTileController(isExpanded: false);
  }

  void setSchecdule() {
    widget.schedule.price = int.parse(_priceContorller.text);
    widget.schedule.scheduleName = _activityConroller.text;
    // widget.schedule.scheduleTime!.to = _timeTo.value;
    // widget.schedule.scheduleTime!.from = _timeFrom.value;
  }

  void itineraryValdiation() {
    if (_activityConroller.text.isEmpty) {
      widget.requestController.isActivtyReviewValid(false);
    } else {
      widget.requestController.isActivtyReviewValid(true);
    }
    if (_priceContorller.text.isEmpty) {
      widget.requestController.isPriceReviewValid(false);
    } else {
      widget.requestController.isPriceReviewValid(true);
    }
    if (_activityConroller.text.isNotEmpty &&
        _priceContorller.text.isNotEmpty) {
      widget.requestController.validReviewSave(true);
    } else {
      widget.requestController.validReviewSave(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      surfaceTintColor: Colors.black12,
      shadowColor: Colors.black12,
      color: Colors.white,
      child: ExpandedTile(
        onTap: () {
          //TODO : must change to obx
          setState(() {});
        },
        trailing: null,
        leading: Container(
          width: 18,
          height: 10,
          decoration:
              const BoxDecoration(color: colorGreen, shape: BoxShape.circle),
        ),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: widget.schedule.scheduleName),
                CustomText(
                  text:
                      "${widget.schedule.scheduleTime!.to!}-${widget.schedule.scheduleTime!.from!}",
                  color: almostGrey,
                  fontSize: 13,
                ),
              ],
            ),
            const Spacer(),
            CustomText(
              text: "${widget.schedule.price} ${"sar".tr}",
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
        content: Obx(
          () => Container(
            height: widget.requestController.validReviewSave.value ? 320 : 360,
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
                  keyboardType: TextInputType.name,
                  controller: _activityConroller,
                  borderColor:
                      widget.requestController.isActivtyReviewValid.value
                          ? almostGrey
                          : colorRed,
                  onChanged: (value) {},
                  height: 42,
                  hintText: 'write the activity name',
                ),
                if (!widget.requestController.isActivtyReviewValid.value)
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
                CustomText(text: "Price"),
                Obx(
                  () => CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: _priceContorller,
                    borderColor:
                        widget.requestController.isPriceReviewValid.value
                            ? almostGrey
                            : colorRed,
                    height: 42,
                    hintText: '00.00 SAR',
                    onChanged: (value) {},
                  ),
                ),
                if (!widget.requestController.isPriceReviewValid.value)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CustomText(
                      text: "*Please enter a price",
                      color: colorRed,
                    ),
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
                              await DatePickerBdaya.showTime12hPicker(
                                context,
                                currentTime: _dateTimeTo,
                                onConfirm: (time) {
                                  _dateTimeTo = time;

                                  widget.schedule.scheduleTime!.to =
                                      DateFormat('h:mma').format(_dateTimeTo);
                                  // setState(() {
                                  //   // widget.timeTO(_timeTo.value);

                                  //   // requestController.requestScheduleList[index].scheduleTime!
                                  //   //     .to = _timeTo.value;
                                  //   // log("to ${requestController.requestScheduleList[index].scheduleTime!.to}");
                                  // });
                                },
                              );
                            },
                            child: Container(
                              width: 144,
                              height: 34,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border.all(color: almostGrey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                SvgPicture.asset('assets/icons/Arrows-s.svg'),
                                CustomText(
                                    color: almostGrey,
                                    text: widget.schedule.scheduleTime!.to),
                              ]),
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
                              await DatePickerBdaya.showTime12hPicker(
                                context,
                                showTitleActions: true,
                                currentTime: _dateTimeFrom,
                                onConfirm: (time) {
                                  _dateTimeFrom = time;
                                  isPickedTimeFrom = true;
                                  widget.schedule.scheduleTime!.from =
                                      DateFormat('h:mma').format(_dateTimeFrom);
                                  log("   timeTo.value  ${_timeFrom.value}");
                                  // setState(() {
                                  //   // widget.timeFrom(_timeTo.value);
                                  //   // requestController.requestScheduleList[index].scheduleTime!
                                  //   //     .to = _timeTo.value;
                                  //   // log("to ${requestController.requestScheduleList[index].scheduleTime!.to}");
                                  // });
                                },
                              );
                            },
                            child: Container(
                              width: 144,
                              height: 34,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border.all(color: almostGrey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                SvgPicture.asset('assets/icons/Arrows-s.svg'),
                                CustomText(
                                    color: almostGrey,
                                    text: widget.schedule.scheduleTime!.from),
                              ]),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.requestController.reviewItenrary
                            .removeAt(widget.indx);
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
                      width: 147,
                      height: 34,
                      child: CustomButton(
                        raduis: 4,
                        title: 'save'.tr,
                        onPressed: () {
                          itineraryValdiation();
                          if (widget.requestController.validReviewSave.value) {
                            setSchecdule();
                            log(widget.schedule.scheduleTime!.to!);
                            log(widget.schedule.scheduleTime!.from!);
                            widget.requestController
                                .reviewItenrary[widget.indx] = widget.schedule;
                            _controller.collapse();
                          } else {
                            AppUtil.errorToast(context, "msg");
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
      ),
    );
  }
}
