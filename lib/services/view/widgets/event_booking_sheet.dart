import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/ajwadi/view/calender_dialog.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/view/event_review.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_text_with_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class EventBookingSheet extends StatefulWidget {
  const EventBookingSheet({super.key, this.event, this.avilableDate});
  final Event? event;
  final List<DateTime>? avilableDate;
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
  int person = 0;
  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;
  bool isDateBeforeToday() {
    DateTime hospitalityDate =
        DateFormat('yyyy-MM-dd').parse(_eventController.selectedDate.value);
    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);

    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime currentDate = DateTime(currentDateInRiyadh.year,
        currentDateInRiyadh.month, currentDateInRiyadh.day);
    print(hospitalityDate.isBefore(currentDate));
    print(hospitalityDate);
    print(currentDate);

    return hospitalityDate.isBefore(currentDate);
  }

  bool isSameDay() {
    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);

    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    //DateTime currentDate = DateTime(currentDateInRiyadh.year, currentDateInRiyadh.month, currentDateInRiyadh.day);

    //DateTime selectedDate = DateTime.parse(widget.serviceController.selectedDate.value);

    // print(selectedDate);
    // print(currentDate);
    // ignore: unrelated_type_equality_checks
    // print(selectedDate == currentDate);
    // ignore: unrelated_type_equality_checks
    //return selectedDate== currentDate;

    DateTime selectedDate = DateTime.parse(_eventController.selectedDate.value);
    DateTime Date = DateFormat('HH:mm').parse(DateFormat('hh:mm a', 'en_US')
        .format(DateTime.parse(widget.event!.daysInfo!.first.startTime)));

    DateTime hostStartDate = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, Date.hour, Date.minute, Date.second);

    DateTime bookingDeadline = hostStartDate.subtract(Duration(hours: 24));

    print(hostStartDate);
    print(currentDateInRiyadh);
    print(bookingDeadline);

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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: showErrorGuests ? 372 : 350,
      width: double.infinity,
      padding: EdgeInsets.only(
          left: width * 0.0615,
          right: width * 0.0615,
          top: width * 0.041,
          bottom: width * 0.082),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetIndicator(),
            SizedBox(
              height: 12,
            ),
            CustomText(
              text: 'date'.tr,
              fontSize: width * 0.043,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
            CustomTextWithIconButton(
              onTap: () {
                print("object");
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
              borderColor: showErrorDate ? colorRed : borderGrey,
              prefixIcon: SvgPicture.asset(
                'assets/icons/Time (2).svg',
                //  color: widget.color,
              ),
              suffixIcon: Icon(
                Icons.arrow_forward_ios,
                color: almostGrey,
                size: width * 0.038,
              ),
              textColor: almostGrey,
            ),
            if (showErrorDate)
              Text(
                AppUtil.rtlDirection2(context)
                    ? "مطلوب ادخال التاريخ "
                    : '*the date is required',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: width * 0.03,
                ),
              ),
            if (showErrorSeat)
              Text(
                AppUtil.rtlDirection2(context)
                    ? "لم تعد هناك مقاعد متاحة في هذا اليوم"
                    : 'No avaliable seat in this date ',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: width * 0.03,
                ),
              ),
            SizedBox(
              height: 16,
            ),
            CustomText(
              text: 'numberofpeorson'.tr,
              fontSize: width * 0.043,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
            Container(
              height: width * 0.123,
              width: width * 0.87,
              padding: EdgeInsets.symmetric(horizontal: width * 0.025),
              margin:
                  EdgeInsets.only(top: height * 0.02, bottom: width * 0.012),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.02),
                border: Border.all(
                  color: showErrorGuests ? Colors.red : borderGrey,
                ),
              ),
              child: Row(
                children: [
                  CustomText(
                    text: "person".tr,
                    fontWeight: FontWeight.w200,
                    color: textGreyColor,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (person > 0) {
                          person = person - 1;
                        } else {
                          // AppUtil.errorToast(
                          //     context,
                          //     AppUtil.rtlDirection2(context)
                          //         ? "لاتوجد مقاعد متاحة"
                          //         : "There is no seats available");
                        }
                      });
                    },
                    child: const Icon(
                      Icons.horizontal_rule_outlined,
                      color: darkGrey,
                    ),
                  ),
                  SizedBox(width: width * 0.038),
                  CustomText(
                    text: person.toString(),
                    color: tileGreyColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(width: width * 0.038),
                  GestureDetector(
                    onTap: () {
                      if (_eventController.selectedDateIndex.value == -1) {
                        return;
                      }
                      if (person <
                          widget
                              .event!
                              .daysInfo![
                                  _eventController.selectedDateIndex.value]
                              .seats) {
                        setState(() {
                          person = person + 1;
                        });
                      } else {
                        AppUtil.errorToast(
                            context,
                            AppUtil.rtlDirection2(context)
                                ? "لاتوجد مقاعد متاحة"
                                : "There is no seats available");
                      }
                    },
                    child: const Icon(
                      Icons.add,
                      color: darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (showErrorGuests)
              Padding(
                padding: EdgeInsets.only(left: width * 0.038),
                child: Text(
                  AppUtil.rtlDirection2(context)
                      ? "يجب أن تختار شخص على الأقل"
                      : '*You need to add at least one guest',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: width * 0.03,
                  ),
                ),
              ),
            SizedBox(
              height: width * 0.06,
            ),
            CustomButton(
              title: 'confirm'.tr,
              onPressed: () async {
                if (person == 0) {
                  setState(() {
                    showErrorGuests = true;
                  });
                }
                if (_eventController.selectedDate.isEmpty) {
                  setState(() {
                    showErrorDate = true;
                  });
                  return;
                }
                if (getSeat(_eventController.selectedDate.value)) {
                  setState(() {
                    showErrorSeat = true;
                  });
                  return;
                }

                if (isSameDay()) {
                  AppUtil.errorToast(
                      context,
                      AppUtil.rtlDirection2(context)
                          ? "يجب أن تحجز قبل 24 ساعة "
                          : "You must booking before 24 hours");
                } else if (isDateBeforeToday()) {
                  AppUtil.errorToast(
                      context,
                      AppUtil.rtlDirection2(context)
                          ? "غير متاح"
                          : "not avalible ");
                } else {
                  setState(() {
                    showErrorDate = false;
                    showErrorGuests = false;
                    showErrorSeat = false;
                  });
                  Get.to(
                      () => EventReview(event: widget.event!, person: person));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
