// import 'package:ajwad_v4/constants/colors.dart';
// import 'package:ajwad_v4/services/view/hospitality_details.dart';
// import 'package:ajwad_v4/utils/app_util.dart';
// import 'package:ajwad_v4/widgets/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// class HospitalityTab extends StatelessWidget {
//   const HospitalityTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.sizeOf(context).width;
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 25,
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: width,
//             decoration: BoxDecoration(
//               color: colorGreen.withOpacity(0.16),
//               borderRadius: const BorderRadius.all(Radius.circular(12)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Stack(
//                   children: [
//                     if (!AppUtil.rtlDirection(context))
//                       Image.asset('assets/images/percent.png'),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         right: AppUtil.rtlDirection(context) ? 22 : 0,
//                         left: AppUtil.rtlDirection(context) ? 0 : 22,
//                         top: 22,
//                         bottom: 17,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           RichText(
//                             text: TextSpan(children: [
//                               TextSpan(
//                                 text: AppUtil.rtlDirection(context)
//                                     ? 'خصومات حصرية لضيوف\n'
//                                     : 'Exclusive Discounts for\n',
//                                 style: TextStyle(
//                                   fontFamily: AppUtil.rtlDirection(context)
//                                       ? 'Noto Kufi Arabic'
//                                       : 'Kufam',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   color: black,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: AppUtil.rtlDirection(context)
//                                     ? 'هوليداي إن!'
//                                     : 'Holiday Inn ',
//                                 style: TextStyle(
//                                   fontFamily: AppUtil.rtlDirection(context)
//                                       ? 'Noto Kufi Arabic'
//                                       : 'Kufam',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                   color: black,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: AppUtil.rtlDirection(context)
//                                     ? ''
//                                     : 'Guests!',
//                                 style: const TextStyle(
//                                   fontFamily: 'Kufam',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   color: black,
//                                 ),
//                               ),
//                             ]),
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           CustomText(
//                             text: 'happyExploring'.tr,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                             color: colorDarkGrey,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Stack(
//                   alignment: AlignmentDirectional.center,
//                   children: [
//                     if (AppUtil.rtlDirection(context))
//                       Image.asset('assets/images/percent.png'),
//                     Image.asset('assets/images/holiday.png'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 21,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CustomText(
//                 text: 'where'.tr,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//               ),
//               CustomText(
//                 text: 'seeAll'.tr,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w400,
//                 color: colorDarkGrey,
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           SizedBox(
//             height: 100,
//             child: ListView.separated(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               itemCount: 4,
//               separatorBuilder: (context, index) {
//                 return const SizedBox(
//                   width: 24,
//                 );
//               },
//               itemBuilder: (context, index) {
//                 return Column(
//                   children: [
//                     const CircleAvatar(
//                       radius: 33,
//                       backgroundImage: AssetImage('assets/images/tabuk.png'),
//                     ),
//                     const SizedBox(
//                       height: 9,
//                     ),
//                     CustomText(
//                       text: AppUtil.rtlDirection(context) ? 'تبوك' : 'Tabuk',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           const SizedBox(
//             height: 40,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CustomText(
//                 text: 'saudiHospitality'.tr,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//               ),
//               CustomText(
//                 text: 'seeAll'.tr,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w400,
//                 color: colorDarkGrey,
//               ),
//             ],
//           ),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: 3,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                //   Get.to(() => HospitalityDetails());
//                 },
//                 child: Card(
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(16))),
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10, horizontal: 15),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Stack(
//                               alignment: AlignmentDirectional.bottomStart,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(10)),
//                                   child: Image.asset('assets/images/farm.png'),
//                                 ),
//                                 Positioned.directional(
//                                   textDirection: Directionality.of(context),
//                                   bottom: 10,
//                                   start: 10,
//                                   child: const CircleAvatar(
//                                     radius: 10.5,
//                                     backgroundImage: AssetImage(
//                                         'assets/images/ajwadi_image.png'),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(
//                               width: 11,
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const CustomText(
//                                   text: 'مزرعة جوي',
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                                 const SizedBox(
//                                   height: 12,
//                                 ),
//                                 Row(
//                                   children: [
//                                     const SizedBox(
//                                       width: 4,
//                                     ),
//                                     SvgPicture.asset(
//                                         'assets/icons/location_pin.svg'),
//                                     const SizedBox(
//                                       width: 4,
//                                     ),
//                                     const CustomText(
//                                       text: 'الرياض، المملكة العربية السعودية',
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w400,
//                                       color: textGreyColor,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 12,
//                                 ),
//                                 Row(
//                                   children: [
//                                     const SizedBox(
//                                       width: 4,
//                                     ),
//                                     Row(
//                                       children: [
//                                         SvgPicture.asset(
//                                             'assets/icons/dish.svg'),
//                                         const SizedBox(
//                                           width: 4,
//                                         ),
//                                         const CustomText(
//                                           text: 'غداء',
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w400,
//                                           color: textGreyColor,
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       width: 26,
//                                     ),
//                                     Row(
//                                       children: [
//                                         SvgPicture.asset(
//                                             'assets/icons/calendar.svg'),
//                                         const SizedBox(
//                                           width: 4,
//                                         ),
//                                         const CustomText(
//                                           text: 'الأربعاء ٢٨ ابريل',
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w400,
//                                           color: textGreyColor,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const CustomText(
//                               text: '4,7',
//                               fontSize: 10,
//                               fontWeight: FontWeight.w700,
//                               color: textGreyColor,
//                             ),
//                             const SizedBox(
//                               width: 4,
//                             ),
//                             SvgPicture.asset('assets/icons/popularity.svg'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//             separatorBuilder: (context, index) {
//               return const SizedBox(
//                 height: 14,
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
