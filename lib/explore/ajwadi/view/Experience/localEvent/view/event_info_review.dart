import 'dart:ffi';
import 'dart:io';

import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/widget/experience_card.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/widget/buttomProgress.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class EventInfoReview extends StatefulWidget {
  final String hospitalityTitleEn;
  final String hospitalityBioEn;
  final String hospitalityTitleAr;
  final String hospitalityBioAr;
  final String hospitalityLocation;
  final double? adventurePrice;

  EventInfoReview({
    required this.hospitalityBioAr,
    required this.hospitalityBioEn,
    required this.hospitalityTitleAr,
    required this.hospitalityTitleEn,
    required this.hospitalityLocation,
    // required this.seats,
    // required this.gender,
    this.adventurePrice,
  });

  @override
  _EventInfoReviewState createState() => _EventInfoReviewState();
}

class _EventInfoReviewState extends State<EventInfoReview> {
  String address = ''; // State variable to store the fetched address
  String startTime = '';
  String endTime = '';
  List<String> imageUrls = [];
  List<Map<String, dynamic>> DaysInfo = [];
  String ragionAr = '';
  String ragionEn = '';
  final EventController _EventController = Get.put(EventController());

  String locationUrl = '';

  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemarks);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          if (AppUtil.rtlDirection2(context)) {
            ragionAr = placemark.locality!;
            ragionEn = 'Riyadh';
          } else {
            ragionAr = 'الرياض';
            ragionEn = placemark.locality!;
          }
        });
        print(placemarks.first);
        return ' ${placemark.locality}';
      }
    } catch (e) {
      print("Error retrieving address: $e");
    }
    return '';
  }

  Future<void> _fetchAddress() async {
    try {
      String result =
          await _getAddressFromLatLng(_EventController.pickUpLocLatLang.value);
      setState(() {
        address = result;
      });
    } catch (e) {
      // Handle error if necessary
      print('Error fetching address: $e');
    }
  }

  void daysInfo() {
    print(_EventController.selectedEndTime);
    // Format for combining date and time
    var formatter = intl.DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    //DateTime date = DateTime.parse(_EventController.selectedDate.value);

    for (var date in _EventController.selectedDates) {
      DateTime newStartTime = DateTime(
          date.year,
          date.month,
          date.day,
          _EventController.selectedStartTime.value.hour,
          _EventController.selectedStartTime.value.minute,
          _EventController.selectedStartTime.value.second,
          _EventController.selectedStartTime.value.millisecond);
      DateTime newEndTime = DateTime(
          date.year,
          date.month,
          date.day,
          _EventController.selectedEndTime.value.hour,
          _EventController.selectedEndTime.value.minute,
          _EventController.selectedEndTime.value.second,
          _EventController.selectedEndTime.value.millisecond);

      //startTime = formatter.format(newStartTime);
      //endTime = formatter.format(newEndTime);

      var newEntry = {
        "startTime": formatter.format(newStartTime),
        "endTime": formatter.format(newEndTime),
        "seats": _EventController.seletedSeat
      };

      DaysInfo.add(newEntry);
    }

    // Print the new dates list
    print(DaysInfo);
  }

  //   for (var date in widget.hospitalityController.selectedDates) {
  //     DateTime newStartTime = DateTime(
  //         date.year,
  //         date.month,
  //         date.day,
  //         widget.hospitalityController.selectedStartTime.value.hour,
  //         widget.hospitalityController.selectedStartTime.value.minute,
  //         widget.hospitalityController.selectedStartTime.value.second,
  //         widget.hospitalityController.selectedStartTime.value.millisecond);
  //     DateTime newEndTime = DateTime(
  //         date.year,
  //         date.month,
  //         date.day,
  //         widget.hospitalityController.selectedEndTime.value.hour,
  //         widget.hospitalityController.selectedEndTime.value.minute,
  //         widget.hospitalityController.selectedEndTime.value.second,
  //         widget.hospitalityController.selectedEndTime.value.millisecond);

  //     startTime = formatter.format(newStartTime);
  //     endTime = formatter.format(newEndTime);

  //     var newEntry = {
  //       "startTime": formatter.format(newStartTime),
  //       "endTime": formatter.format(newEndTime),
  //       "seats": widget.hospitalityController.seletedSeat
  //     };

  //     DaysInfo.add(newEntry);
  //   }

  //   // Print the new dates list
  //   print(DaysInfo);
  // }

  // Function to generate the Google Maps URL
  String getLocationUrl(LatLng location) {
    print(' location lang${location.longitude}');
    return 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
  }

  @override
  void initState() {
    super.initState();
    _fetchAddress();

    daysInfo();

    setState(() {
     locationUrl = getLocationUrl(_EventController.pickUpLocLatLang.value);
      print('Location URL: $locationUrl');
      imageUrls = [
        "https://img.aso.fr/core_app/img-cycling-tdf-jpg/echappee-7/57226/0:0,1200:801-1000-0-70/632b8"
      ];
      //  "https://media.cntraveler.com/photos/607313c3d1058698d13c31b5/1:1/w_1636,h_1636,c_limit/FamilyCamping-2021-GettyImages-948512452-4.jpg"

      // widget.hospitalityController.pickUpLocLatLang.value=LatLng(24.786828,46.647622);
    });
  }

  Widget build(BuildContext context) {
    print('Location URL: $locationUrl');
    print(_EventController.selectedDate.value);
    print(_EventController.pickUpLocLatLang.value.longitude);

    return Scaffold(
      appBar: CustomAppBar(
        'Review'.tr,
        isAjwadi: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reviewevent'.tr,
              style: TextStyle(
                color: Color(0xFF070708),
                fontSize: 17,
                fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic':'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'explinationEvent'.tr,
              style: TextStyle(
                color: Color(0xFF9392A0),
                fontSize: 15,
                fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic':'SF Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 251,
              height: 222,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrls.first),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x0029272E),
                          Color(0xFF29272E),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                          MainAxisAlignment.start,
                      crossAxisAlignment:AppUtil.rtlDirection2(context)? CrossAxisAlignment.end:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppUtil.rtlDirection2(context)
                    ? widget.hospitalityTitleAr
                    : widget.hospitalityTitleEn,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.80,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${address} . ${extractMonths(_EventController.selectedDate.value)}',
                          style: TextStyle(
                            color: Color(0xFFB9B8C1),
                            fontSize: 15,
                            fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic':'SF Pro',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            

      
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 35),
            child: Container(
              child: CustomButton(
                  onPressed: () async {
                //     final isSuccess = 
                //         await _EventController!.createEvent(
                //             nameAr: widget.hospitalityTitleAr,
                //             nameEn: widget.hospitalityTitleEn,
                //             descriptionAr: widget.hospitalityBioAr,
                //             descriptionEn: widget.hospitalityBioEn,
                //             longitude: _EventController.pickUpLocLatLang.value.longitude.toString(),
                //             latitude: _EventController.pickUpLocLatLang.value.latitude.toString(),
                //             date: _EventController.selectedDate.value.substring(0, 10),
                //             price: widget.adventurePrice!,
                //             image: imageUrls,
                //             regionAr: ragionAr,
                //             locationUrl: locationUrl,
                //             regionEn: ragionEn,
                //             //start: intl.DateFormat('HH:mm:ss').format(widget.adventureController!.selectedStartTime.value),
                //            // end: intl.DateFormat('HH:mm:ss').format(widget.adventureController!.selectedEndTime.value),
                //             seat: _EventController.seletedSeat.value,
                //             context: context);

                //     print('is sucssssss');
                //     print(isSuccess);
                //     if (isSuccess) {
                      
                //       showDialog(
                //         context: context,
                //         builder: (BuildContext context) {
                //           return Dialog(
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             child: Container(
                //               width: 350,
                //               height: 110, // Custom width
                //               padding: EdgeInsets.all(16),
                //               child: Column(
                //                 mainAxisSize: MainAxisSize.min,
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.center,
                //                 children: [
                //                   Image.asset(
                //                       'assets/images/paymentSuccess.gif',
                //                       width: 38),
                //                   SizedBox(height: 16),
                //                   Text(
                //                     !AppUtil.rtlDirection2(context)
                //                         ? "Experience published successfully"
                //                         : "تم نشر تجربتك بنجاح ",
                //                     style: TextStyle(fontSize: 15),
                //                     //textDirection:
                //                         //AppUtil.rtlDirection2(context)
                //                             //? TextDirection.rtl
                //                             //: TextDirection.ltr,
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           );
                //         },
                //       ).then((_) {
                // Get.offAll(() => const AjwadiBottomBar());
                //       });

                      
                //     } else {
                //       AppUtil.errorToast(
                //           context, 'somthingWentWrong'.tr);
                //     }
                  },
                  title: 'Publish'.tr,
                  ),
            ),
                  ),
                ),
          ],
        ),
          ],
      ),
      )
    );
  }
}

