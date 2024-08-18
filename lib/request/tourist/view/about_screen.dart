import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/utils/app_util.dart';
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
    print(profileController.profile.descriptionAboutMe);
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => profileController.isProfileLoading.value
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.084,
                vertical: width * 0.035,
              ),
              child: profileController.profile.descriptionAboutMe!.isEmpty &&
                      !profileController.profile.spokenLanguage!.isEmpty
                  ? Center(
                      child: FittedBox(
                        child: CustomText(
                          text: "noAbout".tr,
                          fontSize: width * 0.04,
                          fontFamily: !AppUtil.rtlDirection2(context)
                              ? 'SF Pro'
                              : 'SF Arabic',
                          fontWeight: FontWeight.w400,
                          color: starGreyColor,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          CustomText(
                            maxlines: 8,
                            text: (profileController.profile.descriptionAboutMe
                                        ?.isNotEmpty ??
                                    false)
                                ? profileController.profile.descriptionAboutMe!
                                : '',
                            color: const Color(0xFF41404A),
                            textOverflow: TextOverflow.ellipsis,
                            fontSize: width * 0.038,
                            fontFamily: !AppUtil.rtlDirection2(context)
                                ? 'SF Pro'
                                : 'SF Arabic',
                            fontWeight: FontWeight.w400,
                          ),
                          if (profileController
                              .profile.descriptionAboutMe!.isNotEmpty)
                            SizedBox(
                              height: width * 0.038,
                            ),
                          CustomText(
                            text: 'languages'.tr,
                            fontSize: width * 0.044,
                            fontFamily: !AppUtil.rtlDirection2(context)
                                ? 'SF Pro'
                                : 'SF Arabic',
                            fontWeight: FontWeight.w500,
                            color: black,
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
                                  : profileController
                                      .profile.spokenLanguage!.length,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 5,
                              ),
                              itemBuilder: (context, index) => CustomChips(
                                  title: profileController
                                          .profile.spokenLanguage!.isEmpty
                                      ? "Arabic"
                                      : profileController
                                          .profile.spokenLanguage![index],
                                  backgroundColor: Colors.transparent,
                                  borderColor: Graytext,
                                  textColor: Graytext),
                            ),
                          )
                        ]),
            ),
    );
  }
}
