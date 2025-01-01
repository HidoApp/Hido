import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/filter_controller.dart';
import 'package:ajwad_v4/services/view/widgets/city_filter.dart';
import 'package:ajwad_v4/services/view/widgets/gender_filter.dart';
import 'package:ajwad_v4/services/view/widgets/sort_filter.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_outlined_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key, this.isHospitality = false});
  final bool isHospitality;
  @override
  Widget build(BuildContext context) {
    final eventController = Get.put(EventController()); // Access
    // print(eventController.eventList.length);
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      padding: EdgeInsets.only(
        top: width * 0.04,
        left: width * 0.061,
        right: width * 0.061,
        bottom: width * 0.082,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BottomSheetIndicator(),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: width * 0.071,
              ),
              const SortFilter(),
              SizedBox(
                height: width * 0.061,
              ),
              const CityFilter(),
              if (isHospitality) ...[
                SizedBox(
                  height: width * 0.061,
                ),
                const GenderFilter(),
              ],
              SizedBox(
                height: width * 0.19,
              ),
              // CustomButton(
              //   title: 'apply'.tr,
              //   onPressed: () {},
              // ),
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.white,
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GetBuilder(
              init: FilterController(),
              builder: (controller) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'apply'.tr,
                      onPressed: () {
                        controller.updateFilteredEvents();
                        controller.update();
                        Get.back();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: CustomOutlinedButton(
                          title: 'reset'.tr,
                          buttonColor: colorGreen,
                          titleColor: colorGreen,
                          onTap: () {
                            controller.resetFilters();
                            Get.back();
                          }),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
