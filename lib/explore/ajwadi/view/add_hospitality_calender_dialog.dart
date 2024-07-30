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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HostCalenderDialog extends StatefulWidget {
  const HostCalenderDialog({
    Key? key,
    this.fromAjwady = true,
    required this.type,
    this.ajwadiExploreController,
    this.touristExploreController,
    this.avilableDate,
    this.srvicesController,
    this.advController,
    this.hospitality,
    this.eventController
  }) : super(key: key);
  final bool fromAjwady;
  final String type;
  final AjwadiExploreController? ajwadiExploreController;
  final HospitalityController? srvicesController;
  final AdventureController? advController;
  final EventController? eventController;
  final TouristExploreController? touristExploreController;
  final List<DateTime>? avilableDate;
  final Hospitality? hospitality;

  @override
  State<HostCalenderDialog> createState() => _HostCalenderDialogState();
}

class _HostCalenderDialogState extends State<HostCalenderDialog> {
  String selectedDate = '';
  List<DateTime> selectedDates = [];
  final _ajwadiExploreController = Get.put(AjwadiExploreController());

  @override
  void initState() {
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
    return widget.avilableDate!.contains(val);
  }

  @override
  Widget build(BuildContext context) {
    // Convert the initial selected date from String to DateTime
    DateTime? initialSelectedDate;
    if (widget.type == 'adv' && widget.advController != null) {
      if (widget.advController!.isAdventureDateSelcted.value) {
        initialSelectedDate = DateTime.tryParse(widget.advController!.selectedDate.value);
      }
    } else if (widget.srvicesController != null) {
      if (widget.srvicesController!.isHospatilityDateSelcted.value) {
        initialSelectedDate = DateTime.tryParse(widget.srvicesController!.selectedDate.value);
      }
    }
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
                ),
              ),
              child: Container(
                height: width * 0.76,
                width: width * 0.76,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                alignment: Alignment.bottomRight,
                child: SfDateRangePicker(
                  initialSelectedDate:initialSelectedDate==null? null:initialSelectedDate,
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
                  ),
                  monthViewSettings: const DateRangePickerMonthViewSettings(
                    
                    dayFormat: 'EEE',
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
                  headerStyle: const DateRangePickerHeaderStyle(
                    textAlign: TextAlign.left,
                    textStyle: TextStyle(
                      color: Color(0xFF37B268),
                    ),
                  ),
                  showNavigationArrow: true,
                  onSelectionChanged: (selected) {
                    setState(() {
                      selectedDate = selected.value.toString();
                    });
                  },
                ),
              ),
            ),
          ),
          CustomButton(
            height: width * 0.11,
            customWidth: width * 0.8,
            onPressed: () {
              if (selectedDate != '') {
                if (widget.type == 'adv') {
                  widget.ajwadiExploreController!.isDateEmpty.value = false;
                  widget.advController?.isAdventureDateSelcted.value=true;
                  widget.advController!.selectedDate(selectedDate);
                  widget..advController!.DateErrorMessage.value =  AppUtil.isDateBefore24Hours(widget.advController!.selectedDate.value);

                } else if (widget.type == 'event') {
                  widget.eventController!.isEventDateSelcted.value = true;
                  widget.eventController!.selectedDate(selectedDate);
                } else if (widget.type == 'book') {
                  widget.touristExploreController!.isBookingDateSelected.value =
                      true;
                  widget.touristExploreController!.selectedDate(selectedDate);
                } else if (widget.type == 'hospitality') {
                  widget.srvicesController!.isHospatilityDateSelcted.value =
                      true;
                  widget.srvicesController!.selectedDate(selectedDate);
                  widget.srvicesController!.DateErrorMessage.value =  AppUtil.isDateBefore24Hours(widget.srvicesController!.selectedDate.value);

                }
                Get.back();
              }
            },
            title: "confirm".tr,
          ),
        ],
      ),
    );
  }
}