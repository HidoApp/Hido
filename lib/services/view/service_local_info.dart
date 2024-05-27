import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/request/tourist/view/about_screen.dart';
import 'package:ajwad_v4/request/tourist/view/expert_screen.dart';
import 'package:ajwad_v4/request/tourist/view/reviews_screen.dart';
import 'package:ajwad_v4/request/widgets/local_tile.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServicesLocalInfo extends StatefulWidget {
  const ServicesLocalInfo({super.key, required this.profileId});
  final String profileId;
  @override
  State<ServicesLocalInfo> createState() => _ServicesLocalInfoState();
}

class _ServicesLocalInfoState extends State<ServicesLocalInfo> {
  final _profileController = Get.put(ProfileController());
  late Profile? profile;
  void getProfile() async {
    profile = await _profileController.getProfile(
        context: context, profileId: widget.profileId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //animationDuration: Durations.long1
      //,
      length: 3,
      child: Obx(
        () => _profileController.isProfileLoading.value
            ? const Scaffold(
                appBar: CustomAppBar(""),
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            : Scaffold(
                appBar: const CustomAppBar("Local info"),
                body: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    toolbarHeight: 300,
                    title: Column(
                      children: [
                        profile!.profileImage!.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    profile!.profileImage!),
                                radius: 40,
                              )
                            : const CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/profile_image.png',
                                ),
                                radius: 50,
                              ),
                        const SizedBox(
                          height: 14,
                        ),
                        CustomText(
                          text: profile!.name!,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        //local details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //number of tours tile
                            LocalTile(
                              tripNumber: profile!.adventureNumber!,
                              subtitle: 'adventure'.tr,
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            const SizedBox(
                              height: 44,
                              child: VerticalDivider(
                                color: tileGreyColor,
                                thickness: 1,
                                indent: 10,
                                width: 0,
                                endIndent: 0,
                                //width: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            //review tile
                            LocalTile(
                              tripNumber: profile!.adventureRating!,
                              isRating: true,
                              subtitle: 'rating'.tr,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 21,
                        ),
                        //view offer button
                      ],
                    ),
                    bottom: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: black,
                      unselectedLabelColor: almostGrey,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 14),
                      tabs: [
                        Tab(
                          text: "about".tr,
                        ),
                        Tab(
                          text: "expertise".tr,
                        ),
                        Tab(
                          text: "reviews".tr,
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(children: [
                    AboutScreen(
                      profileController: _profileController,
                    ),
                    const ExpertScreen(),
                    ReviewsScreen(
                      profileId: widget.profileId,
                    )
                  ]),
                ),
              ),
      ),
    );
  }
}
