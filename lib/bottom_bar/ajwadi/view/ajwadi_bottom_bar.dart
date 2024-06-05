import 'package:ajwad_v4/explore/ajwadi/view/ajwadi_map_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/request_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/profle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
          currentIndex: currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: colorGreen,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          unselectedItemColor: dotGreyColor,
          selectedLabelStyle: const TextStyle(shadows: [
            Shadow(
                offset: Offset(0.0, 0.0), blurRadius: 10.0, color: colorGreen),
          ]),
          items: [
            BottomNavigationBarItem(
              
             label: "home".tr,
                icon: currentIndex == 0
                    ? Container(
                        child: SvgPicture.asset("assets/icons/select_request_icon.svg"),
                      )
                    : SvgPicture.asset("assets/icons/request_icon.svg",color: dotGreyColor,)),
            BottomNavigationBarItem(
                label: "request".tr,
                icon: currentIndex == 1
                   
                    ? SvgPicture.asset("assets/icons/my_request_green.svg")
                    : SvgPicture.asset("assets/icons/my_request_green.svg",color: dotGreyColor,)),
              BottomNavigationBarItem(
                  label: "MyExperiences".tr,
                   icon: currentIndex == 2
                    ? 
                      SvgPicture.asset("assets/icons/my_experiences_green.svg")
                    
                    : SvgPicture.asset("assets/icons/my_experiences.svg",color: colorGreen,)),
                     BottomNavigationBarItem(
                  label: "profile".tr,
                   icon: currentIndex == 3
                    ? 
                      SvgPicture.asset("assets/icons/my_profile.svg")
                    
                    : SvgPicture.asset("assets/icons/my_profile_green.svg",color: colorGreen,)),
         
          ],
          onTap: (int newIndex) {
            setState(() {
              currentIndex = newIndex;
            });
          },
        ));
  }
}
