import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/event_details.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/services/view/widgets/ad_cards.dart';
import 'package:ajwad_v4/services/view/widgets/city_chips.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _srvicesController.getAllHospitality(context: context);
  }

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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'saudiHospitality'.tr,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                //cities list view
                SizedBox(
                  height: width * 0.087,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 10,
                    separatorBuilder: (context, index) => SizedBox(
                      width: width * 0.025,
                    ),
                    itemBuilder: (context, index) => CityChips(
                      city: index == 0 ? 'All' : "Makkah",
                    ),
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
                              location: _srvicesController
                                  .hospitalityList[index].region,
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
                            return const SizedBox(
                              height: 16,
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
