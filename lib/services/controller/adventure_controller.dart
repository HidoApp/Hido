import 'dart:developer';

import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/service/adventure_service.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdventureController extends GetxController {
  var adventureList = <Adventure>[].obs;
  var isAdventureListLoading = false.obs;
  var isAdventureByIdLoading = false.obs;
  Future<List<Adventure>?> getAdvdentureList(
      {required BuildContext context}) async {
    try {
      isAdventureListLoading(true);
      final data = await AdventureService.getAdvdentureList(context: context);
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
}
