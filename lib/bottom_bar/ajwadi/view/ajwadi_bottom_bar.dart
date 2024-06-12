import 'package:ajwad_v4/explore/ajwadi/view/ajwadi_map_screen.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/view/add_hospatility_info.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/new_request_screen.dart';
import 'package:ajwad_v4/request/ajwadi/view/request_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/profle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../explore/ajwadi/view/hoapatility/widget/buttomProgress.dart';
import '../../../explore/ajwadi/view/local_home_screen.dart';

class AjwadiBottomBar extends StatefulWidget {
  const AjwadiBottomBar({Key? key}) : super(key: key);

  @override
  State<AjwadiBottomBar> createState() => _AjwadiBottomBarState();
}

final ProfileController _profileController = ProfileController();

int currentIndex = 0;
List bottomScreens = [
  // AjwadiMapScreen(
  //   fromAjwady: true,
  // ),
 LocalHomeScreen(fromAjwady: true,profileController: _profileController),
 const RequestScreen(),
  ButtomProgress(),

//  AddHospatilityInfo(),

  AjwadiMapScreen(
    fromAjwady: true,
  ),
  const NewRequestScreen(),
  const RequestScreen(),
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
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          enableFeedback: false,
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: colorDarkGrey,
          selectedItemColor: colorGreen,
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            fontFamily: 'Kufam',
            color: purple,
          ),
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            fontFamily: 'Kufam',
            color: darkBlack,
          ),
          items: [
            BottomNavigationBarItem(
                label: "home".tr,
                icon: SvgPicture.asset(
                  "assets/icons/request_icon.svg",
                  color: currentIndex == 0 ? colorGreen : colorDarkGrey,
                )),
            BottomNavigationBarItem(
                label: "request".tr,
                icon: SvgPicture.asset(
                  "assets/icons/my_request_green.svg",
                  color: currentIndex == 1 ? colorGreen : colorDarkGrey,
                )),
            BottomNavigationBarItem(
                label: "MyExperiences".tr,
                icon: SvgPicture.asset(
                  "assets/icons/my_experiences.svg",
                  color: currentIndex == 2 ? colorGreen : colorDarkGrey,
                )),
            BottomNavigationBarItem(
                label: "profile".tr,
                icon: SvgPicture.asset(
                  "assets/icons/my_profile_green.svg",
                  color: currentIndex == 3 ? colorGreen : colorDarkGrey,
                )),
          ],
          onTap: (int newIndex) {
            setState(() {
              currentIndex = newIndex;
            });
          },
        ));
  }
}
