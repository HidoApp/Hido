import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/ajwadi_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EventCalenderDialog extends StatefulWidget {
  const EventCalenderDialog(
      {Key? key,
      this.fromAjwady = true,
      required this.type,
      this.ajwadiExploreController,
      this.touristExploreController,
      this.avilableDate,
      this.srvicesController,
      this.advController,
      this.hospitality,
      this.avilableDate2,
      this.eventController})
      : super(key: key);
  final bool fromAjwady;
  final String type;
  final AjwadiExploreController? ajwadiExploreController;
  final HospitalityController? srvicesController;
  final AdventureController? advController;
  final EventController? eventController;

  final TouristExploreController? touristExploreController;
  final List<DateTime>? avilableDate;
  final List<dynamic>? avilableDate2;

  final Hospitality? hospitality;

  @override
  State<EventCalenderDialog> createState() => _EventCalenderDialogState();
}

class _EventCalenderDialogState extends State<EventCalenderDialog> {
  String selectedDate = '';
  List<DateTime> selectedDates = [];

  final _ajwadiExploreController = Get.put(AjwadiExploreController());
  DateRangePickerController _controller = DateRangePickerController();

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

  List<PickerDateRange> _getInitialSelectedRanges() {
    if (widget.eventController != null &&
        widget.eventController!.isEventDateSelcted.value) {
      List<PickerDateRange> ranges = [];
      final selectedDates = widget.eventController!.selectedDates;

      for (int i = 0; i < selectedDates.length; i += 1) {
        DateTime startDate = selectedDates[i];
        DateTime endDate = (i < selectedDates.length)
            ? selectedDates[i ]
            : startDate; // Use the same date for start and end if there's no end date

        ranges.add(PickerDateRange(startDate, endDate));
      }

      return ranges;
    }
    return [];
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
                    initialSelectedRanges: _getInitialSelectedRanges(),

                      // initialSelectedRange: widget.eventController != null &&
                      //         widget.eventController!.isEventDateSelcted.value
                      //     ? PickerDateRange(
                      //         widget.eventController!.selectedDates.first,
                      //         widget.eventController!.selectedDates.last,
                      //       )
                      //     : null,
                      enablePastDates: false,
                      selectableDayPredicate:
                          widget.avilableDate != null ? defineSelectable : null,
                      selectionMode: widget.type == 'event'
                          ? DateRangePickerSelectionMode.multiRange
                          : DateRangePickerSelectionMode.single,
                      selectionColor: colorGreen,
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
                        setState(() {
                          if (selected.value is List<PickerDateRange>) {
                            // Handle multiple ranges
                            List<PickerDateRange> ranges =
                                selected.value as List<PickerDateRange>;
                            selectedDates = [];
                            for (var range in ranges) {
                              DateTime? startDate = range.startDate;
                              DateTime? endDate = range.endDate;

                              if (startDate != null && endDate != null) {
                                for (DateTime date = startDate;
                                    date.isBefore(endDate) ||
                                        date.isAtSameMomentAs(endDate);
                                    date = date.add(Duration(days: 1))) {
                                  selectedDates!.add(DateTime(
                                      date.year, date.month, date.day));
                                }
                              }
                            }
                            selectedDate = selectedDates!
                                .map((date) => date.toString())
                                .join(', ');
                          } else if (selected.value is PickerDateRange) {
                            // Handle single range selection
                            PickerDateRange range =
                                selected.value as PickerDateRange;
                            DateTime? startDate = range.startDate;
                            DateTime? endDate = range.endDate;

                            if (startDate != null && endDate != null) {
                              selectedDates = [];
                              for (DateTime date = startDate;
                                  date.isBefore(endDate) ||
                                      date.isAtSameMomentAs(endDate);
                                  date = date.add(Duration(days: 1))) {
                                selectedDates!.add(
                                    DateTime(date.year, date.month, date.day));
                              }
                              selectedDate =
                                  '${DateTime(startDate.year, startDate.month, startDate.day).toString()}';
                            }
                          } else if (selected.value is DateTime) {
                            // Handle single date selection
                            DateTime singleDate = selected.value as DateTime;
                            selectedDates = [
                              DateTime(singleDate.year, singleDate.month,
                                  singleDate.day)
                            ];
                            selectedDate = DateTime(singleDate.year,
                                    singleDate.month, singleDate.day)
                                .toString();
                          }
                        });

                        print("Selected Dates: $selectedDates");
                        print("Selected Date: $selectedDate");
                      }),
                ),
              ),
            ),
            CustomButton(
                height: width * 0.11,
                customWidth: width * 0.8,
                onPressed: () {
                  if (selectedDate == '') {
                  } else {
                    if (widget.type == 'adv') {
                      // widget.ajwadiExploreController!.isDateEmpty.value = false;
                      widget.advController!.isAdventureDateSelcted.value = true;
                      // widget.ajwadiExploreController!
                      //     .selectedAdvDate(selectedDate);

                      widget.advController!.selectedDate(selectedDate);
                      //  widget.advController!.selectedDates(selectedDates);
                    } else if (widget.type == 'event') {
                      widget.eventController!.isEventDateSelcted.value = true;

                      widget.eventController!.selectedDate(selectedDate);
                      widget.eventController!.selectedDates(selectedDates);
                      print("this selected dates");
                      print(widget.eventController!.selectedDates.length);
                      widget.eventController!.DateErrorMessage.value =
                          !AppUtil.areAllDatesAfter24Hours(
                              widget.eventController!.selectedDates);
                    } else if (widget.type == 'book') {
                      widget.touristExploreController!.isBookingDateSelected
                          .value = true;
                      widget.touristExploreController!
                          .selectedDate(selectedDate);
                    } else if (widget.type == 'hospitality') //new
                    {
                      print('8');
                      widget.srvicesController!.isHospatilityDateSelcted.value =
                          true;
                      // widget.srvicesController!.selectedDates(selectedDates);
                      widget.srvicesController!.selectedDate(selectedDate);
                    }

                    Get.back();
                  }
                },
                title: "confirm".tr)
          ],
        ));
  }
}
