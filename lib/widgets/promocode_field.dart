import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/coupon.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PromocodeField extends StatefulWidget {
  const PromocodeField({
    super.key,
    required this.price,
    required this.type,
  });
  final double price;
  final String type;
  @override
  State<PromocodeField> createState() => _PromocodeFieldState();
}

class _PromocodeFieldState extends State<PromocodeField> {
  final _paymentController = Get.put(PaymentController());
  void couponDiscountPercentage(String code, Coupon coupon) async {
    _paymentController.validateType.value = 'applied';
    double discountPrice = AppUtil.couponPercentageCalculating(
      hidoPercentage: widget.type == 'HOSPITALITY' ? 0.25 : 0.3,
      couponPercentage: coupon.discountPercentage!,
      price: widget.price,
    );
    _paymentController.discountPrice.value = discountPrice > coupon.maxDiscount!
        ? coupon.maxDiscount!.toDouble()
        : discountPrice;

    _paymentController.finalPrice(
      widget.price - _paymentController.discountPrice.value,
    );
    _paymentController.couponId(coupon.id);
    // log(_paymentController.couponId.value);
    // log(_paymentController.discountPrice.value.toString());
    // log(_paymentController.finalPrice.value.toString());
  }

  void couponDiscountAmount(String code, Coupon coupon) async {
    _paymentController.validateType.value = 'applied';
    var discountAmount = AppUtil.couponAmountCalculating(
      hidoPercentage: widget.type == 'HOSPITALITY' ? 0.25 : 0.3,
      couponAmount: coupon.discountAmount!,
      price: widget.price,
    );
    _paymentController.discountPrice.value =
        discountAmount > coupon.maxDiscount!
            ? coupon.maxDiscount!.toDouble()
            : discountAmount;
    _paymentController.finalPrice(
      widget.price - _paymentController.discountPrice.value,
    );
    _paymentController.couponId(coupon.id);
    log(_paymentController.couponId.value);
    log(_paymentController.discountPrice.value.toString());
    log(_paymentController.finalPrice.value.toString());
  }

  @override
  void dispose() {
    _paymentController.discountPrice(0);
    _paymentController.finalPrice(0);
    _paymentController.minSpend(0);
    _paymentController.couponId('');
    _paymentController.isUnderMinSpend(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => Form(
        child: CustomTextField(
          textInputAction: TextInputAction.done,
          height: width * 0.14,
          hintText: 'addpromocode'.tr,
          onFieldSubmitted: (code) async {
            if (code.isEmpty) {
              return;
            }
            final coupon = await _paymentController.getCouponByCode(
                context: context, code: code, type: widget.type);
            if (coupon == null) {
              _paymentController.validateType.value = 'invalid';
              return;
            }
            _paymentController.minSpend(coupon.minSpend!);
            if (widget.price < coupon.minSpend!) {
              _paymentController.validateType.value = 'invalid';
              _paymentController.isUnderMinSpend.value = true;
              return;
            }
            _paymentController.isUnderMinSpend.value = false;
            if (coupon.discountPercentage != null) {
              couponDiscountPercentage(code, coupon);
            } else {
              couponDiscountAmount(code, coupon);
            }
          },
          onChanged: (value) {
            _paymentController.isUnderMinSpend.value = false;
            _paymentController.validateType.value = '';
          },
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .030),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _paymentController.isCouponByCodeLoading.value
                    ? [
                        const CircularProgressIndicator(),
                      ]
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
