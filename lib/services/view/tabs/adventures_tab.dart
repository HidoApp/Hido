import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/widgets/custom_adventure_item.dart';
import 'package:ajwad_v4/services/view/widgets/custom_city_item.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdventuresTab extends StatelessWidget {
  const AdventuresTab({super.key, required this.isAviailable});
  final bool isAviailable;

  @override
  Widget build(BuildContext context) {
        final double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: isAviailable
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'where'.tr,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    CustomText(
                      text: 'seeAll'.tr,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: colorDarkGrey,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 24,
                      );
                    },
                    itemBuilder: (context, index) {
                      return CustomCityItem(
                          image: 'assets/images/tabuk.png',
                          title:
                              AppUtil.rtlDirection(context) ? 'تبوك' : 'Tabuk');
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'cultureSights'.tr,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    CustomText(
                      text: 'seeAll'.tr,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: colorDarkGrey,
                    ),
                  ],
                ),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return CustomAdventureItem(
                        onTap: () {
                          Get.to(() => AdventureDetails());
                        },
                        title: AppUtil.rtlDirection(context)
                            ? 'ربع الخالي'
                            : 'Empty Quarter',
                        rate: '4.7',
                        location: AppUtil.rtlDirection(context)
                            ? 'ربع الخالي، المملكة العربية السعودية'
                            : 'Empty Quarter, Saudi Arabia',
                        description: AppUtil.rtlDirection(context)
                            ? 'الربع الخالي عبارة عن صحراء رملية تغطي معظم الجنوب.'
                            : 'The Rub\' al Khali is the sand desert encompassing most of the southern ..',
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 25,
                      );
                    },
                  ),
                ),
              ],
            )
          : Column(
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                // Image.asset(
                //   'assets/images/hido_logo.png',
                //   color: pink,
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
    );
  }
}
