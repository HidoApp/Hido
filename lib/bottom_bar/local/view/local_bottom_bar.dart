import 'dart:async';
import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/ajwadi_info.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/request/local/view/new_request_screen.dart';
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

import '../../../explore/local/view/Experience/commen/view/add_experience_info.dart';
import '../../../explore/local/view/local_home_screen.dart';

class LocalBottomBar extends StatefulWidget {
  const LocalBottomBar({Key? key, this.initialIndex // Add this field

      })
      : super(key: key);
  final int? initialIndex; // Add this field

  @override
  State<LocalBottomBar> createState() => _LocalBottomBarState();
}

final ProfileController _profileController = ProfileController();
final storage = GetStorage();
// final isTourGuide = storage.read("TourGuide") ?? true;
//int currentIndex = 0;
List bottomScreens = [];
var profile = Profile().obs;
var localInfo = AjwadiInfo().obs;

class _LocalBottomBarState extends State<LocalBottomBar>
    with SingleTickerProviderStateMixin {
  final _authCntroller = Get.put(AuthController());

  final _profileController = Get.put(ProfileController());
  final _pageController = PageController();
  StreamSubscription? _internetConnection;
  void setInternetConnection() {
    _internetConnection = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          _profileController.isInternetConnected(true);
          //  getProfile();

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
    _internetConnection!.cancel();
    _pageController.dispose();
  }

  getProfile() async {
    try {
      final result = await _profileController.getProfile(context: context);
      if (result != null) {
        profile.value = result;
      } else {
        // Handle null case here (e.g., show an error message or set a default value)
        debugPrint("Profile returned null. Default value applied.");
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors or other issues)
      debugPrint("Error while fetching profile: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _authCntroller.checkAppVersion(context: context);
    setInternetConnection();

    if (_profileController.isInternetConnected.value) {
      getProfile();
      // getLocalInfo();
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _profileController.localBar.value =
    //       widget.initialIndex ?? _profileController.localBar.value;
    //   _pageController.jumpToPage(_profileController.localBar.value);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _profileController.localBar.value == null
          ? const CircularProgressIndicator() // Or a fallback widget
          : !_profileController.isInternetConnected.value
              ? const OfflineScreen()
              : Scaffold(
                  body: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      LocalHomeScreen(
                          fromAjwady: true,
                          profileController: _profileController),
                      if (profile.value.accountType != 'EXPERIENCES')
                        const NewRequestScreen(),
                      const AddExperienceInfo(),
                      ProfileScreen(
                        fromAjwady: true,
                        profileController: _profileController,
                      ),
                    ],
                  ),
                  bottomNavigationBar: Obx(() => Skeletonizer(
                        enabled: _profileController.isProfileLoading.value,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
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
                                    color:
                                        _profileController.localBar.value == 0
                                            ? colorGreen
                                            : colorDarkGrey,
                                  )),
                              if (_profileController.profile.accountType !=
                                  'EXPERIENCES')
                                BottomNavigationBarItem(
                                    label: "request".tr,
                                    icon: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: SvgPicture.asset(
                                        "assets/icons/my_request_green.svg",
                                        color:
                                            _profileController.localBar.value ==
                                                    1
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
                                      color: _profileController
                                                  .profile.accountType !=
                                              'EXPERIENCES'
                                          ? _profileController.localBar.value ==
                                                  2
                                              ? colorGreen
                                              : colorDarkGrey
                                          : _profileController.localBar.value ==
                                                  1
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
                                      color: _profileController
                                                  .profile.accountType !=
                                              'EXPERIENCES'
                                          ? _profileController.localBar.value ==
                                                  3
                                              ? colorGreen
                                              : colorDarkGrey
                                          : _profileController.localBar.value ==
                                                  2
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
                        ),
                      ))),
    );
  }
}
