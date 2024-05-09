import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.profileController});
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 33,
        vertical: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //descripton
          Obx(
            () => profileController.isProfileLoading.value
                ? const Center(child: CircularProgressIndicator())
                : CustomText(
                    text: profileController.profile.descriptionAboutMe ??
                        "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. "),
          ),
          const SizedBox(
            height: 14,
          ),
        ],
      ),
    );
  }
}
