import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/driving_license.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/widget/language_sheet.dart';
import 'package:ajwad_v4/new-onboarding/view/intro_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/bookmark_screen.dart';
import 'package:ajwad_v4/profile/view/legal_doc_screen.dart';
import 'package:ajwad_v4/profile/view/profile_local.dart';
import 'package:ajwad_v4/profile/view/terms&conditions.dart';
import 'package:ajwad_v4/profile/view/my_account.dart';
import 'package:ajwad_v4/profile/view/profile_touriest.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_list_tile.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:ajwad_v4/widgets/local_auth_mark.dart';
import 'package:ajwad_v4/widgets/verion_text.dart';
import 'package:amplitude_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'ticket_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {Key? key, this.fromAjwady = false, required this.profileController})
      : super(key: key);

  final bool fromAjwady;
  final ProfileController profileController;
  // final Profile? profile;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double width, height;
  double totalRating = 0.0;
//
  final _profileController = Get.put(ProfileController());
  // final storage = GetStorage();
  //var isTourGuide  = false;

  @override
  void initState() {
    super.initState();
    if (!widget.fromAjwady) {
      getProfile();
    }
    totalRating = calculateOverallRating();
  }

  void getProfile() async {
    await _profileController.getProfile(context: context).then((onValue) {
      totalRating = calculateOverallRating();
    });
  }

  double calculateOverallRating() {
    // Access profile properties with null-aware operators
    int tourNumber = _profileController.profile.tourNumber ?? 0;
    int eventNumber = _profileController.profile.eventNumber ?? 0;
    int hostNumber = _profileController.profile.hostNumber ?? 0;
    int adventureNumber = _profileController.profile.adventureNumber ?? 0;

    double tourRating = _profileController.profile.tourRating ?? 0.0;
    double eventRating = _profileController.profile.eventRating ?? 0.0;
    double hostRating = _profileController.profile.hostRating ?? 0.0;
    double adventureRating = _profileController.profile.adventureRating ?? 0.0;

    // Calculate the total number of instances
    int totalInstances =
        tourNumber + eventNumber + hostNumber + adventureNumber;

    // Calculate the weighted sum of ratings
    double totalWeightedSum = ((tourNumber * tourRating) +
            (eventNumber * eventRating) +
            (hostNumber * hostRating) +
            (adventureNumber * adventureRating))
        .toDouble();

    // Return the overall rating, ensuring no division by zero
    log("lkjhgfdsdfghj");
    log(totalInstances.toString());
    return totalInstances > 0
        ? double.parse((totalWeightedSum / totalInstances).toStringAsFixed(1))
        : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Obx(() => Skeletonizer(
        enabled: _profileController.isProfileLoading.value,
        child: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          body: Container(
            // height: height * .94, // was .9
            padding: EdgeInsets.only(top: height * 0.09, bottom: width * 0.051),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 24,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: _profileController.isImagesLoading.value ||
                              _profileController.isProfileLoading.value
                          ? Image.asset(
                              "assets/images/profile_image.png",
                              height: 65,
                              width: 65,
                              fit: BoxFit.cover,
                            )
                          : _profileController.profile.profileImage != "" &&
                                  _profileController.profile.profileImage !=
                                      null
                              ? ImageCacheWidget(
                                  image:
                                      _profileController.profile.profileImage!,
                                  height: 65,
                                  width: 65,
                                  placeholder:
                                      "assets/images/profile_image.png",
                                )
                              : Image.asset(
                                  "assets/images/profile_image.png",
                                  height: 65,
                                  width: 65,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    // profile title and sub title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //name
                        Row(
                          children: [
                            CustomText(
                              text: AppUtil.getFirstName(
                                AppUtil.capitalizeFirstLetter(
                                    _profileController.profile.name ??
                                        "not found"),
                              ),
                              //   widget.profileController.,
                              color: black,
                              fontSize: width * 0.051,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              width: width * 0.0205,
                            ),
                            if (_profileController.profile.tourGuideLicense !=
                                null)
                              if (_profileController
                                  .profile.tourGuideLicense!.isNotEmpty)
                                const LocalAuthMark()
                          ],
                        ),
                        Row(
                          //type and rate
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: widget.fromAjwady
                                  ? "${"local".tr} "
                                  : "tourist".tr,
                              color: colorDarkGrey,
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                            if (widget.fromAjwady)
                              CustomText(
                                text: " |",
                                color: colorDarkGrey,
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                            if (widget.fromAjwady)
                              SizedBox(
                                width: width * 0.015,
                              ),
                            if (widget.fromAjwady)
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SvgPicture.asset(
                                  "assets/icons/star.svg",
                                  width: 12,
                                  height: 12,
                                ),
                              ),
                            if (widget.fromAjwady)
                              CustomText(
                                text: " $totalRating",
                                //    "  ${_profileController.isProfileLoading.value ? "" : _profileController.profile.tourRating ?? ""} ",
                                color: colorDarkGrey,
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                          ],
                        )
                      ],
                    ),

                    const Spacer(),
                    //button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.061),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => widget.fromAjwady
                              ? const LocalProfile()
                              : TouriestProfile(
                                  fromAjwady: false,
                                  profileController: _profileController,
                                ));
                        },
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: const Color(0xff070708),
                          size: width * 0.046,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * .041),
                  child: const Divider(
                    color: lightGrey,
                  ),
                ),
                Column(
                  children: [
                    CustomListTile(
                      title: "myProfile".tr,
                      leading: "assets/icons/profile_icon.svg",
                      //   fromAjwady: false,
                      onTap: () {
                        Get.to(() => MyAccount(
                              isLocal: widget.fromAjwady,
                              profileController: _profileController,
                            ));
                      },
                    ),
                    if (_profileController.profile.accountType != null)
                      if (widget.fromAjwady &&
                          _profileController.profile.accountType == 'TOUR_GUID')
                        CustomListTile(
                          title: 'legalDoc'.tr,
                          leading: "assets/icons/legal.svg",
                          onTap: () => Get.to(() => const LegalDocument()),
                        ),
                    if (!widget.fromAjwady)
                      CustomListTile(
                        title: "myTickets".tr,
                        leading: "assets/icons/trips_icon.svg",
                        onTap: () {
                          Get.to(
                            () => TicketScreen(
                              profileController: widget.profileController,
                            ),
                          );
                        },
                      ),
                    if (!widget.fromAjwady)
                      CustomListTile(
                        title: "bookmark".tr,
                        leading: "assets/icons/bookmark_icon_profile.svg",
                        iconColor: black,
                        onTap: () async {
                          Get.to(() => const BookmarkScreen());
                        },
                      ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * .041),
                  child: const Divider(
                    color: lightGrey,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      CustomListTile(
                        title: "Language".tr,
                        leading: "assets/icons/language.svg",
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            builder: (context) {
                              return const LanguageSheet();
                            },
                          );
                        },
                      ),
                      CustomListTile(
                        title: "terms".tr,
                        leading: "assets/icons/help_icon.svg",
                        // fromAjwady: widget.fromAjwady,
                        onTap: () {
                          Get.to(() => const TermsAndConditions(
                                fromAjwady: false,
                              ));
                        },
                      ),
                      CustomListTile(
                        title: "signOut".tr,
                        leading: "assets/icons/signout_icon.svg",
                        // fromAjwady: widget.fromAjwady,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomText(
                                        textAlign: TextAlign.center,
                                        fontSize: 20,
                                        maxlines: 2,
                                        fontWeight: FontWeight.w500,
                                        color: black,
                                        fontFamily:
                                            AppUtil.rtlDirection2(context)
                                                ? "SF Arabic"
                                                : 'SF Pro',
                                        text: "youWantSiginOut".tr),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: CustomButton(
                                        height: 25,
                                        title: "signOut".tr,
                                        onPressed: () async {
                                          // log(storage
                                          //         .read('accessToken') ??
                                          //     "EMPTY 1");
                                          var isLogout =
                                              await AuthService.logOut();
                                          if (isLogout) {
                                            Get.offAll(
                                                () => const OnboardingScreen());
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: CustomButton(
                                        height: 25,
                                        borderColor: colorRed,
                                        buttonColor: Colors.white,
                                        textColor: colorRed,
                                        title: "cancel".tr,
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Center(
                  child: VersionText(),
                )
              ],
            ),
          ),
        )));
  }
}
