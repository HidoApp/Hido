import 'dart:developer';

import 'package:ajwad_v4/explore/tourist/model/activity_progress.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/explore/tourist/model/tourist_map_model.dart';
import 'package:ajwad_v4/explore/tourist/service/tourist_explore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';

class TouristExploreController extends GetxController {
  var selectedDate = ''.obs;
  var selectedTime = ''.obs;
  var selectedStartTime = DateTime.now().obs;
  var selectedEndTime = DateTime.now().obs;
  var TimeErrorMessage = false.obs;
  var isAllPlacesIsLoading = false.obs;
  var isNotGetUserLocation = false.obs;
  var isPlaceIsLoading = false.obs;
  var isBookingDateSelected = false.obs;
  var isBookingTimeSelected = false.obs;
  var isBookedMade = false.obs;
  var isPlaceNotLocked = true.obs;
  var isBookingLoading = false.obs;
  var isBookingByIdLoading = false.obs;
  var isTouristMapLoading = false.obs;
  var isActivityProgressLoading = false.obs;
  var isNewMarkers = true.obs;
  var showActivityProgress = false.obs;
  var activeStepProgres = (-1).obs;
  var timerSec = 300.obs;
  var isTimerEnabled = true.obs;
  var currentLocation =  LatLng(24.7136, 46.6753).obs;
  var showSheet= true.obs;
  Rx<ActivityProgress?> activityProgres = ActivityProgress().obs;
  Rx<TouristMapModel?> touristModel = TouristMapModel().obs;

  Rx<LatLng> pickUpLocLatLang = const LatLng(24.9470921, 45.9903698).obs;
  var isBookingIsMaking = false.obs;

  var allPlaces = <Place>[].obs;
  var bookingList = <Booking>[].obs;

  Future<List<Place>?> getAllPlaces({
    required BuildContext context,
  }) async {
    try {
      isAllPlacesIsLoading(true);
      final data = await TouristExploreService.getAllPlaces(context: context);
      if (data != null) {
        allPlaces(data);
        return allPlaces;
      } else {
        return null;
      }
    } catch (e) {
      print(e);

      return null;
    } finally {
      isAllPlacesIsLoading(false);
    }
  }

  Future<Place?> getPlaceById({
    required String? id,
    required BuildContext context,
  }) async {
    try {
      isPlaceIsLoading(true);
      final data =
          await TouristExploreService.getPlaceById(context: context, id: id!);
      print("this place by id in controller");
      print('${data?.booking?.first.orderStatus}');
      if (data != null) {
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);

      return null;
    } finally {
      isPlaceIsLoading(false);
    }
  }

  Future<bool> bookPlace({
    required String placeId,
    required String timeToGo,
    required String timeToReturn,
    required String date,
    required int guestNumber,
    required int cost,
    required String lng,
    required String lat,
    required String vehicle,
    required BuildContext context,
  }) async {
    try {
      isBookingIsMaking(true);
      final data = await TouristExploreService.bookPlace(
        context: context,
        placeId: placeId,
        timeToGo: timeToGo,
        timeToReturn: timeToReturn,
        date: date,
        guestNumber: guestNumber,
        cost: cost,
        lng: lng,
        lat: lat,
        vehicle: vehicle,
      );
      if (data != null) {
        return data;
      } else {
        return false;
      }
    } catch (e) {
      print(e);

      return false;
    } finally {
      isBookingIsMaking(false);
    }
  }

  Future<List<Booking>?> getTouristBooking({
    required BuildContext context,
  }) async {
    try {
      isBookingLoading(true);

      var date =
          await TouristExploreService.getTouristBooking(context: context);
      print("this booking list");
      bookingList(date);
      return date;
    } catch (e) {
      return null;
    } finally {
      isBookingLoading(false);
    }
  }

  Future<Booking?> getTouristBookingById({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      isBookingByIdLoading(true);

      var date = await TouristExploreService.getTouristBookingById(
          context: context, bookingId: bookingId);
      print('this date code from controller');
      print(date!.date);
      return date!;
    } catch (e) {
      print(e);

      return null;
    } finally {
      isBookingByIdLoading(false);
    }
  }

  Future<TouristMapModel?> touristMap({
    required BuildContext context,
    required String tourType,
  }) async {
    try {
      touristModel.value?.places = [];
      isTouristMapLoading(true);
      TouristMapModel? data = await TouristExploreService.touristMap(
          context: context, tourType: "PLACE");
      touristModel(data);

      return data;
    } catch (e) {
      isTouristMapLoading(false);
      print("e");
      log("this error");
      print(e);
      return null;
    } finally {
      isTouristMapLoading(false);
    }
  }

  Future<ActivityProgress?> getActivityProgress(
      {required BuildContext context}) async {
    try {
      isActivityProgressLoading(true);
      final data =
          await TouristExploreService.getActivityProgress(context: context);
      if (data != null) {
        activityProgres(data);
      }
      return data;
    } catch (e) {
      showActivityProgress(false);
      isActivityProgressLoading(false);
      return null;
    } finally {
      isActivityProgressLoading(false);
    }
  }
}
