import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/filter_controller.dart';
import 'package:ajwad_v4/services/view/widgets/filter_text_chip.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityFilter extends StatelessWidget {
  const CityFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'byCity'.tr,
          fontSize: width * 0.043,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).width * 0.0205,
        ),
        Wrap(
          spacing: 8.0, // Space between chips horizontally
          runSpacing: 8.0, // Space between chips vertically

          children: List.generate(
              AppUtil.regionListEn.length,
              (index) => GetBuilder(
                    init: FilterController(),
                    builder: (controller) => InkWell(
                      onTap: () {
                        controller.selectedCityIndex = index;
                        controller.selectedCity.value =
                            AppUtil.regionListEn[controller.selectedCityIndex];
                        controller.update();
                      },
                      child: FilterTextChip(
                        text: AppUtil.rtlDirection2(context)
                            ? AppUtil.regionListAr[index]
                            : AppUtil.regionListEn[index],
                        textColor: controller.selectedCityIndex == index
                            ? colorGreen
                            : black,
                        backgroundColor: controller.selectedCityIndex == index
                            ? const Color(0xffD4F7DD)
                            : const Color(0xffF6F6F6),
                      ),
                    ),
                  )),
        )
      ],
    );
  }
}