String formatSelectedDates(RxList<dynamic> dates, BuildContext context) {
  // Convert dynamic list to List<DateTime>
  List<DateTime> dateTimeList = dates
      .where((date) => date is DateTime)
      .map((date) => date as DateTime)
      .toList();

  if (dateTimeList.isEmpty) {
    return 'DD/MM/YYYY';
  }

  // Sort the dates
  dateTimeList.sort();

  final bool isArabic = AppUtil.rtlDirection2(context);
  final intl.DateFormat dayFormatter =
      intl.DateFormat('d', isArabic ? 'ar' : 'en');
  final intl.DateFormat monthYearFormatter =
      intl.DateFormat('MMMM yyyy', isArabic ? 'ar' : 'en');

  String formattedDates = '';

  for (int i = 0; i < dateTimeList.length; i++) {
    if (i > 0) {
      // If current date's month and year are different from the previous date's, add a comma
      if (dateTimeList[i].month != dateTimeList[i - 1].month ||
          dateTimeList[i].year != dateTimeList[i - 1].year) {
        formattedDates += ', ';
      } else {
        // If same month and year, just add a space
        formattedDates += ', ';
      }
    }

    formattedDates += dayFormatter.format(dateTimeList[i]);

    // If the next date is in a different month or year, add month and year to the current date
    if (i == dateTimeList.length - 1 ||
        dateTimeList[i].month != dateTimeList[i + 1].month ||
        dateTimeList[i].year != dateTimeList[i + 1].year) {
      formattedDates += ' ${monthYearFormatter.format(dateTimeList[i])}';
    }
  }

  return formattedDates;
}
String extractMonths(String datesString) {
  // Remove brackets and split by comma to get individual date strings
  List<String> dateStrings = datesString.replaceAll('[', '').replaceAll(']', '').split(', ');

  // Parse each date string and extract the month
  List<String> monthsList = dateStrings.map((dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat.MMMM().format(dateTime);
  }).toList();

  // Check if all months are the same
  bool allSame = monthsList.every((month) => month == monthsList[0]);

  if (allSame) {
    return [monthsList[0]].join(',');
  } else {
    return monthsList.join(', ');
  }
}