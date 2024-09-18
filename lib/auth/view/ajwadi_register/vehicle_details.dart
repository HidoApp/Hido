import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({super.key});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
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
                  text: 'لوحة المركبة',
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
              SizedBox(
                height: 30,
              ),
              CustomText(
                  text: 'نوع المركبة',
                  fontSize: width * 0.0435,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro'),
            ],
          ),
        ));
  }
}
