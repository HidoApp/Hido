import 'package:ajwad_v4/notification/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:ajwad_v4/notification/notification.dart';

class NotificationController extends GetxController {
  var isSendingDeviceToken = false.obs;
  var isNotificationLoading = false.obs;
  var isNotificationUpdateLoading = false.obs;

  var notifications = <Notifications>[].obs;

  Future<List<Notifications>?> getNotifications({
    required BuildContext context,
  }) async {
    try {
      isNotificationLoading(true);
      final data =
          await NotificationServices.getNotifications(context: context);
      log("enter noty screen");
      if (data != null) {
        notifications(data);
        return notifications.value;
      } else {
        return null;
      }
    } catch (e) {
      isNotificationLoading(false);
      log(e.toString());
      return null;
    } finally {
      isNotificationLoading(false);
    }
  }

  Future<void> updateNotifications(
      {required BuildContext context,
      List<String>? unreadNotificationIds}) async {
    try {
      isNotificationUpdateLoading(true);
      final data = await NotificationServices.updateNotifications(
          context: context, unreadNotificationIds: unreadNotificationIds);
    } catch (e) {
      isNotificationUpdateLoading(false);
      log(e.toString());
      return null;
    } finally {
      isNotificationUpdateLoading(false);
    }
  }

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
