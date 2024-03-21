import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'localization/locale_string.dart';

void main() {
  runApp(
      // DevicePreview(
      //   enabled: false,
      //   builder: ((context) => MyApp() ))

      const MyApp());
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
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocaleString(),
      locale: Locale(local, local),
      fallbackLocale: Locale(local),
      theme: ThemeData(
          fontFamily: 'HT Rakik',
          primaryColor: colorGreen,
          colorScheme: ColorScheme.light(primary: colorGreen),
          useMaterial3: true),
      title: 'Ajwad',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      //  home: const CheckOutScreen(),
    );
  }
}
