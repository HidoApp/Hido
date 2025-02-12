import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/model/experiences.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/services/view/local_event_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class ServicesCard extends StatefulWidget {
  const ServicesCard({
    Key? key,
    required this.experience,
  }) : super(key: key);

  final Experience experience;

  @override
  _ServicesCardState createState() => _ServicesCardState();
}

class _ServicesCardState extends State<ServicesCard> {
  String address = '';
  bool isLoading = true;

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

        return placemark.subLocality != null &&
                placemark.subLocality!.isNotEmpty
            ? '${placemark.subLocality}'
            : '${placemark.locality}';
      }
    } catch (e) {}
    return '';
  }

  Future<void> _fetchAddress() async {
    try {
      String result = await _getAddressFromLatLng(
          double.parse(widget.experience.coordinates.latitude ?? ''),
          double.parse(widget.experience.coordinates.longitude ?? ''));
      setState(() {
        address = result;
      });
    } catch (e) {
      // Handle error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.041),
      child: GestureDetector(
        onTap: () {
          widget.experience.experiencesType == 'hospitality'
              ? Get.to(() => HospitalityDetails(
                  hospitalityId: widget.experience.id,
                  isLocal: true,
                  experienceType: widget.experience.experiencesType,
                  address: address,
                  isHasBooking: widget.experience.isHasBooking))
              : widget.experience.experiencesType == 'adventure'
                  ? Get.to(() => AdventureDetails(
                      adventureId: widget.experience.id,
                      isLocal: true,
                      address: address,
                      isHasBooking: widget.experience.isHasBooking))
                  : Get.to(() => LocalEventDetails(
                      eventId: widget.experience.id,
                      isLocal: true,
                      address: address,
                      isHasBooking: widget.experience.isHasBooking));
        },
        child: Container(
          // height: width * 0.29,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.030, vertical: width * 0.025),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: width * 0.04, color: shadowColor)
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
                      child: widget.experience.image.isEmpty
                          ? Image.asset('assets/images/Placeholder.png')
                          : CachedNetworkImage(
                              imageUrl: widget.experience.image.first,
                              placeholder: (context, url) =>
                                  Image.asset('assets/images/Placeholder.png'),
                              width: width * 0.23,
                              height: width * 0.23,
                              fit: BoxFit.fill,
                            )
                      //  Image.network(
                      //     widget.experience.image.first,
                      //     width: width * 0.23,
                      //     height: width * 0.23,
                      //     fit: BoxFit.fill,
                      //   ),
                      ),
                  SizedBox(
                    width: width * 0.028,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppUtil.rtlDirection2(context)
                            ? widget.experience.experiencesType == 'hospitality'
                                ? widget.experience.titleAr ?? ''
                                : widget.experience.nameAr ?? ''
                            : widget.experience.experiencesType == 'hospitality'
                                ? widget.experience.titleEn ?? ''
                                : widget.experience.nameEn ?? '',
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
                        children: [
                          SizedBox(
                            width: width * 0.01,
                          ),
                          RepaintBoundary(
                            child: SvgPicture.asset(
                              'assets/icons/map_pin.svg',
                            ),
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          CustomText(
                            text: AppUtil.rtlDirection2(context)
                                ? '${widget.experience.regionAr}, $address'
                                : '${widget.experience.regionEn}, $address',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                            color: colorDarkGrey,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: width * 0.01,
                      ),
                      if (widget.experience.experiencesType == 'adventure' ||
                          (widget.experience.experiencesType == 'event' &&
                              widget.experience.daysInfo.isNotEmpty))
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.01,
                            ),
                            RepaintBoundary(
                              child: SvgPicture.asset(
                                'assets/icons/calendar.svg',
                              ),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            CustomText(
                              text: AppUtil.formatSelectedDaysInfo(
                                  widget.experience.daysInfo, context),
                              color: colorDarkGrey,
                              fontSize: 11,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      if (widget.experience.experiencesType == 'hospitality')
                        if (widget.experience.daysInfo.isNotEmpty)
                          Row(
                            children: [
                              SizedBox(
                                width: width * 0.01,
                              ),
                              RepaintBoundary(
                                child: SvgPicture.asset(
                                  'assets/icons/Clock.svg',
                                ),
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              CustomText(
                                text:
                                    '${AppUtil.formatSelectedDaysInfo(widget.experience.daysInfo, context) ?? ''} - ${AppUtil.formatTimeOnly(context, widget.experience.daysInfo[0].startTime)} ',

                                // '${AppUtil.formatBookingDate(context, widget.experience.daysInfo[0].startTime ?? '')} - ${AppUtil.formatTimeOnly(context, widget.experience.daysInfo[0].startTime)} ',
                                color: colorDarkGrey,
                                fontSize: 11,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                      SizedBox(
                        height: width * 0.01,
                      ),
                      if (widget.experience.experiencesType == 'adventure' ||
                          (widget.experience.experiencesType == 'event' &&
                              widget.experience.daysInfo.isNotEmpty))
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.01,
                            ),
                            RepaintBoundary(
                              child: SvgPicture.asset(
                                'assets/icons/Clock.svg',
                              ),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            CustomText(
                              text:
                                  '${AppUtil.formatTimeOnly(context, widget.experience.daysInfo.first.startTime)} -  ${AppUtil.formatTimeOnly(context, widget.experience.daysInfo.first.endTime)}',
                              color: colorDarkGrey,
                              fontSize: 11,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.013,
                          ),
                          if (widget.experience.experiencesType ==
                              'hospitality')
                            Row(
                              children: [
                                RepaintBoundary(
                                    child: SvgPicture.asset(
                                        'assets/icons/meal.svg')),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                CustomText(
                                  text: AppUtil.rtlDirection2(context)
                                      ? widget.experience.mealTypeAr
                                      : AppUtil.capitalizeFirstLetter(
                                          widget.experience.mealTypeEn),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: AppUtil.rtlDirection2(context)
                                      ? 'SF Arabic'
                                      : 'SF Pro',
                                  color: colorDarkGrey,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // const Spacer(),
              // SvgPicture.asset('assets/icons/star.svg'),
              // SizedBox(
              //   width: width * 0.01,
              // ),
              // CustomText(
              //   text: "",
              //   fontSize: width * 0.025,
              //   fontWeight: FontWeight.w700,
              //   color: colorDarkGreen,
              //   fontFamily: 'Kufam',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
