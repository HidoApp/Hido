import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/summary_screen.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';
import 'package:intl/intl.dart' as intel;

class CustomExperienceCard extends StatelessWidget {
  const CustomExperienceCard({super.key, required this.experience,this.type});

  final experience;
  final String? type;
  @override
  Widget build(BuildContext context) {
    final TouristExploreController _touristExploreController =
        Get.put(TouristExploreController());
    Place? thePlace;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap:
          // booking.orderStatus == 'ACCEPTED' ||
          //         booking.bookingType == 'hospitality' ||
          //         booking.bookingType == 'adventure'
             // ?
               () {
                  // Get.to(() => HospitalityDetails(hospitalityId: hospitality.id,isLocal: true,));
                      
                      
                },
          //     : booking.orderStatus == 'PENDING'
          //         ? () {
          //             print("id place");
          //             print(booking.placeId ?? '');
          //             _touristExploreController
          //                 .getPlaceById(
          //               id: booking.place?.id,
          //               context: context,
          //             )
          //                 .then((place) {
          //               thePlace = place;
          //               Get.to(
          //                 () => FindAjwady(
          //                   booking: thePlace!.booking![0],
          //                   place: booking.place!,
          //                   placeId: thePlace!.id!,
          //                 ),
          //               );
          //               //   ?.then((value) {
          //               //   return getPlaceBooking();
          //               // });
          //             });

          //             // Get.to(() => TicketDetailsScreen(booking: booking));
          //           }
          //         :
          // () {},
      child: Container(
        width: 334,
        height: 120,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(7.36)),
            boxShadow: [
              BoxShadow(
                color: Color(0x3FC7C7C7),
                blurRadius: 10,
                offset: Offset(1, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.36)),
            ),
            color: const Color.fromARGB(255, 255, 255, 255),
            surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
            //elevation: 0, // Set elevation to 0 to prevent default shadow

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
                      SvgPicture.asset('assets/icons/Summary.svg',width: 20,height: 20,),
                      const SizedBox(width: 8),
                      Text(
                         '#${experience.id.substring(0, 7)}',
                        style: TextStyle(
                          color: borderGrey,
                          fontSize: 15,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
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
                          child: type=='hospitality'?
                          Image.network(
                            experience.images[0],
                            height: height * 0.06,
                            width: width * 0.144,
                            fit: BoxFit.cover,
                          ):Image.network(
                            experience.image[0],
                            height: height * 0.06,
                            width: width * 0.144,
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
                                        ? type=='hospitality'? experience.titleAr:experience.nameAr
                                        : type=='hospitality'? experience.titleEn:experience.nameEn,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppUtil.rtlDirection(context)
                                        ? 'SF Pro'
                                        : 'SF Arabic',
                                  ),

                            if(experience.status=='DELETED')

                            Row(
                                children: [
                                  CustomText(
                                    text: 
                                   type=='hospitality'?  formatBookingDate(context,
                                        experience.daysInfo.first.startTime):formatBookingDate(context,
                                        experience.date),
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
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
                                    text:experience.status!='DELETED'?type=='hospitality' ?formatBookingDate(context,
                                        experience.daysInfo.first.startTime):formatBookingDate(context,
                                        experience.date):'',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: colorGreen,
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),

                      ),
                      if(experience.status!='DELETED')
                
                            Padding(
                              padding: const EdgeInsets.only(bottom:14),
                              child: 
                             ElevatedButton(
  onPressed: () {
    Get.to(SummaryScreen(hospitalityId:experience.id));
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
    'Summary',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontFamily: 'SF Pro',
      fontWeight: FontWeight.w600,
    ),
  ),
),
                            ),
                            

                    ],
                  ),
                ),
              ],
            ),
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