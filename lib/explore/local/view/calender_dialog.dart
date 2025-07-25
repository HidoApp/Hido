import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/local/controllers/local_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalenderDialog extends StatefulWidget {
  const CalenderDialog({
    Key? key,
    this.fromAjwady = true,
    required this.type,
    this.localExploreController,
    this.touristExploreController,
    this.avilableDate,
    this.srvicesController,
    this.hospitality,
    this.event,
    this.activity,
    this.eventController,
    this.activityController,
  }) : super(key: key);
  final bool fromAjwady;
  final String type;
  final LocalExploreController? localExploreController;
  final HospitalityController? srvicesController;
  final AdventureController? activityController;
  final TouristExploreController? touristExploreController;
  final List<DateTime>? avilableDate;
  final Hospitality? hospitality;
  final Event? event;
  final Adventure? activity;
  final EventController? eventController;

  @override
  State<CalenderDialog> createState() => _CalenderDialogState();
}

class _CalenderDialogState extends State<CalenderDialog> {
  String selectedDate = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool defineSelectable(DateTime val) {
    if (widget.avilableDate!.contains(val)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(),
                    colorScheme: const ColorScheme.light(
                      primary: Colors.black,
                      onSurface: black,
                    )),
                child: Container(
                  height: width * 0.76,
                  width: width * 0.76,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  alignment: Alignment.bottomRight,
                  child: SfDateRangePicker(
                      backgroundColor: Colors.white,
                      minDate: DateTime.now(),
                      enablePastDates: false,
                      selectableDayPredicate:
                          widget.avilableDate != null ? defineSelectable : null,
                      selectionMode: DateRangePickerSelectionMode.single,
                      selectionColor: colorGreen,
                      selectionTextStyle: const TextStyle(),
                      selectionShape: DateRangePickerSelectionShape.circle,
                      todayHighlightColor: colorGreen,
                      startRangeSelectionColor: colorGreen,
                      endRangeSelectionColor: colorGreen,
                      rangeSelectionColor: colorGreen.withOpacity(0.1),
                      monthCellStyle: const DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorPurple,
                        ),
                        todayTextStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        //  weekendTextStyle: TextStyle(
                        //    fontSize: 12,
                        //  fontWeight: FontWeight.w500,
                        //      color: Colors.blue,
                        //      ),
                      ),
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                        dayFormat:
                            'EEE', // Short format for day names (e.g., Mon, Tue)

                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(
                            color: Color(0xFF070708),
                            fontSize: 12,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      //  showNavigationArrow: true,

                      headerStyle: const DateRangePickerHeaderStyle(
                          backgroundColor: Colors.white,
                          textAlign: TextAlign.left,
                          textStyle: TextStyle(
                            color: Color(0xFF37B268),
                          )),
                      showNavigationArrow: true,
                      onSelectionChanged: (selected) {
                        //  log(selected.value);
                        selectedDate = selected.value.toString();

                        log(selectedDate);
                      }),
                ),
              ),
            ),
            CustomButton(
                height: width * 0.11,
                customWidth: width * 0.8,
                onPressed: () {
                  if (selectedDate == '') {
                    log('no date');
                  } else {
                    if (widget.type == 'adv') {
                      widget.activityController!.isAdventureDateSelcted.value =
                          true;
                      widget.activityController!.selectedDate(selectedDate);
                      widget.activityController!.DateErrorMessage.value = false;
                      for (int i = 0;
                          i < widget.activity!.daysInfo!.length;
                          i++) {
                        if (DateTime.parse(widget
                                    .activity!.daysInfo![i].startTime
                                    .substring(0, 10))
                                .toString() ==
                            selectedDate) {
                          widget.activityController!.selectedDateIndex(i);
                          widget.activityController!
                              .selectedDateId(widget.activity!.daysInfo![i].id);
                          widget.activityController!.selectedTime("");
                          //
                        }
                      }
                    } else if (widget.type == 'event') {
                      widget.eventController!.isEventDateSelcted.value = true;
                      widget.eventController!.selectedDate(selectedDate);
                      widget.eventController!.DateErrorMessage.value = false;
                      for (int i = 0; i < widget.event!.daysInfo!.length; i++) {
                        if (DateTime.parse(widget.event!.daysInfo![i].startTime
                                    .substring(0, 10))
                                .toString() ==
                            selectedDate) {
                          widget.eventController!.selectedDateIndex(i);
                          widget.eventController!
                              .selectedDateId(widget.event!.daysInfo![i].id);
                          widget.eventController!.selectedTime("");
                          //
                        }
                      }
                    } else if (widget.type == 'book') {
                      widget.touristExploreController!.isBookingDateSelected
                          .value = true;
                      widget.touristExploreController!
                          .selectedDate(selectedDate);
                    } else if (widget.type == 'hospitality') {
                      widget.srvicesController!.isHospatilityDateSelcted.value =
                          true;
                      widget.srvicesController!.DateErrorMessage.value = false;
                      widget.srvicesController!.selectedDate(selectedDate);

                      for (int i = 0;
                          i < widget.hospitality!.daysInfo.length;
                          i++) {
                        if (DateTime.parse(widget
                                    .hospitality!.daysInfo[i].startTime
                                    .substring(0, 10))
                                .toString() ==
                            selectedDate) {
                          widget.srvicesController!.selectedDateIndex(i);

                          print(widget
                              .hospitality!
                              .daysInfo[widget
                                  .srvicesController!.selectedDateIndex.value]
                              .endTime);

                          print(widget
                              .hospitality!
                              .daysInfo[widget
                                  .srvicesController!.selectedDateIndex.value]
                              .startTime);

                          //
                          //   print(widget.hospitality!.daysInfo[i].
                          //       );

                          widget.srvicesController!.selectedDateId(
                              widget.hospitality!.daysInfo[i].id);
                          widget.srvicesController!.selectedTime("");
                        }
                      }
                      //   widget.srvicesController!.selectedDateIndex(widget.avilableDate.  (selectedDate));
                    }

                    Get.back();
                  }
                },
                title: "confirm".tr)
          ],
        ));
  }
}
