import 'package:ajwad_v4/explore/local/view/Experience/adventure/view/adventureAddProgress.dart';
import 'package:ajwad_v4/explore/local/view/Experience/local_event/view/eventAddProgress.dart';
import 'package:ajwad_v4/explore/local/view/Experience/widget/experience_card.dart';
import 'package:ajwad_v4/explore/local/view/hoapatility/widget/buttomProgress.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExperienceType extends StatelessWidget {
  const ExperienceType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'AddExperience'.tr,
        isAjwadi: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  // Use Flexible to allow wrapping
                  child: CustomText(
                    text: 'kindofexperience'.tr,
                    color: const Color(0xFF070708),
                    fontSize: 17,
                    fontFamily:
                        AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                    fontWeight: FontWeight.w500,
                    height: 1.1, // Adjust line height as needed
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ExperienceCard(
              title: 'hostType'.tr,
              iconPath: 'HostType',
              subtitle: 'hostSub'.tr,
              onTap: () {
                Get.to(() => const ButtomProgress());
              },
            ),
            const SizedBox(height: 16),
            ExperienceCard(
              title: 'adventureType'.tr,
              iconPath: 'AdventureType',
              subtitle: 'adveSub'.tr,
              onTap: () {
                Get.to(() => const AdventureAddProgress());
              },
            ),
            const SizedBox(height: 16),
            ExperienceCard(
              title: 'LocalEvent'.tr,
              iconPath: 'EventType',
              subtitle: 'eventSub'.tr,
              onTap: () {
                Get.to(() => const EventAddProgress());
              },
            ),
          ],
        ),
      ),
    );
  }
}
