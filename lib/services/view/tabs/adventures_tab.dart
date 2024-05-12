import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/widgets/custom_adventure_item.dart';
import 'package:ajwad_v4/services/view/widgets/custom_city_item.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ajwad_v4/services/controller/serivces_controller.dart';

import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/services/view/widgets/ad_cards.dart';
import 'package:ajwad_v4/services/view/widgets/city_chips.dart';
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
  final _srvicesController = Get.put(SrvicesController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _srvicesController.getAllHospitality(context: context);
  }

  // @override
  // Widget build(BuildContext context) {
  //       final double height = MediaQuery.of(context).size.height;
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(20),
  //     child: isAviailable
  //         ? Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   CustomText(
  //                     text: 'where'.tr,
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                   CustomText(
  //                     text: 'seeAll'.tr,
  //                     fontSize: 10,
  //                     fontWeight: FontWeight.w400,
  //                     color: colorDarkGrey,
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               SizedBox(
  //                 height: 100,
  //                 child: ListView.separated(
  //                   shrinkWrap: true,
  //                   scrollDirection: Axis.horizontal,
  //                   itemCount: 4,
  //                   separatorBuilder: (context, index) {
  //                     return const SizedBox(
  //                       width: 24,
  //                     );
  //                   },
  //                   itemBuilder: (context, index) {
  //                     return CustomCityItem(
  //                         image: 'assets/images/tabuk.png',
  //                         title:
  //                             AppUtil.rtlDirection(context) ? 'تبوك' : 'Tabuk');
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   CustomText(
  //                     text: 'cultureSights'.tr,
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                   CustomText(
  //                     text: 'seeAll'.tr,
  //                     fontSize: 10,
  //                     fontWeight: FontWeight.w400,
  //                     color: colorDarkGrey,
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 300,
  //                 child: ListView.separated(
  //                   scrollDirection: Axis.horizontal,
  //                   shrinkWrap: true,
  //                   itemCount: 4,
  //                   itemBuilder: (context, index) {
  //                     return CustomAdventureItem(
  //                       onTap: () {
  //                         Get.to(() => AdventureDetails());
  //                       },
  //                       title: AppUtil.rtlDirection(context)
  //                           ? 'ربع الخالي'
  //                           : 'Empty Quarter',
  //                       rate: '4.7',
  //                       location: AppUtil.rtlDirection(context)
  //                           ? 'ربع الخالي، المملكة العربية السعودية'
  //                           : 'Empty Quarter, Saudi Arabia',
  //                       description: AppUtil.rtlDirection(context)
  //                           ? 'الربع الخالي عبارة عن صحراء رملية تغطي معظم الجنوب.'
  //                           : 'The Rub\' al Khali is the sand desert encompassing most of the southern ..',
  //                     );
  //                   },
  //                   separatorBuilder: (context, index) {
  //                     return const SizedBox(
  //                       width: 25,
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           )
  //         : Column(
  //             children: [
  //               SizedBox(
  //                 height: height * 0.04,
  //               ),
  //               // Image.asset(
  //               //   'assets/images/hido_logo.png',
  //               //   color: pink,
  //               // ),
  //               // SizedBox(
  //               //   height: height * 0.02,
  //               // ),
  //               CustomText(
  //                 text: 'commingSoon'.tr,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w200,
  //                 textAlign: TextAlign.center,
  //                 color: colorDarkGrey,
  //               )
  //             ],
  //           ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: width * 0.035),
      child: Column(
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
                    text: 'saudi Adventure'.tr,
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
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 10,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  itemBuilder: (context, index) => CityChips(
                    city: index == 0 ? 'All' : "Makkah",
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => _srvicesController.isHospitalityLoading.value
                    ? //if list is loading
                    SizedBox(
                        height: height * 0.4,
                        width: width,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: purple,
                          ),
                        ),
                      )
                    //List of hospitalities
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _srvicesController.hospitalityList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            // card for any services Hospitality,Adventure etc ..
                            child: CustomAdventureItem(
                              onTap: () {
                                Get.to(() => AdventureDetails(
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
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
