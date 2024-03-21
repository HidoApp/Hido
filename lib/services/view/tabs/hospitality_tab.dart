import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/serivces_controller.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/services/view/widgets/custom_hospitality_item.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
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
      padding: const EdgeInsets.all(20),
      child: Obx(() =>
         Column(
          children: [
            Container(
              width: width,
              decoration: BoxDecoration(
                color: purple.withOpacity(0.16),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      if (!AppUtil.rtlDirection(context))
                        Image.asset('assets/images/percent.png'),
                      Padding(
                        padding: EdgeInsets.only(
                          right: !AppUtil.rtlDirection(context) ? 22 : 0,
                          left: !AppUtil.rtlDirection(context) ? 0 : 22,
                          top: 22,
                          bottom: 17,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: !AppUtil.rtlDirection(context)
                                      ? 'خصومات حصرية لضيوف\n'
                                      : 'Exclusive Discounts for\n',
                                  style: TextStyle(
                                    fontFamily: !AppUtil.rtlDirection(context)
                                        ? 'Noto Kufi Arabic'
                                        : 'Kufam',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: black,
                                  ),
                                ),
                                TextSpan(
                                  text: !AppUtil.rtlDirection(context)
                                      ? 'هوليداي إن!'
                                      : 'Holiday Inn ',
                                  style: TextStyle(
                                    fontFamily: AppUtil.rtlDirection(context)
                                        ? 'Noto Kufi Arabic'
                                        : 'Kufam',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: black,
                                  ),
                                ),
                                TextSpan(
                                  text: AppUtil.rtlDirection(context)
                                      ? ''
                                      : 'Guests!',
                                  style: const TextStyle(
                                    fontFamily: 'Kufam',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: black,
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomText(
                              text: 'happyExploring'.tr,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: colorDarkGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      if (AppUtil.rtlDirection(context))
                        Image.asset('assets/images/percent.png'),
                      Image.asset(
                        'assets/images/holiday.png',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            widget.isAviailable
                ? Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     CustomText(
                      //       text: 'where'.tr,
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //     CustomText(
                      //       text: 'seeAll'.tr,
                      //       fontSize: 10,
                      //       fontWeight: FontWeight.w400,
                      //       color: colorDarkGrey,
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // SizedBox(
                      //   height: 100,
                      //   child: ListView.separated(
                      //     shrinkWrap: true,
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: 4,
                      //     separatorBuilder: (context, index) {
                      //       return const SizedBox(
                      //         width: 24,
                      //       );
                      //     },
                      //     itemBuilder: (context, index) {
                      //       return CustomCityItem(
                      //           image: 'assets/images/tabuk.png',
                      //           title: AppUtil.rtlDirection(context)
                      //               ? 'تبوك'
                      //               : 'Tabuk');
                      //     },
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'saudiHospitality'.tr,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          // CustomText(
                          //   text: 'seeAll'.tr,
                          //   fontSize: 10,
                          //   fontWeight: FontWeight.w400,
                          //   color: colorDarkGrey,
                          // ),
                        ],
                      ),
                      _srvicesController.isHospitalityLoading.value ?
                      
                      SizedBox(
                        height: height*0.4,
                        width: width,
                        child: Center(child: CircularProgressIndicator(color: purple,)))
                      : ListView.separated(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _srvicesController.hospitalityList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: CustomHospitalityItem(
                              image: _srvicesController.hospitalityList[index].images[0],
                              personImage: _srvicesController.hospitalityList[index].familyImage,
                              title: !AppUtil.rtlDirection(context)
                                  ? _srvicesController.hospitalityList[index].titleAr
                                  : _srvicesController.hospitalityList[index].titleEn,
                              location:  _srvicesController.hospitalityList[index].region,
                                
                              meal: !AppUtil.rtlDirection(context)
                                  ? _srvicesController.hospitalityList[index].mealTypeAr
                                  : _srvicesController.hospitalityList[index].mealTypeEn,
                              category: AppUtil.rtlDirection(context)
                                  ? _srvicesController.hospitalityList[index].categoryAr
                                  : _srvicesController.hospitalityList[index].categoryEn,
                              rate: '4.7',
                              onTap: () {
                                Get.to(() => HospitalityDetails(hospitalityId:_srvicesController.hospitalityList[index].id ,));
                              },
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
                : Column(
                    children: [
                      SizedBox(
                        height: height * 0.04,
                      ),
                      // Image.asset(
                      //   'assets/images/hido_logo.png',
                      //   color: purple,
                      // ),
                      // SizedBox(
                      //   height: height * 0.02,
                      // ),
                      CustomText(
                        text: 'commingSoon'.tr,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        textAlign: TextAlign.center,
                        color: colorDarkGrey,
                      )
                    ],
                  ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     CustomText(
            //       text: 'where'.tr,
            //       fontSize: 20,
            //       fontWeight: FontWeight.w700,
            //     ),
            //     CustomText(
            //       text: 'seeAll'.tr,
            //       fontSize: 10,
            //       fontWeight: FontWeight.w400,
            //       color: colorDarkGrey,
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // SizedBox(
            //   height: 100,
            //   child: ListView.separated(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 4,
            //     separatorBuilder: (context, index) {
            //       return const SizedBox(
            //         width: 24,
            //       );
            //     },
            //     itemBuilder: (context, index) {
            //       return CustomCityItem(
            //           image: 'assets/images/tabuk.png',
            //           title: AppUtil.rtlDirection(context) ? 'تبوك' : 'Tabuk');
            //     },
            //   ),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     CustomText(
            //       text: 'saudiHospitality'.tr,
            //       fontSize: 20,
            //       fontWeight: FontWeight.w700,
            //     ),
            //     CustomText(
            //       text: 'seeAll'.tr,
            //       fontSize: 10,
            //       fontWeight: FontWeight.w400,
            //       color: colorDarkGrey,
            //     ),
            //   ],
            // ),
            // ListView.separated(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: 4,
            //   itemBuilder: (context, index) {
            //     return GestureDetector(
            //       child: CustomHospitalityItem(
            //         image: 'assets/images/farm.png',
            //         personImage: 'assets/images/ajwadi_image.png',
            //         title: AppUtil.rtlDirection(context)
            //             ? 'مزرعة جوي'
            //             : 'Juwai Farm',
            //         location: AppUtil.rtlDirection(context)
            //             ? 'الرياض، المملكة العربية السعودية'
            //             : 'Riyadh, Saudi Arabia',
            //         meal: AppUtil.rtlDirection(context) ? 'غداء' : 'Lunch',
            //         date: AppUtil.rtlDirection(context)
            //             ? 'الأربعاء ٢٨ ابريل'
            //             : 'Wed, Apr 28',
            //         rate: '4.7',
            //         onTap: () {
            //           Get.to(() => HospitalityDetails());
            //         },
            //       ),
            //     );
            //   },
            //   separatorBuilder: (context, index) {
            //     return const SizedBox(
            //       height: 16,
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
