import 'dart:developer';

import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/service/adventure_service.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventController extends GetxController {
  var EventList = <Adventure>[].obs;
  var isEventListLoading = false.obs;
  var isEventByIdLoading = false.obs;
  var ischeckBookingLoading = false.obs;
  var  selectedImages=<String>[].obs;


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


  var isEventDateSelcted = false.obs;
  var isEventTimeSelcted = false.obs;

  // Rx<LatLng> pickUpLocLatLang = const LatLng(24.9470921, 45.9903698).obs;
  //  Rx<LatLng> pickUpLocLatLang = const LatLng(24.6264,46.544731).obs; 
   Rx<LatLng> pickUpLocLatLang = const LatLng(24.788299,46.631608).obs;









//   Future<List<Adventure>?> getAdvdentureList(
//       {required BuildContext context, String? region}) async {
//     try {
//       isAdventureListLoading(true);
//       final data = await AdventureService.getAdvdentureList(
//           context: context, region: region);
//       if (data != null) {
//         adventureList(data);
//       }
//       return adventureList;
//     } catch (e) {
//       isAdventureListLoading(false);
//       if (context.mounted) {
//         AppUtil.errorToast(context, e.toString());
//       }
//       return null;
//     } finally {
//       isAdventureListLoading(false);
//     }
//   }

//   Future<Adventure?> getAdvdentureById({
//     required BuildContext context,
//     required String id,
//   }) async {
//     try {
//       isAdventureByIdLoading(true);
//       final data =
//           await AdventureService.getAdvdentureById(context: context, id: id);
//       return data;
//     } catch (e) {
//       isAdventureByIdLoading(false);
//       if (context.mounted) {
//         AppUtil.errorToast(context, e.toString());
//       }
//       return null;
//     } finally {
//       isAdventureByIdLoading(false);
//     }
//   }

//   Future<bool> checkAdventureBooking(
//       {required BuildContext context,
//       required String adventureID,
//       String? invoiceId,
//       required int personNumber}) async {
//     try {
//       ischeckBookingLoading(true);
//       final data = await AdventureService.checkAdventureBooking(
//           context: context,
//           adventureID: adventureID,
//           personNumber: personNumber,
//           invoiceId: invoiceId);

//       return data;
//     } catch (e) {
//       // AppUtil.errorToast(context, e.toString());
//       ischeckBookingLoading(false);
//       return false;
//     } finally {
//       ischeckBookingLoading(false);
//     }
//   }

//     var isAdventureLoading = false.obs;

//   Future<bool> createAdventure({
  
//     required String nameAr,
//     required String nameEn,
//     required String descriptionAr,
//     required String descriptionEn,
//     required String longitude,
//     required String latitude,
//     required String date,
//     required int price,
//     required List<String> image,
//     required String regionAr,
//     required String locationUrl,
//     required String regionEn,
//     // required List<Map<String, dynamic>> times,
//     required String start,
//     required String end,
//     required int seat,
//     required BuildContext context,
//   }) async {
//     //print(rememberMe);
//     try {
//       isAdventureLoading(true);
//       final isSuccess = await AdventureService.createAdventure(
//           nameAr: nameAr,
//           nameEn: nameEn,
//           date:date,
//           descriptionAr: descriptionAr,
//           descriptionEn: descriptionEn,
//           longitude: longitude,
//           latitude: latitude,
//           price: price,
//           image: image,
//           regionAr: regionAr,
//           locationUrl: locationUrl,
//           regionEn: regionEn,
//           // times: times,
//           start: start,
//           end: end,
//           seat: seat,
//           context: context
          
//           );

//       print(isSuccess);
//       return isSuccess;
//     } catch (e) {
//       return false;
//     } finally {
//       isAdventureLoading(false);
//     }
//   }


//     var  isEditAdveentureLoading = false.obs;
//   Future<Adventure?> editAdventure({
//     required String id,
//     required String nameAr,
//     required String nameEn,
//     required String descriptionAr,
//     required String descriptionEn,
//     required String longitude,
//     required String latitude,
//     required String date,
//     required int price,
//     required List<String> image,
//     required String regionAr,
//     required String locationUrl,
//     required String regionEn,
//     String?Genre,
//     // required List<Map<String, dynamic>> times,
//     required String start,
//     required String end,
//     required int seat,
//     required BuildContext context,
//   }) async {
//     try {
//       isEditAdveentureLoading(true);

//       final adventure = await AdventureService.editAdventure(
//           id: id,
//          nameAr: nameAr,
//           nameEn: nameEn,
//           date:date,
//           descriptionAr: descriptionAr,
//           descriptionEn: descriptionEn,
//           longitude: longitude,
//           latitude: latitude,
//           price: price,
//           image: image,
//           regionAr: regionAr,
//           locationUrl: locationUrl,
//           regionEn: regionEn,
//           // times: times,
//           start: start,
//           end: end,
//           seat: seat,
//           Genre: Genre,
//           context: context
//       );
//       if (adventure != null) {
//         return adventure;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print(e);
//       return null;
//     } finally {
//        isEditAdveentureLoading(false);
//     }
//   }

//    Future<List<Adventure>?> getUpcommingTicket({
//     required BuildContext context,
//   }) async {
//     try {
//       isUpcommingTicketLoading(true);

//       final data = await AdventureService.getUserTicket(
//         adventureType: 'UPCOMING',
//         context: context,
//       );
//       if (data != null) {
//         upcommingTicket(data);
//          print("object controller");
//        print(data.length);
//         //print(upcommingTicket.first.place?.nameAr);
//         return upcommingTicket;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       isUpcommingTicketLoading(false);
//       print(e);
//       return null;
//     } finally {
//       isUpcommingTicketLoading(false);
//     }
//   }

//    Future<List<Adventure>?> getPastTicket({
//     required BuildContext context,
//   }) async {
//     try {
//       isPastTicketLoading(true);

//       final data = await AdventureService.getUserTicket(
//          adventureType:'PAST',
//         context: context,
//       );
//       print("this pas 1ticket");

//       if (data != null) {
//         print("this pas ticket");
//         pastTicket(data);
//         return pastTicket;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       isPastTicketLoading(false);
//       print(e);
//       return null;
//     } finally {
//       isPastTicketLoading(false);
//     }
//   }


//  var isAdventureDeleteLoading = false.obs;
//   Future<bool?> AdventureDelete(
//       {required BuildContext context, required String adventureId}) async {
//     try {
//       isAdventureDeleteLoading(true);
//       final data = await AdventureService.AdventureDelete(
//           context: context,adventureId: adventureId);
//   isAdventureDeleteLoading(data ?? false);
//       return isAdventureDeleteLoading.value;
//     } catch (e) {
//       log("-< HospitalityDeleteLoading >- $e");
//       return null;
//     } finally {
//      isAdventureDeleteLoading(false);
//     }
//   }
  
}