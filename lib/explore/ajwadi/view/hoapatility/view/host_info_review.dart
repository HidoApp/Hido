import 'dart:io';

import 'package:ajwad_v4/explore/ajwadi/view/Experience/widget/experience_card.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/widget/buttomProgress.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:geocoding/geocoding.dart';

import '../../../../../services/controller/hospitality_controller.dart';

class HostInfoReview extends StatefulWidget {
 
  final String hospitalityTitleEn;
  final String hospitalityBioEn;
  final String hospitalityTitleAr;
  final String hospitalityBioAr;
  final String hospitalityPrice;
  final List<String> hospitalityImages;
  // final int seats;
  // final String gender;
  final HospitalityController hospitalityController;

  HostInfoReview({
   
    required this.hospitalityBioAr,
    required this.hospitalityBioEn,
    required this.hospitalityTitleAr,
    required this.hospitalityTitleEn,
    required this.hospitalityPrice,
    required this.hospitalityImages,
    // required this.seats,
    // required this.gender,
    required this.hospitalityController,
  });

    @override
  _HostInfoReviewState createState() => _HostInfoReviewState();
}

class _HostInfoReviewState extends State<HostInfoReview> {
  String address = ''; // State variable to store the fetched address

  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      print( placemarks);

      if (placemarks.isNotEmpty) {
     Placemark placemark = placemarks.first;
     print( placemarks.first);
        return '${placemark.locality}, ${placemark.subLocality}, ${placemark.country}';
      }
    } catch (e) {
      print("Error retrieving address: $e");
    }
    return '';
  }

  Future<void> _fetchAddress() async {
    try {
      String result = await _getAddressFromLatLng(widget.hospitalityController.pickUpLocLatLang.value);
      setState(() {
        address = result;
      });
    } catch (e) {
      // Handle error if necessary
      print('Error fetching address: $e');
    }
  }

  

  @override
  void initState() {
    super.initState();
    _fetchAddress(); // Fetch address when the widget initializes
  }

  Widget build(BuildContext context) {
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
              'Reviewexperience'.tr,
              style: TextStyle(
                color: Color(0xFF070708),
                fontSize: 20,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Text(
                'explination'.tr,
                style: TextStyle(
                  color: Color(0xFF9392A0),
                  fontSize: 15,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3FC7C7C7),
                    blurRadius: 16,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image:
                            //NetworkImage(hospitalityImages[0]),
                       FileImage(File(widget.hospitalityImages[0])),

                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppUtil.rtlDirection2(context)?widget.hospitalityTitleAr:widget.hospitalityTitleEn,
                              style: TextStyle(
                                color: Color(0xFF070708),
                                fontSize: 16,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Color(0xFF36B268), size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '5.0',
                                  style: TextStyle(
                                    color: Color(0xFF36B268),
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                    address,
                                      //'Riyadh,Al-Majma\'ah, Saudi Arabia',
                                      style: TextStyle(
                                        color: Color(0xFF9392A0),
                                        fontSize: 11,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                    '${formatSelectedDates(
                                  widget.hospitalityController.selectedDates,context)} - ${AppUtil.formatStringTimeWithLocale(context,intl.DateFormat('hh:mm a')
                                                    .format(widget.hospitalityController.selectedStartTime.value))}' ,
                                               
                                      style: TextStyle(
                                        color: Color(0xFF9392A0),
                                        fontSize: 11,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.restaurant, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                     _StringMeal(widget.hospitalityController.selectedMeal.value,context),
                                      style: TextStyle(
                                        color: Color(0xFF9392A0),
                                        fontSize: 11,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    // SizedBox(
                                    //     width:
                                    //         68), // Adjust spacing between text and button
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 16, vertical: 8),
                                    //   decoration: BoxDecoration(
                                    //     color: Color(0xFFECF9F1),
                                    //     borderRadius:
                                    //         BorderRadius.circular(9999),
                                    //   ),
                                    //   child: Text(
                                    //     'show preview',
                                    //     style: TextStyle(
                                    //       color: Color(0xFF36B268),
                                    //       fontSize: 13,
                                    //       fontFamily: 'SF Pro',
                                    //       fontWeight: FontWeight.w400,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
                      child: CustomButton(onPressed: () {}, title: 'Publish'.tr),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

  final bool isArabic = AppUtil.rtlDirection(context);
  final intl.DateFormat dayFormatter = intl.DateFormat('d', isArabic ? 'ar' : 'en');
  final intl.DateFormat monthYearFormatter = intl.DateFormat('MMMM yyyy', isArabic ? 'ar' : 'en');

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

String _StringMeal(String meal, BuildContext context) {
  if (AppUtil.rtlDirection2(context)) {
    switch (meal) {
      case "Breakfast":
        return "فطور";
      case "Dinner":
        return "غداء";
      case "Lunch":
        return "عشاء";
      default:
        return meal; // Return the original meal if no match is found
    }
  } else {
    return meal; // Return the original meal if the direction is not RTL
  }
}
