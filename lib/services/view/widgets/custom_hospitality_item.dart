import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:ajwad_v4/services/view/widgets/text_chip.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

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
    required this.price,
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
  final String price;

  @override
  _ServicesCardState createState() => _ServicesCardState();
}

class _ServicesCardState extends State<ServicesCard> {
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

    if (widget.lang!.isNotEmpty && widget.lang!.isNotEmpty) {
      _fetchAddress(widget.lang!, widget.long!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(width * 0.04),
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

                // Image Section
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
                      SizedBox(height: width * 0.01),
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
                          TextChip(
                            text:
                                // address.value.isNotEmpty
                                //     ? '${widget.location}, ${address.value}'
                                widget.location,
                          ),
                          if (widget.dayInfo != null &&
                              widget.dayInfo!.isNotEmpty)
                            TextChip(
                              text:
                                  '${AppUtil.formatTimeOnly(context, widget.dayInfo![0].startTime)} -  ${AppUtil.formatTimeOnly(context, widget.dayInfo![0].endTime)}',
                            ),
                          TextChip(text: widget.meal),
                        ],
                      ),
                    ],
                  ),
                ),

                // Rating Section (Beside Title/Chips)
                Padding(
                  padding: EdgeInsets.only(top: width * 0.0198),
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
                        SizedBox(width: width * 0.01),
                      RepaintBoundary(
                        child: SvgPicture.asset(
                          'assets/icons/star.svg',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      if (!AppUtil.rtlDirection2(context))
                        CustomText(
                          text: widget.rate,
                          fontSize: width * 0.030,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: AppUtil.SfFontType(context),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: width * 0.029),
            CustomText(
              text: widget.price,
            ),
          ],
        ),
      ),
    );
  }
}
