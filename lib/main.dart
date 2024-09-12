import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/firebase_api.dart';
import 'package:ajwad_v4/firebase_options.dart';
import 'package:ajwad_v4/new-onboarding/view/splash_screen.dart';
import 'package:ajwad_v4/services/view/service_screen.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'localization/locale_string.dart';
import 'package:ajwad_v4/request/local_notification.dart';
import 'package:timeago/timeago.dart' as timeago;

final navigatorKey = GlobalKey<NavigatorState>();

// Initialize shared preferences
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);//new

  await GetStorage.init();
  await GetStorage.init('map_markers');
  await GetStorage.init('bookmark');

  await initializeDateFormatting('ar');
  await LocalNotification.init();
  
  //final Amplitude amplitude = Amplitude.getInstance(); 

  //amplitude.init("feb049885887051bb097ac7f73572f6c");
  timeago.setLocaleMessages('ar', timeago.ArMessages());


  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseApi().initNotifications();
    if (kReleaseMode) {
      await SentryFlutter.init(
        (options) {
          options.dsn =
              'https://f97b8c800c487e29da91161257eda1b3@o4507932979560448.ingest.us.sentry.io/4507932982312960';

          // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
          // We recommend adjusting this value in production.
          options.tracesSampleRate = 0.01;
        },
        appRunner: () => runApp(const MyApp()),
      );
    } else {
      runApp(const MyApp());
    }
  } catch (error) {
    print("Firebase initialization error: $error");
  }

  //runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;

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
        navigatorKey: navigatorKey,
        routes: {
          '/service_screen': (context) => const ServiceScreen(),
        },
        //  home: const CheckOutScreen(),
      ),
    );
  }
}
