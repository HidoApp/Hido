import 'dart:async';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/trip_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/model/last_activity.dart';
import 'package:ajwad_v4/explore/ajwadi/view/add_on_map.dart';
import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:ajwad_v4/explore/ajwadi/services/location_service.dart';
import 'package:ajwad_v4/explore/ajwadi/view/custom_local_ticket_card.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/widget/wallet_details_card.dart';
import 'package:ajwad_v4/explore/ajwadi/view/local_ticket_screen.dart';
import 'package:ajwad_v4/explore/ajwadi/view/next_activity.dart';
import 'package:ajwad_v4/explore/tourist/view/notification/notification_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/category_card.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
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

class LocalWalletScreen extends StatefulWidget {
  const LocalWalletScreen({super.key});

  @override
  State<LocalWalletScreen> createState() => _LocalWalletScreenState();
}

class _LocalWalletScreenState extends State<LocalWalletScreen> {
  final _getStorage = GetStorage();
  final _authController = Get.put(AuthController());

  final _profileController = Get.put(ProfileController());
  final _tripController = Get.put(TripController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        'wallet',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24,top:10),
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
                          ? "المعاملات المالية"
                          : 'Financial transactions',
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
                  SizedBox(height: 30),

                  WalletDetailsCard(),


                ],        
          ),
            ],
        ),
      ),
      ),
    );
  }
}
