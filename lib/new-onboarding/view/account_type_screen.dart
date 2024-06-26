// import 'package:ajwad_v4/auth/view/ajwadi_register/ajwadi_register_screen.dart';
// import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
// import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
// import 'package:ajwad_v4/utils/app_util.dart';
// import 'package:ajwad_v4/widgets/custom_button.dart';
// import 'package:ajwad_v4/widgets/custom_text.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart' as intel;


// import '../../constants/colors.dart';

// class AccountTypeScreen extends StatefulWidget {
//   const AccountTypeScreen({Key? key}) : super(key: key);

//   @override
//   _AccountTypeScreenState createState() => _AccountTypeScreenState();
// }

// class _AccountTypeScreenState extends State<AccountTypeScreen> {
//   final List<String> _images = [
//     'assets/images/Sign-in-Tourist.png',
//     'assets/images/intro_4.png',
//     'assets/images/intro_2.png',
//     'assets/images/intro_3.png',
//     'assets/images/intro5.png',
//     // 'assets/images/intro_3.png',
//     // 'assets/images/intro5.png',
//   ];
//   final List<String> _des = [
//     '',
//     'intro1',
//     'intro2',
//     'intro3',
//     'intro4'
   
//   ];
//   // late final VideoPlayerController _controller;

//   int _currentIndex = 0;
//  @override
//   // void initState() {
//   //   super.initState();
//   //   _controller = VideoPlayerController.asset('assets/video/intro_vid.mp4')
//   //     ..initialize().then((_) {
//   //       _controller.play();
//   //       _controller.setLooping(true);
     
//   //     });
//   // }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           CustomCarouselSlider(
//             images: _images,
//             descriptions: _des,
//             currentIndex: _currentIndex,
//             onPageChanged: (int index) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//             onButton1Pressed: () {
//               // Handle button 1 press
//             },
//             onButton2Pressed: () {
//               // Handle button 2 press
//             },
//             // controller: _controller,
//           ),
//           // Positioned(
//           //   top: 50,
//           //   left: 20,
//           //   child: IconButton(
//           //     icon: Icon(Icons.arrow_back),
//           //     onPressed: () {
//           //       if (_currentIndex > 0) {
//           //         setState(() {
//           //           _currentIndex--;
//           //         });
//           //       }
//           //     },
//           //   ),
//           // ),
//           // Positioned(
//           //   top: 50,
//           //   right: 20,
//           //   child: IconButton(
//           //     icon: Icon(Icons.arrow_forward),
//           //     onPressed: () {
//           //       if (_currentIndex < _images.length - 1) {
//           //         setState(() {
//           //           _currentIndex++;
//           //         });
//           //       }
//           //     },
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

// class CustomCarouselSlider extends StatelessWidget {
//   final List<String> images;
//   final List<String> descriptions;
//   final VoidCallback onButton1Pressed;
//   final VoidCallback onButton2Pressed;
//   final int currentIndex;
//   final ValueChanged<int> onPageChanged;
//   // final  VideoPlayerController controller;


//   const CustomCarouselSlider({
//     Key? key,
//     required this.images,
//     required this.descriptions,
//     required this.onButton1Pressed,
//     required this.onButton2Pressed,
//     required this.currentIndex,
//     required this.onPageChanged,
//     // required this.controller,

//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
    
