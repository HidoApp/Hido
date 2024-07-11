import 'dart:math';

import 'package:ajwad_v4/auth/view/sigin_in/local_sign_in.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import '../../bottom_bar/tourist/view/tourist_bottom_bar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  AnimationController? _controller;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Set the desired duration here
    );

    // Listen for animation completion and stop the controller
    _controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller?.stop();
      }
    });
    _videoController = VideoPlayerController.asset('assets/intro_vid.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController?.setLooping(true);
        _videoController?.setVolume(0.0); // (silent)
        _videoController?.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: Stack(
        children: [
          CustomPaint(
            painter: ArcPainter(),
            child: SizedBox(
              height: _currentIndex == 0
                  ? screenSize.height
                  : screenSize.height / 1.35,
              width: screenSize.width,
            ),
          ),
          Positioned(
            right: _currentIndex == 0 ? 0 : 5,
            left: _currentIndex == 0 ? 0 : 5,
            bottom: _currentIndex == 0
                ? 0
                : _currentIndex == 1
                    ? 247
                    : _currentIndex == 4
                        ? 280
                        : _currentIndex == 2
                            ? 5
                            : 75,
            top: _currentIndex == 0
                ? 0
                : null, // Conditionally remove the top value

            child: _currentIndex == 0
                ? _videoController != null &&
                        _videoController!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                    : Image.asset(
                        'assets/images/vedio_cover.jpeg',
                        fit: BoxFit.fill,
                      )
                : Lottie.asset(
                    AppUtil.rtlDirection2(context)
                        ? tabs[_currentIndex].lottieFileAr
                        : tabs[_currentIndex].lottieFileEn,
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller?.duration = composition.duration;
                      _controller?.reset();
                      _controller?.forward();
                    },
                    key: Key('${Random().nextInt(999999999)}'),
                    width: 600,
                    alignment: Alignment.topCenter,
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: _currentIndex == 0
                  ? 650
                  : _currentIndex == 4
                      ? AppUtil.rtlDirection2(context)
                          ? 358
                          : 355
                      : 360, // Adjust this height to your desired value
              child: Column(
                children: [
                  Flexible(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: tabs.length,
                      itemBuilder: (BuildContext context, int index) {
                        OnboardingModel tab = tabs[index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 0),
                              child: _currentIndex == 0
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              AppUtil.rtlDirection2(context)
                                                  ? const EdgeInsets.only(
                                                      right: 8, bottom: 8)
                                                  : const EdgeInsets.only(
                                                      left: 8, bottom: 8),
                                          child: Text(
                                            AppUtil.rtlDirection2(context)
                                                ? 'اكتشف\nالسعودية\nبأهلها'
                                                : 'Saudi\nThrough\nIts Locals',
                                            textAlign:
                                                AppUtil.rtlDirection2(context)
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 58,
                                              fontFamily: 'Kufam',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: AppUtil.rtlDirection2(context)
                                          ? const EdgeInsets.only(
                                              right: 6, left: 6)
                                          : const EdgeInsets.only(
                                              right: 0, left: 0),
                                      child: Text(
                                        tab.title.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF36B268),
                                          fontSize: 22,
                                          fontFamily: 'HT Rakik',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                            ),
                            //  const SizedBox(height: 16),
                            // Text(
                            //   tab.subtitle,
                            //   style: const TextStyle(
                            //     fontSize: 17.0,
                            //     color: Colors.white70,
                            //   ),
                            //   textAlign: TextAlign.center,
                            // )
                            //            Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     for (int index = 0; index < tabs.length; index++)
                            //       _DotIndicator(isSelected: index == _currentIndex),
                            //   ],
                            // ),
                          ],
                        );
                      },
                      onPageChanged: (value) {
                        //             _currentIndex = value;
                        //              _controller.reset();
                        // _controller.forward();
                        setState(() {
                          _currentIndex = value;
                          if (_currentIndex == 0) {
                            _videoController?.play();
                          } else {
                            _videoController?.pause();
                            _controller?.reset();
                            _controller?.forward();
                          }
                        });
                      },
                    ),
                  ),

                  Padding(
                    padding: _currentIndex == 0
                        ? EdgeInsets.only(bottom: 40)
                        : AppUtil.rtlDirection2(context)
                            ? EdgeInsets.only(bottom: 37.0)
                            : EdgeInsets.only(bottom: 40.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int index = 0; index < tabs.length; index++)
                          _DotIndicator(
                            isSelected: index == _currentIndex,
                            currentIndex: _currentIndex,
                            pageController: _pageController,
                          ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 75)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                    child: CustomButton(
                      title: 'tourist'.tr,
                      textColor: _currentIndex == 0 ? black : null,
                      onPressed: () {
                        Get.to(() => const SignInScreen());
                      },
                      raduis: 8,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    child: CustomButton(
                      title: 'localGuide'.tr,
                      onPressed: () {
                        Get.to(() => const SignInScreen());
                      },
                      buttonColor: _currentIndex == 0
                          ? Color.fromARGB(0, 0, 0, 0)
                          : Color(0xFFF9F9F9),
                      raduis: 8,
                      textColor: colorGreen,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Get.to(() => const TouristBottomBar());
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 32),
                          child: Text(
                            AppUtil.rtlDirection2(context)
                                ? 'الإستمرار كزائر'
                                : 'Continue as a Guest',
                            textAlign: AppUtil.rtlDirection2(context)
                                ? TextAlign.end
                                : TextAlign.start,
                            style: TextStyle(
                              color: _currentIndex == 0
                                  ? Color(0xFFDCDCE0)
                                  : Color(0xFFB9B8C1),
                              fontSize: 16,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: SizedBox(
          //     height: 390,
          //     child: Column(
          //       children: [

          //         Flexible(
          //           child: PageView.builder(
          //             controller: _pageController,
          //             itemCount: tabs.length,
          //             itemBuilder: (BuildContext context, int index) {
          //               OnboardingModel tab = tabs[index];
          //               return Column(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   Padding(
          //                     padding:const EdgeInsets.only(left: 8, right: 8, bottom: 8),

          //                     child: Text(
          //                       tab.title.tr,
          //                       textAlign: TextAlign.center,
          //                                             style: TextStyle(
          //                     color: Color(0xFF36B268),
          //                     fontSize: 22,
          //                     fontFamily: 'HT Rakik',
          //                     fontWeight: FontWeight.w500,
          //                                             ),
          //                     ),
          //                   ),
          //                   //  const SizedBox(height: 16),
          //                   // Text(
          //                   //   tab.subtitle,
          //                   //   style: const TextStyle(
          //                   //     fontSize: 17.0,
          //                   //     color: Colors.white70,
          //                   //   ),
          //                   //   textAlign: TextAlign.center,
          //                   // )
          //         //            Row(
          //         //   mainAxisSize: MainAxisSize.min,
          //         //   children: [
          //         //     for (int index = 0; index < tabs.length; index++)
          //         //       _DotIndicator(isSelected: index == _currentIndex),
          //         //   ],
          //         // ),
          //                 ],
          //               );
          //             },
          //             onPageChanged: (value) {
          //               _currentIndex = value;
          //                _controller.reset();
          // _controller.forward();
          //               setState(() {});
          //             },
          //           ),

          //         ),

          //         Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             for (int index = 0; index < tabs.length; index++)
          //               _DotIndicator(isSelected: index == _currentIndex),
          //           ],
          //         ),
          //         // const SizedBox(height: 75)
          //       Padding(
          //       padding: const EdgeInsets.only(
          //           left: 16, right: 16, bottom: 10),
          //       child: CustomButton(
          //         title: 'tourist'.tr,
          //         onPressed: () {
          //           Get.to(() => SignInScreen());
          //         },
          //         raduis: 8,

          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 16),
          //       child: CustomButton(
          //         title: 'localGuide'.tr,
          //         onPressed: () {
          //           Get.to(() => SignInScreen());
          //         },
          //         buttonColor:Colors.white,
          //         raduis: 8,
          //         textColor: colorGreen,
          //       ),
          //     ),

          // GestureDetector(
          //   onTap: () {
          // Get.to(() => const TouristBottomBar());
          //   },
          //   child: Row(
          //     children: [
          //       Padding(
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          //         child: Text(
          //           AppUtil.rtlDirection2(context) ? 'الإستمرار كزائر' : 'Continue as a Guest',
          //           textAlign: AppUtil.rtlDirection2(context)
          //               ? TextAlign.end
          //               : TextAlign.start,
          //           style: TextStyle(
          //             color: Color(0xFFB9B8C1),
          //             fontSize: 16,
          //             fontFamily: 'SF Pro',
          //             fontWeight: FontWeight.w500,
          //             height: 0,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path whiteArc = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, size.height - 185) // Move to the left bottom
      ..lineTo(size.width,
          size.height - 185) // Draw a straight line to the right bottom
      ..lineTo(size.width, size.height) // Draw a straight line to the right top
      ..lineTo(size.width, 0) // Draw a straight line to the top right corner
      ..close(); // Close the path
    canvas.drawPath(whiteArc, Paint()..color = Color(0xFFF9F9F9));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// class _DotIndicator extends StatelessWidget {
//   final bool isSelected;
//   final int currentIndex;
//    final PageController pageController;

//   const _DotIndicator({Key? key, required this.isSelected,required this.currentIndex,required this.pageController}) : super(key: key);

//   @override
// Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (currentIndex == 4) {
//           pageController.animateToPage(
//             0,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.linear,
//           );
//         } else {
//           pageController.nextPage(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.linear,
//           );
//         }
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(right: 6.0, top: 20),
//         child: isSelected
//             ? SvgPicture.asset('assets/icons/slider.svg')
//             : AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 height: 12.0,
//                 width: 12.0,
//                 margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 2.0),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Color(0xFFDCDCE0),
//                 ),
//               ),
//       ),
//     );
//   }
// }
class _DotIndicator extends StatefulWidget {
  final bool isSelected;
  final PageController pageController;
  final int currentIndex;

  const _DotIndicator({
    Key? key,
    required this.isSelected,
    required this.pageController,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _DotIndicatorState createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<_DotIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.isSelected && !_animationController.isAnimating) {
      _animationController.forward().then((_) {
        _animationController.stop();
      });
    }
  }

  @override
  void didUpdateWidget(covariant _DotIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !_animationController.isAnimating) {
      _animationController.forward().then((_) {
        _animationController.stop();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.currentIndex == 4) {
          widget.pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        } else {
          widget.pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 6.0, top: 20),
        child: widget.isSelected
            ? AnimatedBuilder(
                animation: _animationController,
                child: SvgPicture.asset('assets/icons/slider.svg'),
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animationController.value * 2.0 * 3.141592653589793,
                    child: child,
                  );
                },
              )
            : AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 12.0,
                width: 12.0,
                margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFDCDCE0),
                ),
              ),
      ),
    );
  }
}

class OnboardingModel {
  final String lottieFileEn;
  final String title;
  final String lottieFileAr;

  OnboardingModel(this.lottieFileEn, this.title, this.lottieFileAr);
}

List<OnboardingModel> tabs = [
  OnboardingModel(
    'assets/delivery.json',
    '',
    '',
  ),
  OnboardingModel(
    'assets/onboarding_11.json',
    'intro1',
    'assets/onboarding_1_ar.json',
  ),
  OnboardingModel(
    'assets/onboarding_2.json',
    'intro2',
    'assets/onboarding_2_ar.json',
  ),
  OnboardingModel(
    'assets/testttt.json',
    'intro3',
    'assets/onboarding_3_ar.json',
  ),
  OnboardingModel(
    'assets/onboarding_44.json',
    'intro4',
    'assets/onboarding_4_ar.json',
  ),
];
