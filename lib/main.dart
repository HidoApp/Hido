import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'localization/locale_string.dart';
import 'package:ajwad_v4/request/local_notification.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:background_fetch/background_fetch.dart';

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  // Initialize GetStorage
  await GetStorage.init();
  // Get the timer state from GetStorage
  final storage = GetStorage();
  int remainingSeconds = storage.read('remainingSeconds') ?? 2700;
  // Decrement remaining seconds
  remainingSeconds--;
  // Save the new timer state
  storage.write('remainingSeconds', remainingSeconds);
  // Log the background fetch
  print("Background fetch task running, remainingSeconds: $remainingSeconds");

  BackgroundFetch.finish(task.taskId);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  await LocalNotification.init();
  timeago.setLocaleMessages('ar', timeago.ArMessages());

  // AwesomeNotifications().initialize(
  //   '',
  //   [
  //     NotificationChannel(
  //       channelKey: 'key',
  //       channelName: 'Channel Name',
  //       channelDescription: 'Channel Description',
  //       defaultColor: Color(0xFF9D50DD),
  //       ledColor: Colors.white,
  //     )
  //   ],
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

late String local;

class _MyAppState extends State<MyApp> {
  final _getStorage = GetStorage();
  late String token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = _getStorage.read('token') ?? '';
    print('token $token');
    print('${Platform.localeName.toLocale().languageCode}');

    local = Platform.localeName.toLocale().languageCode;
    //local = Platform.localeName.toLocale().languageCode;

    // print('${Platform.localeName.split('_').first}');
    // local = Platform.localeName.split('_').first.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15, // Adjust as needed
        stopOnTerminate: false,
        enableHeadless: true,
      ),
      (String taskId) async {
        // Your background task code
        print("Background fetch task running");

        // Here you can update your timer logic.
        // For example, you can update the timer value in storage.

        BackgroundFetch.finish(taskId);
      },
    );
    return GetMaterialApp(
      translations: LocaleString(),
      locale: local != "en" && local != "ar"
          ? const Locale('en', "US")
          : Locale(local, local),
      fallbackLocale: Locale(local),
      theme: ThemeData(
          fontFamily: 'HT Rakik',
          primaryColor: colorGreen,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          colorScheme: const ColorScheme.light(primary: colorGreen),
          useMaterial3: true),
      title: 'Ajwad',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      //  home: const CheckOutScreen(),
    );
  }
}
