import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/services/controller/filter_controller.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SortFilter extends StatelessWidget {
  const SortFilter({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'sortBy'.tr,
          fontSize: width * 0.043,
          fontWeight: FontWeight.w500,
        ),
        GetBuilder(
          init: FilterController(),
          builder: (controller) {
            log(controller.sortBySelected.value);
            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.sortBy.length,
              itemBuilder: (context, index) => RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                //    overlayColor: WidgetStatePropertyAll(colorGreen),
                //    fillColor: WidgetStatePropertyAll(starGreyColor),
                activeColor: colorGreen,
                title: CustomText(
                  text: controller.sortBy[index],
                ),
                value: controller.sortBy[index],
                groupValue: controller.sortBySelected.value,
                onChanged: (value) {
                  controller.sortBySelected(value);
                  controller.update();
                },
              ),
            );
          },
        )
      ],
    );
  }
}
