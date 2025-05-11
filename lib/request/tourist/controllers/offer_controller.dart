import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/request/tourist/services/offer_service.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/accepted_offer.dart';
import '../models/offer.dart';
import '../models/offer_details.dart';
import '../models/schedule.dart';

class OfferController extends GetxController {
  var isOffersLoading = false.obs;
  var isOfferLoading = false.obs;
  var messageCreated = ''.obs;
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
      return null;
    } finally {
      isOffersLoading(false);
    }
  }

  List<String?> get firstThreeImages =>
      offers.take(3).map((offer) => offer.image).toList();

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
      return null;
    } finally {
      isOfferLoading(false);
    }
  }

  Future<AcceptedOffer?> acceptOffer({
    required BuildContext context,
    required String offerId,
    String? invoiceId,
    String? couponId,
    required List<Schedule> schedules,
  }) async {
    try {
      isAcceptOfferLoading(true);
      final data = await OfferService.acceptOffer(
        context: context,
        offerId: offerId,
        invoiceId: invoiceId ?? "",
        couponId: couponId,
        schedules: schedules,
      );
      acceptedOffer(data);

      return acceptedOffer.value;
    } catch (e) {
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
      {required BuildContext context,
      required String bookingId,
      required String type,
      String? reason}) async {
    try {
      isBookingCancelLoading(true);
      final data = await OfferService.bookingCancel(
          context: context,
          bookingId: bookingId,
          type: type,
          reason: reason ?? '');

      return data;

      // return isBookingCancel.value;
    } catch (e) {
      log("-< bookingCancel >- $e");
      return false;
    } finally {
      isBookingCancelLoading(false);
    }
  }

  RxList<bool> checkedList = <bool>[].obs;
  getCheckedList(int? index, bool checked) {
    if (index == null) {
      checkedList.value = List.generate(
          offerDetails.value.schedule?.length ?? 0, (index) => true);
      updateScheduleList.value = List<Schedule>.generate(
        offerDetails.value.schedule?.length ?? 0,
        (index) => offerDetails.value.schedule![index],
      );
    } else {
      checkedList[index] = checked;
    }
  }

  //?         ======
  //?  ====== Total ======
  //?         ======

  RxInt totalPrice = RxInt(0);
  void getTotalPrice(List<Schedule>? scheduleList, int? indexRemove) {
    int total = 0;

    // Calculate total without considering current checkbox state
    if (scheduleList != null && scheduleList.isNotEmpty) {
      for (int x = 0; x < scheduleList.length; x++) {
        total += scheduleList[x].price ?? 0;
      }
    }

    // Adjust total based on checkbox state changes
    if (checkedList.isNotEmpty) {
      for (int x = 0; x < checkedList.length; x++) {
        if (!checkedList[x]) {
          // print(
          //     'Removing price of schedule at index $x: ${scheduleList?[x].price}');

          total -= scheduleList?[x].price ?? 0;
        }
      }
    }

    // Update total price
    totalPrice.value = total;
  }

  var updateScheduleList = <Schedule>[].obs;
  var ScheduleList = <Schedule>[].obs;

  RxBool scheduleState = false.obs;
  void checkTotal(int index, bool check) {
    ScheduleList.value = offerDetails.value.schedule!;
    if (ScheduleList.isEmpty || index < 0 || index >= ScheduleList.length) {
      return;
    }

    Schedule schedule = ScheduleList[index];
    if (check) {
      totalPrice += schedule.price ?? 0;

      if (!updateScheduleList.contains(schedule)) {
        updateScheduleList.add(schedule);

        scheduleState.value = false;
        // Track activity addition
        AmplitudeService.amplitude.track(BaseEvent(
          'Select Tour Activity',
          eventProperties: {
            'activityName':
                schedule.scheduleName, // Assuming schedule has activityName
            'price': schedule.price,
            'activityTime': schedule.scheduleTime,
          },
        ));
      }
    } else {
      totalPrice -= schedule.price ?? 0;

      updateScheduleList.remove(schedule);

      AmplitudeService.amplitude.track(BaseEvent(
        'Remove Tour Activity',
        eventProperties: {
          'activityName':
              schedule.scheduleName, // Assuming schedule has activityName
          'price': schedule.price,
          'activityTime': schedule.scheduleTime,
        },
      ));

      if (updateScheduleList.isEmpty) {
        scheduleState.value = true;
      }
    }

    // Update the checked status in the list
    checkedList[index] = check;

    // Notify listeners of the changes
    update();
  }
}
