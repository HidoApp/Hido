import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'localization/locale_string.dart';
import 'package:ajwad_v4/request/local_notification.dart';
import 'package:timeago/timeago.dart' as timeago;

// Initialize shared preferences
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await GetStorage.init('map_markers');
  await GetStorage.init('bookmark');

  await initializeDateFormatting('ar');
  await LocalNotification.init();
  timeago.setLocaleMessages('ar', timeago.ArMessages());
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
    token = _getStorage.read('accessToken') ?? '';
    log('token $token');
    print('${Platform.localeName.toLocale().languageCode}');

    local = Platform.localeName.toLocale().languageCode;
    //local = Platform.localeName.toLocale().languageCode;

    // print('${Platform.localeName.split('_').first}');
    // local = Platform.localeName.split('_').first.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: GetMaterialApp(
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
      ),
    );
  }
}
