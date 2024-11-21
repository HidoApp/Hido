// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui';

// import 'package:ajwad_v4/main.dart';
// import 'package:ajwad_v4/notification/controller/notification_controller.dart';
// import 'package:ajwad_v4/utils/app_util.dart';
// import 'package:firebase_app_installations/firebase_app_installations.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// class FirebaseApi {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   // Declare the variable
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final _notifyController = Get.put(NotificationController());

//   Future<void> initNotifications() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     //fetch FCM token for this device
//     final fCMToken = await messaging.getToken();
//     // .then((token) {
//     //   print("FCM Token: $token");
//     // });
//     final installationId = await FirebaseInstallations.instance.getId();

//     // final installationId = await FirebaseInstallations.instance.getId();

//     // log('installationId:$id');
//     log('Api-token:$fCMToken');
//     log('installationId:$installationId');

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//     //For iOS
//     initPushNotification();
//     // if (Platform.isIOS) {
//     // }

//     // if (Platform.isAndroid) {
//     //   firebaseInit();
//     // }
//   }

//   // Firebase messaging initialization
//   void firebaseInit() {
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification!.android;

//       print("Notification title: ${notification!.title}");
//       print("Notification body: ${notification.body}");
//       print("Data: ${message.data.toString()}");

//       _notifyController.notifyCount.value =
//           _notifyController.notifyCount.value + 1;
//       log("h");
//       log(_notifyController.notifyCount.value.toString());
//       initLocalNotifications(message);
//       showNotification(message);
//       setupInteractMessage();
//     });
//   }

//   //handle received messages
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;

//     String? messageType =
//         message.data['type']; // Get the 'type' from the payload

//     // Navigate based on the type
//     if (messageType == 'KSA') {}
//     //navigate to new screen
//     if (!AppUtil.isGuest()) {
//       //         .then((_) {
//       //       // After the first route is pushed, push the second route
//       navigatorKey.currentState?.pushNamed(
//         '/another_route',
//         arguments: message,
//       );
//       //     });

//       // );
//     }
//     log('Received a message in the App open: ${message.data}');
//     _notifyController.notifyCount.value =
//         _notifyController.notifyCount.value + 1;
//     if (message.notification != null) {
//       log(// get arabic key
//           'Notification message also contained: ${message.notification!.title}, ${message.notification!.body}, ${message.data["title"]}, ${message.data["body"]}');
//       _showDialog(message.notification!.title, message.notification!.body,
//           message.data["title"], message.data["body"]);
//     }
//   }

//   //handle received messages
//   void handleOpenedMessage(RemoteMessage? message) {
//     if (message == null) return;

//     String? messageType =
//         message.data['type']; // Get the 'type' from the payload

//     navigatorKey.currentState?.pushNamed(
//       '/notification_screen',
//       arguments: message,
//     );
//     log('Received a message in the foreground: ${message.data}');
//   }

//   void handleClosedMessage(RemoteMessage? message) {
//     if (message == null) return;

//     String? messageType =
//         message.data['type']; // Get the 'type' from the payload

//     log('Received a message in the background: ${message.data}');

//     if (message.notification != null) {
//       log(// get arabic key
//           'Notification message also contained: ${message.notification!.title}, ${message.notification!.body}, ${message.data["title"]}, ${message.data["body"]}');
//     }
//   }

// // initilize background seeting
//   Future initPushNotification() async {
//     //handle notification if the app was terminated and now opened
//     FirebaseMessaging.instance.getInitialMessage().then(handleClosedMessage);

// //listen to event if notification open
//     FirebaseMessaging.onMessageOpenedApp.listen(handleOpenedMessage);

// //when app open and recieve message
//     FirebaseMessaging.onMessage.listen(handleMessage);
//   }

//   void _showDialog(
//       String? titleEn, String? bodyEn, String? titleAr, String? bodyAr) {
//     final context =
//         navigatorKey.currentContext; // Get context from navigatorKey
//     if (context == null) return; // Check if context is null

//     AppUtil.notifyToast(
//       context,
//       titleAr,
//       bodyAr,
//       titleEn,
//       bodyEn,
//       () {
//         navigatorKey.currentState?.pushNamed(
//           '/notification_screen',
//           arguments: {
//             'title':
//                 titleEn, // Assuming you meant to use `titleEn` and `bodyEn`
//             'body': bodyEn,
//           },
//         );
//       },
//     );
//   }

//   // Initialize local notifications
//   void initLocalNotifications(RemoteMessage message) async {
//     var androidInitSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitSettings = const DarwinInitializationSettings();

//     var initSettings = InitializationSettings(
//         android: androidInitSettings, iOS: iosInitSettings);

//     await _flutterLocalNotificationsPlugin.initialize(initSettings,
//         onDidReceiveNotificationResponse: (payload) {
//       handleMesssage(payload);
//     });
//   }

