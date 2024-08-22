import 'dart:async';

import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TimerController extends GetxController {
  Timer? _timer;
  int remainingSeconds = 1;
  final time = '45.00'.obs;
  @override
  void onReady() {
    _startTimer(2700);
    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    final _profileController = Get.put(ProfileController());
    _profileController.enableSignOut(false);
    remainingSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) async {
      if (remainingSeconds == 0) {
        timer.cancel();
        // final offerController = Get.put(OfferController());
        //  if (offerController.offers.isEmpty) {
        // await Get.dialog(Dialog(
        //   backgroundColor: Colors.white,
        //   surfaceTintColor: Colors.white,
        //   shape: const RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(8.0))),
        //   child: Padding(
        //     padding: const EdgeInsets.all(24),
        //     child: SizedBox(
        //       width: 370,
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           SvgPicture.asset('assets/icons/cancel_icon.svg'),
        //           SizedBox(
        //             height: 8,
        //           ),
        //           CustomText(
        //             text: "unfortunately".tr,
        //             fontSize: 15,
        //             fontFamily: "SF Pro",
        //             fontWeight: FontWeight.w500,
        //           ),
        //           CustomText(
        //             textAlign: TextAlign.center,
        //             text: 'timerDialogContent'.tr,
        //             fontSize: 15,
        //             fontFamily: "SF Pro",
        //             fontWeight: FontWeight.w400,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // )).then((val) async {
        //   await Get.delete<TimerController>(force: true);
        //   Get.offAll(() => const TouristBottomBar());
        //   _profileController.enableSignOut(true);
        // });
        //   } else {
        //   await Get.dialog(Dialog(
        //     backgroundColor: Colors.white,
        //     surfaceTintColor: Colors.white,
        //     shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(8.0))),
        //     child: Padding(
        //       padding: const EdgeInsets.all(24),
        //       child: SizedBox(
        //         width: 370,
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             SvgPicture.asset('assets/icons/cancel_icon.svg'),
        //             SizedBox(
        //               height: 8,
        //             ),
        //             CustomText(
        //               text: "requestTimedOut".tr,
        //               fontSize: 15,
        //               fontFamily: "SF Pro",
        //               fontWeight: FontWeight.w500,
        //             ),
        //             CustomText(
        //               textAlign: TextAlign.center,
        //               text: 'contentTimedOut'.tr,
        //               fontSize: 15,
        //               fontFamily: "SF Pro",
        //               fontWeight: FontWeight.w400,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   )).then((val) async {
        //     await Get.delete<TimerController>(force: true);
        //     _profileController.enableSignOut(true);
        // //    Get.offAll(() => const TouristBottomBar());
        //   });
        // }
      } else {
        int minutes = remainingSeconds ~/ 60;
        int seconds = (remainingSeconds % 60);
        time.value =
            "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        remainingSeconds--;
      }
    });
  }
}
