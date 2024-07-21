import 'dart:developer';

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

class CustomTicketCard extends StatelessWidget {
  const CustomTicketCard({
    super.key,
    required this.booking,
  });

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final TouristExploreController _touristExploreController =
        Get.put(TouristExploreController());
    Place? thePlace;
    log(booking!.cost!);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: booking.orderStatus == 'ACCEPTED' ||
              booking.bookingType == 'hospitality' ||
              booking.bookingType == 'adventure' ||
              booking.bookingType == 'event'
          ? () {
              Get.to(() => TicketDetailsScreen(
                    booking: booking,
                    icon: SvgPicture.asset(
                      'assets/icons/${booking.bookingType! == 'place' ? 'place.svg' : booking.bookingType! == 'hospitality' ? 'hospitality.svg' : booking.bookingType == 'event' ? 'event.svg' : 'adventure.svg'}',
                    ),
                    bookTypeText:
                        getBookingTypeText(context, booking.bookingType!),
                  ));
            }
          : booking.orderStatus == 'PENDING'
              ? () {
                  print("id place");
                  print(booking.placeId ?? '');
                  _touristExploreController
                      .getPlaceById(
                    id: booking.place?.id,
                    context: context,
                  )
                      .then((place) {
                    thePlace = place;
                    Get.to(
                      () => FindAjwady(
                        booking: thePlace!.booking![0],
                        place: booking.place!,
                        placeId: thePlace!.id!,
                      ),
                    );
                    //   ?.then((value) {
                    //   return getPlaceBooking();
                    // });
                  });

                  // Get.to(() => TicketDetailsScreen(booking: booking));
                }
              : () {},
      child: Container(
        width: 334,
        height: 130,
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

            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 12, left: 12, right: 8, top: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 37),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: Image.network(
                        booking.bookingType == "place"
                            ? booking.place!.image![0]
                            : booking.bookingType == "hospitality"
                                ? booking.hospitality!.images[0]
                                : booking.bookingType == 'event'
                                    ? booking.event!.images[0]
                                    : booking.adventure!.image![0],
                        height: height * 0.076,
                        width: width * 0.16,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: AppUtil.rtlDirection(context)
                                    ? booking.bookingType == "place"
                                        ? booking.place!.nameEn!
                                        : booking.bookingType == "hospitality"
                                            ? booking.hospitality!.titleEn
                                            : booking.bookingType == 'event'
                                                ? booking.event!.nameEn ?? ""
                                                : booking.adventure!.nameEn ??
                                                    ''
                                    : booking.bookingType == "place"
                                        ? booking.place!.nameAr!
                                        : booking.bookingType == "hospitality"
                                            ? booking.hospitality!.titleAr
                                            : booking.bookingType == 'event'
                                                ? booking.event!.nameAr!
                                                : booking.adventure!.nameAr ??
                                                    '',
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppUtil.rtlDirection(context)
                                    ? 'SF Pro'
                                    : 'SF Arabic',
                              ),
                              Row(
                                textDirection: AppUtil.rtlDirection2(context)
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/${booking.bookingType! == 'place' ? 'place.svg' : booking.bookingType! == 'hospitality' ? 'hospitality.svg' : booking.bookingType == 'event' ? 'event.svg' : 'adventure.svg'}',
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  CustomText(
                                    text: getBookingTypeText(
                                        context, booking.bookingType!),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/map_pin.svg'),
                            const SizedBox(
                              width: 4,
                            ),
                            CustomText(
                              text: AppUtil.rtlDirection2(context)
                                  ? booking.bookingType == "place"
                                      ? booking.place!.regionAr!
                                      : booking.bookingType! == 'hospitality'
                                          ? booking.hospitality!.regionAr!
                                          : booking.bookingType == 'event'
                                              ? booking.event!.regionAr ?? ""
                                              : booking.adventure!.regionAr ??
                                                  ''
                                  : booking.bookingType == "place"
                                      ? booking.place!.regionEn!
                                      : booking.bookingType! == 'hospitality'
                                          ? booking.hospitality!.regionEn
                                          : booking.bookingType == 'event'
                                              ? booking.event!.regionEn ?? ""
                                              : booking.adventure!.regionEn ??
                                                  '',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textGreyColor,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/grey_calender.svg',
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomText(
                              // text:intel.DateFormat.yMMMMd().format(DateTime.parse(booking.date!)),
                              text: formatBookingDate(context, booking.date),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textGreyColor,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/${booking.orderStatus! == 'ACCEPTED' || booking.orderStatus! == 'Finished' ? 'confirmed.svg' : booking.orderStatus! == 'CANCELED' ? 'canceled.svg' : 'waiting.svg'}',
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            CustomText(
                              text: getOrderStatusText(
                                  context, booking.orderStatus!),
                              //text:booking.orderStatus!,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: booking.orderStatus! == 'ACCEPTED' ||
                                      booking.orderStatus! == 'Finished'
                                  ? colorGreen
                                  : booking.orderStatus! == 'CANCELED'
                                      ? Color(0xFFDC362E)
                                      : colorDarkGrey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
