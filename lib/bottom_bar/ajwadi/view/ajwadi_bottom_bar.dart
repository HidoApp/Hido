import 'package:ajwad_v4/explore/ajwadi/view/ajwadi_map_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/new_request_screen.dart';
import 'package:ajwad_v4/request/ajwadi/view/request_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/profle_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
final isTourGuide = true;
int currentIndex = 0;
List bottomScreens = [
  LocalHomeScreen(fromAjwady: true, profileController: _profileController),
  if (isTourGuide) const NewRequestScreen(),
  //const RequestScreen(),
  const AddExperienceInfo(),
  ProfileScreen(
    fromAjwady: true,
    profileController: _profileController,
  ),
];

class _AjwadiBottomBarState extends State<AjwadiBottomBar>
    with SingleTickerProviderStateMixin {
  final _profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileController.getProfile(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: lightBlack,
          child: bottomScreens[currentIndex],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: BottomNavigationBar(
            elevation: 0,
            enableFeedback: false,
            backgroundColor: Colors.white,
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: colorDarkGrey,
            selectedItemColor: colorGreen,
            unselectedLabelStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              color: colorDarkGrey,
            ),
            selectedLabelStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              color: colorGreen,
            ),
            items: [
              BottomNavigationBarItem(
                  label: "home".tr,
                  icon: SvgPicture.asset(
                    "assets/icons/request_icon.svg",
                    color: currentIndex == 0 ? colorGreen : colorDarkGrey,
                  )),
              if (isTourGuide)
                BottomNavigationBarItem(
                    label: "request".tr,
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SvgPicture.asset(
                        "assets/icons/my_request_green.svg",
                        color: currentIndex == 1 ? colorGreen : colorDarkGrey,
                      ),
                    )),
              BottomNavigationBarItem(
                  label: "MyExperiences".tr,
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: SvgPicture.asset(
                      "assets/icons/my_experiences.svg",
                      color: isTourGuide
                          ? currentIndex == 2
                              ? colorGreen
                              : colorDarkGrey
                          : currentIndex == 1
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
                      color: isTourGuide
                          ? currentIndex == 3
                              ? colorGreen
                              : colorDarkGrey
                          : currentIndex == 2
                              ? colorGreen
                              : colorDarkGrey,
                    ),
                  )),
            ],
            onTap: (int newIndex) {
              setState(() {
                currentIndex = newIndex;
              });
            },
          ),
        ));
  }
}
