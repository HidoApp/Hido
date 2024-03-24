import 'package:ajwad_v4/auth/view/ajwadi_register/ajwadi_register_screen.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../constants/colors.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen>
    with TickerProviderStateMixin {
  int _activeIndex = 0;
  bool startAnimation = false;

  bool firstAnimation = false;
  bool secondAnimation = false;
  bool thirsdAnimation = false;

  double localHeight = 150.0;
  double localWeidth = 140.0;

  double touristHeight = 150.0;
  double touristWeidth = 140.0;

  void _updateSize(int index) {
    setState(() {
      if (index == 1) {
        localWeidth = 200;
        touristWeidth = 80;
      }

      if (index == 2) {
        localWeidth = 80;
        touristWeidth = 200;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(
        const Duration(
          milliseconds: 200,
        ), () {
      setState(() {
        firstAnimation = true;
        startAnimation = true;
      });
    });
  }

  final List<String> _accountTypeImages = [
    'assets/images/account_type1.png',
    'assets/images/account_type2.png',
    'assets/images/account_type3.png',
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CarouselSlider.builder(
          itemCount: _accountTypeImages.length,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index, reason) {
              setState(() {
                _activeIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                if (_activeIndex == 0)
                  AnimatedOpacity(
                    opacity: firstAnimation ? 1 : 0,
                    duration: const Duration(milliseconds: 800),
                    child: Image.asset(
                      _accountTypeImages[0],
                      width: width,
                      height: height,
                      fit: BoxFit.fill,
                    ),
                  ),
                if (_activeIndex == 1)
                  AnimatedOpacity(
                    opacity: secondAnimation ? 1 : 0,
                    duration: const Duration(seconds: 1),
                    child: secondAnimation
                        ? Image.asset(
                            _accountTypeImages[1],
                            width: width,
                            height: height,
                            fit: BoxFit.fill,
                          )
                        : firstAnimation
                            ? Image.asset(
                                _accountTypeImages[0],
                                width: width,
                                height: height,
                                fit: BoxFit.fill,
                              )
                            : Image.asset(
                                _accountTypeImages[2],
                                width: width,
                                height: height,
                                fit: BoxFit.fill,
                              ),
                  ),
                if (_activeIndex == 2)
                  AnimatedOpacity(
                    opacity: thirsdAnimation ? 1 : 0,
                    duration: const Duration(seconds: 1),
                    child: thirsdAnimation
                        ? Image.asset(
                            _accountTypeImages[2],
                            width: width,
                            height: height,
                            fit: BoxFit.fill,
                          )
                        : firstAnimation
                            ? Image.asset(
                                _accountTypeImages[0],
                                width: width,
                                height: height,
                                fit: BoxFit.fill,
                              )
                            : Image.asset(
                                _accountTypeImages[1],
                                width: width,
                                height: height,
                                fit: BoxFit.fill,
                              ),
                  ),
                Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        _activeIndex == 0
                            ? beige
                            : _activeIndex == 1
                                ? black
                                : brown,
                      ],
                    ))),
                Positioned(
                  top: height * 0.45,
                  left: 35,
                  right: 35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_activeIndex == 0)
                        AnimatedOpacity(
                          opacity: startAnimation && _activeIndex == 0 ? 1 : 0,
                          duration: const Duration(milliseconds: 700),
                          child: CustomText(
                            text: "selectType".tr + '!',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.4,
                            textAlign: AppUtil.rtlDirection(context)
                                ? TextAlign.left
                                : TextAlign.right,
                            color: black,
                          ),
                        ),
                      if (_activeIndex == 1)
                        AnimatedOpacity(
                          opacity: secondAnimation ? 1 : 0,
                          duration: Duration(seconds: 1),
                          child: CustomText(
                            text: secondAnimation ? "selectType2".tr : "",
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.4,
                            textAlign: AppUtil.rtlDirection(context)
                                ? TextAlign.left
                                : TextAlign.right,
                            color: Colors.white,
                          ),
                        ),
                      if (_activeIndex == 2)
                        AnimatedOpacity(
                          opacity: thirsdAnimation ? 1 : 0,
                          duration: Duration(seconds: 1),
                          child: CustomText(
                            text: thirsdAnimation ? "selectType3".tr : "",
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.4,
                            textAlign: AppUtil.rtlDirection(context)
                                ? TextAlign.left
                                : TextAlign.right,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (_activeIndex == 0)
                        AnimatedOpacity(
                          opacity: startAnimation && _activeIndex == 0 ? 1 : 0,
                          duration: const Duration(seconds: 1),
                          child: CustomText(
                            text: "selectTypeBreif".tr,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            height: 1.4,
                            textAlign: AppUtil.rtlDirection(context)
                                ? TextAlign.left
                                : TextAlign.right,
                            color: _activeIndex == 0
                                ? black.withOpacity(0.7)
                                : Colors.white.withOpacity(0.7),
                          ),
                        ),
                      if (_activeIndex == 1)
                        AnimatedOpacity(
                          opacity: secondAnimation ? 1 : 0,
                          duration: const Duration(seconds: 1),
                          child: secondAnimation
                              ? CustomText(
                                  text: secondAnimation
                                      ? "selectTypeBreif2".tr
                                      : "",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  height: 1.4,
                                  textAlign: AppUtil.rtlDirection(context)
                                      ? TextAlign.left
                                      : TextAlign.right,
                                  color: _activeIndex == 0
                                      ? black.withOpacity(0.7)
                                      : Colors.white.withOpacity(0.7),
                                )
                              : SizedBox(
                                  height: height * 0.085,
                                ),
                        ),
                      if (_activeIndex == 2)
                        AnimatedOpacity(
                          opacity: thirsdAnimation ? 1 : 0,
                          duration: const Duration(seconds: 1),
                          child: thirsdAnimation
                              ? CustomText(
                                  text: thirsdAnimation
                                      ? "selectTypeBreif3".tr
                                      : "",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  height: 1.4,
                                  textAlign: AppUtil.rtlDirection(context)
                                      ? TextAlign.left
                                      : TextAlign.right,
                                  color: _activeIndex == 0
                                      ? black.withOpacity(0.7)
                                      : Colors.white.withOpacity(0.7),
                                )
                              : SizedBox(
                                  height: height * 0.085,
                                ),
                        ),
                      const SizedBox(
                        height: 38,
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.ltr,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_activeIndex == 1) {
                                  Get.to(() => const AjwadiRegisterScreen());
                                } else {
                                  if (_activeIndex == 0) {
                                    Future.delayed(
                                        const Duration(
                                          milliseconds: 200,
                                        ), () {
                                      setState(() {
                                        thirsdAnimation = false;
                                      });
                                    });

                                    Future.delayed(
                                        const Duration(
                                          milliseconds: 700,
                                        ), () {
                                      setState(() {
                                        firstAnimation = false;
                                      });
                                    });
                                  } else {
                                    Future.delayed(
                                        const Duration(
                                          milliseconds: 200,
                                        ), () {
                                      setState(() {
                                        thirsdAnimation = false;
                                        firstAnimation = false;
                                      });
                                    });
                                  }

                                  Future.delayed(
                                      const Duration(
                                        milliseconds: 500,
                                      ), () {
                                    setState(() {
                                      secondAnimation = true;
                                    });
                                  });

                                  _updateSize(1);
                                  setState(() {
                                    _activeIndex = 1;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        beige.withOpacity(0.1),
                                        Colors.white.withOpacity(0.2),
                                      ],
                                    )),
                                child: AnimatedSize(
                                  curve: Curves.easeIn,
                                  duration: const Duration(milliseconds: 500),
                                  child: Container(
                                    height: localHeight,
                                    width: localWeidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          textDirection: _activeIndex == 0 &&
                                                  AppUtil.rtlDirection(context)
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/guide_logo.svg',
                                              height: 50,
                                            ),
                                            Container(
                                              width:
                                                  _activeIndex == 2 ? 50 : 110,
                                              child: CustomText(
                                                text: 'localGuide'.tr,
                                                textAlign: TextAlign.center,
                                                fontWeight: _activeIndex == 2
                                                    ? FontWeight.w500
                                                    : FontWeight.w700,
                                                maxlines: 2,
                                                fontSize:
                                                    _activeIndex == 2 ? 11 : 16,
                                                height: 1.3,
                                                color: _activeIndex == 0
                                                    ? darkBlack
                                                    : Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (_activeIndex == 1) const Spacer(),
                                        if (_activeIndex == 1)
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() =>
                                                  const AjwadiRegisterScreen());
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              child: const Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  if (_activeIndex == 2) {
                                    Get.to(() => const SignInScreen());
                                  } else {
                                    if (_activeIndex == 0) {
                                      Future.delayed(
                                          const Duration(
                                            milliseconds: 200,
                                          ), () {
                                        setState(() {
                                          secondAnimation = false;
                                        });
                                      });

                                      Future.delayed(
                                          const Duration(
                                            milliseconds: 700,
                                          ), () {
                                        setState(() {
                                          firstAnimation = false;
                                        });
                                      });
                                    } else {
                                      Future.delayed(
                                          const Duration(
                                            milliseconds: 200,
                                          ), () {
                                        setState(() {
                                          secondAnimation = false;
                                          firstAnimation = false;
                                        });
                                      });
                                    }

                                    Future.delayed(
                                        const Duration(
                                          milliseconds: 500,
                                        ), () {
                                      setState(() {
                                        thirsdAnimation = true;
                                      });
                                    });

                                    setState(() {
                                      _activeIndex = 2;
                                    });

                                    _updateSize(2);
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            beige.withOpacity(0.1),
                                            Colors.white.withOpacity(0.2),
                                          ],
                                        )),
                                    child: AnimatedSize(
                                      curve: Curves.easeIn,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: Container(
                                        height: touristHeight,
                                        width: touristWeidth,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (_activeIndex == 2)
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              textDirection:
                                                  _activeIndex == 0 &&
                                                          !AppUtil.rtlDirection(
                                                              context)
                                                      ? TextDirection.rtl
                                                      : TextDirection.ltr,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/tourist_logo.svg',
                                                  height: 50,
                                                ),
                                                Container(
                                                  child: CustomText(
                                                    text: 'tourist'.tr,
                                                    fontWeight:
                                                        _activeIndex == 1
                                                            ? FontWeight.w500
                                                            : FontWeight.w700,
                                                    maxlines: 2,
                                                    fontSize: _activeIndex == 1
                                                        ? 12
                                                        : 16,
                                                    height: 1.3,
                                                    color: _activeIndex == 0
                                                        ? darkBlack
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (_activeIndex == 2)
                                              const Spacer(),
                                            if (_activeIndex == 2)
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(() =>
                                                      const SignInScreen());
                                                },
                                                child: const SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            if (_activeIndex == 2)
                                              const SizedBox(
                                                width: 26,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ))),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      InkWell(
                          onTap: () {
                            Get.to(const TouristBottomBar());
                          },
                          child: CustomText(
                            text: 'exploreAsGuest'.tr,
                            color: _activeIndex == 0 ? black : Colors.white,
                            fontWeight: FontWeight.w400,
                            textDecoration: TextDecoration.underline,
                            fontSize: 14,
                          ))
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
