import 'dart:developer';

import 'package:ajwad_v4/explore/ajwadi/model/wallet.dart';
import 'package:ajwad_v4/notification.dart';
import 'package:ajwad_v4/notificationServices.dart';
import 'package:ajwad_v4/payment/model/coupon.dart';
import 'package:ajwad_v4/payment/model/credit_card.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/model/payment_result.dart';
import 'package:ajwad_v4/payment/service/coupon_service.dart';

import 'package:ajwad_v4/payment/service/payment_service.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notidicationcontroller extends GetxController {

  var isNotificationLoading = false.obs;
  var notifications = Notifications().obs;  

 
 
  Future<Notifications?> getNotifications({
    required BuildContext context,
    int? offset, int? limit
    
  } ) async {
    try {
      isNotificationLoading(true);
      final data =
          await NotificationServices.getNotifications(context: context,offset: offset,limit: limit);
       if (data != null) {
      return notifications(data);  // Update the observable wallet with fetched data
      }
    } catch (e) {
       isNotificationLoading(false);
       log(e.toString());
      return null;
    } finally {
      isNotificationLoading(false);
    }
  }

 
}
