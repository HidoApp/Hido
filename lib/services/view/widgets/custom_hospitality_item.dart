import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/event_details.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ServicesCard extends StatefulWidget {
  const ServicesCard({
    Key? key,
    required this.image,
    this.personImage,
    required this.title,
    required this.location,
    required this.meal,
    required this.category,
    required this.rate,
    required this.onTap,
    this.lang,
    this.long,
    this.dayInfo,
  }) : super(key: key);

  final String image;
  final String? personImage;
  final String title;
  final String location;
  final String meal;
  final String category;
  final String rate;
  final List<DayInfo>? dayInfo;
  final VoidCallback onTap;
  final String? lang;
  final String? long;

  @override
  _ServicesCardState createState() => _ServicesCardState();
}

class _ServicesCardState extends State<ServicesCard> {
  final _servicesController = Get.put(HospitalityController());
  RxString address = ''.obs;
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

      address.value = result;
    } catch (e) {
      // Handle error if necessary
      print('Error fetching address: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.lang!.isNotEmpty && widget.lang!.isNotEmpty) {
      _fetchAddress(widget.lang!, widget.long!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: width * 0.29,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.030, vertical: width * 0.025),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: width * 0.04, color: Colors.black12)
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
                  // Image.network(
                  //   widget.image,
                  //   fit: BoxFit.fill,
                  // ),
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
                      height: width * 0.010,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: width * 0.01,
                        ),
                        SvgPicture.asset(
                          'assets/icons/map_pin.svg',
                        ),
                        SizedBox(
                          width: width * 0.017,
                        ),
                        Obx(
                          () => CustomText(
                            text: address.value.isNotEmpty
                                ? address.value
                                : widget.location,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            color: starGreyColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: width * 0.01,
                    ),
                    if (widget.dayInfo != null && widget.dayInfo!.isNotEmpty)
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.01,
                          ),
                          RepaintBoundary(
                            child: SvgPicture.asset(
                              'assets/icons/timeGrey.svg',
                            ),
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          CustomText(
                            text:
                                '${AppUtil.formatTimeOnly(context, widget.dayInfo![0].startTime)} -  ${AppUtil.formatTimeOnly(context, widget.dayInfo![0].endTime)}',
                            color: starGreyColor,
                            fontSize: 11,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    SizedBox(
                      height: width * 0.013,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.011,
                        ),
                        Row(
                          children: [
                            RepaintBoundary(
                                child:
                                    SvgPicture.asset('assets/icons/meal.svg')),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            if (widget.dayInfo != null)
                              CustomText(
                                text: widget.meal,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                color: starGreyColor,
                              ),
                          ],
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
                  // if (AppUtil.rtlDirection2(context))
                  //   CustomText(
                  //     text: widget.rate,
                  //     fontSize: width * 0.025,
                  //     fontWeight: FontWeight.w700,
                  //     color: colorDarkGreen,
                  //     fontFamily: AppUtil.SfFontType(context),
                  //   ),
                  // if (AppUtil.rtlDirection2(context))
                  //   SizedBox(
                  //     width: width * 0.01,
                  //   ),
                  RepaintBoundary(
                      child: SvgPicture.asset('assets/icons/star.svg')),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  // if (!AppUtil.rtlDirection2(context))
                  CustomText(
                    text: widget.rate,
                    fontSize: width * 0.025,
                    fontWeight: FontWeight.w700,
                    color: colorDarkGreen,
                    fontFamily: AppUtil.SfFontType(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
