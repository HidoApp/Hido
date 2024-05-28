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
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    _regionsController.getRegions(context: context, regionType: "HOSPITALITY");
  }

  var selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        //TODO: Rehab you must replace padding in adventure screen with these values
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: width * 0.035),
        child: Column(
          children: [
            //Ad cards
            const AdCards(),
            SizedBox(
              height: width * 0.051,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'saudiHospitality'.tr,
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                //cities list view
                SizedBox(
                  height: width * 0.087,
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
                                      _regionsController.selectedHospitaltyIndex
                                          .value) // for handle user clicks
                                  {
                                    _regionsController
                                        .selectedHospitaltyIndex.value = index;
                                    print(_regionsController
                                        .regionsHospitalty
                                        .value
                                        .regionEn![index != 0 ? index - 1 : 0]);
                                    if (index == 0) {
                                      _srvicesController.getAllHospitality(
                                          context: context);
                                    } else {
                                      _srvicesController.getAllHospitality(
                                          context: context,
                                          region: index != 0
                                              ? _regionsController
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
                                              .selectedHospitaltyIndex.value ==
                                          index
                                      ? colorDarkGreen
                                      : almostGrey,
                                  backgroundColor: _regionsController
                                              .selectedHospitaltyIndex.value ==
                                          index
                                      ? colorGreen
                                      : Colors.transparent,
                                  textColor: _regionsController
                                              .selectedHospitaltyIndex.value ==
                                          index
                                      ? Colors.white
                                      : almostGrey,
                                  title: index == 0
                                      ? 'All'
                                      : _regionsController.regionsHospitalty
                                          .value.regionEn![index - 1],
                                ),
                              ),
                            ),
                          )
                        : CircularProgressIndicator.adaptive(),
                  ),
                ),
                SizedBox(
                  height: width * 0.05,
                ),
                Obx(
                  () => _srvicesController.isHospitalityLoading.value
                      ? //if list is loading
                      SizedBox(
                          height: height * 0.4,
                          width: width,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      //List of hospitalities
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _srvicesController.hospitalityList.length,
                          itemBuilder: (context, index) {
                            return ServicesCard(
                              onTap: () {
                                Get.to(() => HospitalityDetails(
                                      hospitalityId: _srvicesController
                                          .hospitalityList[index].id,
                                    ));
                              },
                              image: _srvicesController
                                  .hospitalityList[index].images[0],
                              personImage: _srvicesController
                                  .hospitalityList[index].familyImage,
                              title: !AppUtil.rtlDirection(context)
                                  ? _srvicesController
                                      .hospitalityList[index].titleAr
                                  : _srvicesController
                                      .hospitalityList[index].titleEn,
                              location: AppUtil.rtlDirection2(context)
                                  ? _srvicesController
                                          .hospitalityList[index].regionAr ??
                                      ""
                                  : _srvicesController
                                      .hospitalityList[index].regionEn,
                              meal: !AppUtil.rtlDirection(context)
                                  ? _srvicesController
                                      .hospitalityList[index].mealTypeAr
                                  : _srvicesController
                                      .hospitalityList[index].mealTypeEn,
                              category: AppUtil.rtlDirection(context)
                                  ? _srvicesController
                                      .hospitalityList[index].categoryAr
                                  : _srvicesController
                                      .hospitalityList[index].categoryEn,
                              rate: '4.7',
                              dayInfo: _srvicesController
                                  .hospitalityList[index].daysInfo,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: width * 0.041,
                            );
                          },
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
