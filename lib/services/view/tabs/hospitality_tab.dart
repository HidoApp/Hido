import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/serivces_controller.dart';
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
  const HospitalityTab({super.key, required this.isAviailable});
  final bool isAviailable;

  @override
  State<HospitalityTab> createState() => _HospitalityTabState();
}

class _HospitalityTabState extends State<HospitalityTab> {
  SrvicesController _srvicesController = Get.put(SrvicesController());
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Obx(
        () => Column(
          children: [
            //Ad cards
            const AdCards(),
            const SizedBox(
              height: 20,
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
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 5,
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                      itemBuilder: (context, index) => CityChips(
                            city: index == 0 ? 'All' : "Makkah",
                          )),
                ),
                const SizedBox(
                  height: 10,
                ),
                _srvicesController.isHospitalityLoading.value
                    ? SizedBox(
                        height: height * 0.4,
                        width: width,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: purple,
                        )))
                    : ListView.separated(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _srvicesController.hospitalityList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            //hospitality
                            child: CustomHospitalityItem(
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
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 16,
                          );
                        },
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
