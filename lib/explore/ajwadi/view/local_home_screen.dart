// import 'dart:async';

// import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
// import 'package:ajwad_v4/constants/colors.dart';
// import 'package:ajwad_v4/explore/ajwadi/view/add_on_map.dart';
// import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
// import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
// import 'package:ajwad_v4/explore/tourist/view/notification/notification_screen.dart';
// import 'package:ajwad_v4/utils/app_util.dart';
// import 'package:ajwad_v4/widgets/custom_button.dart';
// import 'package:ajwad_v4/widgets/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// import '../../../auth/view/sigin_in/signin_screen.dart';
// import '../../../profile/controllers/profile_controller.dart';
// import '../../../profile/view/messages_screen.dart';

// class LocalHomeScreen extends StatefulWidget {
//   const LocalHomeScreen({super.key, this.fromAjwady = true});

//   final bool fromAjwady;

//   @override
//   State<LocalHomeScreen> createState() => _LocalHomeScreenState();
// }

// class _LocalHomeScreenState extends State<LocalHomeScreen> {

  


//   final _getStorage = GetStorage();
//   final _authController = Get.put(AuthController());



//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: 
//           Positioned(
//             top: 49,
//             left: 16,
//             right: 16,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               textDirection: TextDirection.ltr,
//               children: [
//                 InkWell(
//                   onTap: () {},
//                   child: Container(
//                     height: 36,
//                     width: width * 0.65,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                     alignment: Alignment.center,
//                     child: Row(
//                       // textDirection: TextDirection.rtl,
//                       children: [
//                         const SizedBox(
//                           width: 22,
//                         ),
//                         SvgPicture.asset(
//                           'assets/icons/search.svg',
//                         ),
//                         const SizedBox(
//                           width: 12,
//                         ),
//                         CustomText(
//                           text: 'search'.tr,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           color: thinGrey.withOpacity(0.5),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                         ProfileController _profileController =
//                                           Get.put(ProfileController());
//                                       Get.to(() =>
//                                         MessagesScreen(
//                                               profileController:
//                                                   _profileController)); 
//                                                    },
//                   child: Container(
//                     width: 36,
//                     height: 36,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: gold,
//                     ),
//                     alignment: Alignment.center,
//                     child: SvgPicture.asset('assets/icons/message.svg'),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Get.to(() => NotificationScreen());
//                   },
//                   child: Container(
//                     width: 36,
//                     height: 36,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: colorGreen,
//                     ),
//                     alignment: Alignment.center,
//                     child: SvgPicture.asset('assets/icons/notifications.svg'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//         ],
//       ),
//     );
//   }
//}
