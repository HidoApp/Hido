import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:intl/intl.dart';

class CustomAdventureItem extends StatelessWidget {
  const CustomAdventureItem({
    super.key,
    required this.image,
    this.personImage,
    required this.title,
    required this.location,
    required this.seats,
    required this.rate,
    required this.date,
    required this.onTap,
    required this.times,
  });
  final String image;
  final String? personImage;
  final String title;
  final String location;
  final String seats;
  final String rate;
  final String date;
  final List<Time>? times;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Container(
          height: width * 0.29,
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
                crossAxisAlignment: CrossAxisAlignment.end,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro',

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
                            text: location,
                            fontSize: 11,
                            fontFamily: 'SF Pro',
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
                          SvgPicture.asset(
                              'assets/icons/grey_calender.svg'),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          CustomText(
                            text: formatBookingDate(context,date),
                            fontFamily: 'SF Pro',
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
                              SvgPicture.asset( 'assets/icons/timeGrey.svg',),
                              // SvgPicture.asset('assets/icons/calendar.svg',color: purple,),
                              SizedBox(
                                width: width * 0.02,
                              ),
                      
                              CustomText(
                                text:times != null && times!.isNotEmpty
                                ?'${times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.startTime) ).join(', ')} - ${times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.endTime) ).join(', ')}':
                                '5:00-8:00 AM',                                  
                                fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: starGreyColor,
                                  fontFamily: 'SF Pro',

                              
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
                        text: rate,
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
                        text: rate,
                        fontSize: width * 0.025,
                        fontWeight: FontWeight.w700,
                        color: colorDarkGreen,
                        fontFamily: 'Kufam',
                      ),
                  ],
                ),
              ),
              // SvgPicture.asset('assets/icons/star.svg'),
              // SizedBox(
              //   width: width * 0.01,
              // ),
              // CustomText(
              //   text: rate,
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
  // @override
  // Widget build(BuildContext context) {
  //   return InkWell(
  //     onTap: onTap,
  //     radius: 8,
  //     child: SizedBox(
  //       width: 253,
  //       child: Card(
  //         shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(8))),
  //         color: Colors.white,
  //         child: Padding(
  //           padding: const EdgeInsets.all(12),
  //           child: Column(
  //             children: [
  //               Stack(
  //                 children: [
  //                   Image.asset('assets/images/camel.png'),
  //                   Positioned.directional(
  //                     textDirection: Directionality.of(context),
  //                     top: 4,
  //                     end: 8,
  //                     child: Container(
  //                       width: 31,
  //                       height: 31,
  //                       alignment: Alignment.center,
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: const Color(0xff3A3A3A).withOpacity(0.3),
  //                       ),
  //                       child:
  //                           SvgPicture.asset('assets/icons/heart_rounded.svg'),
  //                     ),
  //                   ),
  //                   Positioned.directional(
  //                     textDirection: Directionality.of(context),
  //                     bottom: 8,
  //                     start: 8,
  //                     child: SizedBox(
  //                       height: 21,
  //                       child: Row(
  //                         children: [
  //                           ListView.builder(
  //                               scrollDirection: Axis.horizontal,
  //                               shrinkWrap: true,
  //                               itemCount: 2,
  //                               itemBuilder: (context, index) {
  //                                 return const Align(
  //                                   widthFactor: 0.6,
  //                                   child: CircleAvatar(
  //                                     radius: 10.5,
  //                                     backgroundImage: AssetImage(
  //                                         'assets/images/ajwadi_image.png'),
  //                                   ),
  //                                 );
  //                               }),
  //                           const Align(
  //                             widthFactor: 0.6,
  //                             child: CircleAvatar(
  //                               radius: 10.5,
  //                               backgroundColor: pink,
  //                               child: CustomText(
  //                                 text: '3+',
  //                                 color: Colors.white,
  //                                 textAlign: TextAlign.center,
  //                                 fontFamily: 'Kufam',
  //                                 fontSize: 8,
  //                                 fontWeight: FontWeight.w400,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 8),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         CustomText(
  //                           text: title,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                         Row(
  //                           children: [
  //                             SvgPicture.asset('assets/icons/popularity.svg'),
  //                             const SizedBox(
  //                               width: 4,
  //                             ),
  //                             CustomText(
  //                               text: rate,
  //                               fontSize: 10,
  //                               fontWeight: FontWeight.w700,
  //                               color: starGreyColor,
  //                               fontFamily: 'Kufam',
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(
  //                       height: 8,
  //                     ),
  //                     Row(
  //                       children: [ 
  //                         SvgPicture.asset(
  //                           'assets/icons/location_pin.svg',
  //                           color: pink,
  //                         ),
  //                         const SizedBox(
  //                           width: 4,
  //                         ),
  //                         CustomText(
  //                           text: location,
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.w400,
  //                           color: starGreyColor,
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(
  //                       height: 12,
  //                     ),
  //                     SizedBox(
  //                       width: 230,
  //                       child: CustomText(
  //                         text: description,
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w400,
  //                         color: const Color(0xffA3A3A3),
  //                         maxlines: 2,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

