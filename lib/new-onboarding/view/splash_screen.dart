import 'dart:async';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/onboarding_try.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:workmanager/workmanager.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Future showNotification() async {

// }
// void callbackDispatcher() {
//   AwesomeNotifications().createNotification(
// content: NotificationContent(
//   id:1,
//   channelKey: 'key',
//   title:"test",
//   body: "test body",

//   ),
//   schedule: NotificationCalendar.fromDate(date: DateTime.now().add(Duration(seconds:1)))

//   );

// Workmanager().executeTask((task, inputData) {
//   showNotification();
//   return Future.value(true);
// });
//}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final _authController = Get.put(AuthController());

  final _getStorage = GetStorage();
  var onBoarding;
  late dynamic userRole;
  late dynamic token;

  late AnimationController _controller;
  late Animation<double> _anim;

  Future<String?> checkForBoarding() async {
    dynamic onBoarding = await _getStorage.read('onBoarding') ?? '';
    print('onBoarding  onBoarding $onBoarding');
    userRole = _getStorage.read('userRole') ?? '';
    token = _getStorage.read('accessToken') ?? '';
    token = _getStorage.read('accessToken') ?? '';

    Animatable<Color> bgColor = RainbowColorTween([
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.red,
    ]);

    // build a rainbow spectrum that blends across the same numerical domain

    // print('onBoarding $onBoarding');
    if (onBoarding == 'yes') {
      return onBoarding;
    } else {
      return null;
    }
  }

  Animatable<double> bgValue = Tween<double>(begin: 0.0, end: 3.0);
  Rainbow rb = Rainbow(rangeStart: 0.0, rangeEnd: 3.0, spectrum: [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.red,
  ]);
  @override
  void initState() {
    // TODO: implement initStateÅ
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )
      ..forward()
      ..repeat();
    _anim = bgValue.animate(_controller);

    //      print('onBoarding $onBoarding');
    Future.delayed(const Duration(seconds: 5), () async {
      onBoarding = await checkForBoarding() ?? 'no';
      _controller.dispose();
      print('onBoarding onBoarding onBoarding $onBoarding');
      if (onBoarding == 'yes' && token != '' && userRole == 'local') {
        if (JwtDecoder.isExpired(token)) {
          final String refreshToken = _getStorage.read('refreshToken');
          var user = await _authController.refreshToken(
              refreshToken: refreshToken, context: context);
          if (user != null) {
            token = user.accessToken;
          }
        }

        Get.off(() => AjwadiBottomBar());
      } else if (onBoarding == 'yes' && token != '' && userRole == 'tourist') {
        if (JwtDecoder.isExpired(token)) {
          final String refreshToken = _getStorage.read('refreshToken');
          var user = await _authController.refreshToken(
              refreshToken: refreshToken, context: context);
          if (user != null) {
            token = user.accessToken;
          }
        }

        Get.off(() => TouristBottomBar());
      } else if (onBoarding == 'yes') {
        Get.off(() => const AccountTypeScreen());
      } else {
        Get.off(() => const AccountTypeScreen());
      }
    });

    //   Workmanager().initialize(
    //   callbackDispatcher,
    //   isInDebugMode: false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Container(
          alignment: Alignment.center,
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SvgPicture.asset(
                  'assets/icons/splash_hido_logo.svg',
                  height: 108,
                  width: 170,
                  fit: BoxFit.scaleDown,
                  color: rb[_anim.value],
                );
              })),
      //  child: Image.asset('assets/images/splash.gif'),
    );
  }
}
