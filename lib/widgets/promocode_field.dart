import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PromocodeField extends StatefulWidget {
  const PromocodeField({super.key});

  @override
  State<PromocodeField> createState() => _PromocodeFieldState();
}

class _PromocodeFieldState extends State<PromocodeField> {
  final _paymentController = Get.put(PaymentController());
  //bool isApplied = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => CustomTextField(
        height: width * 0.14,
        hintText: 'addpromocode'.tr,
      
        onChanged: (value) {
          if (value.trim() == 'HidoGo') {
            _paymentController.isApplied.value = true;
          } else {
            _paymentController.isApplied.value = false;
          }
        },
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .030),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _paymentController.isApplied.value
                ? [
                    CustomText(
                      text: 'applied'.tr,
                      color: colorGreen,
                      fontSize: width * 0.03,
                    ),
                    SizedBox(
                      width: width * .02,
                    ),
                    RepaintBoundary(
                        child: SvgPicture.asset('assets/icons/promocode.svg'))
                  ]
                : [],
          ),
        ),
      ),
    );
  }
}
