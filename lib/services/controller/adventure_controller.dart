import 'dart:developer';

import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/model/adventure_summary.dart';
import 'package:ajwad_v4/services/service/adventure_service.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../request/local/view/widget/include_card.dart';

class AdventureController extends GetxController {
  var adventureList = <Adventure>[].obs;
  var originalAdventureList = <Adventure>[].obs;
  var isAdventureListLoading = false.obs;
  var isAdventureByIdLoading = false.obs;
  var ischeckBookingLoading = false.obs;
  var DateErrorMessage = false.obs;
  var TimeErrorMessage = false.obs;
  var EmptyDateErrorMessage = false.obs;
  var EmptyTimeErrorMessage = false.obs;
  var address = ''.obs;
  var newRangeTimeErrorMessage = false.obs; // newww
  var selectedDate = ''.obs;
  var selectedDates = [].obs; //new
  var selectedTime = ''.obs;
  var selectedStartTime = DateTime.now().obs;
  var selectedEndTime = DateTime.now().obs;
  var isPastTicketLoading = false.obs;
  var isUpcommingTicketLoading = false.obs;
  var isChatLoading = false.obs;
  var upcommingTicket = <Adventure>[].obs;
  var pastTicket = <Adventure>[].obs;
  var seletedSeat = (0).obs;
  var selectedGender = ''.obs;
  var selectedDateIndex = (-1).obs;
  var selectedDateId = "".obs;
  var ragionAr = "".obs;
  var ragionEn = "".obs;
  var startDate = ''.obs;
  var titleAr = "".obs;
  var titleEn = "".obs;
  var titleZh = "".obs;

  var desAr = "".obs;
  var desEn = "".obs;
  var desZh = "".obs;

  var selectedImages = <XFile>[].obs;
  var images = <dynamic>[].obs;
  var addressAdventure = ''.obs;
  var showErrorMaxGuest = false.obs;
  var isAdventureDateSelcted = false.obs;
  var isAdventureTimeSelcted = false.obs;
  var showErrorSeat = false.obs;
  var showErrorGuests = false.obs;
  var person = 0.obs;
  var startTime = ''.obs;
  var includeList = <IncludeCard>[].obs;
  var reviewincludeItenrary = <String>[].obs;
  var isActivtyValid = true.obs;
  var validSave = true.obs;
  var includeCount = 0.obs;
  String lastTranslatedTitleAr = '';

  // Rx<LatLng> pickUpLocLatLang = const LatLng(24.9470921, 45.9903698).obs;
  //  Rx<LatLng> pickUpLocLatLang = const LatLng(24.6264,46.544731).obs;
  Rx<LatLng> pickUpLocLatLang = const LatLng(24.788299, 46.631608).obs;
  Future<List<Adventure>?> getAdvdentureList(
      {required BuildContext context, String? region}) async {
    try {
      isAdventureListLoading(true);
      final data = await AdventureService.getAdvdentureList(
          context: context, region: region);
      if (data != null) {
        // adventureList(data.map((activity) => activity.copyWith()).toList());
        final sorted = data.map((activity) => activity.copyWith()).toList();
        originalAdventureList(
            data.map((activity) => activity.copyWith()).toList());

        //order list
        AppUtil.sortByClosedLast(sorted);
        adventureList(sorted);
      }
      return adventureList;
    } catch (e) {
      isAdventureListLoading(false);
      if (context.mounted) {
        AppUtil.errorToast(context, e.toString());
      }
      return null;
    } finally {
      isAdventureListLoading(false);
    }
  }

