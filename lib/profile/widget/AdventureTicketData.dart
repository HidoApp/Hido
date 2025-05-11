import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';
import '../../explore/tourist/model/booking.dart';
import '../../services/model/adventure.dart';
import '../../utils/app_util.dart';
import '../../widgets/dotted_line_separator.dart';

class AdventureTicketData extends StatelessWidget {
  final Booking? booking;
  final SvgPicture? icon;
  final String? bookTypeText;
  final Adventure? adventure;
  // final int? maleGuestNum;
  // final int? femaleGuestNum;

  AdventureTicketData({
    Key? key,
    this.booking,
    this.icon,
    this.bookTypeText,
    // this.femaleGuestNum,
    // this.maleGuestNum,
    this.adventure,
  }) : super(key: key);
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 117,
        left: AppUtil.rtlDirection2(context)
            ? MediaQuery.of(context).size.width * 0.35
            : null,
        right: AppUtil.rtlDirection2(context)
            ? null
            : MediaQuery.of(context).size.width * 0.35,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Copied'.tr,
              style: TextStyle(
                color: Colors.white,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      _overlayEntry?.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: adventure == null
                          ? booking!.id!.substring(0, 7)
                          : adventure!.booking!.last.id!.substring(0, 7)));
                  _showOverlay(context);
                },
                child: SvgPicture.asset(
                  'assets/icons/Summary.svg',
                  width: 20,
                  height: 20,
                )),
            const SizedBox(width: 8),
            Text(
              '#${adventure == null ? booking!.id!.substring(0, 7) : adventure!.booking!.last.id!.substring(0, 7)}',
              style: TextStyle(
                color: const Color(0xFFB9B8C1),
                fontSize: 13,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "BookingDetails".tr,
              style: TextStyle(
                color: black,
                fontSize: width * 0.044,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            Row(
              children: [
                icon ?? const SizedBox.shrink(),
                Text(
                  ' ${AppUtil.getBookingTypeText(context, bookTypeText ?? '')}',
                  style: TextStyle(
                    color: black,
                    fontSize: width * 0.038,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'date'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: starGreyColor,
                    fontSize: width * 0.035,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  adventure == null
                      ? AppUtil.formatBookingDate(context, booking!.date)
                      : AppUtil.formatBookingDate(
                          context, adventure!.booking!.last.date),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: black,
                    fontSize: width * 0.038,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'pickUp1'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: starGreyColor,
                        fontSize: width * 0.035,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      adventure == null
                          ? formatTimeWithLocale(context, booking!.timeToGo)
                          : formatTimeWithLocale(
                              context, adventure!.booking!.last.timeToGo),
                      style: TextStyle(
                        color: black,
                        fontSize: width * 0.038,
                        fontFamily: AppUtil.SfFontType(context),
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'dropOff1'.tr,
                          style: TextStyle(
                            color: starGreyColor,
                            fontSize: width * 0.035,
                            fontFamily: AppUtil.SfFontType(context),
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          adventure == null
                              ? formatTimeWithLocale(
                                  context, booking!.timeToReturn)
                              : formatTimeWithLocale(context,
                                  adventure!.booking!.last.timeToReturn),
                          style: TextStyle(
                            color: black,
                            fontSize: width * 0.038,
                            fontFamily: AppUtil.SfFontType(context),
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'numberOfPeople'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: starGreyColor,
                fontSize: width * 0.035,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            Text(
              adventure == null
                  ? '${booking?.guestNumber} ${'person'.tr}'
                  : '${adventure!.booking!.last.guestInfo!.guestNumber} ${'person'.tr}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: black,
                fontSize: width * 0.038,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'cost'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: starGreyColor,
                          fontSize: width * 0.035,
                          fontFamily: AppUtil.SfFontType(context),
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            // booking.place!.price.toString(),
                            adventure == null
                                ? booking!.cost.toString()
                                : adventure!.booking!.last.cost.toString(),

                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: black,
                              fontSize: width * 0.044,
                              fontFamily: AppUtil.SfFontType(context),
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            AppUtil.rtlDirection2(context) ? 'ريال' : 'SAR',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: black,
                              fontSize: width * 0.035,
                              fontFamily: AppUtil.SfFontType(context),
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
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
        const SizedBox(
          height: 12,
        ),
        const DottedSeparator(
          color: almostGrey,
          height: 1,
        ),
        const SizedBox(height: 25),
        GestureDetector(
          onTap: () async {
            final Uri url = adventure == null
                ? Uri.parse(booking!.adventure?.locationUrl ?? '')
                : Uri.parse(adventure!.locationUrl ?? '');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $url';
            }
            // String query = Uri.encodeComponent('https://maps.app.goo.gl/Z4kmkh5ikW31NacQA');
            //  String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

            // if (await canLaunchUrl(googleUrl)) {
            //      await launchUrl(googleUrl);
            //         }

//                      String googleUrl =
//                  'comgooglemaps://?center= Z4kmkh5ikW31NacQA;
//                 String appleUrl =
//                  'https://maps.apple.com/?sll=${trip.origLocationObj.lat},${trip.origLocationObj.lon}';
//                 if (await canLaunchUrl("comgooglemaps://")) {
//
//                     await launchUrl(googleUrl);
//                   } else if (await canLaunch(appleUrl)) {
//
//                        await launchUrl(appleUrl);
//                            } else {
//                         throw 'Could not launch url';
//                        }
// }
//                   },
          },
          child: Text(
            'Location'.tr,
            style: TextStyle(
              color: const Color(0xFF37B268),
              fontSize: 18,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w600,
              height: 0,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  String formatTimeWithLocale(BuildContext context, String dateTimeString) {
    DateTime time = DateFormat("HH:mm").parse(dateTimeString);
    String formattedTime = DateFormat.jm().format(time);
    if (AppUtil.rtlDirection2(context)) {
      // Arabic locale
      String suffix = time.hour < 12 ? 'صباحًا' : 'مساءً';
      formattedTime = formattedTime
          .replaceAll('AM', '')
          .replaceAll('PM', '')
          .trim(); // Remove AM/PM
      return '$formattedTime $suffix';
    } else {
      // Default to English locale
      return formattedTime;
    }
  }
}
