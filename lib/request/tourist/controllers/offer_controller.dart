import 'dart:developer';

import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/request/tourist/services/offer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../models/accepted_offer.dart';
import '../models/offer.dart';
import '../models/offer_details.dart';
import '../models/schedule.dart';

class OfferController extends GetxController {
  var isOffersLoading = false.obs;
  var isOfferLoading = false.obs;
  var isAcceptOfferLoading = false.obs;
  var offers = <Offer>[].obs;
  var offerDetails = OfferDetails().obs;
  var acceptedOffer = AcceptedOffer().obs;
  Future<List<Offer>?> getOffers({
    required BuildContext context,
    required String placeId,
    required String bookingId,
  }) async {
    try {
      isOffersLoading(true);
      final data = await OfferService.getOffers(
          context: context, placeId: placeId, bookingId: bookingId);
      log("getOffers");
      offers(data);
      return offers;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isOffersLoading(false);
    }
  }

  Future<OfferDetails?> getOfferById({
    required BuildContext context,
    required String offerId,
  }) async {
    try {
      isOfferLoading(true);
      final data = await OfferService.getOfferById(
        context: context,
        offerId: offerId,
      );
      log("getOfferById");
      offerDetails(data);
      return offerDetails.value;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isOfferLoading(false);
    }
  }

  Future<AcceptedOffer?> acceptOffer({
    required BuildContext context,
    required String offerId,
    required List<Schedule> schedules,
  }) async {
    try {
      isAcceptOfferLoading(true);
      final data = await OfferService.acceptOffer(
        context: context,
        offerId: offerId,
        schedules: schedules,
      );
      acceptedOffer(data);
      return acceptedOffer.value;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isAcceptOfferLoading(false);
    }
  }

  /*
    ?  bookingCancel  
  */
  var isBookingCancelLoading = false.obs;
  var isBookingCancel = false.obs;

  Future<bool?> bookingCancel(
      {required BuildContext context, required String bookingId}) async {
    try {
      isBookingCancelLoading(true);
      final data = await OfferService.bookingCancel(
          context: context, bookingId: bookingId);
      isBookingCancel(data ?? false);
      return isBookingCancel.value;
    } catch (e) {
      log("-< bookingCancel >- $e");
      return null;
    } finally {
      isBookingCancelLoading(false);
    }
  }

  RxList<bool> checkedList = <bool>[].obs;
  getCheckedList(int? index, bool checked) {
    if (index == null) {
      checkedList.value = List.generate(
          offerDetails.value.schedule?.length ?? 0, (index) => true);
    } else {
      checkedList[index] = checked;
    }
  }

  //?         ======
  //?  ====== Total ======
  //?         ======

  RxInt totalPrice = RxInt(0);
  getTotalPrice(List<Schedule>? scheduleList, int? indexRemove) {
    int total = 0;
    if (scheduleList != null && scheduleList.isNotEmpty) {
      for (int x = 0; x < scheduleList.length; x++) {
        if (checkedList[x]) {
          total += scheduleList[x].price ?? 0;
        }
      }
    }
    totalPrice.value = total;
    log("totalPrice: ${totalPrice.value}");
  }

  checkTotal(int index, bool check) {
    log("index: $index");
    log("check $check");

    List<Schedule>? scheduleTemp = [];
    if (offerDetails.value.schedule != null) {
      for (var schedule in offerDetails.value.schedule!) {
        scheduleTemp.add(schedule);
      }
    }

    if (!check) {
      if (scheduleTemp.isNotEmpty) {
        if (scheduleTemp[index].price != null && !check) {
          getCheckedList(index, false);
          offerDetails.value.schedule![index].userAgreed = false;
          getTotalPrice(scheduleTemp, index);
        }
      }
    } else {
      if (scheduleTemp.isNotEmpty) {
        getCheckedList(index, true);
        offerDetails.value.schedule![index].userAgreed = true;
        getTotalPrice(scheduleTemp, null);
      }
    }
  }
}
