import 'dart:developer';

import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/service/adventure_service.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdventureController extends GetxController {
  var adventureList = <Adventure>[].obs;
  var isAdventureListLoading = false.obs;
  var isAdventureByIdLoading = false.obs;
  var ischeckBookingLoading = false.obs;
  Future<List<Adventure>?> getAdvdentureList(
      {required BuildContext context, String? region}) async {
    try {
      isAdventureListLoading(true);
      final data = await AdventureService.getAdvdentureList(
          context: context, region: region);
      if (data != null) {
        adventureList(data);
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
      String? invoiceId,
      required int personNumber}) async {
    try {
      ischeckBookingLoading(true);
      final data = await AdventureService.checkAdventureBooking(
          context: context,
          adventureID: adventureID,
          personNumber: personNumber,
          invoiceId: invoiceId);
          print("Date of adventure");
          print(data);
      return data;
    } catch (e) {
      // AppUtil.errorToast(context, e.toString());
      ischeckBookingLoading(false);
      return false;
    } finally {
      ischeckBookingLoading(false);
    }
  }
}
