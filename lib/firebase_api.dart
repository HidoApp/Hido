import 'dart:developer';

import 'package:ajwad_v4/main.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

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
