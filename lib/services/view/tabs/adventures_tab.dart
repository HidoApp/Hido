import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/request/ajwadi/view/widget/empty_request.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/regions_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/service/adventure_service.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/widgets/custom_adventure_item.dart';
import 'package:ajwad_v4/services/view/widgets/custom_city_item.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ajwad_v4/services/controller/hospitality_controller.dart';

import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/services/view/widgets/ad_cards.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/services/view/widgets/custom_hospitality_item.dart';
import 'package:ajwad_v4/services/view/widgets/custom_adventure_item.dart';

class AdventuresTab extends StatefulWidget {
  const AdventuresTab({
    super.key,
  });

  @override
  State<AdventuresTab> createState() => _AdventuresTabState();
}

class _AdventuresTabState extends State<AdventuresTab> {
  // final _srvicesController = Get.put(HospitalityController());
  final _adventureController = Get.put(AdventureController());
  List<Adventure>? adventureList;
  void getAdvdentureList() async {
    adventureList =
        await _adventureController.getAdvdentureList(context: context);
    // print("ADV ID : ${_adventureController.adventureList[0].id}");
  }

  final _regionsController = Get.put(RegionsController(), tag: 'tag');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdvdentureList();
    _regionsController.getRegions(context: context, regionType: "ADVENTURE");
  }

  @override
  void dispose() {
    _regionsController.selectedAdventureIndex(0);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 32),
      // padding: EdgeInsets.symmetric(
      //     horizontal: width * 0.04, vertical: width * 0.035),
      child: Column(
        children: [
          //Ad cards
          // const AdCards(),
          // SizedBox(
          //   height: width * 0.085,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => _adventureController.isAdventureListLoading.value
                    ? //if list is loading
                    SizedBox(
                        height: height * 0.4,
                        width: width,
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      )
                    //List of hospitalities
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Obx(
                          () => _adventureController.adventureList.isNotEmpty
                              ? ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      _adventureController.adventureList.length,
                                  itemBuilder: (context, index) {
                                    return CustomAdventureItem(
                                      onTap: () {
                                        Get.to(() => AdventureDetails(
                                              adventureId: _adventureController
                                                  .adventureList[index].id,
                                            ));
                                      },
                                      image: _adventureController
                                          .adventureList[index].image![0],
                                      date: _adventureController
                                          .adventureList[index].date!,
                                      title: !AppUtil.rtlDirection(context)
                                          ? _adventureController
                                              .adventureList[index].nameAr!
                                          : _adventureController
                                              .adventureList[index].nameEn!,
                                      location: AppUtil.rtlDirection2(context)
                                          ? _adventureController
                                              .adventureList[index].regionAr!
                                          : _adventureController
                                              .adventureList[index].regionEn!,
                                      seats: _adventureController
                                          .adventureList[index].seats
                                          .toString(),
                                      times: _adventureController
                                          .adventureList[index].times,
                                      rate: '4.7',
                                      lang: _adventureController
                                          .adventureList[index]
                                          .coordinates
                                          ?.latitude,
                                      long: _adventureController
                                          .adventureList[index]
                                          .coordinates
                                          ?.longitude,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: width * 0.041,
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Center(
                                    child: CustomEmptyWidget(
                                      title: "noExperiences".tr,
                                      //    image: "",
                                      subtitle: 'noExperiencesSubtitle'.tr,
                                    ),
                                  ),
                                ),
                        ),
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
