import 'dart:developer';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PickupRideWidget extends StatelessWidget {
  const PickupRideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _profileController = Get.put(ProfileController());

    final Map _pickupRide = {
      'sedan': [
        'assets/icons/selected_sedan_icon.svg',
        'assets/icons/unselected_sedan_icon.svg'
      ],
      'suv': [
        'assets/icons/selected_suv_car.svg',
        'assets/icons/unselected_suv_icon.svg'
      ],
      '4x4': [
        'assets/icons/selected_4x4_icon.svg',
        'assets/icons/unselected_4x4_icon.svg'
      ],
      'van': [
        'assets/icons/selected_van_icon.svg',
        'assets/icons/unselected_van_icon.svg'
      ]
    };
    final button = _pickupRide
        .map((key, values) {
          final value = Obx(
            () => Container(
              margin: const EdgeInsets.only(left: 2),
              child: GestureDetector(
                onTap: () {
                  _profileController.selectedRide.value = key;
                  log(_profileController.selectedRide.value);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _profileController.selectedRide.value == key
                          ? colorGreen
                          : almostGrey,
                    ),
                    color: _profileController.selectedRide.value == key
                        ? lightGreen
                        : Colors.white,
                  ),
                  child: Column(
                    children: [
                      const Spacer(),
                      RepaintBoundary(
                        child: SvgPicture.asset(
                          _profileController.selectedRide.value == key
                              ? values[0]
                              : values[1],
                        ),
                      ),
                      const Spacer(),
                      CustomText(
                        text: "$key".tr,
                        color: _profileController.selectedRide.value == key
                            ? colorGreen
                            : dividerColor,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          return MapEntry(key, value);
        })
        .values
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: button,
    );
  }
}
