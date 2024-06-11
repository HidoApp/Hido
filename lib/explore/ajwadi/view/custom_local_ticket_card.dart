import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLocalTicketCard extends StatefulWidget {
  const CustomLocalTicketCard({
    Key? key,
    this.booking,
  }) : super(key: key);

  final Booking? booking;

  @override
  _CustomLocalTicketCardState createState() => _CustomLocalTicketCardState();
}

class _CustomLocalTicketCardState extends State<CustomLocalTicketCard> {
  bool isDetailsTapped1 = false;

  @override
  Widget build(BuildContext context) {
    final TouristExploreController _touristExploreController =
        Get.put(TouristExploreController());
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return InkWell(
      child: Container(
        width: double.infinity,
        height: 152,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(),
          shadows: [
            BoxShadow(
              color: Color(0x3FC7C7C7),
              blurRadius: 15,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
          surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  textDirection: AppUtil.rtlDirection2(context)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  children: [
                    CustomText(
                      text: 'Edge of the World',
                      color: Color(0xFF070708),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      fontFamily: AppUtil.rtlDirection(context)
                          ? 'SF Pro'
                          : 'SF Arabic',
                    ),
                    Spacer(),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // onPressed function
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            surfaceTintColor:
                                MaterialStateProperty.all(Colors.white),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(
                                color: Color(0xFF37B268),
                                fontSize: 13,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                            fixedSize:
                                MaterialStateProperty.all(Size(73, 40)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(
                                  color: Color(0xFF37B268),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          child: Text('Chat'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // onPressed function
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF37B268)),
                            fixedSize:
                                MaterialStateProperty.all(Size(89, 40)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(
                                  color: Color.fromARGB(255, 76, 196, 124),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            'Start',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 13,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                      text: 'With Eddie Bravo',
                      textAlign: TextAlign.right,
                      color: Color(0xFF41404A),
                      fontSize: 12,
                      fontFamily: 'SF Pro',
                      height: 0,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Divider(thickness: 1, color: Color(0xFFECECEE)),
                // SingleChildScrollView(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       ListTile(
                //         onTap: () {
                //           setState(() {
                //             isDetailsTapped1 = !isDetailsTapped1;
                //           });
                //         },
                //         title: Row(
                //           mainAxisAlignment: MainAxisAlignment.end,
                //           children: [
                //             CustomText(
                //               text: 'See more '.tr,
                //               color: Color(0xFF37B268),
                //               fontSize: 12,
                //               fontFamily: 'SF Pro',
                //               fontWeight: FontWeight.w500,
                //               textAlign: AppUtil.rtlDirection2(context)
                //                   ? TextAlign.right
                //                   : TextAlign.right,
                //             ),
                //           ],
                //         ),
                //       ),
                //       if (isDetailsTapped1)
                //         Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 7),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Container(
                //                 decoration: ShapeDecoration(
                //                   color: Colors.white,
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(12),
                //                   ),
                //                 ),
                //                 child: Row(
                //                   children: [
                //                     SvgPicture.asset('assets/icons/date.svg'),
                //                     const SizedBox(width: 10),
                //                     CustomText(
                //                       text: '', // Add the booking date here
                //                       color: Colors.grey,
                //                       fontSize: 13,
                //                       fontWeight: FontWeight.w400,
                //                       fontFamily: 'SF Pro',
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //               const SizedBox(height: 10),
                //               Row(
                //                 children: [
                //                   SvgPicture.asset('assets/icons/time3.svg'),
                //                   const SizedBox(width: 9),
                //                   CustomText(
                //                     text: '', // Add the booking time here
                //                     color: Colors.grey,
                //                     fontSize: 13,
                //                     fontWeight: FontWeight.w400,
                //                     fontFamily: 'SF Pro',
                //                   ),
                //                 ],
                //               ),
                //               const SizedBox(height: 10),
                //               Row(
                //                 children: [
                //                   SvgPicture.asset('assets/icons/guests.svg'),
                //                   const SizedBox(width: 10),
                //                   CustomText(
                //                     text: '', // Add the guest number here
                //                     color: Colors.grey,
                //                     fontSize: 13,
                //                     fontWeight: FontWeight.w400,
                //                     fontFamily: 'SF Pro',
                //                   ),
                //                 ],
                //               ),
                //               const SizedBox(height: 10),
                //               Row(
                //                 children: [
                //                   const SizedBox(width: 10),
                //                   CustomText(
                //                     text: '', // Add the vehicle type here
                //                     color: Colors.grey,
                //                     fontSize: 13,
                //                     fontWeight: FontWeight.w400,
                //                     fontFamily: 'SF Pro',
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
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
      return intel.DateFormat('EEEE، d MMMM yyyy', 'ar').format(dateTime);
    } else {
      // Default to English locale
      return intel.DateFormat('EEEE, d MMMM yyyy').format(dateTime);
    }
  }
}
