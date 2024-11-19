import 'package:ajwad_v4/explore/ajwadi/model/last_activity.dart';
import 'package:ajwad_v4/explore/ajwadi/view/custom_local_ticket_card.dart';
import 'package:ajwad_v4/explore/ajwadi/view/local_ticket_screen.dart';
import 'package:ajwad_v4/notification/notifications_screen.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/profile/view/my_account.dart';
import 'package:ajwad_v4/profile/widget/prodvided_services_sheet.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../profile/controllers/profile_controller.dart';
import '../../../profile/view/messages_screen.dart';
import '../../../widgets/category_card.dart';
import '../controllers/trip_controller.dart';

class LocalHomeScreen extends StatefulWidget {
  const LocalHomeScreen(
      {super.key, this.fromAjwady = true, required this.profileController});
  final ProfileController profileController;

  final bool fromAjwady;

  @override
  State<LocalHomeScreen> createState() => _LocalHomeScreenState();
}

class _LocalHomeScreenState extends State<LocalHomeScreen> {
  final _profileController = Get.put(ProfileController());
  final _tripController = Get.put(TripController());
  final _requestController = Get.put(RequestController());
  final PaymentController _paymentController = Get.put(PaymentController());

  NextActivity? nextTrip;

  void getNextActivity() async {
    await _tripController.getNextActivity(context: context).then((value) {
      if (!mounted) return;

      // _tripController.nextStep.value =
      //     _tripController.nextTrip.value.activityProgress ?? '';
      if (value != null) {
        _tripController.nextStep.value = value.activityProgress ?? '';

        if (_tripController.nextTrip.value.activityProgress != 'PENDING' &&
            _tripController.nextTrip.value.activityProgress!.isNotEmpty &&
            _tripController.nextTrip.value.activityProgress != '') {
          _tripController.progress.value = getActivityProgressText(
                  _tripController.nextTrip.value.activityProgress ?? '',
                  context)
              .clamp(0.0, 1.0);
        } else {
          _tripController.progress.value =
              (_tripController.progress.value - 1.0).clamp(0.0, 1.0);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (_profileController.profile.accountType != 'EXPERIENCES') {
      getNextActivity();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Obx(
      () => Skeletonizer(
        enabled: _profileController.isProfileLoading.value,
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            if (_profileController.profile.accountType != 'EXPERIENCES') {
              await _tripController.getNextActivity(context: context);
              //  getNextActivity();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 53, left: 16, right: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: width * 0.8728,
                      //height: 60,
                      height: width * 0.08,
                    ),
                    // SizedBox(height: 16),

                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: width * 0.09),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  ProfileController profileController =
                                      Get.put(ProfileController());
                                  Get.to(() => MessagesScreen(
                                      profileController: profileController));
                                },
                                child: SizedBox(
                                  width: 36,
                                  height: 22,
                                  child: SvgPicture.asset(
                                      'assets/icons/Communication_black.svg'),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => NotificationsScreen());
                                },
                                child: SizedBox(
                                  width: 36,
                                  height: 24,
                                  child: SvgPicture.asset(
                                      'assets/icons/AlertBlack2.svg'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaler: TextScaler.linear(1.0)),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: AppUtil.rtlDirection2(context)
                                          ? "ياهلا"
                                          : 'Welcome ',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(7, 7, 8, 1),
                                        fontSize: 20,
                                        fontFamily: 'HT Rakik',
                                        fontWeight: FontWeight.w500,
                                        height: 0.07,
                                        letterSpacing: 0.80,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _profileController
                                              .isProfileLoading.value
                                          ? ""
                                          : ' ${_profileController.profile.name ?? "".split(' ').take(1).join(' ')}',
                                      style: TextStyle(
                                        color: const Color(0xFF37B268),
                                        fontSize: width * 0.051,
                                        fontFamily: 'HT Rakik',
                                        fontWeight: FontWeight.w500,
                                        height: 0.07,
                                        letterSpacing: 0.80,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //const Spacer(),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 11.0),
                            //   child: Row(
                            //     children: [
                            //       InkWell(
                            //         onTap: () {
                            //           ProfileController profileController =
                            //               Get.put(ProfileController());
                            //           Get.to(() => MessagesScreen(
                            //               profileController: profileController));
                            //         },
                            //         child: SizedBox(
                            //           width: 36,
                            //           height: 24,
                            //           child: SvgPicture.asset(
                            //               'assets/icons/Communication_black.svg'),
                            //         ),
                            //       ),
                            //       InkWell(
                            //         onTap: () {
                            //           Get.to(() => NotificationsScreen());
                            //         },
                            //         child: SizedBox(
                            //           width: 36,
                            //           height: 24,
                            //           child: SvgPicture.asset(
                            //               'assets/icons/AlertBlack2.svg'),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: width * 0.02),
                    SizedBox(
                      width: double.infinity,
                      height: 168,
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 0, vertical: 16),
                      child: const Center(
                        child: CustomWalletCard(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Yourservices'.tr,
                          color: const Color(0xFF070708),
                          fontSize: 17,
                          fontFamily: 'HT Rakik',
                          fontWeight: FontWeight.w500,
                          height: 0.10,
                          textDirection: TextDirection.ltr,
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            CategoryCard(
                              title: AppUtil.rtlDirection2(context)
                                  ? "جولات "
                                  : 'Tours',
                              icon: 'tour_category',
                              color: const Color(0xFFECF9F1),
                              onPressed: () {
                                // log(_profileController.profile.accountType!);
                                if (_profileController.profile.accountType ==
                                    'EXPERIENCES') {
                                  Get.to(() => MyAccount(
                                        isLocal: true,
                                        profileController: _profileController,
                                      ));
                                  Get.bottomSheet(
                                      const ProdvidedServicesSheet());
                                } else {
                                  Get.to(
                                    () => LocalTicketScreen(
                                      servicesController:
                                          Get.put(TripController()),
                                      type: 'tour',
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 6),
                            CategoryCard(
                              title: 'hospitality'.tr,
                              icon: 'host_category',
                              color: const Color(0xFFF5F2F8),
                              onPressed: () {
                                Get.to(
                                  () => LocalTicketScreen(
                                    servicesController:
                                        Get.put(HospitalityController()),
                                    type: 'hospitality',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            CategoryCard(
                              title: 'adventure'.tr,
                              icon: 'adventure_category',
                              color: const Color(0xFFF9F4EC),
                              onPressed: () {
                                Get.to(
                                  () => LocalTicketScreen(
                                    servicesController:
                                        Get.put(AdventureController()),
                                    type: 'adventure',
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6),
                            CategoryCard(
                              title: 'LocalEvent'.tr,
                              icon: 'event_category',
                              color: const Color(0xFFFEFDF1),
                              onPressed: () {
                                Get.to(
                                  () => LocalTicketScreen(
                                    servicesController:
                                        Get.put(EventController()),
                                    type: 'event',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        if (_profileController.profile.accountType !=
                            'EXPERIENCES') ...{
                          CustomText(
                            text: 'nextActivity'.tr,
                            color: const Color(0xFF070708),
                            fontSize: 17,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                            height: 0.10,
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(height: 27),
                          Obx(
                            () => Skeletonizer(
                              enabled: _tripController
                                      .isNextActivityLoading.value ||
                                  _requestController.isRequestEndLoading.value,
                              child: !_tripController.isTripUpdated.value ||
                                      _tripController.nextTrip.value.id!.isEmpty
                                  //! _tripController.isTripUpdated.value

                                  ? Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 135,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 1.50,
                                                  color: Color(0xFFECECEE)),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Center(
                                            child: CustomText(
                                              text: "noNextActivity".tr,
                                              textAlign: TextAlign.center,
                                              color: const Color(0xFFDCDCE0),
                                              fontSize: 16,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? "SF Arabic"
                                                      : 'SF Pro',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20)
                                      ],
                                    )
                                  : const Column(
                                      children: [
                                        //  SizedBox(height: 11),
                                        CustomLocalTicketCard(),

                                         SizedBox(height: 11),
                                      ],
                                    ),
                            ),
                          ),
                        }
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

double getActivityProgressText(String activityProgress, BuildContext context) {
  switch (activityProgress) {
    case 'ON_WAY':
      return 0.25;
    case 'ARRIVED':
      return 0.50;
    case 'IN_PROGRESS':
      return 0.75;
    default:
      return 1.0; // Handle any other possible values
  }
}