  Future<Adventure?> getAdvdentureById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      isAdventureByIdLoading(true);
      final data =
          await AdventureService.getAdvdentureById(context: context, id: id);
      return data;
    } catch (e) {
      isAdventureByIdLoading(false);
      if (context.mounted) {
        AppUtil.errorToast(context, e.toString());
      }
      return null;
    } finally {
      isAdventureByIdLoading(false);
    }
  }

  Future<bool> checkAdventureBooking(
      {required BuildContext context,
      required String adventureID,
      required String dayId,
      required String date,
      String? invoiceId,
      String? couponId,
      required int personNumber}) async {
    try {
      ischeckBookingLoading(true);
      final data = await AdventureService.checkAdventureBooking(
          context: context,
          adventureID: adventureID,
          personNumber: personNumber,
          date: date,
          dayId: dayId,
          couponId: couponId,
          invoiceId: invoiceId ?? "");

      return data;
    } catch (e) {
      // AppUtil.errorToast(context, e.toString());
      ischeckBookingLoading(false);
      return false;
    } finally {
      ischeckBookingLoading(false);
    }
  }

  var isAdventureLoading = false.obs;

  Future<bool> createAdventure({
    required String nameAr,
    required String nameEn,
    required String nameZh,
    required String descriptionAr,
    required String descriptionEn,
    required String descriptionZh,
    List<String>? priceIncludesEn,
    List<String>? priceIncludesAr,
    List<String>? priceIncludesZh,
    required String longitude,
    required String latitude,
    //required String date,
    required int price,
    required List<String> image,
    required String regionAr,
    required String locationUrl,
    required String regionEn,
    // required List<Map<String, dynamic>> times,
    // required String start,
    // required String end,
    required int seat,
    required List<Map<String, dynamic>> daysInfo,
    required BuildContext context,
  }) async {
    //
    try {
      isAdventureLoading(true);
      final isSuccess = await AdventureService.createAdventure(
          nameAr: nameAr,
          nameEn: nameEn,
          nameZh: nameZh,
          daysInfo: daysInfo,
          //  date: date,
          descriptionAr: descriptionAr,
          descriptionEn: descriptionEn,
          descriptionZh: descriptionZh,
          priceIncludesAr: priceIncludesAr,
          priceIncludesEn: priceIncludesEn,
          priceIncludesZh: priceIncludesZh,
          longitude: longitude,
          latitude: latitude,
          price: price,
          image: image,
          regionAr: regionAr,
          locationUrl: locationUrl,
          regionEn: regionEn,
          // times: times,
          // start: start,
          // end: end,
          seat: seat,
          context: context);

      return isSuccess;
    } catch (e) {
      log(e.toString());
      return false;
    } finally {
      isAdventureLoading(false);
    }
  }

  var isEditAdveentureLoading = false.obs;
  Future<Adventure?> editAdventure({
    required String id,
    required String nameAr,
    required String nameEn,
    required String nameZh,
    required String descriptionAr,
    required String descriptionEn,
    required String descriptionZh,
    List<String>? priceIncludesEn,
    List<String>? priceIncludesAr,
    List<String>? priceIncludesZh,
    required String longitude,
    required String latitude,
    required int price,
    required List<String> image,
    required String regionAr,
    required String locationUrl,
    required String regionEn,
    String? Genre,
    // required List<Map<String, dynamic>> times,
    required List<Map<String, dynamic>> daysinfo,
    required BuildContext context,
  }) async {
    try {
      isEditAdveentureLoading(true);

      final adventure = await AdventureService.editAdventure(
          daysInfo: daysinfo,
          id: id,
          nameAr: nameAr,
          nameEn: nameEn,
          nameZh: nameZh,
          descriptionAr: descriptionAr,
          descriptionEn: descriptionEn,
          descriptionZh: descriptionZh,
          priceIncludesAr: priceIncludesAr,
          priceIncludesEn: priceIncludesEn,
          priceIncludesZh: priceIncludesZh,
          longitude: longitude,
          latitude: latitude,
          price: price,
          image: image,
          regionAr: regionAr,
          locationUrl: locationUrl,
          regionEn: regionEn,
          // times: times,
          Genre: Genre,
          context: context);
      if (adventure != null) {
        return adventure;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      isEditAdveentureLoading(false);
    }
  }

  Future<List<Adventure>?> getUpcommingTicket({
    required BuildContext context,
  }) async {
    try {
      isUpcommingTicketLoading(true);

      final data = await AdventureService.getUserTicket(
        adventureType: 'UPCOMING',
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

  Future<List<Adventure>?> getPastTicket({
    required BuildContext context,
  }) async {
    try {
      isPastTicketLoading(true);

      final data = await AdventureService.getUserTicket(
        adventureType: 'PAST',
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

  var isAdventureDeleteLoading = false.obs;
  Future<bool?> AdventureDelete(
      {required BuildContext context, required String adventureId}) async {
    try {
      isAdventureDeleteLoading(true);
      final data = await AdventureService.AdventureDelete(
          context: context, adventureId: adventureId);

      isAdventureDeleteLoading(data ?? false);
      return isAdventureDeleteLoading.value;
    } catch (e) {
      log("-< AdventurwDeleteLoading >- $e");
      return null;
    } finally {
      isAdventureDeleteLoading(false);
    }
  }

  Future<AdventureSummary?> getAdventureSummaryById({
    required BuildContext context,
    required String id,
    required String date,
  }) async {
    try {
      isAdventureByIdLoading(true);
      final data = await AdventureService.getAdventureSummaryById(
          date: date, context: context, id: id);
      return data;
    } catch (e) {
      isAdventureByIdLoading(false);
      return null;
    } finally {
      isAdventureByIdLoading(false);
    }
  }

  // bool checkForOneHour({required BuildContext context, date, time}) {
  //   final parsedDate = DateTime.parse(date);
  //   log(date);
  //   log(time);
  //   if (parsedDate.year == parsedDate.year &&
  //       parsedDate.month == parsedDate.month &&
  //       parsedDate.day == parsedDate.day) {
  //     final isValid = AppUtil.isAdventureTimeDifferenceOneHour(time);
  //     if (isValid) {
  //       return true;
  //     } else {
  //       AppUtil.errorToast(
  //           context,
  //           AppUtil.rtlDirection2(context)
  //               ? "لا يمكنك الحجز اليوم لأن موعد التجربة بعد ساعة من الآن"
  //               : "You cannot book today because the experience is after  1 hour from now.");

  //       return false;
  //     }
  //   } else {
  //     return true;
  //   }
  // }

  bool checkForOneHour({required BuildContext context}) {
    log(startTime.value);
    log(selectedDate.value);
    log((AppUtil.areDatesOnSameDay(startTime.value, selectedDate.value))
        .toString());
    if (AppUtil.areDatesOnSameDay(startTime.value, selectedDate.value)) {
      final isValid = AppUtil.isTimeDifferenceOneHour(startTime.value);
      if (isValid) {
        return true;
      } else {
        AppUtil.errorToast(context, "checkForOneOur".tr);

        return false;
      }
    } else {
      log('hj');
      return true;
    }
  }
}
