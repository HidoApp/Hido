import 'package:ajwad_v4/services/model/regions.dart';
import 'package:ajwad_v4/services/service/regions_service.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegionsController extends GetxController {
  var isRegionsLoading = false.obs;
  var regionsHospitalty = Regions().obs;
  var regionsAdventure = Regions().obs;
  var regionsEvent = Regions().obs;
  var selectedHospitaltyIndex = 0.obs;
  var selectedAdventureIndex = 0.obs;
  var selectedEventIndex = 0.obs;
  Future<Regions?> getRegions({
    required BuildContext context,
    required String regionType,
  }) async {
    try {
      isRegionsLoading(true);
      var data = await RegionsServices.getRegions(
          context: context, regionType: regionType);
      if (regionType == ('ADVENTURE')) {
        regionsAdventure(data);
      } else if (regionType == "EVENT") {
        regionsEvent(data);
      } else {
        regionsHospitalty(data);
      }
      return data;
    } catch (e) {
      isRegionsLoading(false);
      AppUtil.errorToast(context, e.toString());
    } finally {
      isRegionsLoading(false);
    }
    return null;
  }
}
