import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/event/model/event.dart';
import 'package:ajwad_v4/services/model/event_summary.dart';
import 'package:ajwad_v4/services/service/event_service.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EventController extends GetxController {
  var eventList = <Event>[].obs;

  var originalEventList = <Event>[].obs;

  var isEventListLoading = false.obs;
  var isEventByIdLoading = false.obs;
  var showErrorMaxGuest = false.obs;
  var newRangeTimeErrorMessage = false.obs; // newww
  var ischeckBookingLoading = false.obs;
  var selectedImages = <XFile>[].obs;
  var images = <dynamic>[].obs;
  var addressEventCard = ''.obs;
  var address = ''.obs;
  var DateErrorMessage = false.obs;
  var TimeErrorMessage = false.obs;
  var EmptyDateErrorMessage = false.obs;
  var EmptyTimeErrorMessage = false.obs;
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
  var titleZh = "".obs;

  var bioAr = "".obs;
  var bioEn = "".obs;
  var bioZh = "".obs;
  var ragionAr = "".obs;
  var ragionEn = "".obs;
  var startDate = ''.obs;
  var isEventDateSelcted = false.obs;
  var isEventTimeSelcted = false.obs;
  //check if this event  allow coupons or not
  var allowCoupons = true.obs;
  // check if user can make free booking
  var hasFreeBooking = true.obs;
  // // total allowed seat for free booking
  // var totalSeats = true.obs;

  // Rx<LatLng> pickUpLocLatLang = const LatLng(24.9470921, 45.9903698).obs;
  //  Rx<LatLng> pickUpLocLatLang = const LatLng(24.6264,46.544731).obs;
  Rx<LatLng> pickUpLocLatLang = const LatLng(24.788299, 46.631608).obs;

  Future<List<Event>?> getEventList(
      {required BuildContext context, String? region}) async {
    try {
      isEventListLoading(true);
      final data =
          await EventService.getEventList(context: context, region: region);
      if (data != null) {
        final sorted =
            data.map((event) => event.copyWith()).toList(); // Deep copy
        originalEventList(data.map((event) => event.copyWith()).toList()); //

        //order list
        AppUtil.sortByClosedLast(sorted);
        eventList(sorted);
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
      final data = await EventService.getEventById(context: context, id: id);
      if (data != null) {
        allowCoupons(data.allowCoupons);
        hasFreeBooking(data.hasFreeBooking);
        return data;
      }
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
    required String nameZh,
    required String descriptionAr,
    required String descriptionEn,
    required String descriptionZh,
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
    //
    try {
      isEventLoading(true);
      final isSuccess = await EventService.createEvent(
          nameAr: nameAr,
          nameEn: nameEn,
          nameZh: nameZh,
          descriptionAr: descriptionAr,
          descriptionEn: descriptionEn,
          descriptionZh: descriptionZh,
          longitude: longitude,
          latitude: latitude,
          price: price,
          image: image,
          regionAr: regionAr,
          locationUrl: locationUrl,
          regionEn: regionEn,
          daysInfo: daysInfo,
          context: context);

      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      isEventLoading(false);
    }
  }

  var isEditEventLoading = false.obs;
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
          context: context);
      if (event != null) {
        return event;
      } else {
        return null;
      }
    } catch (e) {
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

  Future<List<Event>?> getPastTicket({
    required BuildContext context,
  }) async {
    try {
      isPastTicketLoading(true);

      final data = await EventService.getUserTicket(
        eventType: 'PAST',
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

  var isEventDeleteLoading = false.obs;
  Future<bool?> EventDelete(
      {required BuildContext context, required String eventId}) async {
    try {
      isEventDeleteLoading(true);
      final data =
          await EventService.EventDelete(context: context, eventId: eventId);
      isEventDeleteLoading(data ?? false);
      return isEventDeleteLoading.value;
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
    required String date,
  }) async {
    try {
      isEventByIdLoading(true);
      final data = await EventService.getEventSummaryById(
          context: context, id: id, date: date);
      return data;
    } catch (e) {
      isEventByIdLoading(false);
      return null;
    } finally {
      isEventByIdLoading(false);
    }
  }

  Future<bool> checkAndBookEvent(
      {required BuildContext context,
      String? paymentId,
      required String eventId,
      double? cost,
      required String dayId,
      required int person,
      String? couponId,
      required String date}) async {
    try {
      ischeckBookingLoading(true);
      final data = await EventService.checkAndBookEvent(
          context: context,
          paymentId: paymentId ?? "",
          eventId: eventId,
          cost: cost ?? 0,
          dayId: dayId,
          person: person,
          couponId: couponId,
          date: date);
      return data;
    } catch (e) {
      ischeckBookingLoading(false);
      return false;
    } finally {
      ischeckBookingLoading(false);
    }
  }

  var isImagesLoading = false.obs;

  Future<UploadImage?> uploadProfileImages(
      {required File file,
      required String fileType,
      required BuildContext context}) async {
    try {
      isImagesLoading(true);
      final isSucces = await EventService.uploadImages(
          file: file, fileType: fileType, context: context);

      return isSucces;
    } catch (e) {
      return null;
    } finally {
      isImagesLoading(false);
    }
  }

  bool checkForOneHour({required BuildContext context}) {
    log(startDate.value);
    log(selectedDate.value);
    log((AppUtil.areDatesOnSameDay(startDate.value, selectedDate.value))
        .toString());
    if (AppUtil.areDatesOnSameDay(startDate.value, selectedDate.value)) {
      final isValid = AppUtil.isTimeDifferenceOneHour(startDate.value);
      if (isValid) {
        return true;
      } else {
        AppUtil.errorToast(context, "checkForOneOur".tr);

        return false;
      }
    } else {
      return true;
    }
  }
}
