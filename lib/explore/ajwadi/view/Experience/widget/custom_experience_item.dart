import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/model/experiences.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/services/view/local_event_details.dart';
import 'package:ajwad_v4/services/view/widgets/text_chip.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_publish_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:blur/blur.dart';
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
  bool shouldBlur = false;

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

  bool _computeShouldBlur() {
    if (widget.experience.experiencesType == 'hospitality') {
      return widget.experience.titleEn.isEmpty ||
          widget.experience.titleZh.isEmpty;
    } else {
      return widget.experience.nameEn.isEmpty ||
          widget.experience.nameZh.isEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    bool shouldBlur = _computeShouldBlur();
    double blurAmount = shouldBlur ? 4.5 : 0;
    double colorOpacity = shouldBlur ? 0.4 : 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.041),
      child: GestureDetector(
        onTap: () {
          widget.experience.experiencesType == 'hospitality'
              ? widget.experience.titleEn.isEmpty ||
                      widget.experience.titleZh.isEmpty
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomPublishDialog(
                          description: 'ExperienceSentDes'.tr,
                          icon: 'white_loader.svg',
                          iconColor: colorGreen,
                        );
                      },
                    )
                  : Get.to(() => HospitalityDetails(
                      hospitalityId: widget.experience.id,
                      isLocal: true,
                      experienceType: widget.experience.experiencesType,
                      address: address,
                      isHasBooking: widget.experience.isHasBooking))
              : widget.experience.experiencesType == 'adventure'
                  ? widget.experience.nameEn.isEmpty ||
                          widget.experience.nameZh.isEmpty
                      ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomPublishDialog(
                              description: 'ExperienceSentDes'.tr,
                              icon: 'white_loader.svg',
                              iconColor: colorGreen,
                            );
                          },
                        )
                      : Get.to(() => AdventureDetails(
                          adventureId: widget.experience.id,
                          isLocal: true,
                          address: address,
                          isHasBooking: widget.experience.isHasBooking))
                  : widget.experience.nameEn.isEmpty ||
                          widget.experience.nameZh.isEmpty
                      ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomPublishDialog(
                              description: 'ExperienceSentDes'.tr,
                              icon: 'white_loader.svg',
                              iconColor: colorGreen,
                            );
                          },
                        )
                      : Get.to(() => LocalEventDetails(
                          eventId: widget.experience.id,
                          isLocal: true,
                          address: address,
                          isHasBooking: widget.experience.isHasBooking));
        },
        child: Blur(
          blur: blurAmount,
          colorOpacity: colorOpacity,
          overlay: shouldBlur
              ? Padding(
                  padding: AppUtil.rtlDirection2(context)
                      ? const EdgeInsets.only(right: 18)
                      : const EdgeInsets.only(left: 18),
                  child: Center(
                    child: CustomText(
                      text: 'UnderReview'.tr,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      textAlign: TextAlign.center,
                      fontFamily: AppUtil.SfFontType(context),
                    ),
                  ),
                )
              : null,
          borderRadius:
              const BorderRadius.horizontal(right: Radius.circular(20)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: widget.experience.image.isEmpty
                            ? Image.asset('assets/images/Placeholder.png')
                            : CachedNetworkImage(
                                imageUrl: widget.experience.image.first,
                                placeholder: (context, url) => Image.asset(
                                    'assets/images/Placeholder.png'),
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
                    SizedBox(width: width * 0.028),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: width * 0.01),
                          CustomText(
                            text: AppUtil.rtlDirection2(context)
                                ? widget.experience.experiencesType ==
                                        'hospitality'
                                    ? widget.experience.titleAr ?? ''
                                    : widget.experience.nameAr ?? ''
                                : widget.experience.experiencesType ==
                                        'hospitality'
                                    ? (widget.experience.titleEn.isEmpty)
                                        ? widget.experience.titleAr
                                        : widget.experience.titleEn
                                    : (widget.experience.nameEn.isEmpty)
                                        ? widget.experience.nameAr
                                        : widget.experience.nameEn,
                            fontSize: width * 0.041,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppUtil.rtlDirection2(context)
                                ? 'SF Arabic'
                                : 'SF Pro',
                          ),
                          SizedBox(height: width * 0.02),
                          Wrap(
                            spacing: width * 0.013, // space between chips
                            runSpacing: width *
                                0.013, //  space when wrapping to new line
                            children: [
                              TextChip(
                                text: AppUtil.rtlDirection2(context)
                                    ? widget.experience.regionAr
                                    : widget.experience.regionEn,
                                // ? '${widget.experience.regionAr}, $address'
                                // : '${widget.experience.regionEn}, $address',
                              ),
                              if (widget.experience.experiencesType ==
                                      'adventure' ||
                                  widget.experience.experiencesType == 'event')
                                if (widget.experience.daysInfo.isNotEmpty)
                                  TextChip(
                                    text: AppUtil.formatSelectedDaysInfo(
                                        widget.experience.daysInfo, context),
                                  ),
                              if (widget.experience.experiencesType ==
                                  'hospitality')
                                if (widget.experience.daysInfo.isNotEmpty)
                                  TextChip(
                                    text:
                                        '${AppUtil.formatSelectedDaysInfo(widget.experience.daysInfo, context) ?? ''} - ${AppUtil.formatTimeOnly(context, widget.experience.daysInfo[0].startTime)} ',
                                  ),
                              if (widget.experience.experiencesType ==
                                      'adventure' ||
                                  widget.experience.experiencesType == 'event')
                                if (widget.experience.daysInfo.isNotEmpty)
                                  TextChip(
                                    text:
                                        '${AppUtil.formatTimeOnly(context, widget.experience.daysInfo.first.startTime)} -  ${AppUtil.formatTimeOnly(context, widget.experience.daysInfo.first.endTime)}',
                                  ),
                              if (widget.experience.experiencesType ==
                                  'hospitality')
                                TextChip(
                                  text: AppUtil.rtlDirection2(context)
                                      ? widget.experience.mealTypeAr
                                      : AppUtil.capitalizeFirstLetter(
                                          widget.experience.mealTypeEn),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: width * 0.0198),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (AppUtil.rtlDirection2(context))
                            CustomText(
                              text: widget.experience.rating.toString(),
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
                              text: widget.experience.rating.toString(),
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
                if (!shouldBlur) ...[
                  SizedBox(height: width * 0.029),
                  CustomText(
                    color: colorGreen,
                    text: AppUtil.rtlDirection2(context)
                        ? 'تم النشر'
                        : 'Published',
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
