import 'dart:async';
import 'dart:math';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
import 'package:ajwad_v4/new-onboarding/view/onboarding_try.dart';
import 'package:ajwad_v4/new-onboarding/view/account_type_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
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
  final getStorage = GetStorage();
  late AnimationController _controller;
  var onBoarding;
  late dynamic userRole;
  late dynamic token;

  // Future<String?> checkForBoarding() async {
  //   dynamic onBoarding = await _getStorage.read('onBoarding') ?? '';
  //   print('onBoarding  onBoarding $onBoarding');

  //   token = _getStorage.read('accessToken') ?? '';

  //   if (onBoarding == 'yes') {
  //     return onBoarding;
  //   } else {
  //     return null;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    print(userRole = getStorage.read('userRole') ?? 'NULL ROLE');
    print(userRole = getStorage.read('accessToken') ?? 'NULL ');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Set the desired duration here
    )..forward();
    userRole = getStorage.read('userRole') ?? '';
    token = getStorage.read('accessToken') ?? '';
    Future.delayed(const Duration(seconds: 5), () async {
      //  onBoarding = await checkForBoarding() ?? 'no';
      _controller.dispose();
      if (token != '' && userRole == 'local') {
        if (JwtDecoder.isExpired(token)) {
          final String refreshToken = getStorage.read('refreshToken');
          var user = await _authController.refreshToken(
              refreshToken: refreshToken, context: context);
          if (user != null) {
            token = user.accessToken;
          }
          print('token $token');
        }

        Get.off(() => const AjwadiBottomBar());
      } else if (token != '' && userRole == 'tourist') {
        if (JwtDecoder.isExpired(token)) {
          final String refreshToken = getStorage.read('refreshToken');
          // print('HEeree');
          var user = await _authController.refreshToken(
              refreshToken: refreshToken, context: context);
          if (user != null) {
            token = user.accessToken;
            print('token $token');
          }
        }

        Get.off(() => const TouristBottomBar());
      } else {
        Get.off(() => const OnboardingScreen(), transition: Transition.fade);
      }
    });
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: Stack(
        children: [
          Center(
            child: Lottie.asset(
              'assets/splash_screen_new.json',
              controller: _controller,
              onLoaded: (composition) {
                _controller.duration = composition.duration;
                _controller.forward();
              },
              key: Key('${Random().nextInt(999999999)}'),
              width: 600,
              alignment: Alignment.center,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                  'Failed to load animation',
                  style: TextStyle(color: Colors.red),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
