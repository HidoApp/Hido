import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/tour_stepper.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/local/view/Experience/widget/local_trip_card.dart';
import 'package:ajwad_v4/explore/local/view/Experience/local_event/view/event_experience_card.dart';
import 'package:ajwad_v4/explore/local/view/hoapatility/view/hospitality_experience_card.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'Experience/adventure/view/custom_experience_card.dart';

class LocalTicketScreen extends StatefulWidget {
  // final ProfileController profileController;
  final servicesController;
  final String? type;

  const LocalTicketScreen({super.key, this.servicesController, this.type});

  @override
  State<LocalTicketScreen> createState() => _LocalTicketScreenState();
}

class _LocalTicketScreenState extends State<LocalTicketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  // final _servicesController = Get.put(HospitalityController());

  //List<String> status = ['canceled', 'waiting', 'confirmed'];
  final _authController = Get.put(AuthController());
  final _profileController = Get.put(ProfileController());

  void getTicket() {
    if (widget.type == 'tour') {
      if (_profileController.profile.tourGuideLicense != '' &&
          (_authController.localInfo.transportationMethod ?? []).isNotEmpty) {
        widget.servicesController.getPastTicket(context: context);
        widget.servicesController.getUpcommingTicket(context: context);
      }
    } else {
      widget.servicesController.getPastTicket(context: context);
      widget.servicesController.getUpcommingTicket(context: context);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getTicket();
  }

  String _appBarText() {
    if (widget.type == 'tour') {
      return "Tour".tr;
    }
    if (widget.type == 'hospitality') {
      return "Hospitality".tr;
    }
    if (widget.type == 'adventure') {
      return "Adventure".tr;
    }
    if (widget.type == 'event') {
      return "Event".tr;
    }

    return ""; // Add validation for other steps if needed
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        _appBarText(),
      ),
      body:
          // Obx(
          //   () =>

          Padding(
        padding: const EdgeInsets.only(
          top: 3,
        ),
        child: Column(
          children: [
            MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.0)),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: colorGreen,
                overlayColor: WidgetStateProperty.all(Colors.white),
                unselectedLabelColor: colorDarkGrey,
                dividerColor: const Color(0xFFB9B8C1),
                // indicatorPadding: EdgeInsets.symmetric(horizontal: 1),
                tabs: [
                  Tab(text: "upcomingTrips".tr),
                  Tab(text: "pastTrips".tr),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 24,
            // ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: widget.type == 'tour' &&
                        (_authController.localInfo.transportationMethod ?? [])
                            .isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.04,
                            right: width * 0.04,
                            bottom: width * 0.2),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomEmptyWidget(
                                title: 'CompleteInfoDes'.tr,
                                image: "offline",
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 36,
                                ),
                                child: CustomButton(
                                  title: 'CompleteInfo'.tr,
                                  onPressed: () {
                                    _profileController.reset();

                                    Get.to(() => const TourStepper());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Obx(
                        () => Padding(
                          padding: EdgeInsets.only(bottom: width * 0.2),
                          // padding: const EdgeInsets.symmetric(
                          //     horizontal: 0, vertical: 24),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Tab 1 content (upcomingTrips)

                              Skeletonizer(
                                enabled: widget.servicesController
                                    .isUpcommingTicketLoading.value,
                                child: widget.servicesController.upcommingTicket
                                        .isEmpty
                                    ? widget.type == 'tour'
                                        ? CustomEmptyWidget(
                                            title: 'noRequest'.tr,
                                            image: 'NoTicket',
                                            subtitle: 'noRequestSub'.tr,
                                          )
                                        : CustomEmptyWidget(
                                            title: 'noBooking'.tr,
                                            image: 'NoTicket',
                                            subtitle: 'noBookingSub'.tr,
                                          )
                                    // ? Column(
                                    //     children: [
                                    //       Text('true'),
                                    //     ],
                                    //   )
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: widget.servicesController
                                            .upcommingTicket.length,
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 11,
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          return widget.type == 'tour'
                                              ? LocalTripCard(
                                                  trip: widget
                                                      .servicesController
                                                      .upcommingTicket[index],
                                                )
                                              : widget.type == 'event'
                                                  ? EventExperienceCard(
                                                      experience: widget
                                                              .servicesController
                                                              .upcommingTicket[
                                                          index],
                                                      type: widget.type)
                                                  : widget.type == 'hospitality'
                                                      ? HospitalityExperienceCard(
                                                          experience: widget
                                                              .servicesController
                                                              .upcommingTicket[index],
                                                          type: widget.type,
                                                        )
                                                      : CustomExperienceCard(
                                                          experience: widget
                                                              .servicesController
                                                              .upcommingTicket[index],
                                                          type: widget.type);
                                        },
                                      ),
                              ),

                              // Tab 2 content (pastTrips)
                              Skeletonizer(
                                enabled: widget.servicesController
                                    .isPastTicketLoading.value,
                                child: widget
                                        .servicesController.pastTicket.isEmpty
                                    ? widget.type == 'tour'
                                        ? CustomEmptyWidget(
                                            title: 'noRequest'.tr,
                                            image: 'NoTicket',
                                            subtitle: 'noRequestSub'.tr,
                                          )
                                        : CustomEmptyWidget(
                                            title: 'noBooking'.tr,
                                            image: 'NoTicket',
                                            subtitle: 'noBookingSub'.tr,
                                          )
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: widget.servicesController
                                            .pastTicket.length,
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 11,
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          return widget.type == 'tour'
                                              ? LocalTripCard(
                                                  trip: widget
                                                      .servicesController
                                                      .pastTicket[index],
                                                  isPast: true)
                                              : widget.type == 'event'
                                                  ? EventExperienceCard(
                                                      experience: widget
                                                          .servicesController
                                                          .pastTicket[index],
                                                      type: widget.type,
                                                      isPast: true)
                                                  : widget.type == 'hospitality'
                                                      ? HospitalityExperienceCard(
                                                          experience: widget
                                                                  .servicesController
                                                                  .pastTicket[
                                                              index],
                                                          type: widget.type,
                                                          isPast: true)
                                                      : CustomExperienceCard(
                                                          experience: widget
                                                              .servicesController
                                                              .pastTicket[index],
                                                          type: widget.type,
                                                          isPast: true);
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
