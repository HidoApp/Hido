import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPloicySheet extends StatelessWidget {
  const CustomPloicySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(36)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Icon(Icons.keyboard_arrow_down)),
            const SizedBox(
              height: 24,
            ),
            CustomText(
              text: 'cancellationPolicy'.tr,
              fontSize: 18,
            ),
            const SizedBox(
              height: 24,
            ),
            CustomText(
              text: 'cancellationPolicyBreif'.tr,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ],
        ),
      ),
    );
  }
}
