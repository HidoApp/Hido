import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/controller/regions_controller.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/event_details.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/services/view/widgets/ad_cards.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/services/view/widgets/custom_hospitality_item.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HospitalityTab extends StatefulWidget {
  const HospitalityTab({
    super.key,
  });

  @override
  State<HospitalityTab> createState() => _HospitalityTabState();
}

class _HospitalityTabState extends State<HospitalityTab> {
  final _srvicesController = Get.put(HospitalityController());
  final _regionsController = Get.put(RegionsController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _srvicesController.getAllHospitality(context: context);
  }

  @override
  void dispose() {
    // _regionsController.selectedHospitaltyIndex(0);
    // TODO: implement dispose
    super.dispose();
  }

  var selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        // padding: EdgeInsets.symmetric(
        //     horizontal: width * 0.04, vertical: width * 0.035),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 32),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.041),
                  child: Obx(() => Skeletonizer(
                        enabled: _srvicesController.isHospitalityLoading.value,
                        child: _srvicesController.hospitalityList.isNotEmpty
                            ? ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    _srvicesController.hospitalityList.length,
                                itemBuilder: (context, index) {
                                  return ServicesCard(
                                      onTap: () {
                                        Get.to(() => HospitalityDetails(
                                              hospitalityId: _srvicesController
                                                  .hospitalityList[index].id,
                                            ));
                                      },
                                      image: _srvicesController
                                          .hospitalityList[index].images.first,
                                      personImage: _srvicesController
                                          .hospitalityList[index]
                                          .user
                                          .profile
                                          .image,
                                      title: AppUtil.rtlDirection2(context)
                                          ? _srvicesController
                                              .hospitalityList[index].titleAr
                                          : _srvicesController
                                              .hospitalityList[index].titleEn,
                                      location: AppUtil.rtlDirection2(context)
                                          ? _srvicesController.hospitalityList[index].regionAr ??
                                              ""
                                          : _srvicesController
                                              .hospitalityList[index].regionEn,
                                      meal: AppUtil.rtlDirection2(context)
                                          ? _srvicesController
                                              .hospitalityList[index].mealTypeAr
                                          : AppUtil.capitalizeFirstLetter(_srvicesController
                                              .hospitalityList[index]
                                              .mealTypeEn),
                                      category: AppUtil.rtlDirection(context)
                                          ? _srvicesController
                                              .hospitalityList[index].categoryAr
                                          : _srvicesController
                                              .hospitalityList[index]
                                              .categoryEn,
                                      rate: '4.7',
                                      dayInfo: _srvicesController
                                          .hospitalityList[index].daysInfo,
                                      lang: _srvicesController
                                              .hospitalityList[index]
                                              .coordinate
                                              .latitude ??
                                          '',
                                      long: _srvicesController
                                              .hospitalityList[index]
                                              .coordinate
                                              .longitude ??
                                          '');
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
                                    // image: "",
                                    subtitle: 'noExperiencesSubtitle'.tr,
                                  ),
                                ),
                              ),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
