import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/view/event_details.dart';
import 'package:ajwad_v4/services/view/widgets/custom_city_item.dart';
import 'package:ajwad_v4/services/view/widgets/custom_event_item.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsTab extends StatelessWidget {
  const EventsTab({super.key, required this.isAviailable});
    final bool isAviailable;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: width,
            decoration: BoxDecoration(
              color: lightYellow.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right:! AppUtil.rtlDirection(context) ? 16 : 0,
                      left:! AppUtil.rtlDirection(context) ? 0 : 16,
                      top: 12,
                      bottom: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'inviteYourFriend'.tr,
                          fontSize: 18,
                          fontWeight: FontWeight.w700, 
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        SizedBox(
                          width: 133,
                          child: CustomText(
                            text: 'getDiscount'.tr,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: colorDarkGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 72,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: gold,
                            ),
                            child: CustomText(
                              text: 'invite'.tr,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Image.asset('assets/images/invite_your_friend.png'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          isAviailable ? 

          Column(children: [

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
                text: 'nearestEvent'.tr,
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
            height: 320,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return CustomEventItem(
                  onTap: () {
                    Get.to(() => EventDetails());
                  },
                  title: AppUtil.rtlDirection(context)
                      ? 'سباق الهجن'
                      : 'Camel Raising',
                  rate: '4.7',
                  location: AppUtil.rtlDirection(context)
                      ? 'ربع الخالي، المملكة العربية السعودية'
                      : 'Riyadh, Saudi Arabia',
                  date: AppUtil.rtlDirection(context)
                      ? '23 ابريل'
                      : 'Wed, Apr 28',
                  description: AppUtil.rtlDirection(context)
                      ? 'الربع الخالي عبارة عن صحراء رملية تغطي معظم الجنوب.'
                      : 'Shaqra is plateau and it is a famous commercial town many ...',
                );
              },
              separatorBuilder: (context, index) { 
                return const SizedBox(
                  width: 15,
                );
              },
            ),
          ),


          ],)
           : Column(
                  children: [
                    SizedBox(
                      height: height * 0.04,
                    ),
                   
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
