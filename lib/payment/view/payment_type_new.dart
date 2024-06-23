import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/payment/widget/credit_form.dart';
import 'package:ajwad_v4/services/view/paymentType.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:ajwad_v4/widgets/payment_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PaymentType extends StatefulWidget {
  const PaymentType({super.key, required this.price});
  final int price;
  @override
  State<PaymentType> createState() => _PaymentTypeState();
}

class _PaymentTypeState extends State<PaymentType> {
  PaymentMethod? _selectedPaymentMethod;
  Invoice? invoice;

  final _paymentController = Get.put(PaymentController());
  Future<void> selectPaymentType(PaymentMethod paymentMethod) async {
    if (paymentMethod == PaymentMethod.appelpay) {
      invoice = await _paymentController.paymentGateway(
          context: context,
          language: AppUtil.rtlDirection2(context) ? 'AR' : 'EN',
          paymentMethod: 'APPLE_PAY',
          price: widget.price);
    } else if (paymentMethod == PaymentMethod.stcpay) {
      invoice = await _paymentController.paymentGateway(
          context: context,
          language: AppUtil.rtlDirection2(context) ? 'AR' : 'EN',
          paymentMethod: 'STC_PAY',
          price: widget.price);
    } else if (paymentMethod == PaymentMethod.creditCard) {
      invoice = await _paymentController.paymentGateway(
          context: context,
          language: AppUtil.rtlDirection2(context) ? 'AR' : 'EN',
          paymentMethod: 'MADA',
          price: widget.price);
    } else {
      AppUtil.errorToast(context, 'Must pick methoed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar('checkout'.tr),
      body: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: 32,
        ),
        child: Column(
          children: [
            CustomText(
              text: 'paymentMethod'.tr,
              fontSize: width * 0.047,
              fontFamily: 'HT Rakik',
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: width * 0.04,
            ),
            Row(
              children: [
                Radio<PaymentMethod>(
                  value: PaymentMethod.creditCard,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                SvgPicture.asset('assets/icons/logos_mastercard.svg'),
                const SizedBox(
                  width: 2,
                ),
                SvgPicture.asset('assets/icons/logos_visa.svg'),
                SizedBox(
                  width: 6,
                ),
                CustomText(
                  text: 'creditCard'.tr,
                  color: Color(0xFF070708),
                  fontSize: 16,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
                // Text(
                //   'Credit/Debit card',
                //   style: TextStyle(
                //     color: Color(0xFF070708),
                //     fontSize: 15,
                //     fontFamily: 'SF Pro',
                //     fontWeight: FontWeight.w500,
                //     height: 0,
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                Radio<PaymentMethod>(
                  value: PaymentMethod.appelpay,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                // Text('pay'),

                SvgPicture.asset(
                  "assets/icons/applePay_icon.svg",
                  color: Color.fromARGB(255, 0, 0, 0),
                  height: 20,
                ),
              ],
            ),
            Row(
              children: [
                Radio<PaymentMethod>(
                  value: PaymentMethod.stcpay,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                SvgPicture.asset(
                  "assets/icons/stc.svg",
                  height: 20,
                ),
              ],
            ),

            // SizedBox(
            //   height: width * 0.25,
            // ),
            if (_selectedPaymentMethod == PaymentMethod.creditCard)
              CreditForm(),

            // SizedBox(
            //   height: width * 0.25,
            // ),

            //discount widget
            // const PromocodeField(),
            const Spacer(),
            DottedSeparator(
              color: almostGrey,
              height: width * 0.002,
            ),
            SizedBox(
              height: width * 0.09,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'total'.tr,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                CustomText(
                  // text: 'SAR ${widget.adventure.price.toString()}',
                  text: '${"sar".tr} ${widget.price}',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => _paymentController.isPaymentGatewayLoading.value
                  ? const CircularProgressIndicator.adaptive()
                  : CustomButton(
                      onPressed: () async {
                        print(_selectedPaymentMethod);
                        if (_selectedPaymentMethod != null) {
                          await selectPaymentType(_selectedPaymentMethod!);
                          if (invoice != null) {
                            Get.to(() => PaymentWebView(
                                url: invoice!.url!, title: 'payment'.tr));
                          } else {
                            print('invoice nulll');
                          }
                        } else {
                          AppUtil.errorToast(context, "msg");
                        }
                      },
                      title: 'pay'.tr,
                      icon: AppUtil.rtlDirection2(context)
                          ? const Icon(Icons.keyboard_arrow_right,
                              color: Colors.white)
                          : const Icon(Icons.keyboard_arrow_left,
                              color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