//   // Handle the message when notification is tapped
//   void handleMesssage(NotificationResponse payload) {
//     navigatorKey.currentState?.pushNamed(
//       '/notification_screen',
//     );
//     print('In handleMesssage function');
//     if (payload.payload != null) {}
//   }

//   // Show notification on Android/iOS
//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel androidNotificationChannel =
//         AndroidNotificationChannel(
//       message.notification!.android!.channelId.toString(),
//       message.notification!.android!.channelId.toString(),
//       importance: Importance.high,
//       showBadge: true,
//       playSound: true,
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       androidNotificationChannel.id.toString(),
//       androidNotificationChannel.name.toString(),
//       channelDescription: 'Flutter Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       ticker: 'ticker',
//       sound: androidNotificationChannel.sound,
//     );

//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: darwinNotificationDetails,
//     );

//     final String? locale = PlatformDispatcher.instance.locale.languageCode;
//     final String platformLocale = Platform.localeName;
//     final isArabic = (locale == 'ar') || platformLocale.startsWith('ar');
//     log('Is Arabic: $isArabic');

//     final title = isArabic
//         ? message.data["title"] ?? message.notification?.title
//         : message.notification?.title;
//     final body = isArabic
//         ? message.data["body"] ?? message.notification?.body
//         : message.notification?.body;

//     log('Notification message background: $title, $body');

//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//           0, title, body, notificationDetails);
//     });
//   }

//   // Handle initial message when app is terminated
//   Future<void> setupInteractMessage() async {
//     // When app is terminated
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     if (initialMessage != null) {
//       FirebaseMessaging.instance.getInitialMessage().then(handleClosedMessage);
//     }

//     FirebaseMessaging.onMessageOpenedApp.listen(handleOpenedMessage);
//   }
// }
import 'dart:developer';

import 'package:ajwad_v4/main.dart';
import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FirebaseApi {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final _notifyController = Get.put(NotificationController());

  Future<void> initNotifications() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    //fetch FCM token for this device
    final fCMToken = await messaging.getToken();
    // .then((token) {
    //   print("FCM Token: $token");
    // });
    final installationId = await FirebaseInstallations.instance.getId();

    // final installationId = await FirebaseInstallations.instance.getId();

    // log('installationId:$id');
    log('Api-token:$fCMToken');
    log('installationId:$installationId');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    initPushNotification();
  }

  //handle received messages
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    String? messageType =
        message.data['type']; // Get the 'type' from the payload

    // Navigate based on the type
    if (messageType == 'KSA') {
      //navigate to new screen
      if (!AppUtil.isGuest()) {
        // navigatorKey.currentState?.pushNamed(
        //   '/service_screen',
        //   arguments: message,
        // );
        navigatorKey.currentState?.pushNamed(
          '/notification_screen',
          arguments: message,
        );
      }
      //         .then((_) {
      //       // After the first route is pushed, push the second route
      //       navigatorKey.currentState?.pushNamed(
      //         '/another_route',
      //         arguments: message,
      //       );
      //     });
    }
    // );

    log('Received a message in the App open: ${message.data}');
    _notifyController.notifyCount.value =
        _notifyController.notifyCount.value + 1;
    if (message.notification != null) {
      log(// get arabic key
          'Notification message also contained: ${message.notification!.title}, ${message.notification!.body}, ${message.data["title"]}, ${message.data["body"]}');
      _showDialog(message.notification!.title, message.notification!.body,
          message.data["title"], message.data["body"]);
    }
  }

  //handle received messages
  void handleOpenedMessage(RemoteMessage? message) {
    if (message == null) return;

    String? messageType =
        message.data['type']; // Get the 'type' from the payload

    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
    log('Received a message in the foreground: ${message.data}');
  }

  void handleClosedMessage(RemoteMessage? message) {
    if (message == null) return;

    String? messageType =
        message.data['type']; // Get the 'type' from the payload

    log('Received a message in the background: ${message.data}');

    if (message.notification != null) {
      log(// get arabic key
          'Notification message also contained: ${message.notification!.title}, ${message.notification!.body}, ${message.data["title"]}, ${message.data["body"]}');
    }
  }

// initilize background seeting
  Future initPushNotification() async {
    //handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleClosedMessage);

//listen to event if notification open
    FirebaseMessaging.onMessageOpenedApp.listen(handleOpenedMessage);

//when app open and recieve message
    FirebaseMessaging.onMessage.listen(handleMessage);
  }

  void _showDialog(
      String? titleEn, String? bodyEn, String? titleAr, String? bodyAr) {
    final context =
        navigatorKey.currentContext; // Get context from navigatorKey
    if (context == null) return; // Check if context is null

    AppUtil.notifyToast(
      context,
      titleAr,
      bodyAr,
      titleEn,
      bodyEn,
      () {
        navigatorKey.currentState?.pushNamed(
          '/notification_screen',
          arguments: {
            'title':
                titleEn, // Assuming you meant to use `titleEn` and `bodyEn`
            'body': bodyEn,
          },
        );
      },
    );
  }
}
