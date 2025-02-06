
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
        const SizedBox(height: 10),
        GetBuilder(
          init: FilterController(),
          builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min, // Prevents extra space
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                controller.sortBy.length,
                (index) => Row(
                  children: [
                    Radio<String>(
                      value: controller.sortBy[index],
                      groupValue: controller.sortBySelected.value,
                      onChanged: (value) {
                        controller.sortBySelected(value);
                        controller.update();
                      },
                      activeColor: colorGreen, // Selected color
                      fillColor:
                          WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.selected)) {
                          return colorGreen; // Selected color
                        }
                        return thinGrey; // Unselected color (gray)
                      }),
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // Shrinks tap area
                      visualDensity: const VisualDensity(
                        horizontal:
                            -4, // Shrinks horizontal padding inside the radio button
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Space between radio button and text
                    CustomText(
                      text: controller.sortBy[index],
                      fontSize: width * 0.035,
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
