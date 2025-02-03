import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/calender_dialog.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/view/review_adventure_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_with_icon_button.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class ActivityBookingSheet extends StatefulWidget {
  const ActivityBookingSheet(
      {super.key,
      required this.activity,
      this.address,
      required this.avilableDate});
  final Adventure activity;
  final String? address;
  final List<DateTime> avilableDate;

  @override
  State<ActivityBookingSheet> createState() => _ActivityBookingSheetState();
}

class _ActivityBookingSheetState extends State<ActivityBookingSheet> {
  int seat = 0;

  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;
  final _activityController = Get.put(AdventureController());

  bool isDateBeforeToday() {
    DateTime parsedDate =
        DateTime.parse(_activityController.selectedDate.value);
    final parsedDateInRiyadh = tz.TZDateTime.from(parsedDate, location)
        .subtract(const Duration(hours: 3));

    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);

    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);

    Duration difference = parsedDateInRiyadh.difference(currentDateInRiyadh);

    return difference.inHours > 24;
  }

  bool isSameDay() {
    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);

    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);

    DateTime selectedDate =
        DateTime.parse(_activityController.selectedDate.value);
    DateTime Date = DateFormat('HH:mm').parse(DateFormat('hh:mm a', 'en_US')
        .format(DateTime.parse(widget.activity.daysInfo!.first.startTime)));

    DateTime hostStartDate = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, Date.hour, Date.minute, Date.second);

    DateTime bookingDeadline =
        hostStartDate.subtract(const Duration(hours: 24));

    return bookingDeadline.isBefore(currentDateInRiyadh);
  }

  bool getSeat(String availableDate) {
    for (var date in widget.activity.daysInfo!) {
      if (date.startTime.substring(0, 10) == availableDate) {
        seat = date.seats;
        log('$availableDate -> the avaliable seat in it -> $seat');

        return seat == 0;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _activityController.address(widget.address);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _activityController.isAdventureDateSelcted(false);
    _activityController.selectedDate("");
    _activityController.selectedDateIndex(-1);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Obx(
      () => Container(
        // height: width * 0.58,
        // width: double.infinity,
        padding: EdgeInsets.only(
          left: width * 0.0615,
          right: width * 0.0615,
          top: width * 0.045,
          bottom: width * 0.0820,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: width * 0.065,
            ),
            Align(
              alignment: AppUtil.rtlDirection(context)
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: CustomTextWithIconButton(
                onTap: () {
                  // setState(() {
                  //   selectedChoice = 3;
                  // });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CalenderDialog(
                          fromAjwady: false,
                          type: 'adv',
                          activity: widget.activity,
                          avilableDate: widget.avilableDate,
                          activityController: _activityController,
                        );
                      });
                },
                height: height * 0.06,
                width: double.infinity,
                title: _activityController.isAdventureDateSelcted.value
                    ? _activityController.selectedDate.value
                        .toString()
                        .substring(0, 10)
                    : 'mm/dd/yyy'.tr,
                borderColor: _activityController.DateErrorMessage.value
                    ? colorRed
                    : borderGrey,
                prefixIcon: Container(),
                suffixIcon: SvgPicture.asset(
                  "assets/icons/green_calendar.svg",
                ),
                textColor: borderGrey,
              ),
            ),
            if (_activityController.DateErrorMessage.value)
              Padding(
                padding: EdgeInsets.only(left: width * 0.01),
                child: CustomText(
                  text: AppUtil.rtlDirection2(context)
                      ? "مطلوب ادخال التاريخ "
                      : '*the date is required',
                  color: colorRed,
                  fontSize: width * 0.028,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                ),
              ),
            if (_activityController.showErrorSeat.value)
              Padding(
                padding: EdgeInsets.only(left: width * 0.01),
                child: CustomText(
                  text: AppUtil.rtlDirection2(context)
                      ? "لم تعد هناك مقاعد متاحة في هذا اليوم"
                      : 'No avaliable seat in this date ',
                  color: colorRed,
                  fontSize: width * 0.028,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                ),
              ),
            SizedBox(
              height: height * 0.01,
            ),
            CustomText(
              text: 'numberofpeorson'.tr,
              color: Colors.black,
              fontSize: width * 0.044,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              height: height * 0.06,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: width * 0.038),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.02),
                border: Border.all(
                  color: _activityController.showErrorMaxGuest.value ||
                          _activityController.showErrorGuests.value
                      ? colorRed
                      : borderGrey,
                ),
              ),
              child: Row(
                children: [
                  CustomText(
                    text: "person".tr,
                    fontWeight: FontWeight.w400,
                    color: borderGrey,
                    fontSize: width * 0.035,
                    fontFamily:
                        AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (_activityController.person.value > 0) {
                        _activityController.person.value =
                            _activityController.person.value - 1;
                        _activityController.showErrorMaxGuest.value = false;
                      }
                    },
                    // setState(() {
                    //   if (person > 0) {
                    //     person = person - 1;
                    //     _adventureController.showErrorMaxGuest.value = false;
                    //   }

                    child: const Icon(
                      Icons.horizontal_rule_outlined,
                      color: borderGrey,
                    ),
                  ),
                  SizedBox(width: width * 0.038),
                  CustomText(
                    text: _activityController.person.value.toString(),
                    fontWeight: FontWeight.w400,
                    color: borderGrey,
                    fontSize: width * 0.035,
                    fontFamily:
                        AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  ),
                  SizedBox(width: width * 0.038),
                  GestureDetector(
                    onTap: () {
                      if (_activityController.selectedDateIndex.value == -1) {
                        _activityController.DateErrorMessage.value = true;
                        return;
                      }
                      if (_activityController.person.value <
                          widget
                              .activity
                              .daysInfo![
                                  _activityController.selectedDateIndex.value]
                              .seats) {
                        _activityController.person.value =
                            _activityController.person.value + 1;
                        _activityController.showErrorGuests.value = false;
                      } else {
                        _activityController.showErrorMaxGuest.value = true;
                      }
                    },
                    child: const Icon(
                      Icons.add,
                      color: borderGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (_activityController.showErrorMaxGuest.value)
              Padding(
                padding: EdgeInsets.only(left: width * 0.01),
                child: CustomText(
                  text: AppUtil.rtlDirection2(context)
                      ? "ليس هناك مقاعد متاحة أكثر من العدد الحالي"
                      : '*There are no more seats available than the current number',
                  color: colorRed,
                  fontSize: width * 0.028,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                ),
              ),
            if (_activityController.showErrorGuests.value)
              Padding(
                padding: EdgeInsets.only(left: width * 0.01),
                child: CustomText(
                  text: AppUtil.rtlDirection2(context)
                      ? "يجب أن تختار شخص على الأقل"
                      : '*You need to add at least one guest',
                  color: colorRed,
                  fontSize: width * 0.028,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                ),
              ),
            SizedBox(
              height: width * 0.06,
            ),
            SizedBox(
              height: width * 0.06,
            ),
            CustomButton(
                onPressed: () {
                  if (_activityController.isAdventureDateSelcted.value ==
                      false) {
                    _activityController.DateErrorMessage.value = true;

                    // return;
                  }
                  if (_activityController.person.value == 0) {
                    _activityController.showErrorGuests.value = true;
                  } else if ((getSeat(_activityController.selectedDate.value
                      .substring(0, 10)))) {
                    _activityController.showErrorSeat.value = true;
                  } else {
                    _activityController.showErrorMaxGuest.value = false;

                    _activityController.showErrorGuests.value = false;
                    _activityController.showErrorSeat.value = false;
                    final isValid =
                        _activityController.checkForOneHour(context: context);
                    if (!isValid) {
                      return;
                    }
                    Get.to(() => ReviewAdventure(
                        adventure: widget.activity,
                        person: _activityController.person.value));
                    AmplitudeService.amplitude.track(
                        BaseEvent('Review Adventure Booking', eventProperties: {
                      'adventureTime':
                          '${AppUtil.formatTimeOnly(context, widget.activity.daysInfo![_activityController.selectedDateIndex.value].startTime)} -  ${AppUtil.formatTimeOnly(context, widget.activity.daysInfo![_activityController.selectedDateIndex.value].endTime)}',
                      'adventureDate': AppUtil.formatBookingDate(
                          context, _activityController.selectedDate.value),
                      'PersonNo': _activityController.person.value,
                    }));
                  }
                },
                title: 'confirm'.tr)
          ],
        ),
      ),
    );
  }
}
