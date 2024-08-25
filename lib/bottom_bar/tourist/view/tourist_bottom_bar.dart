import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/tourist_map_screen.dart';
import 'package:ajwad_v4/explore/widget/rating_sheet.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/profile/view/guest_sign_in.dart';
import 'package:ajwad_v4/profile/view/profle_screen.dart';
import 'package:ajwad_v4/services/view/service_screen.dart';
import 'package:ajwad_v4/shop/view/shop_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TouristBottomBar extends StatefulWidget {
  const TouristBottomBar({super.key});

  @override
  State<TouristBottomBar> createState() => _TouristBottomBarState();
}

class _TouristBottomBarState extends State<TouristBottomBar> {
  final _pageController = PageController();
  int _currentIndex = 0;
  final ProfileController _profileController = ProfileController();
  final getStorage = GetStorage();
  late Profile profile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (!AppUtil.isGuest()) {
      getProfile();
      getUserActions();
      _profileController.isUserOpenTheApp(true);
    }
  }

  void getProfile() async {
    await _profileController.getProfile(context: context);
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
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: BottomNavigationBar(
          elevation: 0,
          enableFeedback: false,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Color(0xFFB9B8C1),
          selectedItemColor: colorGreen,
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
          ),
          selectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontFamily: AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
            color: darkBlack,
          ),
          onTap: (index) {
            //   print(getStorage.read('accessToken'));
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(_currentIndex);
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                decoration: _currentIndex == 0
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [],
                      )
                    : const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: SvgPicture.asset(
                    'assets/icons/map_icon.svg',
                    color: _currentIndex == 0 ? colorGreen : Color(0xFFB9B8C1),
                  ),
                ),
              ),
              label: 'explore'.tr,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  'assets/icons/request_icon.svg',
                ),
              ),
              activeIcon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: SvgPicture.asset(
                    'assets/icons/select_request_icon.svg',
                    color: _currentIndex == 1 ? colorGreen : Color(0xFFB9B8C1),
                  ),
                ),
              ),
              label: 'services'.tr,
            ),
            // BottomNavigationBarItem(
            //   icon: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //       decoration: _currentIndex == 2
            //           ? BoxDecoration(
            //               borderRadius: BorderRadius.circular(20),
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: blue.withOpacity(0.2),
            //                   blurRadius: 5,
            //                   spreadRadius: 3,
            //                   offset: const Offset(0, 0), // Shadow position
            //                 ),
            //               ],
            //             )
            //           : const BoxDecoration(),
            //       child: SvgPicture.asset(
            //         'assets/icons/bag.svg',
            //         color: _currentIndex == 2 ? blue : colorDarkGrey,
            //       ),
            //     ),
            //   ),
            //   label: 'shop'.tr,
            // ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: _currentIndex == 3
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorGreen.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 3,
                            offset: const Offset(0, 0), // Shadow position
                          ),
                        ],
                      )
                    : const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: SvgPicture.asset(
                    'assets/icons/my_profile.svg',
                    color: _currentIndex == 2 ? colorGreen : Color(0xFFB9B8C1),
                  ),
                ),
              ),
              label: 'profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