//     return Container(
//       width: currentIndex==0?MediaQuery.of(context).size.width:390,
//       height: 944,
//       padding: const EdgeInsets.only(top: 70),
//       clipBehavior: Clip.antiAlias,
//       decoration:currentIndex==0? BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(images[0]), // Your background image
//                 fit: BoxFit.fill,
//               ),
//             ) :ShapeDecoration(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//       ),
//       child: Column(
//         children: [
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               CarouselSlider.builder(
//                 itemCount: images.length,
//                 disableGesture: true,
//                 itemBuilder: (context, index, realIndex) {
                  
//                 //    if (index == 0) {
//                 //           return SizedBox(
//                 //   width: controller.value.size?.width ?? 0,
//                 //   height: controller.value.size?.height ?? 0,
//                 //   child: VideoPlayer(controller),
//                 // ); // Display video as the first item
//                 //          } else {
//                   return Column(
//                     children: [
//                       if(index==0)...[

//                     Container( ),
//                       ]
//                       else...[

                    
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         // margin: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           image: DecorationImage(
//                             image: AssetImage(images[index]),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                         height: 380,
//                       ),
//                       ],
                     
//                           if(index==0)...[// Space between image and description
//                           //  SizedBox(
//                           // height: 50),
//                            Padding(
//                              padding: AppUtil.rtlDirection2(context)?const EdgeInsets.only(top:132,left:77,right:25): const EdgeInsets.only(top:50,right:82),
//                              child: Text(
//                              AppUtil.rtlDirection2(context)?'اكتشف السعودية بأهلها':'\nSaudi   \nThrough   \nIts Locals   ',
//                              textAlign:  AppUtil.rtlDirection2(context)?TextAlign.right: TextAlign.left,
//                              style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 53,
//                              fontFamily: 'HT Rakik',
//                              fontWeight: FontWeight.w500,
//                              ),
//                              )),
                             
//                 ]else...[
//                         SizedBox(
//                           height: 20),
//                       Padding(
//                         padding:
//                             const EdgeInsets.only(left: 8, right: 8, bottom: 8),
//                         child: Text(
//                           descriptions[index].tr,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Color(0xFF36B268),
//                             fontSize: 22,
//                             fontFamily: 'HT Rakik',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       ],
//                     ],
//                   );
//                         // }
//                 },
//                 options: CarouselOptions(
//                   height: 480,
//                   viewportFraction: 1.0,
//                   enlargeCenterPage: true,
//                   onPageChanged: (index, reason) {
//                     onPageChanged(index);
//                   },
//                 ),
//               ),
//               Container(
//                 // margin: EdgeInsets.only(top: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: images.map((url) {
//                     int index = images.indexOf(url);
//                     return currentIndex == index
//                         ? SvgPicture.asset('assets/icons/slider.svg')
//                         : Container(
//                             width: 12.0,
//                             height: 12.0,
//                             margin: EdgeInsets.symmetric(
//                                 vertical: 15.0, horizontal: 2.0),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Color(0xFFDCDCE0),
//                             ),
//                           );
//                   }).toList(),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 16, right: 16, top: 29, bottom: 10),
//                 child: CustomButton(
//                   title: 'tourist'.tr,
//                   onPressed: () {
//                     Get.to(() => SignInScreen());
//                   },
//                   raduis: 8,

                  
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: CustomButton(
//                   title: 'localGuide'.tr,
//                   onPressed: () {
//                     Get.to(() => SignInScreen());
//                   },
//                   buttonColor:currentIndex==0?Color.fromARGB(0, 0, 0, 0) :Colors.white,
//                   raduis: 8,
//                   textColor: colorGreen,
//                 ),
//               ),
//             ],
//           ),
//           GestureDetector(
//             onTap: () {
//           Get.to(() => const TouristBottomBar());
//             },
//             child: Row(
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
//                   child: Text(
//                     AppUtil.rtlDirection2(context) ? 'الإستمرار كزائر' : 'Continue as a Guest',
//                     textAlign: AppUtil.rtlDirection2(context)
//                         ? TextAlign.end
//                         : TextAlign.start,
//                     style: TextStyle(
//                       color:currentIndex==0?Colors.white: Color(0xFFB9B8C1),
//                       fontSize: 16,
//                       fontFamily: 'SF Pro',
//                       fontWeight: FontWeight.w500,
//                       height: 0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }




// class AccountTypeScreen extends StatefulWidget {
//   const AccountTypeScreen({super.key});

//   @override
//   State<AccountTypeScreen> createState() => _AccountTypeScreenState();
// }

// class _AccountTypeScreenState extends State<AccountTypeScreen>
//     with TickerProviderStateMixin {
//   int _activeIndex = 0;
//   bool startAnimation = false;

//   bool firstAnimation = false;
//   bool secondAnimation = false;
//   bool thirsdAnimation = false;

//   double localHeight = 140.0;
//   double localWeidth = 153.0;

//   double touristHeight = 140.0;
//   double touristWeidth = 153.0;

//   void _updateSize(int index) {
//     setState(() {
//       if (index == 1) {
//         localWeidth = 200;
//         touristWeidth = 80;
//       }

//       if (index == 2) {
//         localWeidth = 80;
//         touristWeidth = 200;
//       }
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     Future.delayed(
//         const Duration(
//           milliseconds: 200,
//         ), () {
//       setState(() {
//         firstAnimation = true;
//         startAnimation = true;
//       });
//     });
//   }
// // 'assets/images/account_type1.png',
// //     'assets/images/account_type2.png',
// //     'assets/images/account_type3.png',
//   final List<String> _accountTypeImages = [
//     'assets/images/account_type1.png',
//     'assets/images/Sign-in-Local.png',
//     'assets/images/Sign-in-Tourist.png',

//   ];

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final double height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: CarouselSlider.builder(
//           itemCount: _accountTypeImages.length,
//           options: CarouselOptions(
//             height: MediaQuery.of(context).size.height,
//             viewportFraction: 1,
//             enableInfiniteScroll: false,
//             scrollPhysics: const NeverScrollableScrollPhysics(),
//             onPageChanged: (index, reason) {
//               setState(() {
//                 _activeIndex = index;
//               });
//             },
//           ),
//           itemBuilder: (context, index, realIndex) {
//             return Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 if (_activeIndex == 0)
//                   AnimatedOpacity(
//                     opacity: firstAnimation ? 1 : 0,
//                     duration: const Duration(milliseconds: 800),
//                     child: Image.asset(
//                       _accountTypeImages[0],
//                       width: width,
//                       height: height,
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 if (_activeIndex == 1)
//                   AnimatedOpacity(
//                     opacity: secondAnimation ? 1 : 0,
//                     duration: const Duration(seconds: 1),
//                     child: secondAnimation
//                         ? Image.asset(
//                             _accountTypeImages[1],
//                             width: width,
//                             height: height,
//                             fit: BoxFit.cover,
//                           )
//                         : firstAnimation
//                             ? Image.asset(
//                                 _accountTypeImages[0],
//                                 width: width,
//                                 height: height,
//                                 fit: BoxFit.fill,
//                               )
//                             : Image.asset(
//                                 _accountTypeImages[2],
//                                 width: width,
//                                 height: height,
//                                 fit: BoxFit.fill,
//                               ),
//                   ),
//                 if (_activeIndex == 2)
//                   AnimatedOpacity(
//                     opacity: thirsdAnimation ? 1 : 0,
//                     duration: const Duration(seconds: 1),
//                     child: thirsdAnimation
//                         ? Image.asset(
//                             _accountTypeImages[2],
//                             width: width,
//                             height: height,
//                             fit: BoxFit.fill,
//                           )
//                         : firstAnimation
//                             ? Image.asset(
//                                 _accountTypeImages[0],
//                                 width: width,
//                                 height: height,
//                                 fit: BoxFit.fill,
//                               )
//                             : Image.asset(
//                                 _accountTypeImages[1],
//                                 width: width,
//                                 height: height,
//                                 fit: BoxFit.fill,
//                               ),
//                   ),
//                 Container(
//                     height: height,
//                     width: width,
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         _activeIndex == 0
//                             ? beige
//                             : _activeIndex == 1
//                                 ? Colors.black54
//                                 :Colors.transparent,
//                       ],
//                     ))),
//                 Positioned(
//                   top: height * 0.45,
//                   left: 30,
//                   right: 30,
//                   bottom: 60,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (_activeIndex == 0)
//                         AnimatedOpacity(
//                           opacity: startAnimation && _activeIndex == 0 ? 1 : 0,
//                           duration: const Duration(milliseconds: 700),
//                           child: CustomText(
//                             text: "selectType".tr + '!',
//                             //fontWeight: FontWeight.w700,
//                             //fontSize: 20,
//                             //height: 1.4,
//                             color: Colors.white,
//                             fontSize: 34,
//                             fontFamily: 'HT Rakik',
//                             fontWeight: FontWeight.w500,
//                            // height: 0.03,

//                             textAlign: AppUtil.rtlDirection(context)
//                                 ? TextAlign.left
//                                 : TextAlign.right,
//                           ),
//                         ),
//                       if (_activeIndex == 1)
//                         AnimatedOpacity(
//                           opacity: secondAnimation ? 1 : 0,
//                           duration: Duration(seconds: 1),
//                           child: CustomText(
//                             text: secondAnimation ? "selectType2".tr : "",
//                             //fontWeight: FontWeight.w700,
//                             //fontSize: 20,
//                             height: 1.3,
//                              fontSize: 32,
//                             fontFamily: 'HT Rakik',
//                             fontWeight: FontWeight.w500,
//                             // height: 0.03,
//                             textAlign: AppUtil.rtlDirection(context)
//                                 ? TextAlign.left
//                                 : TextAlign.right,
//                             color: Colors.white,
//                           ),
//                         ),
//                       if (_activeIndex == 2)
//                         AnimatedOpacity(
//                           opacity: thirsdAnimation ? 1 : 0,
//                           duration: Duration(seconds: 1),
//                           child: CustomText(
//                             text: thirsdAnimation ? "selectType3".tr : "",
//                             // fontWeight: FontWeight.w700,
//                             // fontSize: 20,
//                              height: 1.3,
//                              fontSize: 33,
//                             fontFamily: 'HT Rakik',
//                             fontWeight: FontWeight.w500,
//                             // height: 0.03,
//                             textAlign: AppUtil.rtlDirection(context)
//                                 ? TextAlign.left
//                                 : TextAlign.right,
//                             color: Colors.white,
//                           ),
//                         ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       if (_activeIndex == 0)
//                         AnimatedOpacity(
//                           opacity: startAnimation && _activeIndex == 0 ? 1 : 0,
//                           duration: const Duration(seconds: 1),
//                           child: CustomText(
//                             text: "selectTypeBreif".tr,
//                             // fontWeight: FontWeight.w500,
//                             // fontSize: 12,
//                              height: 1.4,
//                            fontSize: 16,
//                            fontFamily: 'SF Arabic',
//                             fontWeight: FontWeight.w400,
//                             textAlign: AppUtil.rtlDirection(context)
//                                 ? TextAlign.left
//                                 : TextAlign.right,
//                             color: _activeIndex == 0
//                                 ? Colors.white
//                                 : Colors.white.withOpacity(0.7),
//                           ),
//                         ),
//                       if (_activeIndex == 1)
//                         AnimatedOpacity(
//                           opacity: secondAnimation ? 1 : 0,
//                           duration: const Duration(seconds: 1),
//                           child: secondAnimation
//                               ? CustomText(
//                                   text: secondAnimation
//                                       ? "selectTypeBreif2".tr
//                                       : "",
//                                       fontSize: 16,
//                                       fontFamily: 'SF Arabic',
//                                       fontWeight: FontWeight.w500,
//                                   // fontWeight: FontWeight.w500,
//                                   // fontSize: 12,
//                                   height: 1.4,
//                                   textAlign: AppUtil.rtlDirection(context)
//                                       ? TextAlign.left
//                                       : TextAlign.right,
//                                   color: _activeIndex == 0
//                                       ? black.withOpacity(0.7)
//                                       : Colors.white.withOpacity(0.7),
//                                 )
//                               : SizedBox(
//                                   height: height * 0.085,
//                                 ),
//                         ),
//                       if (_activeIndex == 2)
//                         AnimatedOpacity(
//                           opacity: thirsdAnimation ? 1 : 0,
//                           duration: const Duration(seconds: 1),
//                           child: thirsdAnimation
//                               ? CustomText(
//                                   text: thirsdAnimation
//                                       ? "selectTypeBreif3".tr
//                                       : "",
//                                       fontSize: 16,
//                                       fontFamily: 'SF Arabic',
//                                       fontWeight: FontWeight.w500,
//                                   // fontWeight: FontWeight.w500,
//                                   // fontSize: 12,
//                                   height: 1.4,
//                                   textAlign: AppUtil.rtlDirection(context)
//                                       ? TextAlign.left
//                                       : TextAlign.right,
//                                   color: _activeIndex == 0
//                                       ? black.withOpacity(0.7)
//                                       : Colors.white.withOpacity(0.7),
//                                 )
//                               : SizedBox(
//                                   height: height * 0.085,
//                                 ),
//                         ),
//                       const SizedBox(
//                         height: 70,
//                       ),
//                       Align(
//                         alignment: AlignmentDirectional.bottomCenter,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           textDirection: TextDirection.ltr,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 if (_activeIndex == 1) {
//                                   Get.to(() => const AjwadiRegisterScreen());
//                                 } else {
//                                   if (_activeIndex == 0) {
//                                     Future.delayed(
//                                         const Duration(
//                                           milliseconds: 200,
//                                         ), () {
//                                       setState(() {
//                                         thirsdAnimation = false;
//                                       });
//                                     });

//                                     Future.delayed(
//                                         const Duration(
//                                           milliseconds: 700,
//                                         ), () {
//                                       setState(() {
//                                         firstAnimation = false;
//                                       });
//                                     });
//                                   } else {
//                                     Future.delayed(
//                                         const Duration(
//                                           milliseconds: 200,
//                                         ), () {
//                                       setState(() {
//                                         thirsdAnimation = false;
//                                         firstAnimation = false;
//                                       });
//                                     });
//                                   }

//                                   Future.delayed(
//                                       const Duration(
//                                         milliseconds: 500,
//                                       ), () {
//                                     setState(() {
//                                       secondAnimation = true;
//                                     });
//                                   });

//                                   _updateSize(1);
//                                   setState(() {
//                                     _activeIndex = 1;
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(12)),
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.center,
//                                       colors: [
//                                         beige.withOpacity(0.1),
//                                         Colors.white.withOpacity(0.15000000596046448),

//                                        // Colors.white.withOpacity(0.4),
//                                       ],
//                                     )),
//                                 child: AnimatedSize(
//                                   curve: Curves.easeIn,
//                                   duration: const Duration(milliseconds: 500),
//                                   child: Container(
//                                     height: localHeight,
//                                     width: localWeidth,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                            crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                       children: [
//                                     //  if (_activeIndex == 1) const Spacer(),
//                                       if (_activeIndex == 1)
//                                           GestureDetector(
//                                             onTap: () {
//                                               Get.to(() =>
//                                                   const AjwadiRegisterScreen());
//                                             },

//                                              child:Container(
//                                               height: 30,
//                                               width: 30,
//                                               child: const Icon(
//                                                 Icons.arrow_back_ios,
//                                                 color: Colors.white,
//                                               ),
//                                             ),

//                                           ),
//                                        if (_activeIndex == 1)

//                                          const SizedBox(
//                                                 width: 10,
//                                               ),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                           textDirection: _activeIndex == 0 &&
//                                                   AppUtil.rtlDirection(context)
//                                               ? TextDirection.rtl
//                                               : TextDirection.ltr,
//                                           children: [
//                                             SvgPicture.asset(
//                                               'assets/images/guide_logo.svg',
//                                               height: 50,
//                                             ),
//                                             Container(
//                                               width:
//                                                   _activeIndex == 2 ? 70 : 110,
//                                               child: CustomText(
//                                                 text: 'localGuide'.tr,

//                                                 textAlign: TextAlign.center,
//                                                 fontWeight: _activeIndex == 2
//                                                     ? FontWeight.w600
//                                                     : FontWeight.w700,
//                                                 maxlines: 2,
//                                                 fontSize:
//                                                     _activeIndex == 2 ? 11 : 16,
//                                                 height: 0,
//                                                 color: _activeIndex == 0
//                                                     ? Colors.white
//                                                     : Colors.white,
//                                               ),
//                                             ),

//                                           ],
//                                         ),
//                                         // if (_activeIndex == 1) const Spacer(),
//                                         // if (_activeIndex == 1)
//                                         //   GestureDetector(
//                                         //     onTap: () {
//                                         //       Get.to(() =>
//                                         //           const AjwadiRegisterScreen());
//                                         //     },
//                                         //     child: Container(
//                                         //       height: 40,
//                                         //       width: 40,
//                                         //       child: const Icon(
//                                         //         Icons.arrow_back_ios,
//                                         //         color: Colors.white,
//                                         //       ),
//                                         //     ),
//                                         //   ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                                 onTap: () {
//                                   if (_activeIndex == 2) {
//                                     Get.to(() => const SignInScreen());
//                                   } else {
//                                     if (_activeIndex == 0) {
//                                       Future.delayed(
//                                           const Duration(
//                                             milliseconds: 200,
//                                           ), () {
//                                         setState(() {
//                                           secondAnimation = false;
//                                         });
//                                       });

//                                       Future.delayed(
//                                           const Duration(
//                                             milliseconds: 700,
//                                           ), () {
//                                         setState(() {
//                                           firstAnimation = false;
//                                         });
//                                       });
//                                     } else {
//                                       Future.delayed(
//                                           const Duration(
//                                             milliseconds: 200,
//                                           ), () {
//                                         setState(() {
//                                           secondAnimation = false;
//                                           firstAnimation = false;
//                                         });
//                                       });
//                                     }

//                                     Future.delayed(
//                                         const Duration(
//                                           milliseconds: 500,
//                                         ), () {
//                                       setState(() {
//                                         thirsdAnimation = true;
//                                       });
//                                     });

//                                     setState(() {
//                                       _activeIndex = 2;
//                                     });

//                                     _updateSize(2);
//                                   }
//                                 },
//                                 child: Container(
//                                     decoration: BoxDecoration(
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(12)),
//                                         gradient: LinearGradient(
//                                           begin: Alignment.topCenter,
//                                           end: Alignment.center,
//                                           colors: [
//                                             beige.withOpacity(0.1),
//                                             // Colors.white.withOpacity(0.4),
//                                           Colors.white.withOpacity(0.15000000596046448),

//                                           ],
//                                         )),
//                                     child: AnimatedSize(
//                                       curve: Curves.easeIn,
//                                       duration:
//                                           const Duration(milliseconds: 500),
//                                       child: Container(
//                                         height: touristHeight,
//                                         width: touristWeidth,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             if (_activeIndex == 2)
//                                               const SizedBox(
//                                                 width: 50,
//                                               ),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               textDirection:
//                                                   _activeIndex == 0 &&
//                                                           !AppUtil.rtlDirection(
//                                                               context)
//                                                       ? TextDirection.rtl
//                                                       : TextDirection.ltr,
//                                               children: [
//                                                 SvgPicture.asset(
//                                                   'assets/images/tourist_logo.svg',
//                                                   height: 50,
//                                                 ),
//                                                 Container(
//                                                   child: CustomText(
//                                                     text: 'tourist'.tr,
//                                                     fontWeight:
//                                                         _activeIndex == 1
//                                                             ? FontWeight.w500
//                                                             : FontWeight.w700,
//                                                     maxlines: 2,
//                                                     fontSize: _activeIndex == 1
//                                                         ? 12
//                                                         : 16,
//                                                     height: 0,
//                                                     color: _activeIndex == 0
//                                                         ? Colors.white
//                                                         : Colors.white,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             if (_activeIndex == 2)
//                                               const Spacer(),
//                                             if (_activeIndex == 2)
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Get.to(() =>
//                                                       const SignInScreen());
//                                                 },
//                                                 child: const SizedBox(
//                                                   height: 30,
//                                                   width: 30,
//                                                   child: Icon(
//                                                       Icons.arrow_forward_ios,
//                                                       color: Colors.white),
//                                                 ),
//                                               ),
//                                             if (_activeIndex == 2)
//                                               const SizedBox(
//                                                 width: 26,
//                                               ),
//                                           ],
//                                         ),
//                                       ),
//                                     ))),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: width * 0.041,
//                       ),
//                       InkWell(
//                           onTap: () {
//                             Get.to(() => const TouristBottomBar());
//                           },
//                           child: CustomText(
//                             text: 'exploreAsGuest'.tr,

//                             color: _activeIndex == 0 ?Colors.white: Colors.white,
//                             // fontWeight: FontWeight.w400,
//                             // textDecoration: TextDecoration.underline,
//                             // fontSize: width * 0.035,
//                             textAlign: TextAlign.center,
//                             fontSize:  width * 0.036,
//                            fontFamily: 'HT Rakik',
//                             fontWeight: FontWeight.w400,
//                           height: 0,
//                           ))
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }),
//     );
//   }
// }

// import 'package:ajwad_v4/auth/view/ajwadi_register/ajwadi_register_screen.dart';
// import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
// import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
// import 'package:ajwad_v4/utils/app_util.dart';
// import 'package:ajwad_v4/widgets/custom_text.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import 'package:get/get.dart';

// import '../../constants/colors.dart';

// class AccountTypeScreen extends StatefulWidget {
//   const AccountTypeScreen({Key? key}) : super(key: key);

//   @override
//   State<AccountTypeScreen> createState() => _AccountTypeScreenState();
// }

// class _AccountTypeScreenState extends State<AccountTypeScreen> {
//   int _activeIndex = 0;

//   final List<String> _accountTypeImages = [
//     'assets/images/account_type1.png',
//     'assets/images/Sign-in-Local.png',
//     'assets/images/Sign-in-Tourist.png',
//   ];

//  @override
// Widget build(BuildContext context) {
//   final double width = MediaQuery.of(context).size.width;
//   final double height = MediaQuery.of(context).size.height;

//   return Scaffold(
//     backgroundColor: Colors.black,
//     body: Stack(
//       children: [
//         CarouselSlider.builder(
//           itemCount: _accountTypeImages.length,
//           options: CarouselOptions(
//             height: MediaQuery.of(context).size.height,
//             viewportFraction: 1,
//             enableInfiniteScroll: false,
//             scrollPhysics: const NeverScrollableScrollPhysics(),
//             onPageChanged: (index, reason) {
//               setState(() {
//                 _activeIndex = index;
//               });
//             },
//           ),
//           itemBuilder: (context, index, realIndex) {
//             return Image.asset(
//               _accountTypeImages[index],
//               width: width,
//               height: height,
//               fit: BoxFit.fill,
//             );
//           },
//         ),
//         Positioned(
//           top: height * 0.45,
//           left: 30,
//           right: 30,
//           bottom: 60,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                 text: _activeIndex == 0
//                     ? "selectType".tr + '!'
//                     : _activeIndex == 1
//                         ? "selectType2".tr
//                         : "selectType3".tr,
//                 color: Colors.white,
//                 fontSize: 34,
//                 fontFamily: 'HT Rakik',
//                 fontWeight: FontWeight.w500,
//                 textAlign: AppUtil.rtlDirection(context)
//                     ? TextAlign.left
//                     : TextAlign.right,
//               ),
//               SizedBox(height: 10),
//               CustomText(
//                 text: _activeIndex == 0
//                     ? "selectTypeBreif".tr
//                     : _activeIndex == 1
//                         ? "selectTypeBreif2".tr
//                         : "selectTypeBreif3".tr,
//                 color: Colors.white.withOpacity(0.7),
//                 fontSize: 16,
//                 fontFamily: 'SF Arabic',
//                 fontWeight: FontWeight.w400,
//                 textAlign: AppUtil.rtlDirection(context)
//                     ? TextAlign.left
//                     : TextAlign.right,
//               ),
//               SizedBox(height: 70),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 textDirection: TextDirection.ltr,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       // Handle local tap
//                     },
//                     child: Container(
//                       // Local container
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // Handle tourist tap
//                     },
//                     child: Container(
//                       // Tourist container
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: width * 0.041),
//               InkWell(
//                 onTap: () {
//                   Get.to(() => const TouristBottomBar());
//                 },
//                 child: CustomText(
//                   text: 'exploreAsGuest'.tr,
//                   color: Colors.white,
//                   fontSize: width * 0.036,
//                   fontFamily: 'HT Rakik',
//                   fontWeight: FontWeight.w400,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
// }
