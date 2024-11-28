import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/firebase_api.dart';
import 'package:ajwad_v4/firebase_options.dart';
import 'package:ajwad_v4/new-onboarding/view/splash_screen.dart';
import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/notification/customBadge.dart';
import 'package:ajwad_v4/notification/notifications_screen.dart';
import 'package:ajwad_v4/share/services/share_services.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/error_screen_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'localization/locale_string.dart';
import 'package:ajwad_v4/request/local_notification.dart';
import 'package:timeago/timeago.dart' as timeago;

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final String? locale = PlatformDispatcher.instance.locale.languageCode;
  log('WidgetsBinding Locale: $locale');
  final String platformLocale = Platform.localeName;
  log('Platform Locale: $platformLocale');

  // Determine Arabic based on both approaches
  final isArabic = (locale == 'ar') || platformLocale.startsWith('ar');
  log('Is Arabic: $isArabic');

  // Fetch localized notification details
  final title = isArabic
      ? message.data["title"] ?? message.notification?.title
      : message.notification?.title;
  final body = isArabic
      ? message.data["body"] ?? message.notification?.body
      : message.notification?.body;

  // Log the details for debugging
  log('Notification message background: $title, $body');

  // Display the notification
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel', // ID for the notification channel
    'High Importance Notifications', // Name of the channel
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.high,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID (unique)
    title, // Notification title
    body, // Notification body
    platformChannelSpecifics,
  );
  final _notifyController = Get.put(NotificationController());

  _notifyController.notifyCount.value = _notifyController.notifyCount.value + 1;
  log("hjkkk");
  log(_notifyController.notifyCount.value.toString());
}

// Initialize shared preferences
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);//new

  await GetStorage.init();
  await GetStorage.init('bookmark');

  await initializeDateFormatting('ar');
  await LocalNotification.init();

  //amplitude
  AmplitudeService.initializeAmplitude();

  timeago.setLocaleMessages('ar', timeago.ArMessages());

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    ShareServices.handleDynamicLinks();
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
    log('Error');
  }
  if (kReleaseMode) ErrorWidget.builder = (_) => const ErrorScreenWidget();
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

    local = GetStorage().read('language') ??
        Platform.localeName.toLocale().languageCode;
    log("AMMAR");
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: GetMaterialApp(
        localizationsDelegates: const [
          CountryLocalizations.delegate,
        ],
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
        title: 'Hido',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        navigatorKey: navigatorKey,
        routes: {
          //'/tourist_bottom_bar': (context) => const TouristBottomBar(),
          '/notification_screen': (context) => NotificationsScreen(),
        },
        //  home: const CheckOutScreen(),
      ),
    );
  }
}
