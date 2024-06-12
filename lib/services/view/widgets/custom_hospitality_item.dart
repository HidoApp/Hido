import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/event_details.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    super.key,
    required this.image,
    this.personImage,
    required this.title,
    required this.location,
    required this.meal,
    required this.category,
    required this.rate,
    required this.onTap,
    this.dayInfo,
  });

  final String image;
  final String? personImage;
  final String title;
  final String location;
  final String meal;
  final String category;
  final String rate;
  final List<DayInfo>? dayInfo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
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
                  child: Image.network(
                    image,
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
                      text: title,
                      fontSize:16,
                      fontWeight: FontWeight.w500,

                       fontFamily: 'SF Pro',
                    ),
                    SizedBox(
                      height: width * 0.010,
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
                          text: location,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF Pro',

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
                        SvgPicture.asset(
                          'assets/icons/timeGrey.svg',
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        // CustomText(
                        //   text: dayInfo[0].startTime,
                        //   fontSize: width * 0.025,
                        //   fontWeight: FontWeight.w400,
                        //   color: starGreyColor,
                        // ),
                        CustomText(
                          text: AppUtil.rtlDirection2(context)
                              ? '${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(dayInfo![0].startTime))} -  ${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(dayInfo![0].endTime))}'
                              : ' ${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(dayInfo![0].startTime))} -  ${DateFormat('hh:mm a', 'en_US').format(DateTime.parse(dayInfo![0].endTime))}',
                          color: starGreyColor,
                          fontSize: 11,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: width * 0.01,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.015,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/meal.svg'),
                            SizedBox(
                              width: width * 0.024,
                            ),
                            if (dayInfo != null || dayInfo != [])
                              CustomText(
                                text: meal,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SF Pro',

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
            SvgPicture.asset('assets/icons/star.svg'),
            SizedBox(
              width: width * 0.01,
            ),
            CustomText(
              text: rate,
              fontSize: width * 0.025,
              fontWeight: FontWeight.w700,
              color: colorDarkGreen,
              fontFamily: 'Kufam',
            ),
          ],
        ),
      ),
    );
  }
}
