import 'dart:math';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/view/sigin_in/local_sign_in.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
//
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  final AmplitudeService amplitudeService =
      AmplitudeService(); // Create instance of AmplitudeService

// // Async function to initialize Amplitude
//   void _initializeAmplitude() async {
//     amplitude = Amplitude(Configuration(
//       apiKey: "feb049885887051bb097ac7f73572f6c",
//       // serverZone: ServerZone.eu,
//       // defaultTracking: DefaultTrackingOptions(
//       //   sessions: true,
//       // ),
//     ));

//     // Wait until the Amplitude instance is fully built
//     await amplitude.isBuilt;
//      amplitude.flush();

//   }

  @override
  void initState() {
    // FirebaseMessaging.onMessage.listen((event) {

    //   if(event.notification==null) return;
    //   showDialog(context: context,
    //    builder: ((context) {
    //      return Material(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //          Container(
    //           width: 200,
    //           height: 200,
    //           color: Colors.white,
    //           child: Column(
    //             children: [
    //               Text(event.notification?.title??''),
    //               SizedBox(height: 8,),
    //               Text(event.notification?.body??'')
    //             ],
    //           ),
    //          )
    //         ],
    //       ),

    //      );
    //    })

    //    );

    // });
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
    //_initializeAmplitude();
    // Initialize Amplitude
    // AmplitudeService.initializeAmplitude();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
            //comment
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
                  ? height * 0.776
                  // 650
                  : _currentIndex == 4
                      ? AppUtil.rtlDirection2(context)
                          ? height * 0.428
                          : height * 0.4256
                      // ? 358
                      // : 355
                      : height * 0.431,
              //  :360, // Adjust this height to your desired value

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
                              //comment
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
                                                    ? EdgeInsets.only(
                                                        right: width * 0.032)
                                                    : EdgeInsets.only(
                                                        left: width * 0.032,
                                                      ),
                                            child:
                                                AppUtil.rtlDirection2(context)
                                                    ? SvgPicture.asset(
                                                        'assets/icons/intro_ved_ar.svg',
                                                      )
                                                    : SvgPicture.asset(
                                                        'assets/icons/intro_ved.svg',
                                                      )),
                                      ],
                                    )
                                  : Padding(
                                      padding: AppUtil.rtlDirection2(context)
                                          ? EdgeInsets.only(
                                              right: width * 0.06,
                                              left: width * 0.06)
                                          : EdgeInsets.only(
                                              right: _currentIndex == 1
                                                  ? width * 0.09
                                                  : _currentIndex == 2
                                                      ? width * 0.09
                                                      : width * 0.06,
                                              left: _currentIndex == 1
                                                  ? width * 0.09
                                                  : _currentIndex == 2
                                                      ? width * 0.09
                                                      : width * 0.06),
                                      child: CustomText(
                                        text: tab.title.tr,
                                        textAlign: TextAlign.center,
                                        color: Color(0xFF36B268),
                                        fontSize: width * 0.055,
                                        maxlines: 2,
                                        fontFamily: 'HT Rakik',
                                        //  maxLines: 2, // Limit to 2 lines

                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
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

                        AmplitudeService.amplitude.track(BaseEvent(
                            'Onboarding Page Viewed ${tabs[_currentIndex].title}',
                            eventProperties: {
                              'page_index':_currentIndex,
                              'page_title':tabs[_currentIndex].title
                            }
                            ));
                      },
                    ),
                  ),

                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    // data: MediaQuery.of(context)
                    //     .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: Padding(
                      padding: _currentIndex == 0
                          ? EdgeInsets.only(bottom: width * 0.1)
                          : AppUtil.rtlDirection2(context)
                              ? EdgeInsets.only(bottom: width * 0.093)
                              : EdgeInsets.only(bottom: width * 0.1),
                      //  ? EdgeInsets.only(bottom: 40)
                      // : AppUtil.rtlDirection2(context)
                      //     ? EdgeInsets.only(bottom: 37.0)
                      //     : EdgeInsets.only(bottom: 40.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int index = 0; index < tabs.length; index++)
                            _DotIndicator(
                              isSelected: index == _currentIndex,
                              currentIndex: _currentIndex,
                              pageController: _pageController,
                              index: index,
                            ),
                        ],
                      ),
                    ),
                  ),
                  // const SizedBox(height: 75)
                  Padding(
                    padding:
                        // const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                        EdgeInsets.only(
                            left: width * 0.041,
                            right: width * 0.041,
                            bottom: width * 0.026),
                    child: CustomButton(
                      title: 'tourist'.tr,
                      textColor: _currentIndex == 0 ? black : null,
                      onPressed: () async {
                        AmplitudeService.amplitude.track(BaseEvent(
                            'Onboarding Tourist Sign In Button Clicked'));

                        Get.to(() => const SignInScreen());
                        // Get.off(() => AjwadiBottomBar());
                      },
                      raduis: 8,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.041, right: width * 0.041),
                    //EdgeInsets.only(right: 16, left: 16),

                    child: CustomButton(
                      title: 'localGuide'.tr,
                      onPressed: () {
                        AmplitudeService.amplitude.track(BaseEvent(
                            'Onboarding Local Sign In Button Clicked'));
                        Get.to(() => const LocalSignIn());
                      },
                      buttonColor: _currentIndex == 0
                          ? const Color.fromARGB(0, 0, 0, 0)
                          : const Color(0xFFF9F9F9),
                      raduis: 8,
                      textColor: colorGreen,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                     
                      Get.offAll(() => const TouristBottomBar());
                       AmplitudeService.amplitude.track(
                          BaseEvent('Onboarding Continue as Guest Clicked'));
                          
                          
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.041,
                            vertical: height * 0.039,
                            //vertical:32
                          ),
                          child: CustomText(
                            text: AppUtil.rtlDirection2(context)
                                ? 'الإستمرار كزائر'
                                : 'Continue as a Guest',
                            textAlign: AppUtil.rtlDirection2(context)
                                ? TextAlign.end
                                : TextAlign.start,
                            color: _currentIndex == 0
                                ? Color(0xFFDCDCE0)
                                : Color(0xFFB9B8C1),
                            fontSize: 16,
                            fontFamily: AppUtil.SfFontType(context),
                            fontWeight: FontWeight.w500,
                            height: 0,
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

class _DotIndicator extends StatefulWidget {
  final bool isSelected;
  final PageController pageController;
  final int currentIndex;
  final int index;

  const _DotIndicator({
    Key? key,
    required this.isSelected,
    required this.pageController,
    required this.currentIndex,
    required this.index,
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
      // _animationController.forward().then((_) {
      //   _animationController.stop();
      // });
      if (mounted) {
        _animationController.forward().then((_) {
          if (mounted) {
            _animationController.stop();
          }
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant _DotIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !_animationController.isAnimating) {
      // _animationController.forward().then((_) {
      //   _animationController.stop();
      // });
      if (mounted) {
        _animationController.forward().then((_) {
          if (mounted) {
            _animationController.stop();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    if (widget.index == widget.currentIndex) {
      dotColor = colorGreen; // Current index color
    } else if (widget.index == widget.currentIndex - 1 ||
        widget.index == widget.currentIndex - 2 ||
        widget.index == widget.currentIndex - 3 ||
        widget.index == widget.currentIndex - 4) {
      dotColor = colorGreen; // Previous index color
    } else {
      dotColor = Color(0xFFDCDCE0); // Other indexes color
    }

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
                  color: dotColor,
                  // Color(0xFFDCDCE0),
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
    'assets/onboarding_2_neww.json',
    'intro2',
    'assets/onboarding_222_Ar.json',
  ),
  OnboardingModel(
    'assets/testttt.json',
    'intro3',
    'assets/onboarding_3_ar.json',
  ),
  OnboardingModel(
    'assets/onboarding_55555.json',
    'intro4',
    'assets/onboarding_4_ar.json',
  ),
];
