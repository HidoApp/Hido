import 'dart:developer';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/request/ajwadi/models/request_model.dart';
import 'package:ajwad_v4/request/ajwadi/services/request_service.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/card_itenrary.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  RxInt requestIndex = 0.obs;
  /* ?
            ? getRequestList 
  */
  RxString address = ''.obs;
  var isRequestListLoading = false.obs;
  var isBookingLoading = false.obs;
  var requestList = <RequestModel>[].obs;
  //add itnrary flow
  var itineraryList = <ItineraryCard>[].obs;
  var intinraryCount = 0.obs;
  var startTime = ''.obs;
  var endtime = ''.obs;
  var reviewItenrary = <RequestSchedule>[].obs;
// valditon itenrary
  var isActivtyValid = true.obs;

  var isPriceValid = true.obs;

  var isStartTimeValid = true.obs;
  var isStartTimeInRange = true.obs;
  //var isStartTimeValidWITH = true.obs;
  var isEndTimeValid = true.obs;
  var isEndTimeInRange = true.obs;

  var validSave = true.obs;

  /// valditon itenrary review
  var timeToGo = DateTime.now().obs;
  var timeToReturn = DateTime.now().obs;
  var isStartTimeReviewInRange = true.obs;
  var isEndTimeReviewInRange = true.obs;

  var isActivtyReviewValid = true.obs;
  var isPriceReviewValid = true.obs;
  var isStartTimeReviewValid = true.obs;
  var isEndTimeReviewValid = true.obs;
  var validReviewSave = false.obs;
  Future<List<RequestModel>?> getRequestList(
      {required BuildContext context}) async {
    try {
      isRequestListLoading(true);
      final data = await RequestService.getRequestList(context: context);
      requestList(data);
      return requestList;
    } catch (e) {
      log(e.toString());
      return null;
    } finally {
      isRequestListLoading(false);
    }
  }

  Future<Booking?> getBookingById(
      {required BuildContext context, required String bookingId}) async {
    try {
      isBookingLoading(true);
      final data = await RequestService.getBookingById(
          context: context, bookingId: bookingId);

      return data;
    } catch (e) {
      log(e.toString());
      return null;
    } finally {
      isBookingLoading(false);
    }
  }

  /* ?
            ? requestAccept 
  */

  var isRequestAcceptLoading = false.obs;
  RxBool isRequestAccept = false.obs;

  RxList<RequestSchedule> requestScheduleList =
      <RequestSchedule>[RequestSchedule(scheduleTime: ScheduleTime())].obs;

  Future<bool?> requestAccept(
      {required String id,
      required List<RequestSchedule> requestScheduleList,
      required BuildContext context}) async {
    try {
      isRequestAcceptLoading(true);
      final data = await RequestService.requestAccept(
          id: id, requestScheduleList: requestScheduleList, context: context);
      isRequestAccept.value = data ?? false;
      return isRequestAccept.value;
    } catch (e) {
      log(e.toString());
      isRequestAccept.value = false;
      return null;
    } finally {
      isRequestAcceptLoading(false);
    }
  }

  /* ?
            ? requestReject 
  */

  var isRequestRejectLoading = false.obs;
  RxBool isRequestReject = false.obs;

  Future<bool?> requestReject(
      {required String id, required BuildContext context}) async {
    try {
      isRequestRejectLoading(true);
      final data = await RequestService.requestReject(id: id, context: context);
      isRequestReject.value = data ?? false;
      return isRequestReject.value;
    } catch (e) {
      log(e.toString());
      isRequestReject.value = false;
      return null;
    } finally {
      isRequestRejectLoading(false);
    }
  }

  /* ?
            ? getRequestById 
  */

  var isGetRequestByIdLoading = false.obs;
  var requestModel = RequestModel().obs;

  Future<RequestModel?> getRequestById(
      {required String requestId, required BuildContext context}) async {
    try {
      isGetRequestByIdLoading(true);
      final data = await RequestService.getRequestById(
          requestId: requestId, context: context);
      requestModel(data);
      return requestModel.value;
    } catch (e) {
      log(e.toString());
      return null;
    } finally {
      isGetRequestByIdLoading(false);
    }
  }

  /* ?
            ? requestEnd 
  */

  var isRequestEndLoading = false.obs;
  RxBool isRequestEndReject = false.obs;

  Future<bool?> requestEnd(
      {required String id, required BuildContext context}) async {
    try {
      isRequestEndLoading(true);
      final data = await RequestService.requestEnd(id: id, context: context);
      // log(data.toString());
      isRequestEndReject.value = data ?? false;
      return isRequestEndReject.value;
    } catch (e) {
      log(e.toString());
      isRequestEndReject.value = false;
      return isRequestEndReject.value;
    } finally {
      isRequestEndLoading(false);
    }
  }
}
