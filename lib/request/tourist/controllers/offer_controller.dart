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
      print(e);
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
      print(e);
      return null;
    } finally {
      isOfferLoading(false);
    }
  }

  Future<AcceptedOffer?> acceptOffer({
    required BuildContext context,
    required String offerId,
    required String invoiceId,
    required List<Schedule> schedules,
  }) async {
    try {
      isAcceptOfferLoading(true);
      final data = await OfferService.acceptOffer(
        context: context,
        offerId: offerId,
        invoiceId: invoiceId,
        schedules: schedules,
      );
      acceptedOffer(data);
      print("pay from services");
      print(data?.orderStatus);
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
    log("checkedList[index!].toString()");
    if (index == null) {
      log("index nulll");
      checkedList.value = List.generate(

          offerDetails.value.schedule?.length ?? 0, (index) => true);
        updateScheduleList = List<Schedule>.generate(
        offerDetails.value.schedule?.length??0,
        (index) => offerDetails.value.schedule![index],
      
      );
      print("data");
      print(  updateScheduleList[0].scheduleName);
            print(  updateScheduleList[1].scheduleName);
                  print(  updateScheduleList[2].scheduleName);


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
    print('Total price before adjustments: $total');

    // Adjust total based on checkbox state changes
    if (checkedList.isNotEmpty) {
      for (int x = 0; x < checkedList.length; x++) {
        if (!checkedList[x]) {
          print(
              'Removing price of schedule at index $x: ${scheduleList?[x].price}');

          total -= scheduleList?[x].price ?? 0;
        }
      }
    }

    // Update total price
    totalPrice.value = total;
    print('Final total price: ${totalPrice.value}');


}
  
  List<Schedule> updateScheduleList = <Schedule>[].obs; 
  RxBool scheduleState = false.obs;
 void checkTotal(int index, bool check) {
  List<Schedule>? scheduleList = offerDetails.value.schedule;
  if (scheduleList == null || index < 0 || index >= scheduleList.length) {
    return;
  }

  Schedule schedule = scheduleList[index];
  if (check) {
      totalPrice += schedule.price ?? 0;
      print("Before add");
      print(updateScheduleList.length);
      if (index < updateScheduleList.length) {
        updateScheduleList.insert(index, schedule);
                      scheduleState.value=false;

      } else {
                updateScheduleList.add(schedule);
              scheduleState.value=false;

      }
      print("After add");
      print(updateScheduleList.length);
    } else {
      totalPrice -= schedule.price ?? 0;
      print("Before remove");
      print(updateScheduleList.length);
      if (index < updateScheduleList.length) {

        updateScheduleList.removeAt(index);
        
      } else {
        
      updateScheduleList.removeLast();
      if(updateScheduleList.isEmpty){
        scheduleState.value=true;
      }

      }
      print("After remove");
            print(updateScheduleList.length);



    }

  // Update the checked status in the list
  checkedList[index] = check;
  print(check);

    Schedule schedule = scheduleList[index];
    if (check) {
      totalPrice += schedule.price ?? 0;
    } else {
      totalPrice -= schedule.price ?? 0;
    }

    // Update the checked status in the list
    checkedList[index] = check;
    log("checkd list");
    log(checkedList.length.toString());

    // Notify listeners of the changes
    update();
  }
}
