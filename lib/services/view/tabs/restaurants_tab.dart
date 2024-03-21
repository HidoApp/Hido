import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/view/restaurant_details.dart';
import 'package:ajwad_v4/services/view/widgets/custom_city_item.dart';
import 'package:ajwad_v4/services/view/widgets/custom_restaurant_item.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantsTab extends StatelessWidget {
  const RestaurantsTab({super.key, required this.isAviailable});
    final bool isAviailable;

  @override
  Widget build(BuildContext context) { 
    
    final double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
    

            isAviailable ? Column(
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
                    title: AppUtil.rtlDirection(context) ? 'تبوك' : 'Tabuk');
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
                text: 'nearbyLocalRestaurants'.tr,
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


            ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return CustomRestaurantItem(
                image: 'assets/images/saudi_corner.png',
                title: AppUtil.rtlDirection(context)
                    ? 'مطعم الركن السعودي'
                    : 'Saudi Corner Restaurant',
                time: AppUtil.rtlDirection(context)
                    ? '1:00 مساء -2:00 صباحاً'
                    : '1:00 PM -2:00 AM',
                onTap: () {
                  Get.to(() => RestaurantDetails());
                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 16,
              );
            },
          )

              ],
            ) :

             Column(
                  children: [
                    SizedBox(
                      height: height * 0.04,
                    ),
                    // Image.asset(
                    //   'assets/images/hido_logo.png',
                    //   color: reddishOrange,
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
        
        ],
      ),
    );
  }
}
