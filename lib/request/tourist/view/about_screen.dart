import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.profileController});
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => profileController.isProfileLoading.value
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.084,
                vertical: width * 0.035,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //descripton
                  CustomText(
                      text: profileController.profile.descriptionAboutMe ??
                          "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. "),

                  SizedBox(
                    height: width * 0.035,
                  ),
                  CustomText(
                    text: 'languages'.tr,
                    fontSize: width * 0.043,
                  ),
                  SizedBox(
                    height: width * 0.030,
                  ),
                  SizedBox(
                    height: width * 0.087,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: profileController
                              .profile.spokenLanguage!.isEmpty
                          ? 1
                          : profileController.profile.spokenLanguage!.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 5,
                      ),
                      itemBuilder: (context, index) => CustomChips(
                          title:
                              profileController.profile.spokenLanguage!.isEmpty
                                  ? "Arabic"
                                  : profileController
                                      .profile.spokenLanguage![index],
                          backgroundColor: Colors.transparent,
                          borderColor: almostGrey,
                          textColor: almostGrey),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
