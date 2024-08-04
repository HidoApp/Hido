import 'package:ajwad_v4/explore/ajwadi/model/last_activity.dart';
import 'package:ajwad_v4/explore/ajwadi/model/local_trip.dart';
import 'package:ajwad_v4/explore/ajwadi/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TripController extends GetxController {
  var isPastTicketLoading = false.obs;
  var isUpcommingTicketLoading = false.obs;
  var isChatLoading = false.obs;
  var upcommingTicket = <LocalTrip>[].obs;
  var pastTicket = <LocalTrip>[].obs;
  NextActivity? nextTrip = NextActivity();
  var updatedActivity= NextActivity();
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
        print("object controller");
        print(data.length);
        //print(upcommingTicket.first.place?.nameAr);
        return upcommingTicket;
      } else {
        return null;
      }
    } catch (e) {
      isUpcommingTicketLoading(false);
      print(e);
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
      print("this pas 1ticket");

      if (data != null) {
        print("this pas ticket");
        pastTicket(data);
        return pastTicket;
      } else {
        return null;
      }
    } catch (e) {
      isPastTicketLoading(false);
      print(e);
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
      print("TRUE");

      isNextActivityLoading(true);
      nextTrip = (await TripService.getNextActivity(context: context));

    
      print('this trip data');
         return nextTrip;
     
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
        return data;
    
    } catch (e) {
      print(e);
      isActivityProgressLoading(false);
      return null;
    } finally {
      isActivityProgressLoading(false);
    }
  }

}
