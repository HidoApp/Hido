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
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.avilableDate != null) {
      for (var date in widget.avilableDate!) {}
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
    if (widget.type == 'event') {}
    if (widget.eventController != null &&
        widget.eventController!.isEventDateSelcted.value) {
      List<PickerDateRange> ranges = [];
      final selectedDates = widget.eventController!.selectedDates;

      for (int i = 0; i < selectedDates.length; i += 1) {
        DateTime startDate = selectedDates[i];
        DateTime endDate = (i < selectedDates.length)
            ? selectedDates[i]
            : startDate; // Use the same date for start and end if there's no end date

        ranges.add(PickerDateRange(startDate, endDate));
      }

      return ranges;
    }
    return [];
  }

  List<PickerDateRange> _getInitialSelectedRangesOfExperience() {
    if ((widget.srvicesController != null &&
            widget.srvicesController!.isHospatilityDateSelcted.value) ||
        (widget.advController != null &&
            widget.advController!.isAdventureDateSelcted.value)) {
      List<PickerDateRange> ranges = [];
      final selectedDates = widget.type == 'hospitality'
          ? widget.srvicesController!.selectedDates
          : widget.advController!.selectedDates;

      for (int i = 0; i < selectedDates.length; i += 1) {
        DateTime startDate = selectedDates[i];
        DateTime endDate = (i < selectedDates.length)
            ? selectedDates[i]
            : startDate; // Use the same date for start and end if there's no end date

        ranges.add(PickerDateRange(startDate, endDate));
      }

      return ranges;
    }
    // widget.srvicesController!.selectedDates([]);

    return [];
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
                      initialSelectedRanges: widget.type == 'event'
                          ? _getInitialSelectedRanges()
                          : _getInitialSelectedRangesOfExperience(),

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
                      selectionMode: DateRangePickerSelectionMode.multiRange,
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
                        setState(() {
                          // Clear previously selected dates
                          selectedDates = [];

                          // Handle multiple date ranges (if supported)
                          if (selected.value is List<PickerDateRange>) {
                            List<PickerDateRange> ranges =
                                selected.value as List<PickerDateRange>;

                            for (var range in ranges) {
                              DateTime? startDate = range.startDate;
                              DateTime? endDate = range.endDate ??
                                  startDate; // If endDate is null, assume it's a single date range

                              if (startDate != null) {
                                for (DateTime date = startDate;
                                    date.isBefore(endDate!) ||
                                        date.isAtSameMomentAs(endDate);
                                    date = date.add(const Duration(days: 1))) {
                                  selectedDates.add(DateTime(
                                      date.year, date.month, date.day));
                                }
                              }
                            }

                            // Join the selected dates as a string
                            selectedDate = selectedDates
                                .map((date) => date.toString())
                                .join(', ');

                            // Handle a single date range (start and end date)
                          } else if (selected.value is PickerDateRange) {
                            PickerDateRange range =
                                selected.value as PickerDateRange;
                            DateTime? startDate = range.startDate;
                            DateTime? endDate = range.endDate ??
                                startDate; // If endDate is null, assume it's the same as startDate

                            if (startDate != null) {
                              for (DateTime date = startDate;
                                  date.isBefore(endDate!) ||
                                      date.isAtSameMomentAs(endDate);
                                  date = date.add(const Duration(days: 1))) {
                                selectedDates.add(
                                    DateTime(date.year, date.month, date.day));
                              }

                              selectedDate = selectedDates
                                  .map((date) => date.toString())
                                  .join(', ');
                            }

                            // Handle a single date selection
                          } else if (selected.value is DateTime) {
                            DateTime singleDate = selected.value as DateTime;
                            selectedDates = [
                              DateTime(singleDate.year, singleDate.month,
                                  singleDate.day)
                            ];

                            // Format single date to string
                            selectedDate = selectedDates[0].toString();
                          }
                        });

                        // Debug prints for selected dates
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
                      widget.advController!.selectedDates(selectedDates);

                      widget.advController!.DateErrorMessage.value =
                          !AppUtil.areAllDatesAfter24Hours(
                              widget.advController!.selectedDates);
                      // widget.advController!.DateErrorMessage.value =
                      //     AppUtil.isDateBefore24Hours(
                      //         widget.advController!.selectedDate.value);
                      if (widget.advController!.isAdventureTimeSelcted.value) {
                        widget.advController!.newRangeTimeErrorMessage.value =
                            AppUtil.areAllDatesTimeBefore(
                                widget.advController!.selectedDates,
                                widget.advController!.selectedStartTime.value);
                      }
                      //  widget.advController!.selectedDates(selectedDates);
                    } else if (widget.type == 'event') {
                      widget.eventController!.isEventDateSelcted.value = true;
                      widget.eventController!.selectedDate(selectedDate);
                      widget.eventController!.selectedDates(selectedDates);

                      widget.eventController!.DateErrorMessage.value =
                          !AppUtil.areAllDatesAfter24Hours(
                              widget.eventController!.selectedDates);

                      if (widget.eventController!.isEventTimeSelcted.value) {
                        widget.eventController!.newRangeTimeErrorMessage.value =
                            AppUtil.areAllDatesTimeBefore(
                                widget.eventController!.selectedDates,
                                widget
                                    .eventController!.selectedStartTime.value);
                      }
                    } else if (widget.type == 'book') {
                      widget.touristExploreController!.isBookingDateSelected
                          .value = true;
                      widget.touristExploreController!
                          .selectedDate(selectedDate);
                    } else if (widget.type == 'hospitality') //new
                    {
                      // widget.srvicesController!.isHospatilityDateSelcted.value =
                      //     true;
                      // widget.srvicesController!.selectedDate(selectedDate);
                      widget.srvicesController!.isHospatilityDateSelcted.value =
                          true;

                      widget.srvicesController!.selectedDate(selectedDate);
                      widget.srvicesController!.selectedDates(selectedDates);

                      widget.srvicesController!.DateErrorMessage.value =
                          !AppUtil.areAllDatesAfter24Hours(
                              widget.srvicesController!.selectedDates);
                      //new srs
                      if (widget
                          .srvicesController!.isHospatilityTimeSelcted.value) {
                        widget.srvicesController!.newRangeTimeErrorMessage
                                .value =
                            AppUtil.areAllDatesTimeBefore(
                                widget.srvicesController!.selectedDates,
                                widget.srvicesController!.selectedStartTime
                                    .value);
                      }
                    }

                    Get.back();
                  }
                },
                title: "confirm".tr)
          ],
        ));
  }
}
