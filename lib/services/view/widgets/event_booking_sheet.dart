import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/app_constants.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/local/view/calender_dialog.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/view/event_review.dart';
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

class EventBookingSheet extends StatefulWidget {
  const EventBookingSheet(
      {super.key, this.event, this.avilableDate, this.address});
  final Event? event;
  final List<DateTime>? avilableDate;
  final String? address;

  @override
  State<EventBookingSheet> createState() => _EventBookingSheetState();
}

class _EventBookingSheetState extends State<EventBookingSheet> {
  final _eventController = Get.put(EventController());
  int selectedChoice = 3;

  int guestNum = 0;
  bool showErrorGuests = false;
  bool showErrorDate = false;
  bool showErrorSeat = false;
  bool showErrorMaxGuest = false;
  int seat = 0;
  int totalFreeSeats = 0;
  int person = 0;
  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;

  bool isDateBeforeToday() {
    DateTime parsedDate = DateTime.parse(_eventController.selectedDate.value);
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

    DateTime selectedDate = DateTime.parse(_eventController.selectedDate.value);
    DateTime Date = DateFormat('HH:mm').parse(DateFormat('hh:mm a', 'en_US')
        .format(DateTime.parse(widget.event!.daysInfo!.first.startTime)));

    DateTime hostStartDate = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, Date.hour, Date.minute, Date.second);

    DateTime bookingDeadline =
        hostStartDate.subtract(const Duration(hours: 24));

