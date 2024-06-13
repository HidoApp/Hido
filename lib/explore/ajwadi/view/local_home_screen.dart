import 'dart:async';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_on_map.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
import 'package:ajwad_v4/explore/ajwadi/view/custom_local_ticket_card.dart';
import 'package:ajwad_v4/explore/tourist/view/notification/notification_screen.dart';
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

class LocalHomeScreen extends StatefulWidget {
  const LocalHomeScreen({super.key, this.fromAjwady = true,required this.profileController});
  final ProfileController profileController;

  final bool fromAjwady;

  @override
  State<LocalHomeScreen> createState() => _LocalHomeScreenState();
}

class _LocalHomeScreenState extends State<LocalHomeScreen> {
  final _getStorage = GetStorage();
  final _authController = Get.put(AuthController());

  final _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();

    getProfile();
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
                  padding: const EdgeInsets.only(top: 44, left: 16, right: 16),
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
                                child:SvgPicture.asset(
                                    'assets/icons/Alerts_black.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18),
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:AppUtil.rtlDirection2(context)?"ياهلا": 'Welcome ',
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
                                      : AppUtil.rtlDirection2(context)?" نورة العيسى":'${_profileController.profile.name ?? ""}',
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
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 184,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 16),
                        child: Center(
                          child: CustomWalletCard(),
                        ),
                      ),
                      Container(
                        width: 358,
                        height: 441,
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                               AppUtil.rtlDirection(context)?"خدمات": 'Your services',
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
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CategoryCard(
                                  title:  AppUtil.rtlDirection(context)?"جولات ":'Tours',
                                  icon: 'tour_category',
                                  color: Color(0xFFECF9F1),
                                  onPressed: () {
                                    Get.to(
                                      () => TicketScreen(
                                        profileController:
                                            _profileController,
                                      ),
                                    );
                                  },
                                ),
                                CategoryCard(
                                    title:  AppUtil.rtlDirection(context)?"استضافة":'Hospitality',
                                    icon: 'host_category',
                                    color: Color(0xFFF5F2F8)),
                                CategoryCard(
                                    title: 'Adventure',
                                    icon: 'adventure_category',
                                    color: Color(0xFFF9F4EC)),
                              ],
                            ),
                            SizedBox(height: 32),
                            Text(
                              AppUtil.rtlDirection(context)?"نشاطك القادم": 'Your next activity ',
                              style: TextStyle(
                                color: Color(0xFF070708),
                                fontSize: 17,
                                fontFamily: 'HT Rakik',
                                fontWeight: FontWeight.w500,
                                height: 0.10,
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                            SizedBox(height: 16),
                            CustomLocalTicketCard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
