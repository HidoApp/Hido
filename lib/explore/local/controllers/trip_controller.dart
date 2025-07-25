import 'dart:developer';

import 'package:ajwad_v4/explore/local/model/last_activity.dart';
import 'package:ajwad_v4/explore/local/model/local_trip.dart';
import 'package:ajwad_v4/explore/local/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  var isPastTicketLoading = false.obs;
  var isUpcommingTicketLoading = false.obs;
  var isChatLoading = false.obs;
  Rx<bool> isTripFinallyEnd = false.obs;
  Rx<bool> isTripEnd = false.obs;

  var upcommingTicket = <LocalTrip>[].obs;
  var pastTicket = <LocalTrip>[].obs;
  var nextTrip = NextActivity().obs;
  var updatedActivity = NextActivity().obs;
  Rx<String> nextStep = 'PENDING'.obs;
  Rx<double> progress = 0.1.obs;
  Rx<bool> isTripOnWay = false.obs;
  Rx<bool> isTripUpdated = false.obs;

  Future<List<LocalTrip>?> getUpcommingTicket({
    required BuildContext context,
  }) async {
    try {
      isUpcommingTicketLoading(true);

      final data = await TripService.getUserTicket(
        tourType: 'UPCOMING',
        context: context,
      );
      if (data != null) {
        upcommingTicket(data);

        //
        return upcommingTicket;
      } else {
        return null;
      }
    } catch (e) {
      isUpcommingTicketLoading(false);

      return null;
    } finally {
      isUpcommingTicketLoading(false);
    }
  }

  Future<List<LocalTrip>?> getPastTicket({
    required BuildContext context,
  }) async {
    try {
      isPastTicketLoading(true);

      final data = await TripService.getUserTicket(
        tourType: 'PAST',
        context: context,
      );

      if (data != null) {
        pastTicket(data);
        return pastTicket;
      } else {
        return null;
      }
    } catch (e) {
      isPastTicketLoading(false);

      return null;
    } finally {
      isPastTicketLoading(false);
    }
  }

  var isNextActivityLoading = false.obs;

  Future<NextActivity?> getNextActivity({
    required BuildContext context,
  }) async {
    try {
      isNextActivityLoading(true);
      var next = await TripService.getNextActivity(context: context);

      if (next != null) {
        log('data not equal null');

        isTripUpdated(true);
        return nextTrip(next);
      } else {
        log('data equal null');

        isTripUpdated(false);
        return null;
        // return  nextTrip(next);
      }
    } catch (e) {
      isNextActivityLoading(false);

      return null;
    } finally {
      isNextActivityLoading(false);
    }
  }

  var isActivityProgressLoading = false.obs;
  Future<NextActivity?> updateActivity({
    required String id,
    required BuildContext context,
  }) async {
    try {
      isActivityProgressLoading(true);

      final data = await TripService.updateActivity(id: id, context: context);
      if (data != null) {
        log('data not equal null2');
        log(data.id ?? '');
        isTripUpdated(true);
        return updatedActivity(data);
      } else {
        log('data equal null2');

        isTripUpdated(false);
        return updatedActivity(data);
      }
    } catch (e) {
      isActivityProgressLoading(false);
      return null;
    } finally {
      isActivityProgressLoading(false);
    }
  }
}
