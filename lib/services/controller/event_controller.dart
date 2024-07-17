import 'dart:developer';

import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/event_summary.dart';
import 'package:ajwad_v4/services/service/adventure_service.dart';
import 'package:ajwad_v4/services/service/event_service.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventController extends GetxController {
  var eventList = <Event>[].obs;
  var isEventListLoading = false.obs;
  var isEventByIdLoading = false.obs;
  var ischeckBookingLoading = false.obs;
  var  selectedImages=<String>[].obs;
  var address = ''.obs;
  var DateErrorMessage=false.obs;
  var TimeErrorMessage=false.obs;
  var selectedDate = ''.obs;
  var selectedDates = [].obs; //new
  var selectedTime = ''.obs;
  var selectedStartTime = DateTime.now().obs;
  var selectedEndTime = DateTime.now().obs;
  var isPastTicketLoading = false.obs;
  var isUpcommingTicketLoading = false.obs;
  var isChatLoading = false.obs;
  var upcommingTicket = <Event>[].obs;
  var pastTicket = <Event>[].obs;
  var seletedSeat = (0).obs;
  var selectedGender = ''.obs;
  var selectedDateIndex = (-1).obs;
  var selectedDateId = "".obs;
  var titleAr = "".obs;
  var titleEn = "".obs;
  var bioAr = "".obs;
  var bioEn = "".obs;
  




  var isEventDateSelcted = false.obs;
  var isEventTimeSelcted = false.obs;

  // Rx<LatLng> pickUpLocLatLang = const LatLng(24.9470921, 45.9903698).obs;
  //  Rx<LatLng> pickUpLocLatLang = const LatLng(24.6264,46.544731).obs; 
   Rx<LatLng> pickUpLocLatLang = const LatLng(24.788299,46.631608).obs;


Future<List<Event>?> getEventList(
      {required BuildContext context, String? region}) async {
    try {
      isEventListLoading(true);
      final data =
          await EventService.getEventList(context: context, region: region);
      if (data != null) {
        eventList(data);
      }
      return eventList;
    } catch (e) {
      isEventListLoading(false);
      if (context.mounted) {
        AppUtil.errorToast(context, e.toString());
      }
      return null;
    } finally {
      isEventListLoading(false);
    }
  }


  Future<Event?> getEventById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      isEventByIdLoading(true);
      final data =
          await EventService.getEventById(context: context, id: id);
      return data;
    } catch (e) {
       isEventByIdLoading(false);
      if (context.mounted) {
        AppUtil.errorToast(context, e.toString());
      }
      return null;
    } finally {
      isEventByIdLoading(false);
    }
  }



   var isEventLoading = false.obs;

  Future<bool> createEvent({
  
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String longitude,
    required String latitude,
    required double price,
    required List<String> image,
    required String regionAr,
    required String locationUrl,
    required String regionEn,
   required List<Map<String, dynamic>> daysInfo,

    required BuildContext context,
  }) async {
    //print(rememberMe);
    try {
      isEventLoading(true);
      final isSuccess = await EventService.createEvent(
          nameAr: nameAr,
          nameEn: nameEn,
          descriptionAr: descriptionAr,
          descriptionEn: descriptionEn,
          longitude: longitude,
          latitude: latitude,
          price: price,
          image: image,
          regionAr: regionAr,
          locationUrl: locationUrl,
          regionEn: regionEn,
          daysInfo: daysInfo,
          context: context
          
          );

      print(isSuccess);
      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      isEventLoading(false);
    }
  }


    var  isEditEventLoading = false.obs;
  Future<Event?> editEvent({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String longitude,
    required String latitude,
    required double price,
    required List<String> image,
    required String regionAr,
    required String locationUrl,
    required String regionEn,
    required List<Map<String, dynamic>> daysInfo,

    required BuildContext context,
  }) async {
    try {
      isEditEventLoading(true);

      final event = await EventService.editEvent(
          id: id,
         nameAr: nameAr,
          nameEn: nameEn,
          descriptionAr: descriptionAr,
          descriptionEn: descriptionEn,
          longitude: longitude,
          latitude: latitude,
          price: price,
          image: image,
          regionAr: regionAr,
          locationUrl: locationUrl,
          regionEn: regionEn,
         daysInfo: daysInfo,
          context: context
      );
      if (event != null) {
        return event;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    } finally {
       isEditEventLoading(false);
    }
  }

   Future<List<Event>?> getUpcommingTicket({
    required BuildContext context,
  }) async {
    try {
      isUpcommingTicketLoading(true);

      final data = await EventService.getUserTicket(
        eventType: 'UPCOMING',
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

   Future<List<Event>?> getPastTicket({
    required BuildContext context,
  }) async {
    try {
      isPastTicketLoading(true);

      final data = await EventService.getUserTicket(
         eventType:'PAST',
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


 var  isEventDeleteLoading = false.obs;
  Future<bool?> EventDelete(
      {required BuildContext context, required String eventId}) async {
    try {
     isEventDeleteLoading(true);
      final data = await EventService.EventDelete(
          context: context,eventId: eventId);
   isEventDeleteLoading(data ?? false);
      return  isEventDeleteLoading.value;
    } catch (e) {
      log("-< HospitalityDeleteLoading >- $e");
      return null;
    } finally {
     isEventDeleteLoading(false);
    }
  }
  
  Future<EventSummary?> getEventSummaryById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      print("TRUE");
      isEventByIdLoading(true);
      final data =
          await EventService.getEventSummaryById(context: context, id: id);
      return data;
    } catch (e) {
       isEventByIdLoading(false);
      return null;
    } finally {
       isEventByIdLoading(false);
    }
  }
  
  
}
