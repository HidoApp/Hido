
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/view/Adventure_summary_screen.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/summary_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:intl/intl.dart' as intel;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class CustomExperienceCard extends StatelessWidget {
  const CustomExperienceCard({super.key, required this.experience, this.type,this.isPast=false});

  final experience;
  final String? type;
  final bool isPast;

  bool isDateBefore24Hours() {
    final String timeZoneName = 'Asia/Riyadh';
    late tz.Location location;

    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime parsedDate;
    if (type == 'hospitality' || type == 'event') {
      if (experience.daysInfo.isNotEmpty) {
        parsedDate = DateTime.parse(experience.daysInfo.first.startTime);
      } else {
        return true;
      }
    } else {
      parsedDate = DateTime.parse(experience.date);
    }
    final parsedDateInRiyadh =
        tz.TZDateTime.from(parsedDate, location).subtract(Duration(hours: 3));

    Duration difference = parsedDateInRiyadh.difference(currentDateInRiyadh);
    print('this deffrence');
    print(difference);
    return difference.inHours <= 24;
  }

  @override
  Widget build(BuildContext context) {
    final TouristExploreController _touristExploreController =
        Get.put(TouristExploreController());
    Place? thePlace;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
     padding: EdgeInsets.symmetric(horizontal: width * 0.041),
      child: SizedBox(
        width: 334,
        height: 120,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(7.36)),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
               blurRadius: width * 0.04,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Summary.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                   CustomText(
                     text:'#${experience.id.substring(0, 7)}',
                        color: borderGrey,
                        fontSize: 15,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2, top: 14),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6.57)),
                        child: type == 'hospitality'
                            ?ImageCacheWidget(
                              image:experience.images.isNotEmpty? experience.images[0]:'assets/images/Placeholder.png' ,
                              height: height * 0.06,
                              width: width * 0.144,
                            )
                            
                            
                            : ImageCacheWidget(
                              image:experience.image.isNotEmpty? experience.image[0]:'assets/images/Placeholder.png',
                              height: height * 0.06,
                              width: width * 0.144,
                            )
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
                                      ? type == 'hospitality'
                                          ? experience.titleAr
                                          : experience.nameAr
                                      : type == 'hospitality'
                                          ? experience.titleEn
                                          : experience.nameEn,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Pro'
                                      : 'SF Arabic',
                                ),
                                // if (experience.status == 'DRAFT' ||
                                //     experience.status == 'CLOSED')
                                //   Row(
                                //     children: [
                                //       CustomText(
                                //         text: type == 'hospitality' ||
                                //                 type == 'event'
                                //             ? experience.daysInfo.isNotEmpty
                                //                 ? formatBookingDate(
                                //                     context,
                                //                     experience.daysInfo.first
                                //                         .startTime)
                                //                 : ''
                                //             : formatBookingDate(
                                //                 context, experience.date),
                                //         fontSize: 12,
                                //         fontFamily:
                                //             AppUtil.rtlDirection2(context)
                                //                 ? 'SF Arabic'
                                //                 : 'SF Pro',
                                //         fontWeight: FontWeight.w600,
                                //         color: Color(0xFFB9B8C1),
                                //       ),
                                //     ],
                                //   ),
                              ],
                            ),
                        
                               if(isPast)
                                  Row(
                                    children: [
                                      CustomText(
                                        text: type == 'hospitality' ||
                                                type == 'event'
                                            ? experience.daysInfo.isNotEmpty
                                                ? formatBookingDate(
                                                    context,
                                                    experience.daysInfo.first
                                                        .startTime)
                                                : ''
                                            : formatBookingDate(
                                                context, experience.date),
                                        fontSize: 12,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? 'SF Arabic'
                                                : 'SF Pro',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFB9B8C1),
                                      ),
                                    ],
                                  ),
                         
                         
                            if(!isPast)
                              Row(
                                children: [
    
                                  CustomText(
                                    text: type == 'hospitality' ||
                                            type == 'event'
                                        ? experience.daysInfo.isNotEmpty
                                            ? formatBookingDate(
                                                context,
                                                experience
                                                    .daysInfo.first.startTime)
                                            : ''
                                        : formatBookingDate(
                                            context, experience.date),
                                    fontSize: 12,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                    color: colorGreen,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                   
                      if(!isPast)
                      isDateBefore24Hours()
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (type == 'hospitality') {
                                    Get.to(SummaryScreen(
                                        hospitalityId: experience.id));
                                  } else if (type == 'adventure') {
                                    Get.to(AdventureSummaryScreen(
                                        adventureId: experience.id));
                                  } else {
                                    // Get.to(EventSummaryScreen(eventId:experience.id));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorGreen,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  minimumSize:
                                      Size(100, 37), // Width and height
                                ),
                                child:CustomText(
                                 text:'summary'.tr,
                                  textAlign: TextAlign.center,
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: AppUtil.rtlDirection2(context)
                                        ? 'SF Arabic'
                                        : 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                              ))
                          : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
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
