import 'dart:async';

import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/new_request_screen.dart';
import 'package:ajwad_v4/request/ajwadi/view/request_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/profle_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/offline_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../explore/ajwadi/view/Experience/add_experience_info.dart';
import '../../../explore/ajwadi/view/hoapatility/widget/buttomProgress.dart';
import '../../../explore/ajwadi/view/local_home_screen.dart';

class AjwadiBottomBar extends StatefulWidget {
  const AjwadiBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  State<AjwadiBottomBar> createState() => _AjwadiBottomBarState();
}

final ProfileController _profileController = ProfileController();
final storage = GetStorage();
// final isTourGuide = storage.read("TourGuide") ?? true;
//int currentIndex = 0;
List bottomScreens = [];

class _AjwadiBottomBarState extends State<AjwadiBottomBar>
    with SingleTickerProviderStateMixin {
  final _profileController = Get.put(ProfileController());
  final _pageController = PageController();
  StreamSubscription? _internetConnection;
  void setInternetConnection() {
    _internetConnection = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          _profileController.isInternetConnected(true);
          getProfile();

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
    // TODO: implement dispose
    super.dispose();
    _internetConnection!.cancel();
  }

  getProfile() async {
    await _profileController.getProfile(context: context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !_profileController.isInternetConnected.value
          ? const OfflineScreen()
          : Scaffold(
              body: Skeletonizer(
                enabled: _profileController.isProfileLoading.value,
                child: PageView(
                  controller: _pageController,
                  //  index: _profileController.localBar.value,
                  children: [
                    LocalHomeScreen(
                        fromAjwady: true,
                        profileController: _profileController),
                    if (_profileController.profile.accountType != 'EXPERIENCES')
                      const NewRequestScreen(),
                    //const RequestScreen(),
                    const AddExperienceInfo(),
                    ProfileScreen(
                      fromAjwady: true,
                      profileController: _profileController,
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Obx(() => Skeletonizer(
                    enabled: _profileController.isProfileLoading.value,
                    child: BottomNavigationBar(
                      elevation: 0,
                      enableFeedback: false,
                      backgroundColor: Colors.white,
                      currentIndex: _profileController.localBar.value,
                      type: BottomNavigationBarType.fixed,
                      unselectedItemColor: colorDarkGrey,
                      selectedItemColor: colorGreen,
                      unselectedLabelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        color: colorDarkGrey,
                      ),
                      selectedLabelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        color: colorGreen,
                      ),
                      items: [
                        BottomNavigationBarItem(
                            label: "home".tr,
                            icon: SvgPicture.asset(
                              "assets/icons/request_icon.svg",
                              color: _profileController.localBar.value == 0
                                  ? colorGreen
                                  : colorDarkGrey,
                            )),
                        if (_profileController.profile.accountType !=
                            'EXPERIENCES')
                          BottomNavigationBarItem(
                              label: "request".tr,
                              icon: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: SvgPicture.asset(
                                  "assets/icons/my_request_green.svg",
                                  color: _profileController.localBar.value == 1
                                      ? colorGreen
                                      : colorDarkGrey,
                                ),
                              )),
                        BottomNavigationBarItem(
                            label: "MyExperiences".tr,
                            icon: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: SvgPicture.asset(
                                "assets/icons/my_experiences.svg",
                                color: _profileController.profile.accountType !=
                                        'EXPERIENCES'
                                    ? _profileController.localBar.value == 2
                                        ? colorGreen
                                        : colorDarkGrey
                                    : _profileController.localBar.value == 1
                                        ? colorGreen
                                        : colorDarkGrey,
                              ),
                            )),
                        BottomNavigationBarItem(
                            label: "profile".tr,
                            icon: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: SvgPicture.asset(
                                "assets/icons/my_profile_green.svg",
                                color: _profileController.profile.accountType !=
                                        'EXPERIENCES'
                                    ? _profileController.localBar.value == 3
                                        ? colorGreen
                                        : colorDarkGrey
                                    : _profileController.localBar.value == 2
                                        ? colorGreen
                                        : colorDarkGrey,
                              ),
                            )),
                      ],
                      onTap: (int newIndex) {
                        _profileController.localBar(newIndex);
                        _pageController.jumpToPage(newIndex);
                      },
                    ),
                  ))),
    );
  }
}
