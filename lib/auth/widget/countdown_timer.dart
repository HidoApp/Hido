import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key, required this.resendOtp});
  final void Function() resendOtp;
  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  final _controller = CountdownController(autoStart: true);

  @override
  Widget build(BuildContext context) {
    return Countdown(
      seconds: 300,
      controller: _controller,
      build: (BuildContext context, double time) => GestureDetector(
        onTap: () {
          if (time == 0) {
            widget.resendOtp();
            _controller.restart();
          }
        },
        child: CustomText(
          text: time == 0 ? 'resendCode'.tr : AppUtil.countdwonFormat(time),
          color: colorGreen,
        ),
      ),
      interval: const Duration(seconds: 1),
      onFinished: () {},
    );
  }
}
