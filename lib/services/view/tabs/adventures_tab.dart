import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/regions_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/service/adventure_service.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/widgets/custom_adventure_item.dart';
import 'package:ajwad_v4/services/view/widgets/custom_city_item.dart';
import 'package:ajwad_v4/utils/app_util.dart';
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
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      // padding: EdgeInsets.symmetric(
      //     horizontal: width * 0.04, vertical: width * 0.035),
      child: Column(
        children: [
          //Ad cards
          const AdCards(),
          SizedBox(
            height: width * 0.085,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'saudiAdventure'.tr,
                    color: Color(0xFF070708),
                    fontSize: 17,
                    fontFamily: 'HT Rakik',
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.05,
              ),
              //cities list view
              SizedBox(
                height: width * 0.080,
                child: Obx(
                  () => !_regionsController.isRegionsLoading.value
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: _regionsController
                                  .regionsHospitalty.value.regionEn!.length +
                              1,
                          separatorBuilder: (context, index) => SizedBox(
                            width: width * 0.025,
                          ),
                          itemBuilder: (context, index) => Obx(
                            () => GestureDetector(
                              onTap: () {
                                if (index !=
                                    _regionsController.selectedAdventureIndex
                                        .value) // for handle user clicks
                                {
                                  _regionsController
                                      .selectedAdventureIndex.value = index;
                                  print(_regionsController
                                      .regionsAdventure
                                      .value
                                      .regionAr![index != 0 ? index - 1 : 0]);
                                  if (index == 0) {
                                    _adventureController.getAdvdentureList(
                                        context: context);
                                  } else {
                                    _adventureController.getAdvdentureList(
                                        context: context,
                                        region: index != 0
                                            ? AppUtil.rtlDirection2(context)
                                                ? _regionsController
                                                        .regionsHospitalty
                                                        .value
                                                        .regionAr![
                                                    index != 0 ? index - 1 : 0]
                                                : _regionsController
                                                        .regionsHospitalty
                                                        .value
                                                        .regionEn![
                                                    index != 0 ? index - 1 : 0]
                                            : null);
                                  }
                                }
                              },
                              child: CustomChips(
                                borderColor: _regionsController
                                            .selectedAdventureIndex.value ==
                                        index
                                    ? colorGreen
                                    : almostGrey,
                                backgroundColor: _regionsController
                                            .selectedAdventureIndex.value ==
                                        index
                                    ? colorGreen
                                    : Colors.transparent,
                                textColor: _regionsController
                                            .selectedAdventureIndex.value ==
                                        index
                                    ? Colors.white
                                    : almostGrey,
                                title: index == 0
                                    ? 'all'.tr
                                    : AppUtil.rtlDirection2(context)
                                        ? _regionsController.regionsHospitalty
                                            .value.regionAr![index - 1]
                                        : _regionsController.regionsHospitalty
                                            .value.regionEn![index - 1],
                              ),
                            ),
                          ),
                        )
                      : const CircularProgressIndicator.adaptive(),
                ),
              ),
              SizedBox(
                height: width * 0.06,
              ),
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
                    : Obx(
                        () => ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _adventureController.adventureList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              // card for any services Hospitality,Adventure etc ..
                              child: CustomAdventureItem(
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
                                    .adventureList[index].coordinates?.latitude,
                                long:_adventureController
                                    .adventureList[index].coordinates?.longitude,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: width * 0.041,
                            );
                          },
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
