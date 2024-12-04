import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  // You can initialize variables here

  final PaymentController _paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    Place? thePlace;

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Obx(
      () => Container(
        width: double.infinity,
        height: 137,
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          color: Colors.white,
          shadows: [
            BoxShadow(
              color: Color(0x3FC7C7C7),
              blurRadius: 15,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(228, 233, 235, 246),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/icons/Finance_icon.svg'),
                ),
              ),
              CustomText(
                text: AppUtil.rtlDirection2(context)
                    ? "إجمالي المحفظة"
                    : 'Total balance',
                color: const Color(0xFFB9B8C1),
                fontSize: 13,
                fontFamily:
                    AppUtil.rtlDirection2(context) ? "SF Arabic" : 'SF Pro',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
              const SizedBox(
                width: 4,
              ),
              MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(1.0)),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: _paymentController.wallet.value.totalInitiatedAmount
                        .toString(),
                    style: TextStyle(
                      color: const Color(0xFF070708),
                      fontSize: AppUtil.rtlDirection(context) ? 28 : 28,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: AppUtil.rtlDirection2(context) ? " ر.س " : ' SAR',
                    style: const TextStyle(
                      color: Color(0xFFB9B8C1),
                      fontSize: 20,
                      fontFamily: 'HT Rakik',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.80,
                    ),
                  )
                ])),
              ),
              // The rest of your widget tree can go here...
            ],
          ),
        ),
      ),
    );
  }
}
