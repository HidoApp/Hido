
import 'package:ajwad_v4/explore/tourist/model/advertisement.dart';
import 'package:ajwad_v4/explore/tourist/service/advertisement_service.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class AdvertisementController extends GetxController {
  
  var isAdvertisementLoading = false.obs;
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
      isAdvertisementLoading(false);
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