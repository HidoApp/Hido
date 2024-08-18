import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AvailableContainerWidget extends StatelessWidget {
  const AvailableContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFEAEAEA)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/tickcircle.svg',
            width: 19,
            height: 19,
          ),
          const SizedBox(width: 16),
          CustomText(
            text: 'available'.tr,
            color: colorGreen,
            fontSize: 14,
            fontFamily: 'HT Rakik',
            fontWeight: FontWeight.w300,
          ),
          const Spacer(),
          const CustomText(
            text: 'Aj20',
            color: black,
            fontSize: 14,
            fontFamily: 'HT Rakik',
            fontWeight: FontWeight.w300,
          ),
        ],
      ),
    );
  }
}
