import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/payment/model/payment_result.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/model/payment.dart';
import 'package:ajwad_v4/services/service/hospitality_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../model/summary.dart';

class HospitalityController extends GetxController {
  var DateErrorMessage = false.obs;
  var TimeErrorMessage = false.obs;
  var EmptyDateErrorMessage = false.obs;
  var EmptyTimeErrorMessage = false.obs;
  var isHospitalityLoading = true.obs;
  var showErrorMaxGuest = false.obs;
  var selectedDate = ''.obs;
  var selectedDates = [].obs; //new
  var selectedTime = ''.obs;
  var selectedStartTime = DateTime.now().obs;
  var selectedEndTime = DateTime.now().obs;
  var isPastTicketLoading = false.obs;
  var isUpcommingTicketLoading = false.obs;
  var isChatLoading = false.obs;
  var upcommingTicket = <Hospitality>[].obs;
  var pastTicket = <Hospitality>[].obs;
  var seletedSeat = (0).obs;
  var selectedGender = ''.obs;
  var selectedMealAr = ''.obs;
  var selectedMealEn = ''.obs;
  var selectedDateIndex = (-1).obs;
  var selectedDateId = "".obs;
  var isHospitalityByIdLoading = false.obs;
  var selectedImages = <XFile>[].obs;
  var images = <dynamic>[].obs;

  var isCheckAndBookLoading = false.obs;
  var isCheckHospitalitPaymentLoading = false.obs;
  var isHospitalitPaymentLoading = false.obs;

  var hospitalityList = <Hospitality>[].obs;
  var isHospatilityDateSelcted = false.obs;
  var isHospatilityTimeSelcted = false.obs;
  var address = ''.obs;
  var isAdventureTimeSelcted = false.obs;
  var ragionAr = "".obs;
  var ragionEn = "".obs;
  var tabIndex = 0.obs;
  var addresHostCard = ''.obs;
  // Rx<LatLng> pickUpLocLatLang = const LatLng(24.9470921, 45.9903698).obs;
  Rx<LatLng> pickUpLocLatLang = const LatLng(24.6264, 46.544731).obs;

  Future<RxList<Hospitality>?> getAllHospitality(
      {required BuildContext context, String? region}) async {
    try {
      isHospitalityLoading(true);
      final data = await HospitalityService.getAllHospitality(
          context: context, region: region);
      if (data != null) {
        hospitalityList(data);
      }
      return hospitalityList;
    } catch (e) {
      isHospitalityLoading(false);
      return null;
    } finally {
      isHospitalityLoading(false);
    }
  }

