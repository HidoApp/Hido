import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/view/Adventure_summary_screen.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/view/event_summary_screen.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/summary_screen.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';
import 'package:intl/intl.dart' as intel;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class EventExperienceCard extends StatefulWidget {
  const EventExperienceCard({Key?key, required this.experience,this.type}): super(key: key);


  final experience;
  final String? type;

  @override
  State<EventExperienceCard> createState() => _EventExperienceCardState();
}

class _EventExperienceCardState extends State<EventExperienceCard> {
   @override
  void initState() {
    super.initState();
    selectedDate = dates.first;

    _controller = ExpandedTileController(isExpanded: false);
  }
   
   
bool isDateBefore24Hours() {
   final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;
  
  tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
     DateTime parsedDate = DateTime.parse(widget.experience.daysInfo.first.startTime);
    Duration difference =  parsedDate.difference(currentDateInRiyadh);
    print('this deffrence');
    print(difference);
    return difference.inHours <= 24;
  }
  late ExpandedTileController _controller;
String? selectedDate;

  final List<String> dates = [
    '27 فبراير',
    '25 فبراير',
    '29 فبراير',
        '23فبراير',
            '28 فبراير',
    



  ];

  
  @override
  Widget build(BuildContext context) {
    final TouristExploreController _touristExploreController =
        Get.put(TouristExploreController());
    Place? thePlace;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
     height: _controller.isExpanded ? width * 0.3+(dates.length * 15.0) : width * 0.35,
     width: double.infinity,
     padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
        color: Colors.white,

          shadows: [
            BoxShadow(
              color: Color(0x3FC7C7C7),
              blurRadius: 15,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         
         Row(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
             Padding(
               padding: const EdgeInsets.only(bottom: 1),
               child: ClipRRect(
                 borderRadius:
                     const BorderRadius.all(Radius.circular(6.57)),
                 child: Image.network(
                   widget.experience.image[0],
                   height: height * 0.06,
                   width: width * 0.132,
                   fit: BoxFit.cover,
                 ),
               ),
             ),
             SizedBox(
               width: 8,
             ),
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.only(bottom: 15),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment:
                           MainAxisAlignment.spaceBetween,
                       children: [
                         CustomText(
                           text: AppUtil.rtlDirection2(context)
                               ? widget.experience.nameAr
                               :widget. experience.nameEn,
                           fontSize: 16,
                           fontWeight: FontWeight.w600,
                           fontFamily: AppUtil.rtlDirection2(context)
                               ? 'SF Pro'
                               : 'SF Arabic',
                         ),

                   if(widget.experience.status=='DELETED')

                   Row(
                       children: [
                         CustomText(
                           text: 
                         formatBookingDate(context,
                              widget. experience.daysInfo.first.startTime),
                           fontSize: 12,
                           fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',
                           fontWeight: FontWeight.w600,
                           color: Color(0xFFB9B8C1),
                        
                         ),
                       ],
                     ),
                         
                       ],
                     ),

                     Row(
                       children: [
                       //  if(hospitality.status!='DELETED')

                         CustomText(
                           text:selectedDate,
                          //  formatBookingDate(context,
                          //    widget.  experience.daysInfo.first.startTime),
                           fontSize: 12,
                            fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',

                           fontWeight: FontWeight.w600,
                           color: colorGreen,
                         ),
                       ],
                     ),

                   ],
                 ),
               ),

             ),
             if(widget.experience.status!='DELETED')
         
                   Padding(
                     padding: const EdgeInsets.only(bottom:14),
                     child: isDateBefore24Hours()?

                    ElevatedButton(
  onPressed: () {
   
     
     Get.to(EventSummaryScreen(eventId:widget.experience.id));

    
  },
  style: ElevatedButton.styleFrom(
    backgroundColor:colorGreen, 
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(4),
    ),
    minimumSize: Size(100, 37), // Width and height
  ),
  child: Text(
AppUtil.rtlDirection2(context)? 'ملخص':'Summary',
    textAlign: TextAlign.center,
    style: TextStyle(
     color: Colors.white,
     fontSize: 13,
     fontFamily: AppUtil.rtlDirection2(context)? 'SF Arabic': 'SF Pro',

     fontWeight: FontWeight.w600,
    ),
  ),
):Container(),
                   ),
                   

           ],
         ),

         const Divider(
     color: lightGrey,
         ),
         //                              // SizedBox(height: width * 0.03),
         ExpandedTile(
     contentseparator: 12,
     trailing: Icon(
       Icons.keyboard_arrow_down_outlined,
       size: width * 0.046,
     ),
     disableAnimation: true,
     trailingRotation: 180,
     onTap: () {
       // print(widget.request.date);
       setState(() {});
     },
     title:CustomText(
       text: AppUtil.rtlDirection2(context) ? 'تغيير التاريخ' : 'See more',
       color:black,
       fontSize: 13,
       fontFamily: AppUtil.rtlDirection2(context)
                   ? 'SF Arabic'
                   : 'SF Pro',
       fontWeight: FontWeight.w500,
     ),
     content: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
       Container(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: dates.map((date) {
                        bool isSelected = date == selectedDate;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                          child: Container(
                            width: 88,
                            height: 24,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? Color(0xFFECF9F1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(48),
                            ),
                            child: Center(
                              child: Text(
                                date,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected ? Color(0xFF37B268) : Color(0xFF9392A0),
                                  fontSize: 12,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
        
      
     controller: _controller,
     theme: const ExpandedTileThemeData(
       leadingPadding: EdgeInsets.zero,
       titlePadding: EdgeInsets.zero,
       headerPadding: EdgeInsets.zero,
       contentPadding: EdgeInsets.zero,
       headerSplashColor: Colors.transparent,
       headerColor: Colors.transparent,
       contentBackgroundColor: Colors.transparent,
     ),
         ),
       ],
     ),
       );
  }

  String getOrderStatusText(BuildContext context, String orderStatus) {
    if (AppUtil.rtlDirection2(context)) {
      switch (orderStatus) {
        case 'ACCEPTED':
          return 'مؤكد';
        case 'Uppending':
          return 'في الانتظار';
        case 'Finished':
          return 'اكتملت';
        case 'CANCELED':
          return 'تم الالغاء';
        default:
          return orderStatus;
      }
    } else {
      return orderStatus;
    }
  }

  String getBookingTypeText(BuildContext context, String bookingType) {
    if (AppUtil.rtlDirection2(context)) {
      switch (bookingType) {
        case 'place':
          return 'جولة';
        case 'adventure':
          return 'مغامرة';
        case 'hospitality':
          return 'ضيافة';
        case 'event':
          return 'فعالية';
        default:
          return bookingType;
      }
    } else {
      if (bookingType == 'place') {
        return "Tour";
      } else {
        return bookingType;
      }
    }
  }

  String formatBookingDate(BuildContext context, String date) {
    DateTime dateTime = DateTime.parse(date);
    if (AppUtil.rtlDirection2(context)) {
      // Set Arabic locale for date formatting
      return intel.DateFormat('d MMMM yyyy', 'ar').format(dateTime);
    } else {
      // Default to English locale
      return intel.DateFormat('d MMMM yyyy').format(dateTime);
    }
  }
}
