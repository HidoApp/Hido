import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/profile/view/order_screen.dart';
import 'package:ajwad_v4/profile/view/ticket_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/messages_screen.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen.dart';
import 'package:ajwad_v4/request/tourist/view/tourist_chat_screen.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/services/service/regions_service.dart';
import 'package:ajwad_v4/services/view/tabs/adventures_tab.dart';
import 'package:ajwad_v4/services/view/tabs/events_tab.dart';
import 'package:ajwad_v4/services/view/tabs/restaurants_tab.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/home_icons_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'tabs/hospitality_tab.dart';
import 'package:ajwad_v4/explore/tourist/view/notification/notification_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  final _srvicesController = Get.put(HospitalityController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // getReg();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          controller: ScrollController(),
          headerSliverBuilder: (context, isScrolled) => [
            SliverAppBar(
              automaticallyImplyLeading: false,
              //  expandedHeight: width * 0.48,
              toolbarHeight: width * 0.31,
              forceMaterialTransparency: true,

              pinned: true,
              centerTitle: false,

              leading: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "serviceTitle".tr,
                      color: Colors.white,
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
                    CustomText(
                      text: _tabIndex == 0
                          ? "hospitalityDetails".tr
                          : "adventureDetails".tr,
                      color: Colors.white,
                      fontSize: 11,
                      maxlines: 2,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              leadingWidth: 400,

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
                                      ProfileController _profileController =
                                          Get.put(ProfileController());
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
                                      ProfileController _profileController =
                                          Get.put(ProfileController());
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
                                          : NotificationScreen());
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
                child: Image.asset(
                  'assets/images/${_tabIndex == 0 ? 'service_hospitality_cover' : _tabIndex == 2 ? 'service_adventures_cover' : _tabIndex == 1 ? 'service_events_cover' : 'service_restaurants_cover'}.png',
                  width: width,
                  fit: BoxFit.fill,
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                // indicatorPadding: const EdgeInsets.only(
                //   top: 10,
                // ),
                //dividerColor: Colors.transparent,
                dividerHeight: 0,
                // overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(width * 0.03),
                    topRight: Radius.circular(width * 0.03),
                  ),
                  color: Colors.white,
                ),
                labelPadding: EdgeInsets.all(width * 0.03),
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                onTap: (index) {
                  setState(() {
                    _tabIndex = index;
                  });
                  print(_tabController.index);
                  print("_tabController");
                },
                tabs: [
                  Padding(
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
                      child: CustomText(
                        text: "hospitality".tr,
                        color: _tabIndex == 0 ? black : Colors.white,
                        fontWeight:
                            _tabIndex == 0 ? FontWeight.w500 : FontWeight.w400,
                        fontSize:
                            _tabIndex == 0 ? width * 0.033 : width * 0.033,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      ),
                    ),
                  ),

                  Padding(
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
                      child: CustomText(
                        text: "adventures".tr,
                        color: _tabIndex == 1 ? black : Colors.white,
                        fontWeight:
                            _tabIndex == 1 ? FontWeight.w500 : FontWeight.w400,
                        fontSize:
                            _tabIndex == 1 ? width * 0.033 : width * 0.033,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                      ),
                    ),
                  ),
                  Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 18),

                    padding: EdgeInsets.symmetric(
                        horizontal:
                            // !AppUtil.rtlDirection(context) ? 15 : 5),
                            AppUtil.rtlDirection2(context) ? 15 : 5),

                    //padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomText(
                      text: "events".tr,
                      color: _tabIndex == 2 ? darkBlue : Colors.white,
                      fontWeight:
                          _tabIndex == 2 ? FontWeight.w700 : FontWeight.w400,
                      fontSize: _tabIndex == 2 ? width * 0.033 : width * 0.028,
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