  Future<Hospitality?> getHospitalityById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      isHospitalityByIdLoading(true);
      final data =
          await HospitalityService.getHospitalityById(context: context, id: id);
      return data;
    } catch (e) {
      isHospitalityByIdLoading(false);
      return null;
    } finally {
      isHospitalityByIdLoading(false);
    }
  }

  // Future<Adventure?> getAdventureById({
  //   required BuildContext context,
  //   required String id,
  // }) async {
  //   try {
  //
  //     isHospitalityByIdLoading(true);
  //     final data =
  //         await HospitalityService.getAdvdentureById(context: context, id: id);
  //     return data;
  //   } catch (e) {
  //     isHospitalityByIdLoading(false);
  //     return null;
  //   } finally {
  //     isHospitalityByIdLoading(false);
  //   }
  // }

  Future<bool> checkAndBookHospitality({
    required BuildContext context,
    required bool check,
    String? paymentId,
    required String hospitalityId,
    required String date,
    required String dayId,
    required int numOfMale,
    required int numOfFemale,
    required double cost,
  }) async {
    try {
      isCheckAndBookLoading(true);
      print(
          '  \ncheck: $check, \n hospitalityId:$hospitalityId, paymentId: $paymentId,\n ,date: $date,dayId: $dayId, numOfFemale: $numOfFemale, numOfMale: $numOfMale, cost: $cost');

      final data = await HospitalityService.checkAndBookHospitality(
          context: context,
          check: check,
          hospitalityId: hospitalityId,
          paymentId: paymentId,
          date: date,
          dayId: dayId,
          numOfFemale: numOfFemale,
          numOfMale: numOfMale,
          cost: cost);

      return data;
    } catch (e) {
      isCheckAndBookLoading(false);
      return false;
    } finally {
      isCheckAndBookLoading(false);
    }
  }

  Future<Payment?> hospitalityPayment({
    required BuildContext context,
    required String hospitalityId,
  }) async {
    try {
      isCheckAndBookLoading(true);
      final data = await HospitalityService.hospitalityPayment(
        context: context,
        hospitalityId: hospitalityId,
      );
      return data;
    } catch (e) {
      isCheckAndBookLoading(false);
      return null;
    } finally {
      isCheckAndBookLoading(false);
    }
  }

  var isCreditCardPaymentLoading = false.obs;
  // var PaymentResult = false.obs;

  Future<PaymentResult?> payWithCreditCard({
    required BuildContext context,
    required int amount,
    required String name,
    required String number,
    required String cvc,
    required String month,
    required String year,
  }) async {
    {
      try {
        isCreditCardPaymentLoading(true);
        final data = HospitalityService.payWithCreditCard(
          context: context,
          amount: amount,
          name: name,
          number: number,
          cvc: cvc,
          month: month,
          year: year,
        );
        return data;
      } catch (e) {
        return null;
      } finally {
        isCreditCardPaymentLoading(false);
      }
    }
  }

  var isSaudiHospitalityLoading = false.obs;

  Future<bool> createHospitality({
    required String titleAr,
    required String titleEn,
    required String bioAr,
    required String bioEn,
    required String mealTypeAr,
    required String mealTypeEn,
    required String longitude,
    required String latitude,
    required String touristsGender,
    required int price,
    required List<String> images,
    required String regionAr,
    required String location,
    required String regionEn,
    required List<Map<String, dynamic>> daysInfo,
    required String start,
    required String end,
    required int seat,
    required BuildContext context,
  }) async {
    //
    try {
      isSaudiHospitalityLoading(true);
      final isSuccess = await HospitalityService.createHospitality(
          titleAr: titleAr,
          titleEn: titleEn,
          bioAr: bioAr,
          bioEn: bioEn,
          mealTypeAr: mealTypeAr,
          mealTypeEn: mealTypeEn,
          longitude: longitude,
          latitude: latitude,
          touristsGender: touristsGender,
          price: price,
          images: images,
          regionAr: regionAr,
          location: location,
          regionEn: regionEn,
          daysInfo: daysInfo,
          start: start,
          end: end,
          seat: seat,
          context: context);

      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      isSaudiHospitalityLoading(false);
    }
  }

  var isImagesLoading = false.obs;

  Future<UploadImage?> uploadProfileImages(
      {required File file,
      required String uploadOrUpdate,
      required BuildContext context}) async {
    try {
      isImagesLoading(true);
      final isSucces = await HospitalityService.uploadProfileImages(
          file: file, uploadOrUpdate: uploadOrUpdate, context: context);

      return isSucces;
    } catch (e) {
      return null;
    } finally {
      isImagesLoading(false);
    }
  }

  var isEditHospitalityLoading = false.obs;
  Future<Hospitality?> editHospatility({
    required String id,
    required String titleAr,
    required String titleEn,
    required String bioAr,
    required String bioEn,
    required String mealTypeAr,
    required String mealTypeEn,
    required String longitude,
    required String latitude,
    required String touristsGender,
    required double price,
    required List<String> images,
    required String regionAr,
    required String location,
    required String regionEn,
    // required List<Map<String, dynamic>> daysInfo,
    required String start,
    required String end,
    required int seat,
    required BuildContext context,
  }) async {
    try {
      isEditHospitalityLoading(true);

      final hospitality = await HospitalityService.editHospitality(
          id: id,
          titleAr: titleAr,
          titleEn: titleEn,
          bioAr: bioAr,
          bioEn: bioEn,
          mealTypeAr: mealTypeAr,
          mealTypeEn: mealTypeEn,
          longitude: longitude,
          latitude: latitude,
          touristsGender: touristsGender,
          price: price,
          images: images,
          regionAr: regionAr,
          location: location,
          regionEn: regionEn,
          // daysInfo: daysInfo,
          start: start,
          end: end,
          seat: seat,
          context: context);
      if (hospitality != null) {
        return hospitality;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      isEditHospitalityLoading(false);
    }
  }

  Future<List<Hospitality>?> getUpcommingTicket({
    required BuildContext context,
  }) async {
    try {
      isUpcommingTicketLoading(true);

      final data = await HospitalityService.getUserTicket(
        hostType: 'UPCOMING',
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

  Future<List<Hospitality>?> getPastTicket({
    required BuildContext context,
  }) async {
    try {
      isPastTicketLoading(true);

      final data = await HospitalityService.getUserTicket(
        hostType: 'PAST',
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

  Future<Summary?> getHospitalitySummaryById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      isHospitalityByIdLoading(true);
      final data = await HospitalityService.getHospitalitySummaryById(
          context: context, id: id);
      return data;
    } catch (e) {
      isHospitalityByIdLoading(false);
      return null;
    } finally {
      isHospitalityByIdLoading(false);
    }
  }

  var isHospitalityDeleteLoading = false.obs;
  Future<bool?> hospitalityDelete(
      {required BuildContext context, required String hospitalityId}) async {
    try {
      isHospitalityDeleteLoading(true);
      final data = await HospitalityService.hospitalityDelete(
          context: context, hospitalityId: hospitalityId);
      isHospitalityDeleteLoading(data ?? false);
      return isHospitalityDeleteLoading.value;
    } catch (e) {
      log("-< HospitalityDeleteLoading >- $e");
      return null;
    } finally {
      isHospitalityDeleteLoading(false);
    }
  }
}
