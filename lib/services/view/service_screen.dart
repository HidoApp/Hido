import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/advertisement_controller.dart';
import 'package:ajwad_v4/notification/notifications_screen.dart';
import 'package:ajwad_v4/profile/view/ticket_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/messages_screen.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/controller/regions_controller.dart';
import 'package:ajwad_v4/services/view/tabs/adventures_tab.dart';
import 'package:ajwad_v4/services/view/tabs/events_tab.dart';
import 'package:ajwad_v4/services/view/widgets/ad_cards.dart';
import 'package:ajwad_v4/services/view/widgets/custom_chips.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/home_icons_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'tabs/hospitality_tab.dart';
import 'package:ajwad_v4/notification/notification_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // int _tabIndex = 0;

  final _srvicesController = Get.put(HospitalityController());
  final _regionsController = Get.put(RegionsController());
  final ProfileController _profileController = Get.put(ProfileController());
  final _AdverController = Get.put(AdvertisementController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: _srvicesController.tabIndex.value);

    _AdverController.getAllAdvertisement(context: context);

    // getReg();
  }

  void getExperiencesByRegion(int index) async {
    switch (_srvicesController.tabIndex.value) {
      case 0:
        _regionsController.selectedHospitaltyIndex(index);
        await _srvicesController.getAllHospitality(
            context: context,
            region: index != 0 ? AppUtil.regionListEn[index] : null);
        break;
      case 1:
        final adventureController = Get.put(AdventureController());
        _regionsController.selectedAdventureIndex(index);
        await adventureController.getAdvdentureList(
            context: context,
            region: index != 0 ? AppUtil.regionListEn[index] : null);
        break;
      case 2:
        final eventController = Get.put(EventController());
        _regionsController.selectedEventIndex(index);

        await eventController.getEventList(
            context: context,
            region: index != 0 ? AppUtil.regionListEn[index] : null);
        break;
      default:
    }
  }

  Widget _buildRegionChips(int index) {
    switch (_srvicesController.tabIndex.value) {
      case 0:
        return CustomChips(
          borderColor: _regionsController.selectedHospitaltyIndex.value == index
              ? colorGreen
              : almostGrey,
          backgroundColor:
              _regionsController.selectedHospitaltyIndex.value == index
                  ? colorGreen
                  : Colors.transparent,
          textColor: _regionsController.selectedHospitaltyIndex.value == index
              ? Colors.white
              : almostGrey,
          title: AppUtil.rtlDirection2(context)
              ? AppUtil.regionListAr[index]
              : AppUtil.regionListEn[index],
        );
      case 1:
        return CustomChips(
          borderColor: _regionsController.selectedAdventureIndex.value == index
              ? colorGreen
              : almostGrey,
          backgroundColor:
              _regionsController.selectedAdventureIndex.value == index
                  ? colorGreen
                  : Colors.transparent,
          textColor: _regionsController.selectedAdventureIndex.value == index
              ? Colors.white
              : almostGrey,
          title: AppUtil.rtlDirection2(context)
              ? AppUtil.regionListAr[index]
              : AppUtil.regionListEn[index],
        );
      case 2:
        return CustomChips(
          borderColor: _regionsController.selectedEventIndex.value == index
              ? colorGreen
              : almostGrey,
          backgroundColor: _regionsController.selectedEventIndex.value == index
              ? colorGreen
              : Colors.transparent,
          textColor: _regionsController.selectedEventIndex.value == index
              ? Colors.white
              : almostGrey,
          title: AppUtil.rtlDirection2(context)
              ? AppUtil.regionListAr[index]
              : AppUtil.regionListEn[index],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          floatHeaderSlivers: true,

          // scrollBehavior: CupertinoScrollBehavior(),
          controller: ScrollController(),
          headerSliverBuilder: (context, isScrolled) => [
            SliverAppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: width * 0.36,
              forceMaterialTransparency: true,
              pinned: false,
              centerTitle: false,
              leading: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "serviceTitle".tr,
                      color: Colors.white,
                      // shadows: const [
                      //   Shadow(
                      //     blurRadius: 15.0, // Soften the shadow
                      //     color: Colors.black, // Set shadow color
                      //   ),
                      // ],
                      maxlines: 2,
                      fontSize: 20,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Obx(
                      () => CustomText(
                        text: _srvicesController.tabIndex.value == 0
                            ? "hospitalityDetails".tr
                            : _srvicesController.tabIndex.value == 1
                                ? "adventureDetails".tr
                                : "eventDetailsSub".tr,
                        color: Colors.white,
                        fontSize: 11,
                        maxlines: 2,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              leadingWidth: double.infinity,
              actions: [
                Padding(
                    // padding: EdgeInsets.only(right: width * 0.06,),
                    padding: AppUtil.rtlDirection2(context)
                        ? EdgeInsets.only(
                            left: width * 0.061, bottom: height * 0.10)
                        : EdgeInsets.only(
                            right: width * 0.06,
                          ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: !AppUtil.isGuest()
                          ? Row(
                              children: [
                                HomeIconButton(
                                    onTap: () {
                                      // ProfileController _profileController =
                                      //     Get.put(ProfileController());
                                      Get.to(() => AppUtil.isGuest()
                                          ? const SignInScreen()
                                          : TicketScreen(
                                              profileController:
                                                  _profileController));
                                    },
                                    icon: 'assets/icons/ticket_icon.svg'),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                HomeIconButton(
                                    onTap: () {
                                      // ProfileController _profileController =
                                      //     Get.put(ProfileController());
                                      Get.to(() => AppUtil.isGuest()
                                          ? const SignInScreen()
                                          : MessagesScreen(
                                              profileController:
                                                  _profileController));
                                    },
                                    icon:
                                        'assets/icons/Communication_white.svg'),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                HomeIconButton(
                                    onTap: () {
                                      Get.to(() => AppUtil.isGuest()
                                          ? const SignInScreen()
                                          : NotificationsScreen());
                                    },
                                    icon: 'assets/icons/Alerts_white.svg')
                              ],
                            )
                          : const SizedBox(),
                    ))
              ],
              flexibleSpace: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(width * 0.05),
                    bottomRight: Radius.circular(width * 0.05)),
                child: Obx(
                  () => Image.asset(
                    'assets/images/${_srvicesController.tabIndex.value == 0 ? 'service_hospitality_cover_1.png' : _srvicesController.tabIndex.value == 1 ? 'service_adventures_cover.png' : _srvicesController.tabIndex.value == 2 ? 'service_events_cover.png' : 'service_restaurants_cover.png'}',
                    //  width: width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                dividerColor: Colors.white.withOpacity(1),
                // dividerHeight: 1.5,
                // overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(width * 0.03),
                    topRight: Radius.circular(width * 0.03),
                  ),
                  color: Colors.white,
                ),
                labelPadding: EdgeInsets.only(
                    top: width * 0.015,
                    right: width * 0.026,
                    left: width * 0.026,
                    bottom: 0),
                padding:
                    EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 0),
                onTap: (index) {
                  _srvicesController.tabIndex.value = index;
                },
                tabs: [
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(width * 0.03),
                            topRight: Radius.circular(width * 0.03)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.1)
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                // !AppUtil.rtlDirection(context) ? 15 : 5),
                                AppUtil.rtlDirection2(context)
                                    ? width * 0.038
                                    : width * 0.012),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(width * 0.03),
                                  topRight: Radius.circular(width * 0.03))),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CustomText(
                              text: "hospitality".tr,
                              color: _srvicesController.tabIndex.value == 0
                                  ? black
                                  : Colors.white,
                              fontWeight: _srvicesController.tabIndex.value == 0
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              fontSize: _srvicesController.tabIndex.value == 0
                                  ? width * 0.033
                                  : width * 0.033,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Obx(
                    () => Container(
                      padding: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(width * 0.03),
                            topRight: Radius.circular(width * 0.03)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.1)
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                // !AppUtil.rtlDirection(context) ? 15 : 5),
                                AppUtil.rtlDirection2(context)
                                    ? width * 0.038
                                    : width * 0.012),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(width * 0.03),
                                  topRight: Radius.circular(width * 0.03))),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CustomText(
                              text: "adventures".tr,
                              color: _srvicesController.tabIndex.value == 1
                                  ? black
                                  : Colors.white,
                              fontWeight: _srvicesController.tabIndex.value == 1
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              fontSize: _srvicesController.tabIndex.value == 1
                                  ? width * 0.033
                                  : width * 0.033,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Container(
                      padding: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(width * 0.03),
                            topRight: Radius.circular(width * 0.03)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.1)
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                // !AppUtil.rtlDirection(context) ? 15 : 5),
                                AppUtil.rtlDirection2(context)
                                    ? width * 0.038
                                    : width * 0.012),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(width * 0.03),
                                  topRight: Radius.circular(width * 0.03))),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CustomText(
                              text: "events".tr,
                              color: _srvicesController.tabIndex.value == 2
                                  ? black
                                  : Colors.white,
                              fontWeight: _srvicesController.tabIndex.value == 2
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              fontSize: _srvicesController.tabIndex.value == 2
                                  ? width * 0.033
                                  : width * 0.033,
                              fontFamily: AppUtil.rtlDirection2(context)
                                  ? 'SF Arabic'
                                  : 'SF Pro',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 18),
                  //   child: CustomText(
                  //     text: "restaurants".tr,
                  //     color: _tabIndex == 3 ? black : Colors.white,
                  //     fontWeight:
                  //         _tabIndex == 3 ? FontWeight.w700 : FontWeight.w400,
                  //   ),
                  // ),
                ],
              ),
            ),
            // SliverAppBar(
            //   excludeHeaderSemantics: true,
            //   automaticallyImplyLeading: false,
            //   shadowColor: Colors.black,
            //   toolbarHeight: width * 0.4,
            //   forceMaterialTransparency: true,
            //   pinned: false,
            //   centerTitle: true,
            //   // titleSpacing: 30,
            //   title: AdCards(),
            // ),
            Obx(() {
              if (_AdverController.advertisementList.isNotEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 28,
                      left: 16,
                      right: 16,
                      bottom: 0,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: const AdCards(),
                      ),
                    ),
                  ),
                );
              } else {
                return SliverToBoxAdapter(
                    child: SizedBox(
                  height: width * 0.12,
                ));
              }
            }),

            SliverToBoxAdapter(
              // leadingWidth: double.infinity,
              // backgroundColor: Colors.white,
              // foregroundColor: Colors.white,
              // surfaceTintColor: Colors.white,
              // floating: true,
              // automaticallyImplyLeading: false,
              // expandedHeight: 0,
              // toolbarHeight: width * 0.22,
              // pinned: true,
              // stretch: true,
              // //  pinned: true,
              // leading:
              child: Padding(
                padding: AppUtil.rtlDirection2(context)
                    ? EdgeInsets.only(right: width * 0.041)
                    : EdgeInsets.only(left: width * 0.041),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => CustomText(
                        text: _srvicesController.tabIndex.value == 0
                            ? 'saudiHospitality'.tr
                            : _srvicesController.tabIndex.value == 1
                                ? 'saudiAdventure'.tr
                                : 'saudiEvent'.tr,
                        color: Color(0xFF070708),
                        fontSize: width * 0.043,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: width * 0.041,
                    ),
                    SizedBox(
                        height: width * 0.080,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: AppUtil.regionListEn.length,
                          separatorBuilder: (context, index) => SizedBox(
                            width: width * 0.025,
                          ),
                          itemBuilder: (context, index) => Obx(
                            () => GestureDetector(
                                onTap: () => getExperiencesByRegion(index),
                                child: _buildRegionChips(index)),
                          ),
                        )),
                  ],
                ),
              ),
            )
          ],
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HospitalityTab(),
              AdventuresTab(),
              EventsTab(),
              // RestaurantsTab(
              //   isAviailable: false,
              // ),
            ],
          ),
        ));
  }
}
