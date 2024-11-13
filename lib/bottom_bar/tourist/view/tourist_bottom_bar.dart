import 'dart:async';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/tourist_map_screen.dart';
import 'package:ajwad_v4/explore/widget/rating_sheet.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/profile/view/guest_sign_in.dart';
import 'package:ajwad_v4/profile/view/profle_screen.dart';
import 'package:ajwad_v4/services/view/service_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/offline_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class TouristBottomBar extends StatefulWidget {
  const TouristBottomBar({super.key});

  @override
  State<TouristBottomBar> createState() => _TouristBottomBarState();
}

class _TouristBottomBarState extends State<TouristBottomBar> {
  final _pageController = PageController();
  // int _currentIndex = 0;
  final ProfileController _profileController = ProfileController();
  final getStorage = GetStorage();
  final _authCntroller = Get.put(AuthController());

  late Profile profile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authCntroller.checkAppVersion(context: context);

    setInternetConnection();
  }

  StreamSubscription? _internetConnection;
  void setInternetConnection() {
    _internetConnection = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          _profileController.isInternetConnected(true);
          if (!AppUtil.isGuest()) {
            getProfile();
            // getUserActions();
            // _profileController.isUserOpenTheApp(true);
          }
          break;
        case InternetStatus.disconnected:
          _profileController.isInternetConnected(false);
          break;
        default:
          _profileController.isInternetConnected(false);
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _internetConnection!.cancel();
  }

  void getProfile() async {
    await _profileController.getProfile(context: context);
    GetStorage().write('user_id', _profileController.profile.id);
  }

  void getUserActions() async {
    await _profileController.getAllActions(context: context);
    if (_profileController.actionsList.isNotEmpty) {
      Get.bottomSheet(
              isScrollControlled: true,
              RatingSheet(
                activityProgress: _profileController.actionsList.first,
              ))
          .then((value) => _profileController.updateUserAction(
              context: context,
              id: _profileController.actionsList.first.id ?? ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => _profileController.isInternetConnected.value
          ? Scaffold(
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  // Container(),
                  const TouristMapScreen(),
                  const ServiceScreen(),
                  // const ShopScreen(),
                  AppUtil.isGuest()
                      ? const GuestSignInScreen()
                      : ProfileScreen(
                          fromAjwady: false,
                          profileController: _profileController,
                          //  profile: profile,
                        ),
                ],
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      blurRadius: 40,
                      color: Color.fromRGBO(33, 33, 33, 0.05),
                      offset: Offset(10, 0))
                ]),
                child: Obx(
                  () => BottomNavigationBar(
                    elevation: 0,
                    enableFeedback: false,
                    backgroundColor: Colors.white,
                    currentIndex: _profileController.touriestBar.value,
                    type: BottomNavigationBarType.fixed,
                    unselectedItemColor: const Color(0xFFB9B8C1),
                    selectedItemColor: colorGreen,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                    ),
                    selectedLabelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      color: darkBlack,
                    ),
                    onTap: (index) {
                      //
                      _profileController.touriestBar.value = index;
                      _pageController
                          .jumpToPage(_profileController.touriestBar.value);
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: Container(
                          decoration: _profileController.touriestBar.value == 0
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [],
                                )
                              : const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: RepaintBoundary(
                              child: SvgPicture.asset(
                                'assets/icons/map_icon.svg',
                                color: _profileController.touriestBar.value == 0
                                    ? colorGreen
                                    : const Color(0xFFB9B8C1),
                              ),
                            ),
                          ),
                        ),
                        label: 'explore'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          decoration: _profileController.touriestBar.value == 1
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [],
                                )
                              : const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: RepaintBoundary(
                              child: SvgPicture.asset(
                                'assets/icons/request_icon.svg',
                                color: _profileController.touriestBar.value == 1
                                    ? colorGreen
                                    : const Color(0xFFB9B8C1),
                              ),
                            ),
                          ),
                        ),
                        label: 'services'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          decoration: _profileController.touriestBar.value == 2
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [],
                                )
                              : const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: RepaintBoundary(
                              child: SvgPicture.asset(
                                'assets/icons/my_profile.svg',
                                color: _profileController.touriestBar.value == 2
                                    ? colorGreen
                                    : const Color(0xFFB9B8C1),
                              ),
                            ),
                          ),
                        ),
                        label: 'profile'.tr,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const OfflineScreen(),
    );
  }
}
