import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/timer_controller.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingTimer extends StatefulWidget {
  const FloatingTimer({super.key});

  @override
  State<FloatingTimer> createState() => _FloatingTimerState();
}

class _FloatingTimerState extends State<FloatingTimer>
    with WidgetsBindingObserver {
  final _timerController = Get.put(TimerController(), permanent: true);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is going to the background
      log('App is paused');
      // Save state here
    } else if (state == AppLifecycleState.resumed) {
      // App is coming to the foreground
      log('App is resumed');
      // Restore state here
    } else if (state == AppLifecycleState.detached) {
      // App is detached
      log('App is detached');
      // Perform cleanup if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width * 0.11,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.256,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(199, 199, 199, 0.25), blurRadius: 15)
          ],
          borderRadius: BorderRadius.circular(33),
        ),
        child: Obx(
          () => CustomText(
            text: _timerController.time.value,
            color: colorGreen,
            fontSize: MediaQuery.of(context).size.width * 0.041,
            fontFamily: 'SF Pro',
          ),
        ));
  }
}
