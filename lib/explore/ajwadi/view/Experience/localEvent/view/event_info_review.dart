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
        return '${placemark.subLocality}, ${placemark.locality},${placemark.country}';
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
        "seats": _EventController.seletedSeat.value
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
    // _fetchAddress();

    daysInfo();
   WidgetsBinding.instance.addPostFrameCallback((_) {

    setState(() {
     locationUrl = getLocationUrl(_EventController.pickUpLocLatLang.value);
      print('Location URL: $locationUrl');
     imageUrls = [
     "https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2018/12/21/1407236-1526060639.jpg?itok=mZ-hVN8I",
    "https://www.arabnews.com/sites/default/files/styles/n_670_395/public/2018/02/09/1096136-371337553.jpg?itok=KQ9w43Y-",
    "https://www.arabnews.com/sites/default/files/styles/n_670_395/public/2018/02/09/1096141-325555191.jpg?itok=BbYMyMpa"
];

      //  "https://media.cntraveler.com/photos/607313c3d1058698d13c31b5/1:1/w_1636,h_1636,c_limit/FamilyCamping-2021-GettyImages-948512452-4.jpg"
    // _EventController.pickUpLocLatLang.value=LatLng(24.9591,46.7661);

    });
            _fetchAddress();
    }
    );

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
                        image: NetworkImage(imageUrls[0]),
                        // FileImage(File(widget.hospitalityImages[0])),
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
                              AppUtil.rtlDirection2(context)
                                  ? widget.hospitalityTitleAr
                                  : widget.hospitalityTitleEn,
                              style: TextStyle(
                                color: Color(0xFF070708),
                                fontSize: 16,
                                fontFamily: AppUtil.rtlDirection2(context)?'SF Arabic': 'SF Pro',
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
                                    fontFamily:AppUtil.rtlDirection2(context)?'SF Arabic': 'SF Pro',
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
                                    SvgPicture.asset(
                                        'assets/icons/map_pin.svg'),
                                    const SizedBox(width: 4),
                                    Text(
                                      address,
                                     
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
                                  const SizedBox(width: 1),

                                      SvgPicture.asset(
                                        'assets/icons/grey_calender.svg',
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        AppUtil.formatSelectedDates(_EventController.selectedDates, context),
                                        style: TextStyle(
                                          color: Color(0xFF9392A0),
                                          fontSize: 11,
                                          fontFamily: AppUtil.rtlDirection2(context)?'SF Arabic': 'SF Pro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                               
                                const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: SvgPicture.asset(
                                          'assets/icons/timeGrey.svg',
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${AppUtil.formatStringTimeWithLocale(context, intl.DateFormat('HH:mm:ss').format(_EventController.selectedStartTime.value))} - ${AppUtil.formatStringTimeWithLocale(context, intl.DateFormat('HH:mm:ss').format(_EventController.selectedEndTime.value))}',
                                        style: TextStyle(
                                          color: Color(0xFF9392A0),
                                          fontSize: 11,
                                            fontFamily: AppUtil.rtlDirection2(context)?'SF Arabic'
                                       : 'SF Pro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
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
            child: Column(
              children: [
              CustomButton(
                  onPressed: () async {
                    final isSuccess = 
                        await _EventController!.createEvent(
                            nameAr: _EventController.titleAr.value,
                            nameEn: _EventController.titleEn.value,
                            descriptionAr:_EventController.bioAr.value,
                            descriptionEn: _EventController.bioEn.value,
                            longitude: _EventController.pickUpLocLatLang.value.longitude.toString(),
                            latitude: _EventController.pickUpLocLatLang.value.latitude.toString(),
                            price: widget.adventurePrice!,
                            image: imageUrls,
                            regionAr: ragionAr,
                            locationUrl: locationUrl,
                            daysInfo: DaysInfo,
                            regionEn: ragionEn,
                            context: context);

                    print('is sucssssss');
                    print(isSuccess);
                    if (isSuccess) {
                      
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: 350,
                              height: 110, // Custom width
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      'assets/images/paymentSuccess.gif',
                                      width: 38),
                                  SizedBox(height: 16),
                                  Text(
                                    !AppUtil.rtlDirection2(context)
                                        ? "Experience published successfully"
                                        : "تم نشر تجربتك بنجاح ",
                                    style: TextStyle(fontSize: 15),
                                    //textDirection:
                                        //AppUtil.rtlDirection2(context)
                                            //? TextDirection.rtl
                                            //: TextDirection.ltr,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).then((_) {
                Get.offAll(() => const AjwadiBottomBar());
                      });

                      
                    } else {
                      // AppUtil.errorToast(
                      //     context, 'somthingWentWrong'.tr);
                    }
                  },
                  title: 'Publish'.tr,
                  ),
                   SizedBox(height: 10),

                                CustomButton(
                                    onPressed: () {
                                      Get.until((route) =>
                                          Get.currentRoute == '/ExperienceType');
                                    },
                                    title: AppUtil.rtlDirection2(context)
                                        ? 'عودة للتجارب'
                                        : 'Return to Experiences',
                                    buttonColor: Colors.white.withOpacity(0.3),
                                    textColor: Color(0xFF070708)),

              ],
            ),
                  ),
                ),
                //  SizedBox(height: 10),

                //                 CustomButton(
                //                     onPressed: () {
                //                       Get.until((route) =>
                //                           Get.currentRoute == '/FindAjwady');
                //                     },
                //                     title: AppUtil.rtlDirection2(context)
                //                         ? 'عودة للعروض'
                //                         : 'Return to Offers'.tr,
                //                     buttonColor: Colors.white.withOpacity(0.3),
                //                     textColor: Color(0xFF070708)),

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
String extractMonths(context, String datesString) {
  // Remove brackets and split by comma to get individual date strings
  List<String> dateStrings = datesString.replaceAll('[', '').replaceAll(']', '').split(', ');


   String locale = AppUtil.rtlDirection2(context) ? 'ar' : 'en';

  // Parse each date string and extract the month
  List<String> monthsList = dateStrings.map((dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat.MMMM(locale).format(dateTime);
    
  }).toList();

  // Check if all months are the same
  bool allSame = monthsList.every((month) => month == monthsList[0]);

  if (allSame) {
    return [monthsList[0]].join(',');
  } else {
    return monthsList.join(', ');
  }
}