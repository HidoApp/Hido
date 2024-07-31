import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/ajwadi_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalenderDialog extends StatefulWidget {
  const CalenderDialog({
    Key? key,
    this.fromAjwady = true,
    required this.type,
    this.ajwadiExploreController,
    this.touristExploreController,
    this.avilableDate,
    this.srvicesController,
    this.hospitality,
    this.event,
    this.eventController,
  }) : super(key: key);
  final bool fromAjwady;
  final String type;
  final AjwadiExploreController? ajwadiExploreController;
  final HospitalityController? srvicesController;
  final TouristExploreController? touristExploreController;
  final List<DateTime>? avilableDate;
  final Hospitality? hospitality;
  final Event? event;
  final EventController? eventController;

  @override
  State<CalenderDialog> createState() => _CalenderDialogState();
}

class _CalenderDialogState extends State<CalenderDialog> {
  String selectedDate = '';

  final _ajwadiExploreController = Get.put(AjwadiExploreController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.avilableDate != null) {
      print("widget.avilableDate!.length");
      print(widget.avilableDate!.length);

      for (var date in widget.avilableDate!) {
        print(date);
      }
    }
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
    final width = MediaQuery.of(context).size.width;
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
                      selectionColor: Colors.green,
                      selectionTextStyle: TextStyle(),
                      selectionShape: DateRangePickerSelectionShape.circle,
                      todayHighlightColor: colorGreen,
                      startRangeSelectionColor: colorGreen,
                      endRangeSelectionColor: colorGreen,
                      rangeSelectionColor: colorGreen.withOpacity(0.1),
                      monthCellStyle: const DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF37B268),
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
                      widget.ajwadiExploreController!.isDateEmpty.value = false;
                      widget.ajwadiExploreController!
                          .selectedAdvDate(selectedDate);
                    } else if (widget.type == 'event') {
                      widget.eventController!.isEventDateSelcted.value = true;
                      widget.eventController!.selectedDate(selectedDate);
                              widget.eventController!.DateErrorMessage.value=false;
                      for (int i = 0; i < widget.event!.daysInfo!.length; i++) {
                        if (DateTime.parse(widget.event!.daysInfo![i].startTime
                                    .substring(0, 10))
                                .toString() ==
                            selectedDate) {
                          widget.eventController!.selectedDateIndex(i);
                          widget.eventController!
                              .selectedDateId(widget.event!.daysInfo![i].id);
                          widget.eventController!.selectedTime("");
                          //  print(widget.srvicesController!.selectedTime);
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
                          widget.srvicesController!.DateErrorMessage.value=false;
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
                          print("endTime");
                          print(widget
                              .hospitality!
                              .daysInfo[widget
                                  .srvicesController!.selectedDateIndex.value]
                              .endTime);

                          print("startTime");
                          print(widget
                              .hospitality!
                              .daysInfo[widget
                                  .srvicesController!.selectedDateIndex.value]
                              .startTime);

                          print("endTime iiiii ");
                          print(widget.hospitality!.daysInfo[i].endTime);

                          print("startTime iiiiii");
                          print(widget.hospitality!.daysInfo[i].startTime);

                          print("selectedDate ID");
                          print(widget.hospitality!.daysInfo[i].id);

                          // print("selectedDate ID");
                          //   print(widget.hospitality!.daysInfo[i].
                          //       );

                          print("selectedDate index");
                          print(i);

                          widget.srvicesController!.selectedDateId(
                              widget.hospitality!.daysInfo[i].id);
                          widget.srvicesController!.selectedTime("");
                          print(widget.srvicesController!.selectedTime);
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
