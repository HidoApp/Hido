import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/request/tourist/view/about_screen.dart';
import 'package:ajwad_v4/request/tourist/view/reviews_screen.dart';
import 'package:ajwad_v4/request/widgets/local_tile.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ServicesLocalInfo extends StatefulWidget {
  const ServicesLocalInfo(
      {super.key, required this.profileId, this.isHospitality = false});
  final String profileId;
  final bool isHospitality;
  @override
  State<ServicesLocalInfo> createState() => _ServicesLocalInfoState();
}

class _ServicesLocalInfoState extends State<ServicesLocalInfo> {
  final _profileController = Get.put(ProfileController());
  void getProfile() async {
    await _profileController.getProfile(
        context: context, profileId: widget.profileId);
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      //animationDuration: Durations.long1
      //,
      length: 2,
      child: Obx(
        () => Skeletonizer(
          enabled: _profileController.isProfileLoading.value,
          child: Scaffold(
            appBar: CustomAppBar("loclaInfo".tr),
            body: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                toolbarHeight: width * 0.76,
                title: Column(
                  children: [
                    _profileController.profile.profileImage != null &&
                            _profileController.profile.profileImage != ""
                        ? CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                _profileController.profile.profileImage!),
                            radius: width * 0.102,
                          )
                        : CircleAvatar(
                            backgroundImage: const AssetImage(
                              'assets/images/profile_image.png',
                            ),
                            radius: width * 0.128,
                          ),
                    SizedBox(
                      height: width * 0.035,
                    ),
                    CustomText(
                      text: _profileController.profile.name ?? "",
                      fontSize: width * 0.061,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: width * .035,
                    ),
                    //local details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //number of tours tile
                        LocalTile(
                          tripNumber: widget.isHospitality
                              ? _profileController.profile.hostNumber ?? 0
                              : _profileController.profile.adventureNumber ?? 0,
                          subtitle: widget.isHospitality
                              ? "hospitality".tr
                              : 'adventure'.tr,
                        ),
                        SizedBox(
                          width: width * 0.033,
                        ),
                        SizedBox(
                          height: width * 0.1128,
                          child: const VerticalDivider(
                            color: tileGreyColor,
                            thickness: 1,
                            indent: 10,
                            width: 0,
                            endIndent: 0,
                            //width: 20,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        //review tile
                        LocalTile(
                          tripRate: widget.isHospitality
                              ? _profileController.profile.hostRating ?? 0
                              : _profileController.profile.adventureRating ?? 0,
                          isRating: true,
                          subtitle: 'review'.tr,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: width * 0.053,
                    ),
                    //view offer button
                  ],
                ),
                bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: black,
                  unselectedLabelColor: almostGrey,
                  indicatorPadding:
                      EdgeInsets.symmetric(horizontal: width * 0.035),
                  tabs: [
                    Tab(
                      text: "about".tr,
                    ),
                    Tab(
                      text: "reviews".tr,
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: [
                const AboutScreen(),
                ReviewsScreen(
                  profileId: widget.profileId,
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
