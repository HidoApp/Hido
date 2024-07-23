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
    final width = MediaQuery.of(context).size.width;

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
        leading: _controller.isExpanded
            ? null
            : Container(
                width: width * 0.046,
                height: width * 0.025,
                decoration: const BoxDecoration(
                    color: colorGreen, shape: BoxShape.circle),
              ),
        title: _controller.isExpanded
            ? const SizedBox.shrink()
            : Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: widget.schedule.scheduleName),
                      CustomText(
                        text:
                            "${AppUtil.formatStringTimeWithLocale(context, widget.schedule.scheduleTime!.from!)}-${AppUtil.formatStringTimeWithLocale(context,widget.schedule.scheduleTime!.to!)}",
                        color: almostGrey,
                        fontSize: width * .03,
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
            titlePadding: EdgeInsets.symmetric(horizontal: width * 0.020),
            headerRadius: _controller.isExpanded ? 0 : 8,
            headerSplashColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            trailingPadding: EdgeInsets.zero),
        content: Obx(
          () => Container(
            height: widget.requestController.validReviewSave.value
                ? width * 0.78
                : width * 0.92,
            width: double.infinity,
            padding: EdgeInsets.only(
                left: width * 0.030,
                top: width * 0.051,
                bottom: width * 0.051,
                right: width * 0.030),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (_controller.isExpanded)
                      Container(
                        width: width * 0.046,
                        height: width * 0.025,
                        decoration: const BoxDecoration(
                            color: colorGreen, shape: BoxShape.circle),
                      ),
                    Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.016),
                      child: CustomText(
                        text: "activityName".tr,
                        fontSize: width * 0.038,
                        fontWeight: FontWeight.w500,
                           fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: width * 0.01,
                ),
                Padding(
                  padding:AppUtil.rtlDirection2(context)?EdgeInsets.only( right: width * 0.04): EdgeInsets.only( left: width * 0.04),
                  child: CustomTextField(
                    keyboardType: TextInputType.name,
                    controller: _activityConroller,
                    borderColor:
                        widget.requestController.isActivtyReviewValid.value
                            ? almostGrey
                            : colorRed,
                    onChanged: (value) {},
                    height: width * 0.09,
                    hintText: 'activityHint'.tr,
                  ),
                ),
                if (!widget.requestController.isActivtyReviewValid.value)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.53),
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
                    padding: EdgeInsets.symmetric(horizontal: width * 0.058),
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
                      keyboardType: TextInputType.number,
                      controller: _priceContorller,
                      borderColor:
                          widget.requestController.isPriceReviewValid.value
                              ? almostGrey
                              : colorRed,
                      height: width * 0.09,
                      hintText: '00.00 ${"sar".tr}',
                      onChanged: (value) {},
                    ),
                  ),
                ),
                if (!widget.requestController.isPriceReviewValid.value)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.53),
                    child: CustomText(
                      text: "priceError".tr,
                      color: colorRed,
                      fontSize: width * 0.028,
                     fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                    ),
                  ),
                SizedBox(
                  height: width * 0.051,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                         padding: EdgeInsets.symmetric(horizontal: width * 0.035),
                          child: CustomText(
                            text: "startTime".tr,
                            fontSize: width * 0.038,
                            fontWeight: FontWeight.w500,
                           fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                          ),
                        ),
                        SizedBox(
                          width: width * 0.37,
                          height: width * 0.087,
                          child: GestureDetector(
                            onTap: () async {
                              await DatePickerBdaya.showTime12hPicker(
                                context,
                                currentTime: _dateTimeTo,
                                onConfirm: (time) {
                                  _dateTimeTo = time;

                                  widget.schedule.scheduleTime!.from =
                                      DateFormat(
                                    'h:mma',
                                  ).format(_dateTimeTo);
                                  log("${widget.schedule.scheduleTime!.to}");
                                  // setState(() {
                                  //   // widget.timeTO(_timeTo.value);

                                  //   // requestController.requestScheduleList[index].scheduleTime!
                                  //   //     .to = _timeTo.value;
                                  //   // log("to ${requestController.requestScheduleList[index].scheduleTime!.to}");
                                  // });
                                },
                              );
                            },
                            child: Padding(
                  padding:AppUtil.rtlDirection2(context)?EdgeInsets.only( right: width * 0.015): EdgeInsets.only( left: width * 0.015),
                              child: Container(
                                width: width * 0.45,
                                height: width * 0.087,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.030,
                                    vertical: width * 0.015),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  border: Border.all(color: almostGrey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(children: [
                                  SvgPicture.asset('assets/icons/Arrows-s.svg'),
                                  SizedBox(width:width*0.01),
                                  CustomText(
                                      color: almostGrey,
                                      text: widget.schedule.scheduleTime!.from,
                                      fontSize: width * 0.033,
                                      fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                        SizedBox(
                          width: width * 0.4,
                          height: width * 0.087,
                          child: GestureDetector(
                            onTap: () async {
                              await DatePickerBdaya.showTime12hPicker(
                                context,
                                showTitleActions: true,
                                currentTime: _dateTimeFrom,
                                onConfirm: (time) {
                                  _dateTimeFrom = time;
                                  isPickedTimeFrom = true;
                                  widget.schedule.scheduleTime!.to = DateFormat(
                                    'h:mma',
                                  ).format(_dateTimeFrom);
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
                              width: width * 0.39,
                              height: width * 0.087,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.030,
                                  vertical: width * 0.015),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border.all(color: almostGrey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                SvgPicture.asset('assets/icons/Arrows-s.svg'),
                                   SizedBox(width:width*0.01),

                                CustomText(
                                  fontSize: width * 0.033,
                           fontFamily:AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                                    color: almostGrey,
                                    text: widget.schedule.scheduleTime!.to),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                height: width * 0.06,
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
                        width: width * 0.36,
                        height: width * 0.088,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: width * .0410),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: colorRed, width: 1),
                        ),
                        child: CustomText(
                          text: 'delete'.tr,
                          textAlign: TextAlign.center,
                          color: colorRed,
                          fontSize: width * .038,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.38,
                      height: width * 0.088,
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
                            // AppUtil.errorToast(context, "msg");
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
