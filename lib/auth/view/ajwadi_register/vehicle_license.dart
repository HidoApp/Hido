import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class VehicleLicenseScreen extends StatefulWidget {
  const VehicleLicenseScreen({super.key});

  @override
  State<VehicleLicenseScreen> createState() => _VehicleLicenseScreenState();
}

class _VehicleLicenseScreenState extends State<VehicleLicenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        'registerVehicle'.tr,
        isBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: width * 0.041,
            right: width * 0.041,
            top: width * 0.0307,
            bottom: width * 0.082),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                text: "vehicleLicense".tr,
                fontSize: width * 0.0435,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro'),
            Form(
              key: _authController.vehicleKey,
              child: CustomTextField(
                hintText: 'vehicleHint'.tr,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(9),
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _authController.vehicleLicense(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
