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
  const EventCalenderDialog({
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
  State<EventCalenderDialog> createState() => _EventCalenderDialogState();
}

class _EventCalenderDialogState extends State<EventCalenderDialog> {
  String selectedDate = '';
    List<DateTime> selectedDates = [];

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
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  alignment: Alignment.bottomRight,
                  child: SfDateRangePicker(
                   backgroundColor: Colors.white,

                      minDate: DateTime.now(),
                      enablePastDates: false,
                      selectableDayPredicate:
                          widget.avilableDate != null ? defineSelectable : null,
                      selectionMode: widget.type =='event'?  DateRangePickerSelectionMode.multiple:DateRangePickerSelectionMode.single,
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
                     dayFormat: 'EEE', // Short format for day names (e.g., Mon, Tue)
                     
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
                          textAlign: TextAlign.left,
                          textStyle: TextStyle(color:Color(0xFF37B268),)
                          ),
                           showNavigationArrow: true,

                      onSelectionChanged: (selected) {
                        print(selected.value);
                      selectedDate = selected.value.toString();

                       selectedDates = selected.value.cast<DateTime>();
                        
                        print(selected);
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
                    widget.eventController!.DateErrorMessage.value= !AppUtil.areAllDatesAfter24Hours(widget.eventController!.selectedDates);

                    } else if (widget.type == 'book') {
                      widget.touristExploreController!.isBookingDateSelected
                          .value = true;
                      widget.touristExploreController!
                          .selectedDate(selectedDate);
                    } 
                    else if (widget.type == 'hospitality'  )//new
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
                title:"confirm".tr)
          ],
        ));
  }
}
