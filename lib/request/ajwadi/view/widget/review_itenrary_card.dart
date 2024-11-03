import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
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
  final _formKey = GlobalKey<FormState>();

  DateTime _dateTimeFrom = DateTime.now();
  DateTime _dateTimeTo = DateTime.now();
  var activityName = '';
  var price = 0;
  final _activityConroller = TextEditingController();
  final _priceContorller = TextEditingController();

  var isPickedTimeTo = false;
  var isPickedTimeFrom = false;
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

  bool compareTime(DateTime dateTimeFromPicker) {
    String pickerTime24 = DateFormat('HH:mm:ss').format(dateTimeFromPicker);

    DateTime parsedPickerTime = DateFormat('HH:mm:ss').parse(pickerTime24);
    log("pickerTime24");
    log(pickerTime24);
    log(widget.requestController.timeToReturn.value.toString());
    log((parsedPickerTime.day == widget.requestController.timeToGo.value.day)
        .toString());

    if (widget.requestController.timeToGo.value
        .isAfter(widget.requestController.timeToReturn.value)) {
      // pm to am
      // Compare hour and minute
      return parsedPickerTime
              .isAtSameMomentAs(widget.requestController.timeToGo.value) ||
          parsedPickerTime
              .isAtSameMomentAs(widget.requestController.timeToReturn.value) ||
          !(parsedPickerTime
                  .isBefore(widget.requestController.timeToGo.value) &&
              parsedPickerTime
                  .isAfter(widget.requestController.timeToReturn.value));
    } else {
      // Compare hour and minute
      return parsedPickerTime
              .isAtSameMomentAs(widget.requestController.timeToGo.value) ||
          parsedPickerTime
              .isAtSameMomentAs(widget.requestController.timeToReturn.value) ||
          parsedPickerTime.isAfter(widget.requestController.timeToGo.value) &&
              parsedPickerTime
                  .isBefore(widget.requestController.timeToReturn.value);
    }
  }

  // bool compareTime(DateTime dateTimeFromPicker) {
  //   String pickerTime24 = DateFormat('HH:mm:ss').format(dateTimeFromPicker);
  //   DateTime parsedPickerTime = DateFormat('HH:mm:ss').parse(pickerTime24);
  //   // Compare hour and minute
  //   return parsedPickerTime
  //           .isAtSameMomentAs(widget.requestController.timeToGo.value) ||
  //       parsedPickerTime
  //           .isAtSameMomentAs(widget.requestController.timeToReturn.value) ||
  //       parsedPickerTime.isAfter(widget.requestController.timeToGo.value) &&
  //           parsedPickerTime
  //               .isBefore(widget.requestController.timeToReturn.value);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _activityConroller.dispose();
    _priceContorller.dispose();
    _controller.dispose();
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
        _priceContorller.text.isNotEmpty &&
        widget.requestController.isStartTimeReviewInRange.value &&
        widget.requestController.isEndTimeReviewInRange.value &&
        _formKey.currentState!.validate()) {
      widget.requestController.validReviewSave(true);
    } else {
      widget.requestController.validReviewSave(false);
    }
  }

  String formatTime(String time) {
    DateTime dateTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('h:mm a', AppUtil.rtlDirection2(context) ? 'ar' : 'en')
        .format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 10,
      surfaceTintColor: Colors.black12,
      shadowColor: Colors.black12,
      color: Colors.white,
      child: ExpandedTile(
        onTap: () {
          //TODO : must change to obx
          //   _controller.collapse();

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
                            "${AppUtil.formatStringTimeWithLocaleRequest(context, widget.schedule.scheduleTime!.from!)}- ${AppUtil.formatStringTimeWithLocaleRequest(context, widget.schedule.scheduleTime!.to!)}",
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
            // height: widget.requestController.validReviewSave.value
            //     ? width * 0.9
            //     : width * 0.92,
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
            child: Form(
              key: _formKey,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.016),
                        child: CustomText(
                          text: "activityName".tr,
                          fontSize: width * 0.038,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: width * 0.01,
                  ),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) => activityName = value,
                    validator: false,
                    controller: _activityConroller,
                    validatorHandle: (activity) {
                      if (activity == null || activity.isEmpty) {
                        return "activityError".tr;
                      }
                    },
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
                    controller: _priceContorller,
                    textInputAction: TextInputAction.done,
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
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      price = int.parse(value);
                    },
                  ),
                  SizedBox(
                    height: width * 0.051,
                  ),
                  Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                locale: AppUtil.rtlDirection2(context)
                                    ? LocaleType.ar
                                    : LocaleType.en,
                                currentTime: _dateTimeFrom,
                                onConfirm: (time) {
                                  _dateTimeFrom = time;
                                  log(compareTime(time).toString());
                                  widget
                                      .requestController
                                      .isStartTimeReviewInRange
                                      .value = compareTime(time);

                                  if (widget.requestController
                                      .isStartTimeInRange.value) {
                                    setState(() {
                                      widget.schedule.scheduleTime!.from =
                                          DateFormat(
                                        'h:mma',
                                      ).format(_dateTimeFrom);
                                    });
                                  }
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
                                    color: widget.requestController
                                            .isStartTimeReviewInRange.value
                                        ? borderGrey
                                        : colorRed),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                CustomText(
                                  color: starGreyColor,
                                  text:
                                      AppUtil.formatStringTimeWithLocaleRequest(
                                          context,
                                          widget.schedule.scheduleTime!.from ??
                                              '00:00'.tr),
                                  fontSize: width * 0.033,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                ),
                              ]),
                            ),
                          ),
                          if (!widget
                              .requestController.isStartTimeReviewInRange.value)
                            CustomText(
                              text: 'timeErorrRange'.tr,
                              color: colorRed,
                              fontSize: width * 0.028,
                              fontFamily: AppUtil.SfFontType(context),
                            ),
                          if (!widget
                              .requestController.isEndTimeReviewInRange.value)
                            CustomText(
                              text: '',
                              color: colorRed,
                              fontSize: width * 0.028,
                              fontFamily: AppUtil.SfFontType(context),
                            ),
                        ],
                      ),
                      const Spacer(),
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
                                locale: AppUtil.rtlDirection2(context)
                                    ? LocaleType.ar
                                    : LocaleType.en,
                                showTitleActions: true,
                                currentTime: _dateTimeTo,
                                onConfirm: (time) {
                                  _dateTimeTo = time;
                                  log(compareTime(time).toString());
                                  widget
                                      .requestController
                                      .isEndTimeReviewInRange
                                      .value = compareTime(time);

                                  widget.schedule.scheduleTime!.to = DateFormat(
                                    'h:mma',
                                  ).format(_dateTimeTo);
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
                                    color: widget.requestController
                                            .isEndTimeReviewInRange.value
                                        ? borderGrey
                                        : colorRed),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                // SvgPicture.asset('assets/icons/Arrows-s.svg'),
                                //  SizedBox(width:width*0.01),
                                CustomText(
                                  fontSize: width * 0.033,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  color: starGreyColor,
                                  text:
                                      AppUtil.formatStringTimeWithLocaleRequest(
                                          context,
                                          widget.schedule.scheduleTime!.to ??
                                              '00:00'.tr),
                                )
                              ]),
                            ),
                          ),
                          if (!widget
                              .requestController.isEndTimeReviewInRange.value)
                            CustomText(
                              text: 'timeErorrRange'.tr,
                              color: colorRed,
                              fontSize: width * 0.028,
                              fontFamily: AppUtil.SfFontType(context),
                            ),
                          if (!widget
                              .requestController.isStartTimeReviewInRange.value)
                            CustomText(
                              text: '',
                              color: colorRed,
                              fontSize: width * 0.028,
                              fontFamily: AppUtil.SfFontType(context),
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
                          widget.requestController.reviewItenrary
                              .removeAt(widget.indx);
                          widget.requestController.startTime('');
                          widget.requestController.endtime('');
                        },
                        child: Container(
                          width: width * 0.38,
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
                            fontFamily: 'HT Rakik',
                            fontSize: width * .038,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: width * 0.38,
                        height: width * 0.088,
                        child: CustomButton(
                          raduis: 4,
                          title: 'save'.tr,
                          onPressed: () {
                            itineraryValdiation();
                            if (widget
                                .requestController.validReviewSave.value) {
                              setSchecdule();
                              log(widget.schedule.scheduleTime!.to!);
                              log(widget.schedule.scheduleTime!.from!);
                              widget.requestController
                                      .reviewItenrary[widget.indx] =
                                  widget.schedule;
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
      ),
    );
  }
}
