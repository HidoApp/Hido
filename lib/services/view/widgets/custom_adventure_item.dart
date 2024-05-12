import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:intl/intl.dart';

class CustomAdventureItem extends StatelessWidget {
  const CustomAdventureItem({
    super.key,
    
    // required this.onTap,
    // required this.title,
    // required this.rate,
    // required this.location,
    // required this.description,

    required this.image,
    this.personImage,
    required this.title,
    required this.location,
    required this.category,
    required this.rate,
    required this.onTap,
    this.dayInfo,
  });

  // final VoidCallback onTap;
  // final String title;
  // final String rate;
  // final String location;
  // final String description;

  final String image;
  final String? personImage;
  final String title;
  final String location;

  final String category;
  final String rate;
  final List<DayInfo>? dayInfo;
  final VoidCallback onTap;






 @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Container(
          width: 362,
          height: 114,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 16, color: Colors.black12)],
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          image,
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        bottom: 7,
                        start: 7,
                        child: personImage == null
                            ? const CircleAvatar(
                                radius: 12.5,
                                backgroundImage: AssetImage(
                                    'assets/images/profile_image.png'),
                              )
                            : CircleAvatar(
                                radius: 13.5,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 12.5,
                                  backgroundImage: NetworkImage(personImage!),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: title,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 4,
                          ),
                          SvgPicture.asset(
                            'assets/icons/map_pin.svg',
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          CustomText(
                            text: location,
                            fontSize: 12,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                            color: starGreyColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 4,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/grey_calender.svg'),
                              const SizedBox(
                                width: 4,
                              ),
                              if (dayInfo != null || dayInfo != [])
                                CustomText(
                                text:DateFormat('E-dd-MMM').format(DateTime.parse(dayInfo![0].startTime)),

                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: starGreyColor,
                                ),
                            ],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          // Row(
                          //   children: [
                          //     SvgPicture.asset('assets/icons/meal_icon.svg'),
                          //     // SvgPicture.asset('assets/icons/calendar.svg',color: purple,),
                          //     SizedBox(
                          //       width: width * 0.01,
                          //     ),
                          //     SizedBox(
                          //       width: 100,
                          //       child: CustomText(
                          //         text: meal,
                          //         fontSize: 10,
                          //         fontWeight: FontWeight.w300,
                          //         color: starGreyColor,
                          //         maxlines: 2,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(
                            width: width * 0.0593,
                          ),
   

                          
                ],

                
              ),
                      Spacer(),
Padding(
  padding: const EdgeInsets.only(top:5),
  child:Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
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

