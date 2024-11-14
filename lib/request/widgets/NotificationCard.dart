import 'package:ajwad_v4/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:get/get.dart';

import '../../profile/controllers/profile_controller.dart';
import '../../profile/view/ticket_screen.dart';

class NotificationCrd extends StatelessWidget {
  const NotificationCrd({
    Key? key,
    this.name = '',
    this.FamilyName = '',
    this.isHost = false,
    this.isTour = false,
    this.isAdve = false,
    required this.isRtl,
    required this.width,
    required this.days,
    this.days2 = '',
    required this.isDisabled,
    required this.onCancel,
    required this.onDismissed,
    required this.isViewed,
  }) : super(key: key);
  final String name;
  final double width;
  final bool isRtl;
  final String days;
  final String days2;
  final bool isDisabled;
  final VoidCallback onCancel;
  final VoidCallback onDismissed;
  final bool isViewed;
  final FamilyName;
  final bool isHost;
  final bool isTour;
  final bool isAdve;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: AppUtil.rtlDirection2(context)
            ? DismissDirection.startToEnd
            : DismissDirection.endToStart, // Swipe right to left
        onDismissed: (direction) {
          onDismissed();
        },
        child: isDisabled
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  ProfileController profileController =
                      Get.put(ProfileController());
                  Get.to(
                      () => TicketScreen(profileController: profileController));
                },
                child: Column(
                  children: [
                    Container(
                      height: 89,
                      decoration: BoxDecoration(
                        color:
                            isViewed ? Colors.white : const Color(0xFFECF9F1),
                        border: const Border(
                          left: BorderSide(color: Color(0xFFECECEE)),
                          top: BorderSide(color: Color(0xFFECECEE)),
                          right: BorderSide(color: Color(0xFFECECEE)),
                          bottom:
                              BorderSide(width: 1, color: Color(0xFFECECEE)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          crossAxisAlignment: isRtl
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/icons/bell.svg'),
                            const SizedBox(width: 13),
                            SizedBox(
                              width: width * 0.48,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: isTour
                                        ? isRtl
                                            ? " جولتك القادمة الى  "
                                            : 'Your next tour to '
                                        : isHost
                                            ? isRtl
                                                ? " استضافتك القادمة في "
                                                : "Your next host in "
                                            : isAdve
                                                ? isRtl
                                                    ? " نشاطك القادمه إلى "
                                                    : "Your next activity "
                                                : isRtl
                                                    ? " فعاليتك القادمة إلى "
                                                    : "Your next event ",
                                    style: TextStyle(
                                      fontFamily:
                                          isRtl ? 'SF Arabic' : 'SF Pro',
                                      fontSize: 13,
                                      fontWeight: isRtl
                                          ? FontWeight.w500
                                          : FontWeight.w500,
                                      color: isRtl ? black : black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: name,
                                    style: TextStyle(
                                      fontFamily:
                                          isRtl ? 'SF Arabic' : 'SF Pro',
                                      fontSize: 13,
                                      fontWeight: isRtl
                                          ? FontWeight.w500
                                          : FontWeight.w500,
                                      color: colorGreen,
                                    ),
                                  ),
                                  TextSpan(
                                    text: days,
                                    style: TextStyle(
                                      fontFamily:
                                          isRtl ? 'SF Arabic' : 'SF Pro',
                                      fontSize: 13,
                                      fontWeight: isRtl
                                          ? FontWeight.w500
                                          : FontWeight.w500,
                                      color: black,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            // IconButton(
                            //   onPressed: onCancel,
                            //   icon: const Icon(
                            //     Icons.cancel,
                            //     color: Colors.red,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    )
                  ],
                ),
              ));
  }
}
