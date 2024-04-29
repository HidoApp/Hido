import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/ticket_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/messages_screen.dart';
import 'package:ajwad_v4/request/tourist/view/tourist_chat_screen.dart';
import 'package:ajwad_v4/services/controller/serivces_controller.dart';
import 'package:ajwad_v4/services/view/tabs/adventures_tab.dart';
import 'package:ajwad_v4/services/view/tabs/events_tab.dart';
import 'package:ajwad_v4/services/view/tabs/restaurants_tab.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'tabs/hospitality_tab.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  SrvicesController _srvicesController = Get.put(SrvicesController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: height * 0.37,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  'assets/images/${_tabIndex == 0 ? 'service_hospitality_cover' : _tabIndex == 2 ? 'service_adventures_cover' : _tabIndex == 1 ? 'service_events_cover' : 'service_restaurants_cover'}.png',
                  width: width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: height * 0.035,
                  left: 16,
                  right: 16,
                  child: Column(
                  crossAxisAlignment: AppUtil.rtlDirection2(context) ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 126,
                        height: 34,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.ltr,


                          children: [
                            //             InkWell(
                            //               onTap: () {},
                            //               child: Container(
                            //                 height: 36,
                            //                 width: width * 0.6,
                            //                 decoration: BoxDecoration(
                            //                //   color: Colors.white,
                            //                   borderRadius: BorderRadius.circular(18),
                            //                 ),
                            //                 alignment: Alignment.center,
                            //                 // child: Row(
                            //                 //   children: [
                            //                 //     const SizedBox(
                            //                 //       width: 22,
                            //                 //     ),
                            //                 //     SvgPicture.asset(
                            //                 //       'assets/icons/search.svg',
                            //                 //     ),
                            //                 //     const SizedBox(
                            //                 //       width: 12,
                            //                 //     ),
                            //                 //     CustomText(
                            //                 //       text: 'search'.tr,
                            //                 //       fontSize: 14,
                            //                 //       fontWeight: FontWeight.w400,
                            //                 //       color: thinGrey.withOpacity(0.5),
                            //                 //     ),
                            //                 //   ],
                            //                 // ),
                            //               ),
                            //             ),
                            //              InkWell(
                            //            onTap: () {
                            //               ProfileController _profileController = Get.put(ProfileController());
                            //             Get.to(() =>  AppUtil.isGuest()
                            // ? const SignInScreen()
                            // : MessagesScreen(  profileController: _profileController));
                            //           },
                            //           child: Container(
                            //             width: 36,
                            //             height: 36,
                            //             decoration: const BoxDecoration(
                            //               shape: BoxShape.circle,
                            //               color: pink,
                            //             ),
                            //             alignment: Alignment.center,
                            //             child: SvgPicture.asset('assets/icons/message.svg'),
                            //           ),
                            //         ),

                            // InkWell(
                            //   onTap: () {
                            //     ProfileController _profileController =
                            //         Get.put(ProfileController());
                            //     Get.to(() => AppUtil.isGuest()
                            //         ? const SignInScreen()
                            //         : MessagesScreen(
                            //             profileController: _profileController));
                            //   },
                            InkWell(
  onTap: () {
    Get.to(() => AppUtil.isGuest()
        ? const SignInScreen()
        : TouristChatScreen(isChat: true));
  },
                              child: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                    'assets/icons/Communication_white.svg'),
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                ProfileController _profileController =
                                    Get.put(ProfileController());
                                Get.to(() => AppUtil.isGuest()
                                    ? const SignInScreen()
                                    : TicketScreen(
                                        profileController: _profileController));
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                    'assets/icons/ticket_icon.svg'),
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                Get.to(() => AppUtil.isGuest()
                                    ? const SignInScreen()
                                    : Scaffold(
                                        body: Center(
                                        child: CustomText(text: 'Comming soon'),
                                      )));
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                    'assets/icons/Alerts_white.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                         // right: AppUtil.rtlDirection(context) ? 8 : 0,
                          //left: AppUtil.rtlDirection(context) ? 0 : 8,
                        right: (_tabIndex == 3) ? (AppUtil.rtlDirection2(context) ? 0 : 155) : (_tabIndex == 1)? (AppUtil.rtlDirection2(context) ? 0 : 49):(AppUtil.rtlDirection2(context) ? 0 : 65),
                        left: (_tabIndex == 3) ? (AppUtil.rtlDirection2(context) ? 225 : 0) : (_tabIndex == 1)?(AppUtil.rtlDirection2(context) ? 133 : 0) :(AppUtil.rtlDirection2(context) ? 89 : 0),

                        ),
                        child: CustomText(
                          text: (_tabIndex == 0
                                  ? ''
                                  : _tabIndex == 2
                                      ? 'serviceAdventureTitle'
                                      : _tabIndex == 1
                                          ? 'serviceEventTitle'
                                          : 'serviceFoodTitle')
                              .tr,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          //right: AppUtil.rtlDirection(context) ? 8 : 0,
                          //left: AppUtil.rtlDirection(context) ? 0 : 8,
                          right: (_tabIndex == 2) ? (AppUtil.rtlDirection2(context) ? 0 : 35) :AppUtil.rtlDirection2(context) ? 0 : 4,
                          left: (_tabIndex == 1) ? (AppUtil.rtlDirection2(context) ? 95 : 0) : AppUtil.rtlDirection2(context) ? 85 : 0,
                        ),
                        child: CustomText(
                          text: (_tabIndex == 0
                                  ? ''
                                  : _tabIndex == 2
                                      ? 'serviceAdventureSubtitle'
                                      : _tabIndex == 1
                                          ? 'serviceEventSubtitle'
                                          : 'serviceFoodSubtitle')
                              .tr,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Directionality(
                 // textDirection: TextDirection.ltr,
                textDirection: AppUtil.rtlDirection2(context) ? TextDirection.rtl : TextDirection.ltr,

                  child: TabBar(
                    controller: _tabController,
                    indicator: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: Colors.white,
                    ),
                    labelPadding: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    onTap: (index) {
                      setState(() {
                        _tabIndex = index;
                      });
                    },
                    tabs: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                // !AppUtil.rtlDirection(context) ? 18 : 5),
                                  AppUtil.rtlDirection2(context) ? 18 : 5),

                        child: Container(
                          child: CustomText(
                            text: "hospitality".tr,
                            color: _tabIndex == 0 ? black : Colors.white,
                            fontWeight: _tabIndex == 0
                                ? FontWeight.w700
                                : FontWeight.w400,
                            fontSize: 11,
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
                          color: _tabIndex == 1 ? black : Colors.white,
                          fontWeight: _tabIndex == 1
                              ? FontWeight.w700
                              : FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                !AppUtil.rtlDirection(context) ? 18 : 5),
                        child: CustomText(
                          text: "adventures".tr,
                          color: _tabIndex == 2 ? black : Colors.white,
                          fontWeight: _tabIndex == 2
                              ? FontWeight.w700
                              : FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: CustomText(
                          text: "restaurants".tr,
                          color: _tabIndex == 3 ? black : Colors.white,
                          fontWeight: _tabIndex == 3
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  HospitalityTab(
                    isAviailable: true,
                  ),
                  EventsTab(
                    isAviailable: false,
                  ),
                  AdventuresTab(
                    isAviailable: false,
                  ),
                  RestaurantsTab(
                    isAviailable: false,
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
