import 'package:ajwad_v4/services/view/paymentType.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RadioPaymentType extends StatelessWidget {
  const RadioPaymentType(
      {super.key,
      this.groupValue,
      this.onChanged,
      required this.isCreditCard,
      required this.logo,
      this.title,
      required this.value});
  final PaymentMethod? groupValue;
  final void Function(PaymentMethod?)? onChanged;
  final bool isCreditCard;
  final String logo;
  final String? title;
  final PaymentMethod value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<PaymentMethod>(
          value: PaymentMethod.creditCard,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        if (isCreditCard) SvgPicture.asset('assets/icons/logos_mastercard.svg'),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.0051,
        ),
        SvgPicture.asset(
          isCreditCard ? 'assets/icons/logos_visa.svg' : logo,
          height: isCreditCard ? 15 : 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.015,
        ),
        if (isCreditCard)
          CustomText(
            text: title,
            color: Color(0xFF070708),
            fontSize: MediaQuery.of(context).size.width * 0.041,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
          ),
      ],
    );
  }
}
