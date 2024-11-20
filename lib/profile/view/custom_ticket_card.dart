import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';
import 'package:intl/intl.dart' as intel;

class CustomTicketCard extends StatefulWidget {
  const CustomTicketCard({
    Key? key,
    required this.booking,
  }) : super(key: key);

  final Booking booking;
  @override
  _CustomTicketCardState createState() => _CustomTicketCardState();
}

class _CustomTicketCardState extends State<CustomTicketCard> {
  String address = '';

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<String> _getAddressFromLatLng(
      double position1, double position2) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position1, position2);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        if (placemark.subLocality!.isEmpty) {
          if (placemark.administrativeArea!.isEmpty) {
            return '${placemark.thoroughfare}';
          } else {
            return '${placemark.administrativeArea}';
          }
        } else {
          return '${placemark.subLocality}';
        }
      }
    } catch (e) {}
    return '';
  }

  Future<void> _fetchAddress() async {
    try {
      double? latitude;
      double? longitude;

      switch (widget.booking.bookingType) {
        case 'hospitality':
          latitude = double.parse(
              widget.booking.hospitality?.coordinate.latitude ?? '');
          longitude = double.parse(
              widget.booking.hospitality?.coordinate.longitude ?? '');
          break;
        case 'event':
          latitude =
              double.parse(widget.booking.event?.coordinates?.latitude ?? '');
          longitude =
              double.parse(widget.booking.event?.coordinates?.longitude ?? '');
          break;
        case 'adventure':
          latitude = double.parse(
              widget.booking.adventure?.coordinates?.latitude ?? '');
          longitude = double.parse(
              widget.booking.adventure?.coordinates?.longitude ?? '');
          break;
        case 'place':
          latitude =
              double.parse(widget.booking.place?.coordinates?.latitude ?? '');
          longitude =
              double.parse(widget.booking.place?.coordinates?.longitude ?? '');
          break;
        default:
          throw Exception('Unknown booking type');
      }

      String result = await _getAddressFromLatLng(latitude, longitude);
      setState(() {
        address = result;
      });
    } catch (e) {
      // Handle error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    final TouristExploreController touristExploreController =
        Get.put(TouristExploreController());
    Place? thePlace;
    // log(widget.booking.cost!);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: widget.booking.orderStatus == 'ACCEPTED'
          ? () {
              Get.to(() => TicketDetailsScreen(
                    booking: widget.booking,
                    icon: SvgPicture.asset(
                      'assets/icons/${widget.booking.bookingType! == 'place' ? 'place.svg' : widget.booking.bookingType! == 'hospitality' ? 'hospitality.svg' : widget.booking.bookingType == 'event' ? 'event.svg' : 'adventure.svg'}',
                    ),
                    bookTypeText: getBookingTypeText(
                        context, widget.booking.bookingType!),
                  ));
            }
          : widget.booking.orderStatus == 'PENDING'
              ? () {
                  touristExploreController
                      .getPlaceById(
                    id: widget.booking.place?.id,
                    context: context,
                  )
                      .then((place) {
                    thePlace = place;
                    Get.to(
                      () => FindAjwady(
                        booking: thePlace!.booking![0],
                        place: widget.booking.place!,
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.041),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
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
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 12, left: 12, right: 12, top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  child: ImageCacheWidget(
                    image: widget.booking.bookingType == "place"
                        ? widget.booking.place!.image![0]
                        : widget.booking.bookingType == "hospitality"
                            ? widget.booking.hospitality!.images[0]
                            : widget.booking.bookingType == 'event'
                                ? widget.booking.event!.images[0]
                                : widget.booking.adventure!.image![0],
                    height: height * 0.076,
                    width: width * 0.16,
                    // fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
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
                              text: !AppUtil.rtlDirection2(context)
                                  ? widget.booking.bookingType == "place"
                                      ? widget.booking.place!.nameEn!
                                      : widget.booking.bookingType ==
                                              "hospitality"
                                          ? widget.booking.hospitality!.titleEn
                                          : widget.booking.bookingType ==
                                                  'event'
                                              ? widget.booking.event!.nameEn ??
                                                  ""
                                              : widget.booking.adventure!
                                                      .nameEn ??
                                                  ''
                                  : widget.booking.bookingType == "place"
                                      ? widget.booking.place!.nameAr!
                                      : widget.booking.bookingType ==
                                              "hospitality"
                                          ? widget.booking.hospitality!.titleAr
                                          : widget.booking.bookingType ==
                                                  'event'
                                              ? widget.booking.event!.nameAr!
                                              : widget.booking.adventure!
                                                      .nameAr ??
                                                  '',
                              fontSize: width * 0.041,
                              fontWeight: FontWeight.w500,
                              fontFamily: !AppUtil.rtlDirection2(context)
                                  ? 'SF Pro'
                                  : 'SF Arabic',
                            ),
                            Row(
                              textDirection: AppUtil.rtlDirection2(context)
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/${widget.booking.bookingType! == 'place' ? 'place.svg' : widget.booking.bookingType! == 'hospitality' ? 'hospitality.svg' : widget.booking.bookingType == 'event' ? 'event.svg' : 'adventure.svg'}',
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                CustomText(
                                  text: AppUtil.getBookingTypeText(
                                      context, widget.booking.bookingType!),
                                  fontSize: width * 0.03,
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
                          SizedBox(
                            width: width * 0.01,
                          ),
                          CustomText(
                            text: address.isNotEmpty
                                ? AppUtil.rtlDirection2(context)
                                    ? '${widget.booking.bookingType == "place" ? widget.booking.place!.regionAr! : widget.booking.bookingType == "hospitality" ? widget.booking.hospitality!.regionAr : widget.booking.bookingType == 'event' ? widget.booking.event!.regionAr : widget.booking.adventure!.regionAr ?? ''}, $address'
                                    : '${widget.booking.bookingType == "place" ? widget.booking.place!.regionEn! : widget.booking.bookingType == "hospitality" ? widget.booking.hospitality!.regionEn : widget.booking.bookingType == 'event' ? widget.booking.event!.regionEn : widget.booking.adventure!.regionEn ?? 'Riyadh'}, $address'
                                : "",

                            //  AppUtil.rtlDirection2(context)
                            //     ? widget.booking.bookingType == "place"
                            //         ? widget.booking.place!.regionAr!
                            //         : widget.booking.bookingType! == 'hospitality'
                            //             ? widget.booking.hospitality!.regionAr!
                            //             : widget.booking.bookingType == 'event'
                            //                 ?widget.booking.event!.regionAr ?? ""
                            //                 : widget.booking.adventure!.regionAr ??
                            //                     ''
                            //     : widget.booking.bookingType == "place"
                            //         ? widget.booking.place!.regionEn!
                            //         : widget.booking.bookingType! == 'hospitality'
                            //             ? widget.booking.hospitality!.regionEn
                            //             : widget.booking.bookingType == 'event'
                            //                 ? widget.booking.event!.regionEn ?? ""
                            //                 : widget.booking.adventure!.regionEn ??
                            //                     '',
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
                          SizedBox(
                            width: width * 0.005,
                          ),
                          SvgPicture.asset(
                            'assets/icons/calendar.svg',
                          ),
                          SizedBox(
                            width: width * 0.013,
                          ),
                          CustomText(
                            // text:intel.DateFormat.yMMMMd().format(DateTime.parse(booking.date!)),
                            text:
                                formatBookingDate(context, widget.booking.date),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textGreyColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/${widget.booking.orderStatus! == 'ACCEPTED' || widget.booking.orderStatus! == 'FINISHED' ? 'confirmed.svg' : widget.booking.orderStatus! == 'CANCELED' ? 'canceled.svg' : 'pending.svg'}',
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          CustomText(
                            text: getOrderStatusText(
                                    context, widget.booking.orderStatus!)
                                .capitalizeFirst,
                            //text:booking.orderStatus!,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: widget.booking.orderStatus! == 'ACCEPTED' ||
                                    widget.booking.orderStatus! == 'FINISHED'
                                ? colorGreen
                                : widget.booking.orderStatus! == 'CANCELED'
                                    ? const Color(0xFFDC362E)
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
    );
  }
}

String getOrderStatusText(BuildContext context, String orderStatus) {
  if (AppUtil.rtlDirection2(context)) {
    switch (orderStatus) {
      case 'ACCEPTED':
        return 'مؤكد';
      case 'PENDING':
        return 'في الإنتظار';
      case 'FINISHED':
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
    return intel.DateFormat('EEEE، d MMMM yyyy', 'ar').format(dateTime);
  } else {
    // Default to English locale
    return intel.DateFormat('E dd MMM yyyy').format(dateTime);
  }
}
