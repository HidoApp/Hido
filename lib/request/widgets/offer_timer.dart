
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OfferTimer extends StatefulWidget {
  const OfferTimer({super.key});

  @override
  State<OfferTimer> createState() => _OfferTimerState();
}

class _OfferTimerState extends State<OfferTimer> {
  final _controller = CountdownController(autoStart: true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Countdown(
      seconds: 20,
      controller: _controller,
      build: (BuildContext context, double time) => CustomText(
        text: AppUtil.countdwonFormat(time),
        color: colorGreen,
      ),
      interval: const Duration(seconds: 1),
      onFinished: () {
        Get.offAll(() => const TouristBottomBar());
      },
    );
  }
}
