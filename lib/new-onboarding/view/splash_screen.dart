import 'dart:async';
import 'dart:math';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
import 'package:ajwad_v4/widgets/verion_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
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
  var resume = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Set the desired duration here
    )..forward();

    userRole = getStorage.read('userRole') ?? '';
    token = getStorage.read('accessToken') ?? '';
    if (!resume) {
      return;
    }
    Future.delayed(const Duration(seconds: 5), () async {
      //  onBoarding = await checkForBoarding() ?? 'no';
      // _controller.dispose();
      if (!mounted) return;

      if (token != '' && userRole == 'local') {
        if (JwtDecoder.isExpired(token)) {
          final String refreshToken = getStorage.read('refreshToken');
          var user = await _authController.refreshToken(
              refreshToken: refreshToken, context: context);
          if (user != null) {
            token = user.accessToken;
          }
        }
        if (!mounted) return; // Check if the widget is still mounted
        _authController.checkLocalWhenSignIn(context);
      } else if (token != '' && userRole == 'tourist') {
        if (JwtDecoder.isExpired(token)) {
          final String refreshToken = getStorage.read('refreshToken');
          //
          var user = await _authController.refreshToken(
              refreshToken: refreshToken, context: context);
          if (user != null) {
            token = user.accessToken;
          }
        }
        Get.off(() => const TouristBottomBar());
      } else {
        Get.off(() => const OnboardingScreen(), transition: Transition.fade);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            'assets/splashScreen.json',
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
              _controller.forward();
            },
            key: Key('${Random().nextInt(999999999)}'),
            fit: BoxFit.cover, // Ensures the animation covers the screen
            width:
                MediaQuery.of(context).size.width, // Set width to screen width
            height: MediaQuery.of(context).size.height, //
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error: $error');
              debugPrint('StackTrace: $stackTrace');
              return const Text(
                'Failed to load animation',
                style: TextStyle(color: Colors.red),
              );
            },
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.width * 0.102,
            left: MediaQuery.of(context).size.width * 0.397,
            // right: MediaQuery.of(context).size.width / 2,
            child: const Center(
              child: VersionText(
                fromSplash: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
