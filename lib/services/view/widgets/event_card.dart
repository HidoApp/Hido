import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:ajwad_v4/services/view/widgets/text_chip.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';

class EventCardItem extends StatefulWidget {
  const EventCardItem(
      {super.key,
      required this.image,
      required this.title,
      required this.location,
      required this.status,
      required this.rate,
      required this.daysInfo,
      required this.onTap,
      this.lang,
      this.long,
      required this.price});
  final String image;
  final String title;
  final String location;
  final String status;
  final String rate;
  final List<DayInfo> daysInfo;
  final VoidCallback onTap;
  final String? lang;
  final String? long;
  final String price;

  @override
  State<EventCardItem> createState() => _EventCardItemState();
}

class _EventCardItemState extends State<EventCardItem> {
  RxString address = ''.obs;
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

  Future<void> _fetchAddress(String position1, String position2) async {
    try {
      String result = await _getAddressFromLatLng(
          double.parse(position1), double.parse(position2));

      address.value = result;
    } catch (e) {
      // Handle error if necessary
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchAddress(widget.lang!, widget.long!);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        child: Container(
          padding: EdgeInsets.all(width * 0.03),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: width * 0.04, color: Colors.black12)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(width * 0.04),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: widget.image.isNotEmpty
                        ? ImageCacheWidget(
                            image: widget.image,
                            width: width * 0.23,
                            height: width * 0.23,
                          )
                        : Image.asset('assets/images/Placeholder.png'),
                  ),
                  SizedBox(width: width * 0.028),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: widget.title,
                          fontSize: width * 0.041,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppUtil.rtlDirection2(context)
                              ? 'SF Arabic'
                              : 'SF Pro',
                        ),
                        SizedBox(height: width * 0.02),
                        Wrap(
                          spacing: width * 0.013, // space between chips
                          runSpacing:
                              width * 0.013, //  space when wrapping to new line
                          children: [
                            // Obx(
                            //   () => TextChip(
                            //     text: address.value.isNotEmpty
                            //         ? '${widget.location}, ${address.value}'
                            //         : widget.location,
                            //   ),
                            // ),
                            TextChip(
                              text: widget.location,
                            ),
                            if (widget.daysInfo.isNotEmpty)
                              TextChip(
                                  text: AppUtil.formatSelectedDaysInfo(
                                      widget.daysInfo, context)),
                            if (widget.daysInfo.isNotEmpty)
                              TextChip(
                                text:
                                    '${AppUtil.formatTimeOnly(context, widget.daysInfo[0].startTime)} -  ${AppUtil.formatTimeOnly(context, widget.daysInfo[0].endTime)}',
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: width * 0.0128),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (AppUtil.rtlDirection2(context))
                          CustomText(
                            text: widget.rate,
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.w500,
                            color: black,
                            fontFamily: AppUtil.SfFontType(context),
                          ),
                        if (AppUtil.rtlDirection2(context))
                          SizedBox(
                            width: width * 0.01,
                          ),
                        SvgPicture.asset(
                          'assets/icons/star.svg',
                          color: black,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        if (!AppUtil.rtlDirection2(context))
                          CustomText(
                            text: widget.rate,
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.w500,
                            color: black,
                            fontFamily: AppUtil.SfFontType(context),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomText(
                color: widget.status != 'CLOSED' ? black : starGreyColor,
                text: widget.status != 'CLOSED' ? widget.price : "finished".tr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatBookingDate(BuildContext context, String date) {
    DateTime dateTime = DateTime.parse(date);
    if (AppUtil.rtlDirection2(context)) {
      // Set Arabic locale for date formatting
      return DateFormat('EEEE، d MMMM', 'ar').format(dateTime);
    } else {
      // Default to English locale
      return DateFormat('EEEE, d MMMM').format(dateTime);
    }
  }
}
