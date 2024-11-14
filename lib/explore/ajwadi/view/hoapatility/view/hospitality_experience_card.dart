import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/view/event_summary_screen.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/summary_screen.dart';
import 'package:ajwad_v4/services/model/booking_dates.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:intl/intl.dart' as intel;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class HospitalityExperienceCard extends StatefulWidget {
  const HospitalityExperienceCard(
      {Key? key, required this.experience, this.type, this.isPast = false})
      : super(key: key);

  final Hospitality experience;
  final String? type;
  final bool isPast;

  @override
  State<HospitalityExperienceCard> createState() =>
      _HospitalityExperienceCardState();
}

class _HospitalityExperienceCardState extends State<HospitalityExperienceCard> {
  @override
  void initState() {
    super.initState();
    sortedBookingDates = widget.experience.bookingDates!
      ..sort((a, b) => a.date.compareTo(b.date));
    selectedDate = sortedBookingDates?.first.date;

    _controller = ExpandedTileController(isExpanded: false);
  }

  bool isDateBefore24Hours(String date) {
    const String timeZoneName = 'Asia/Riyadh';
    late tz.Location location;

    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime parsedDate = DateTime.parse(date);
    final parsedDateInRiyadh = tz.TZDateTime.from(parsedDate, location)
        .subtract(const Duration(hours: 3));

    // Compare only year, month, and day
    // bool isSameDay = currentDateInRiyadh.year == parsedDateInRiyadh.year &&
    //                   currentDateInRiyadh.month == parsedDateInRiyadh.month &&
    //                   currentDateInRiyadh.day == parsedDateInRiyadh.day;

    // if (isSameDay) {
    //   return true;
    // }
    Duration difference = parsedDateInRiyadh.difference(currentDateInRiyadh);
    log('deference ${widget.experience.titleEn}');
    log(difference.toString());
    log((difference.inHours <= 24).toString());

    return (difference.inHours <= 24 || difference.inHours >= 24) &&
        !difference.inHours.isNegative;
    // return difference.inHours <= 24 && difference.inHours > 0;
  }

  bool isDateOut(String date) {
    const String timeZoneName = 'Asia/Riyadh';
    late tz.Location location;

    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime parsedDate = DateTime.parse(date);
    final parsedDateInRiyadh = tz.TZDateTime.from(parsedDate, location)
        .subtract(const Duration(hours: 3));
    log(widget.experience.titleAr.toString());
    log(parsedDate.toString());
    log(parsedDateInRiyadh.toString());
    log(currentDateInRiyadh.toString());

    if (parsedDateInRiyadh.year == currentDateInRiyadh.year &&
        parsedDateInRiyadh.month == currentDateInRiyadh.month &&
        parsedDateInRiyadh.day == currentDateInRiyadh.day) {
      return false; // Return false if it's the same day
    }

    return parsedDateInRiyadh.isBefore(currentDateInRiyadh);

    // return parsedDateInRiyadh.isBefore(currentDateInRiyadh);
  }

  late ExpandedTileController _controller;
  String? selectedDate;
  List<BookingDates>? sortedBookingDates;
  final List<String> dates = [
    '27 فبراير',
    '25 فبراير',
    '29 فبراير',
    '23فبراير',
    '28 فبراير',
  ];

  @override
  Widget build(BuildContext context) {
    final TouristExploreController touristExploreController =
        Get.put(TouristExploreController());
    Place? thePlace;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.041),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          color: Colors.white,
          shadows: [
            BoxShadow(
              color: const Color(0x3FC7C7C7),
              blurRadius: width * 0.04,
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6.57)),
                    child: ImageCacheWidget(
                      image: widget.experience.images.isNotEmpty
                          ? widget.experience.images[0]
                          : 'assets/images/Placeholder.png',
                      height: height * 0.06,
                      width: width * 0.132,
                    )),
              ),
              const SizedBox(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: AppUtil.rtlDirection2(context)
                                ? widget.experience.titleAr
                                : widget.experience.titleEn,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Pro'
                                : 'SF Arabic',
                          ),
                          if (widget.isPast)
                            Row(
                              children: [
                                CustomText(
                                  text: widget.experience.daysInfo!.isNotEmpty
                                      ? AppUtil.formatSelectedDaysInfo(
                                          widget.experience.daysInfo!, context)
                                      : '',
                                  fontSize: 12,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFB9B8C1),
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (!widget.isPast)
                        Row(
                          children: [
                            CustomText(
                              text: isDateOut(selectedDate!)
                                  ? widget.experience.daysInfo!.isNotEmpty
                                      ? AppUtil.formatSelectedDaysInfo(
                                          widget.experience.daysInfo!, context)
                                      : ''
                                  : formatBookingDate(context, selectedDate!),
                              fontSize: 12,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w600,
                              color: isDateOut(selectedDate!)
                                  ? const Color(0xFFB9B8C1)
                                  : colorGreen,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if (!widget.isPast) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: isDateBefore24Hours(selectedDate!)
                      ? ElevatedButton(
                          onPressed: () {
                            Get.to(SummaryScreen(
                              hospitalityId: widget.experience.id,
                              date: selectedDate!,
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorGreen,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            minimumSize:
                                const Size(100, 37), // Width and height
                          ),
                          child: CustomText(
                            text: 'summary'.tr,
                            textAlign: TextAlign.center,
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Container(),
                )
              ],
            ]),
            const Divider(
              color: lightGrey,
            ),
            if (widget.experience.status != 'DELETED') ...[
              ExpandedTile(
                contentseparator: 12,
                trailing: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: width * 0.046,
                ),
                disableAnimation: true,
                trailingRotation: 180,
                onTap: () {
                  //
                  setState(() {});
                },
                title: CustomText(
                  text: AppUtil.rtlDirection2(context)
                      ? (!widget.isPast)
                          ? 'تغيير التاريخ'
                          : 'التواريخ المحجوزة'
                      : (!widget.isPast)
                          ? 'Change Date'
                          : "Booked Dates",
                  color: black,
                  fontSize: 13,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  fontWeight: FontWeight.w500,
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children:
                            sortedBookingDates!.map<Widget>((bookingDate) {
                          final date = bookingDate
                              .date; // Access the date property directly
                          bool isSelected = date == selectedDate;
                          bool isPastDate = isDateOut(date);

                          return GestureDetector(
                            onTap: isPastDate
                                ? null // Disable tap if date is in the past
                                : () {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  },
                            child: Container(
                              width: 88,
                              height: 24,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isPastDate
                                    ? Colors.transparent // Gray out past dates
                                    : isSelected
                                        ? const Color(0xFFECF9F1)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(48),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: formatBookingDateMonth(context, date),
                                  textAlign: TextAlign.center,
                                  color: isPastDate
                                      ? const Color(
                                          0xFF9392A0) // Gray out past dates
                                      : isSelected
                                          ? const Color(0xFF37B268)
                                          : const Color(0xFF9392A0),
                                  fontSize: 12,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  fontWeight: FontWeight.w400,
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
          ],
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
          return 'نشاط';
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

  String formatBookingDateMonth(BuildContext context, String date) {
    DateTime dateTime = DateTime.parse(date);
    if (AppUtil.rtlDirection2(context)) {
      // Set Arabic locale for date formatting
      return intel.DateFormat('d MMMM', 'ar').format(dateTime);
    } else {
      // Default to English locale
      return intel.DateFormat('d MMMM').format(dateTime);
    }
  }
}
