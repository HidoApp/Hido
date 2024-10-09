import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PromocodeField extends StatefulWidget {
  const PromocodeField({super.key, required this.price, this.isHost = false});
  final int price;
  final bool isHost;
  @override
  State<PromocodeField> createState() => _PromocodeFieldState();
}

class _PromocodeFieldState extends State<PromocodeField> {
  final _paymentController = Get.put(PaymentController());
  void couponHandle(String code) async {
    final coupon = await _paymentController.getCouponByCode(
        context: context, code: code, type: 'ADVENTURE');
    if (coupon == null) {
      _paymentController.validateType.value = 'invalid';
      return;
    }
    _paymentController.validateType.value = 'applied';
    _paymentController.finalPrice.value = AppUtil.couponPercentageCalculating(
      hidoPercentage: widget.isHost ? 0.25 : 0.3,
      couponPercentage: coupon.discountPercentage!,
      price: 100,
    );
    log(_paymentController.finalPrice.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => Form(
        child: CustomTextField(
          height: width * 0.14,
          hintText: 'addpromocode'.tr,
          onFieldSubmitted: (code) async {
            if (code.isEmpty) {
              return;
            }
            couponHandle(code);
          },
          onChanged: (value) => _paymentController.validateType.value = '',
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .030),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _paymentController.isCouponByCodeLoading.value
                    ? [const CircularProgressIndicator()]
                    : buildPrefix(width)),
          ),
        ),
      ),
    );
  }

  List<Widget> buildPrefix(double width) {
    switch (_paymentController.validateType.value) {
      case '':
        return [];
      case 'applied':
        return [
          CustomText(
            text: 'applied'.tr,
            color: colorGreen,
            fontSize: width * 0.03,
          ),
          SizedBox(
            width: width * .02,
          ),
          RepaintBoundary(
            child: SvgPicture.asset(
              'assets/icons/promocode.svg',
            ),
          )
        ];
      case 'invalid':
        return [
          CustomText(
            text: 'invalidCoupon'.tr,
            color: colorRed,
            fontSize: width * 0.03,
          ),
          SizedBox(
            width: width * .02,
          ),
          RepaintBoundary(
            child: SvgPicture.asset(
              'assets/icons/couponFailed.svg',
            ),
          )
        ];
      default:
        return [];
    }
  }
}
