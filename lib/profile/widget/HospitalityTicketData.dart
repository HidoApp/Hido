import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';
import '../../explore/tourist/model/booking.dart';
import '../../services/model/hospitality.dart';
import '../../utils/app_util.dart';
import '../../widgets/dotted_line_separator.dart';

class HostTicketData extends StatelessWidget {
  final Booking? booking;
  final SvgPicture? icon;
  final String? bookTypeText;
  final Hospitality? hospitality;
  // final int? maleGuestNum;
  // final int? femaleGuestNum;

  HostTicketData({
    Key? key,
    this.booking,
    this.icon,
    this.bookTypeText,
    // this.femaleGuestNum,
    // this.maleGuestNum,
    this.hospitality,
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
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: hospitality == null
                          ? booking!.id!.substring(0, 7)
                          : hospitality!.booking!.last.id.substring(0, 7)));
                  _showOverlay(context);
                },
                child: SvgPicture.asset(
                  'assets/icons/Summary.svg',
                  width: 20,
                  height: 20,
                )),
            const SizedBox(width: 8),
            Text(
              '#${hospitality == null ? booking!.id!.substring(0, 7) : hospitality!.booking!.last.id.substring(0, 7)}',
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
                  AppUtil.getBookingTypeText(context, bookTypeText ?? ''),
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
                  hospitality == null
                      ? AppUtil.formatBookingDate(context, booking!.date)
                      : AppUtil.formatBookingDate(
                          context, hospitality!.booking!.last.date),
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
            if (hospitality == null ||
                (hospitality != null && hospitality!.daysInfo.isNotEmpty))
              const SizedBox(height: 12),
            if (hospitality == null ||
                (hospitality != null && hospitality!.daysInfo.isNotEmpty))
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
                        hospitality == null
                            ? AppUtil.formatStringTime(
                                context, booking!.timeToGo)
                            : AppUtil.formatTimeOnly(
                                context, hospitality!.daysInfo.last.startTime),
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
                            hospitality == null
                                ? AppUtil.formatStringTime(
                                    context, booking!.timeToReturn)
                                : AppUtil.formatTimeOnly(context,
                                    hospitality!.daysInfo.last.endTime),
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
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GuestNumber'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: starGreyColor,
                    fontSize: width * 0.038,
                    fontFamily: AppUtil.SfFontType(context),
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospitality == null
                          ? '${booking?.guestInfo?.female ?? 11} ${'female'.tr}'
                          : '${hospitality!.booking?.last.guestInfo.female ?? 50} ${'female'.tr}',
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
                const SizedBox(height: 5),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospitality == null
                          ? '${booking?.guestInfo?.male} ${'male'.tr}'
                          : '${hospitality!.booking?.last.guestInfo.male ?? 90} ${'male'.tr}',
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
              ],
            ),
            const SizedBox(height: 12),
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            // booking.place!.price.toString(),
                            hospitality == null
                                ? booking!.cost.toString()
                                : hospitality!.booking!.last.cost.toString(),

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
          height: 4,
        ),
        const DottedSeparator(
          color: almostGrey,
          height: 1,
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () async {
              final Uri url = hospitality == null
                  ? Uri.parse(booking!.hospitality?.location ?? '')
                  : Uri.parse(hospitality!.location ?? '');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $url';
              }
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
        ),
      ],
    );
  }
}
