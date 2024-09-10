import 'dart:developer';

import 'package:ajwad_v4/main.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await messaging.requestPermission(
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
    //final installationId = await FirebaseInstallations.instance.getId();

//final installationId= await FirebaseInstallations.instance.getId();
//   log('installationId:$id');
    log('Api-token:$fCMToken');
  //  log('installationId:$installationId');

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

      navigatorKey.currentState?.pushNamed(
        '/service_screen',
        arguments: message,
      );
    }
  }

// initilize background seeting
  Future initPushNotification() async {
    //handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

//listen to event if notification open
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

//when app open and recieve message
    FirebaseMessaging.onMessage.listen(handleMessage);

  }
}
