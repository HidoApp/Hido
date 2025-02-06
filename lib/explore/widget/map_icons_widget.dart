import 'dart:developer';

import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/notification/customBadge.dart';
import 'package:ajwad_v4/notification/notifications_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/messages_screen.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MapIconsWidget extends StatelessWidget {
  const MapIconsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _notifyController = Get.put(NotificationController());

    final width = MediaQuery.sizeOf(context).width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //ticket
        // Container(
        //   padding: EdgeInsets.all(width * 0.012),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(width * 0.04),
        //     ),
        //   ),
        //   child: GestureDetector(
        //       onTap: () {
        //         ProfileController profileController =
        //             Get.put(ProfileController());
        //         Get.to(() => AppUtil.isGuest()
        //             ? const SignInScreen()
        //             : TicketScreen(
        //                 profileController: profileController,
        //               ));
        //       },
        //       child: RepaintBoundary(
        //         child: SvgPicture.asset(
        //           'assets/icons/ticket_icon.svg',
        //           color: colorGreen,
        //         ),
        //       )),
        // ),
        // SizedBox(
        //   width: width * 0.030,
        // ),
        Container(
          padding: EdgeInsets.all(width * 0.0128),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(width * 0.04),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              ProfileController profileController0 =
                  Get.put(ProfileController());
              Get.to(() => AppUtil.isGuest()
                  ? const SignInScreen()
                  : MessagesScreen(profileController: profileController0));
            },
            child: SvgPicture.asset(
              'assets/icons/Communication.svg',
              color: colorGreen,
            ),
          ),
        ),
        SizedBox(
          width: width * 0.030,
        ),
        Container(
          padding: EdgeInsets.all(width * 0.0128),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(width * 0.04),
            ),
          ),
          child: CustomBadge(
            onTap: () {
              Get.to(
                () => AppUtil.isGuest()
                    ? const SignInScreen()
                    : NotificationsScreen(),
              );
              log(_notifyController.notifyCount.value.toString());
              _notifyController.notifyCount.value = 0;
            },
            iconPath: 'assets/icons/Alerts.svg',
            iconColor: colorGreen,
            badgeCount: _notifyController.notifyCount,
            badgeColor: Colors.red,
            width: 24,
            top: 2,
            end: 3,
            height: 24,
          ),

          //  GestureDetector(
          //     onTap: () => Get.to(
          //           () => AppUtil.isGuest()
          //               ? const SignInScreen()
          //               : NotificationsScreen(),
          //         ),
          //     child: RepaintBoundary(
          //       child: SvgPicture.asset(
          //         'assets/icons/Alerts.svg',
          //         color: colorGreen,
          //       ),
          //     )),
        ),
        SizedBox(
          width: width * 0.030,
        ),
      ],
    );
  }
}
