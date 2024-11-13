import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventTicketData extends StatefulWidget {
  const EventTicketData(
      {super.key, this.booking, this.icon, this.bookTypeText, this.event});
  final Booking? booking;
  final SvgPicture? icon;
  final String? bookTypeText;
  final Event? event;

  @override
  State<EventTicketData> createState() => _EventTicketDataState();
}

class _EventTicketDataState extends State<EventTicketData> {
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
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: widget.event == null
                          ? widget.booking!.id!.substring(0, 7)
                          : widget.event!.booking!.last.id!.substring(0, 7)));
                  _showOverlay(context);
                },
                child: RepaintBoundary(
                  child: SvgPicture.asset(
                    'assets/icons/Summary.svg',
                    width: 20,
                    height: 20,
                  ),
                )),
            const SizedBox(width: 8),
            Text(
              '#${widget.event == null ? widget.booking!.id!.substring(0, 7) : widget.event!.booking!.last.id!.substring(0, 7)}',
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
                widget.icon ?? const SizedBox.shrink(),
                Text(
                  AppUtil.getBookingTypeText(
                      context, widget.bookTypeText ?? ''),
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
                  widget.event == null
                      ? AppUtil.formatBookingDate(context, widget.booking!.date)
                      : AppUtil.formatBookingDate(
                          context, widget.event!.booking!.last.date),
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
            if (widget.event == null ||
                (widget.event != null && widget.event!.daysInfo!.isNotEmpty))
              const SizedBox(height: 12),
            if (widget.event == null ||
                (widget.event != null && widget.event!.daysInfo!.isNotEmpty))
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
                        widget.event == null
                            ? formatTimeWithLocale(
                                context, widget.booking!.timeToGo)
                            : AppUtil.formatTimeOnly(context,
                                widget.event!.daysInfo!.last.startTime),
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
                            widget.event == null
                                ? formatTimeWithLocale(
                                    context, widget.booking!.timeToReturn)
                                : AppUtil.formatTimeOnly(context,
                                    widget.event!.daysInfo!.last.endTime),
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
                fontSize: width * 0.038,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.event == null
                  ? '${widget.booking?.guestNumber} ${'person'.tr}'
                  : '${widget.event!.booking!.last.guestInfo!.guestNumber} ${'person'.tr}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: black,
                fontSize: width * 0.038,
                fontFamily: AppUtil.SfFontType(context),
                fontWeight: FontWeight.w500,
                height: 0,
              ),
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
                            widget.event == null
                                ? widget.booking!.cost!.toString()
                                : widget.event!.booking!.last.cost.toString(),

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
          height: 8,
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
              final Uri url = widget.event == null
                  ? Uri.parse(widget.booking!.event?.locationUrl ?? '')
                  : Uri.parse(widget.event!.locationUrl ?? '');
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