    return bookingDeadline.isBefore(currentDateInRiyadh);
  }

  bool getSeat(String availableDate) {
    for (var date in widget.event!.daysInfo!) {
      if (date.startTime.substring(0, 10) == availableDate) {
        seat = date.seats;
        log('$availableDate -> the avaliable seat in it -> $seat');

        return seat == 0;
      }
    }
    return false;
  }

  void validateFreeSeat() {
    // check if seat in daysInfo < event free seat
    if (widget
            .event!.daysInfo![_eventController.selectedDateIndex.value].seats >
        widget.event!.totalSeats) {
      // then check if total seat is < 5 which is constant called freeSeatCap
      if (widget.event!.totalSeats < freeSeatCap &&
          person < freeSeatCap - widget.event!.totalSeats) {
        // person ++
        setState(() {
          person = person + 1;
          showErrorGuests = false;
        });
      } else {
        _eventController.showErrorMaxGuest.value = true;
      }
    }

    // if (person < totalFreeSeats) {
    //   setState(() {
    //     person = person + 1;
    //     showErrorGuests = false;
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    _eventController.address(widget.address);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _eventController.isEventDateSelcted(false);
    _eventController.selectedDate("");
    _eventController.selectedDateIndex(-1);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    _eventController.showErrorMaxGuest.value = false;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: width * 0.0615,
        right: width * 0.0615,
        top: width * 0.045,
        bottom: width * 0.0820,
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: width * 0.065,
            ),
            CustomText(
              text: 'date'.tr,
              color: Colors.black,
              fontSize: width * 0.044,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Align(
              alignment: AppUtil.rtlDirection(context)
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: CustomTextWithIconButton(
                onTap: () {
                  setState(() {
                    selectedChoice = 3;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CalenderDialog(
                          fromAjwady: false,
                          type: 'event',
                          avilableDate: widget.avilableDate,
                          eventController: _eventController,
                          event: widget.event,
                        );
                      });
                },
                height: height * 0.06,
                width: double.infinity,
                title: _eventController.isEventDateSelcted.value
                    ? _eventController.selectedDate.value
                        .toString()
                        .substring(0, 10)
                    : 'mm/dd/yyy'.tr,
                borderColor: _eventController.DateErrorMessage.value
                    ? colorRed
                    : borderGrey,
                prefixIcon: Container(),
                suffixIcon: SvgPicture.asset(
                  "assets/icons/green_calendar.svg",
                ),
                textColor: borderGrey,
              ),
            ),
            if (_eventController.DateErrorMessage.value)
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
            if (showErrorSeat)
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
                  color: _eventController.showErrorMaxGuest.value ||
                          showErrorGuests
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
                      setState(() {
                        if (person > 0) {
                          person = person - 1;
                          _eventController.showErrorMaxGuest.value = false;
                        }
                      });
                    },
                    child: const Icon(
                      Icons.horizontal_rule_outlined,
                      color: borderGrey,
                    ),
                  ),
                  SizedBox(width: width * 0.038),
                  CustomText(
                    text: person.toString(),
                    fontWeight: FontWeight.w400,
                    color: borderGrey,
                    fontSize: width * 0.035,
                    fontFamily:
                        AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  ),
                  SizedBox(width: width * 0.038),
                  GestureDetector(
                    onTap: () {
                      if (_eventController.selectedDateIndex.value == -1) {
                        _eventController.DateErrorMessage.value = true;
                        return;
                      }

                      if (widget.event!.price == 0) {
                        validateFreeSeat();
                      }
                      // check if person lower than seat in dayInfo
                      else if (person <
                          widget
                              .event!
                              .daysInfo![
                                  _eventController.selectedDateIndex.value]
                              .seats) {
                        // if this a free price and total seat is > daysInfo seat we will check also for total seat if is lower than 5
                        if (widget.event!.price == 0 &&
                            widget.event!.totalSeats < freeSeatCap) {
                          //example: totalSeat =3 if 3<5 will incremnet person
                          setState(() {
                            person = person + 1;
                            showErrorGuests = false;
                          });
                        } else {
                          setState(() {
                            person = person + 1;
                            showErrorGuests = false;
                          });
                        }
                      } else {
                        _eventController.showErrorMaxGuest.value = true;
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
            if (_eventController.showErrorMaxGuest.value)
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
            if (showErrorGuests)
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
            CustomButton(
              title: 'confirm'.tr,
              onPressed: () async {
                if (_eventController.isEventDateSelcted.value == false) {
                  setState(() {
                    _eventController.DateErrorMessage.value = true;
                  });
                  // return;
                }
                if (person == 0) {
                  setState(() {
                    showErrorGuests = true;
                  });
                } else if ((getSeat(
                    _eventController.selectedDate.value.substring(0, 10)))) {
                  setState(() {
                    showErrorSeat = true;
                  });
                  // return;
                }
                // else if (isSameDay()) {
                //   AppUtil.errorToast(
                //       context,
                //       AppUtil.rtlDirection2(context)
                //           ? "يجب أن تحجز قبل 24 ساعة "
                //           : "You must booking before 24 hours");
                // }
                // else if (!isDateBeforeToday()) {
                //   AppUtil.errorToast(
                //       context,
                //       AppUtil.rtlDirection2(context)
                //           ? "غير متاح"
                //           : "not avalible ");
                // }
                else {
                  _eventController.showErrorMaxGuest.value = false;

                  setState(() {
                    showErrorGuests = false;
                    showErrorSeat = false;
                  });
                  final isValid =
                      _eventController.checkForOneHour(context: context);
                  if (!isValid) {
                    return;
                  }
                  // if (widget.event!.price == 0 &&
                  //     widget.event!.totalSeats < 5) {
                  //   person = widget.event!.totalSeats;
                  // }
                  Get.to(
                      () => EventReview(event: widget.event!, person: person));

                  AmplitudeService.amplitude.track(
                    BaseEvent('Review Event Booking', eventProperties: {
                      'eventTime':
                          '${AppUtil.formatTimeOnly(context, widget.event!.daysInfo![_eventController.selectedDateIndex.value].startTime)} -  ${AppUtil.formatTimeOnly(context, widget.event!.daysInfo![_eventController.selectedDateIndex.value].endTime)}',
                      'eventDate': AppUtil.formatBookingDate(
                          context, _eventController.selectedDate.value),
                      'PersonNo': person,
                    }),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
