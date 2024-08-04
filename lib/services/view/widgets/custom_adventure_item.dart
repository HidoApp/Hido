import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:intl/intl.dart';

class CustomAdventureItem extends StatefulWidget {
  const CustomAdventureItem({
    Key? key,
    required this.image,
    this.personImage,
    required this.title,
    required this.location,
    required this.seats,
    required this.rate,
    required this.date,
    required this.onTap,
    required this.times,
    this.lang,
    this.long,
  }) : super(key: key);

  final String image;
  final String? personImage;
  final String title;
  final String location;
  final String seats;
  final String rate;
  final String date;
  final List<Time>? times;
  final VoidCallback onTap;
  final String? lang;
  final String? long;

  @override
  _CustomAdventureItemState createState() => _CustomAdventureItemState();
}

class _CustomAdventureItemState extends State<CustomAdventureItem> {
  final _servicesController = Get.put(AdventureController());
String address = '';
  Future<String> _getAddressFromLatLng(
      double position1, double position2) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position1, position2);
      print(placemarks);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        print(placemarks.first);
        return '${placemark.locality},${placemark.subLocality}';
      }
    } catch (e) {
      print("Error retrieving address: $e");
    }
    return '';
  }

  Future<void> _fetchAddress(String position1, String position2) async {
    try {
      String result = await _getAddressFromLatLng(
          double.parse(position1), double.parse(position2));
      setState(() {
        address = result;
      });
    } catch (e) {
      // Handle error if necessary
      print('Error fetching address: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.lang!.isNotEmpty && widget.lang!.isNotEmpty)
      _fetchAddress(widget.lang!, widget.long!);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        child: Container(
          height: width * 0.29,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.030,
            vertical: width * 0.025,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: width * 0.04, color: shadowColor),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(width * 0.04),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      widget.image,
                      width: width * 0.23,
                      height: width * 0.23,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.028,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.title,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      ),
                      SizedBox(
                        height: width * 0.01,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.01,
                          ),
                          SvgPicture.asset(
                            'assets/icons/map_pin.svg',
                          ),
                          SizedBox(
                            width: width * 0.017,
                          ),
                          CustomText(
                            text:address.isNotEmpty
                                ?address
                                : widget.location,
                            fontSize: 11,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w400,
                            color: starGreyColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: width * 0.01,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.017,
                          ),
                          SvgPicture.asset('assets/icons/grey_calender.svg'),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          CustomText(
                            text: formatBookingDate(context, widget.date),
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: starGreyColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: width * 0.01,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.01,
                          ),
                          SvgPicture.asset('assets/icons/timeGrey.svg'),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          CustomText(
                            text: widget.times != null &&
                                    widget.times!.isNotEmpty
                                ? '${widget.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.startTime)).join(', ')} - ${widget.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.endTime)).join(', ')}'
                                : '5:00-8:00 AM',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: starGreyColor,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(top: width * 0.0128),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (AppUtil.rtlDirection2(context))
                      CustomText(
                        text: widget.rate,
                        fontSize: width * 0.025,
                        fontWeight: FontWeight.w700,
                        color: colorDarkGreen,
                        fontFamily: 'Kufam',
                      ),
                    if (AppUtil.rtlDirection2(context))
                      SizedBox(
                        width: width * 0.01,
                      ),
                    SvgPicture.asset('assets/icons/star.svg'),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    if (!AppUtil.rtlDirection2(context))
                      CustomText(
                        text: widget.rate,
                        fontSize: width * 0.025,
                        fontWeight: FontWeight.w700,
                        color: colorDarkGreen,
                        fontFamily: 'Kufam',
                      ),
                  ],
                ),
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
      return DateFormat('EEE، d MMMM').format(dateTime);
    }
  }
}
