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
        'Register Vehicle',
        isBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                text: "Vehicle License",
                fontSize: width * 0.0435,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro'),
            Form(
              key: _authController.vehicleKey,
              child: CustomTextField(
                hintText: 'Enter Vehicle License ',
                inputFormatters: [
                  LengthLimitingTextInputFormatter(17),
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
