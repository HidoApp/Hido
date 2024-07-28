import 'dart:async';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/model/last_activity.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_on_map.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
import 'package:ajwad_v4/explore/ajwadi/view/custom_local_ticket_card.dart';
import 'package:ajwad_v4/explore/ajwadi/view/local_ticket_screen.dart';
import 'package:ajwad_v4/explore/ajwadi/view/next_activity.dart';
import 'package:ajwad_v4/explore/tourist/view/notification/notification_screen.dart';
import 'package:ajwad_v4/profile/view/my_account.dart';
import 'package:ajwad_v4/profile/widget/prodvided_services_sheet.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../auth/view/sigin_in/signin_screen.dart';
import '../../../profile/controllers/profile_controller.dart';
import '../../../profile/view/messages_screen.dart';
import '../../../profile/view/ticket_screen.dart';
import '../../../widgets/category_card.dart';
import '../../../widgets/custom_app_bar.dart';
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
  final _getStorage = GetStorage();
  final _authController = Get.put(AuthController());

  final _profileController = Get.put(ProfileController());
  final _tripController = Get.put(TripController());

  void getNextActivity() async {
    await _tripController.getNextActivity(context: context);
  }

  @override
  void initState() {
    super.initState();

    getProfile();
    getNextActivity();
  }

  void getProfile() async {
    await _profileController.getProfile(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Obx(
      () => _profileController.isProfileLoading.value
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 53, left: 16, right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 340.40,
                        height: 60,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.rtl,
                          children: [
                            InkWell(
                              onTap: () {
                                ProfileController _profileController =
                                    Get.put(ProfileController());
                                Get.to(() => MessagesScreen(
                                    profileController: _profileController));
                              },
                              child: Container(
                                width: 36,
                                height: 24,
                                child: SvgPicture.asset(
                                    'assets/icons/Communication_black.svg'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => NotificationScreen());
                              },
                              child: Container(
                                width: 36,
                                height: 24,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                    'assets/icons/Alerts_black.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: AppUtil.rtlDirection2(context)
                                      ? "ياهلا"
                                      : 'Welcome ',
                                  style: TextStyle(
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
                                      : ' ${_profileController.profile.name ?? ""}',
                                  style: TextStyle(
                                    color: Color(0xFF37B268),
                                    fontSize: 20,
                                    fontFamily: 'HT Rakik',
                                    fontWeight: FontWeight.w500,
                                    height: 0.07,
                                    letterSpacing: 0.80,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 1),
                      Container(
                        width: double.infinity,
                        height: 168,
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: 0, vertical: 16),
                        child: Center(
                          child: CustomWalletCard(),
                        ),
                      ),
                      SizedBox(height: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              AppUtil.rtlDirection2(context)
                                  ? "الخدمات المقدمة"
                                  : 'Your services',
                              style: TextStyle(
                                color: Color(0xFF070708),
                                fontSize: 17,
                                fontFamily: 'HT Rakik',
                                fontWeight: FontWeight.w500,
                                height: 0.10,
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          SizedBox(height: 25),
                          Row(
                            children: [
                              CategoryCard(
                                title: AppUtil.rtlDirection2(context)
                                    ? "جولات "
                                    : 'Tours',
                                icon: 'tour_category',
                                color: Color(0xFFECF9F1),
                                onPressed: () {
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
                              SizedBox(width: 6),
                              CategoryCard(
                                title: AppUtil.rtlDirection2(context)
                                    ? "استضافة"
                                    : 'Hospitality',
                                icon: 'host_category',
                                color: Color(0xFFF5F2F8),
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
                          SizedBox(height: 6),
                          Row(
                            children: [
                              CategoryCard(
                                title: AppUtil.rtlDirection2(context)
                                    ? 'مغامرات'
                                    : 'Adventure',
                                icon: 'adventure_category',
                                color: Color(0xFFF9F4EC),
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
                              SizedBox(width: 6),
                              CategoryCard(
                                title: AppUtil.rtlDirection2(context)
                                    ? 'فعاليات محلية'
                                    : 'Local Event',
                                icon: 'event_category',
                                color: Color(0xFFFEFDF1),
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
                          SizedBox(height: 40),
                          Text(
                            AppUtil.rtlDirection2(context)
                                ? "نشاطك القادم"
                                : 'Your next activity ',
                            style: TextStyle(
                              color: Color(0xFF070708),
                              fontSize: 17,
                              fontFamily: 'HT Rakik',
                              fontWeight: FontWeight.w500,
                              height: 0.10,
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                          SizedBox(height: 27),
                          Obx(
                            () => _tripController.isNextActivityLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator.adaptive())
                                : _tripController.nextTrip.isEmpty
                                    ? Container(
                                        width: double.infinity,
                                        height: 135,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 1.50,
                                                color: Color(0xFFECECEE)),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "noNextActivity".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFFDCDCE0),
                                              fontSize: 16,
                                              fontFamily:
                                                  AppUtil.rtlDirection2(context)
                                                      ? "SF Arabic"
                                                      : 'SF Pro',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          //  SizedBox(height: 11),

                                          CustomLocalTicketCard(
                                            nextTrip: _tripController.nextTrip,
                                          ),

                                          SizedBox(height: 11),
                                        ],
                                      ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
