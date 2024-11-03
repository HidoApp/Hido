import 'package:ajwad_v4/notification/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var isSendingDeviceToken = false.obs;

  Future<bool> sendDeviceToken({required BuildContext context}) async {
    try {
      isSendingDeviceToken(true);
      final isSucces =
          await NotificationServices.sendDeviceToken(context: context);
      return isSucces;
    } catch (e) {
      isSendingDeviceToken(false);
      return false;
    } finally {
      isSendingDeviceToken(false);
    }
  }
}
