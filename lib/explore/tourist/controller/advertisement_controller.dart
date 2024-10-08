import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/explore/tourist/model/advertisement.dart';
import 'package:ajwad_v4/explore/tourist/service/advertisement_service.dart';
import 'package:ajwad_v4/payment/model/payment_result.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/model/payment.dart';
import 'package:ajwad_v4/services/service/adventure_service.dart';
import 'package:ajwad_v4/services/service/hospitality_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';


class AdvertisementController extends GetxController {
  
  var isAdvertisementLoading = true.obs;
  var upcommingTicket = <Hospitality>[].obs;
  var pastTicket = <Hospitality>[].obs;
 
  var isAdvertisementByIdLoading = false.obs;

  var advertisementList = <Advertisement>[].obs;

 
  Future<RxList<Advertisement>?> getAllAdvertisement(
      {required BuildContext context}) async {
    try {
      isAdvertisementLoading(true);
      final data = await AdvertisementService.getAllAdvertisement(
          context: context);
      if (data != null) {
       advertisementList(data);
      }
      return advertisementList;
    } catch (e) {
      isAdvertisementLoading(false);
      return null;
    } finally {
      isAdvertisementLoading(false);
    }
  }

  Future<Advertisement?> getAdvertisementById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      isAdvertisementByIdLoading(true);
      final data =
          await  AdvertisementService.getAdvertisementById(context: context, id: id);
      return data;
    } catch (e) {
      isAdvertisementByIdLoading(false);
      return null;
    } finally {
      isAdvertisementByIdLoading(false);
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
}