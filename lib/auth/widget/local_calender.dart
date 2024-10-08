import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// ignore: must_be_immutable
class LocalCalender extends StatelessWidget {
  LocalCalender(
      {super.key,
      required this.onSelectionChanged,
      required this.onPressed,
      this.pastAvalible = true});
  final void Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;
  final bool pastAvalible;
  void Function() onPressed;
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
                    enablePastDates: pastAvalible,

                    yearCellStyle: DateRangePickerYearCellStyle(
                        leadingDatesTextStyle: TextStyle(
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textStyle: TextStyle(
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),
                    view: DateRangePickerView.decade,
                    backgroundColor: Colors.white,
                    selectionMode: DateRangePickerSelectionMode.single,
                    selectionColor: colorGreen,
                    selectionShape: DateRangePickerSelectionShape.circle,
                    todayHighlightColor: Colors.transparent,
                    startRangeSelectionColor: colorGreen,
                    endRangeSelectionColor: colorGreen,
                    rangeSelectionColor: colorGreen.withOpacity(0.1),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: TextStyle(
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),

                      //  weekendTextStyle: TextStyle(
                      //    fontSize: 12,
                      //  fontWeight: FontWeight.w500,
                      //      color: Colors.blue,
                      //      ),
                    ),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      dayFormat:
                          'EEE', // Short format for day names (e.g., Mon, Tue)

                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        backgroundColor: Colors.white,
                        textStyle: TextStyle(
                          color: const Color(0xFF070708),
                          fontSize: 12,
                          fontFamily: AppUtil.SfFontType(context),
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
                      onSelectionChanged!(selected);
                    },
                    onSubmit: (val) {},
                  ),
                ),
              ),
            ),
            CustomButton(
                height: width * 0.11,
                customWidth: width * 0.8,
                onPressed: () => onPressed(),
                title: "confirm".tr)
          ],
        ));
  }
}
