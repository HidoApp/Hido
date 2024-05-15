import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/ajwadi_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
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
    this.ajwadiExploreController,
    this.touristExploreController,
    this.avilableDate,
    this.srvicesController,
    this.hospitality,
  }) : super(key: key);
  final bool fromAjwady;
  final String type;
  final AjwadiExploreController? ajwadiExploreController;
  final HospitalityController? srvicesController;
  final TouristExploreController? touristExploreController;
  final List<DateTime>? avilableDate;
  final Hospitality? hospitality;

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
    return AlertDialog(
        backgroundColor: widget.fromAjwady ? lightBlack : Colors.white,
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
                  height: 300,
                  width: 300,
                  alignment: Alignment.bottomRight,
                  child: SfDateRangePicker(
                      minDate: DateTime.now(),
                      enablePastDates: false,
                      selectableDayPredicate:
                          widget.avilableDate != null ? defineSelectable : null,
                      selectionMode: DateRangePickerSelectionMode.single,
                      selectionColor:
                          widget.type == 'hospitality' ? purple : Colors.green,
                      selectionTextStyle: TextStyle(),
                      selectionShape: DateRangePickerSelectionShape.circle,
                      todayHighlightColor: colorGreen,
                      startRangeSelectionColor: colorGreen,
                      endRangeSelectionColor: colorGreen,
                      rangeSelectionColor: colorGreen.withOpacity(0.1),
                      monthCellStyle: DateRangePickerMonthCellStyle(),
                      headerStyle: const DateRangePickerHeaderStyle(
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(color: lightBlack)),
                      onSelectionChanged: (selected) {
                        print(selected.value);
                        selectedDate = selected.value.toString();
                        print(selected);
                      }),
                ),
              ),
            ),
            CustomButton(
                height: 40,
                customWidth: 260,
                buttonColor: widget.type == 'hospitality' ? purple : null,
                onPressed: () {
                  if (selectedDate == '') {
                  } else {
                    if (widget.type == 'adv') {
                      widget.ajwadiExploreController!.isDateEmpty.value = false;
                      widget.ajwadiExploreController!
                          .selectedAdvDate(selectedDate);
                    } else if (widget.type == 'event') {
                      widget.ajwadiExploreController!.isDateEmpty.value = false;
                      widget.ajwadiExploreController!
                          .selectedAdvDate(selectedDate);
                    } else if (widget.type == 'book') {
                      widget.touristExploreController!.isBookingDateSelected
                          .value = true;
                      widget.touristExploreController!
                          .selectedDate(selectedDate);
                    } else if (widget.type == 'hospitality') {
                      widget.srvicesController!.isHospatilityDateSelcted.value =
                          true;
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
                title: "done".tr)
          ],
        ));
  }
}
