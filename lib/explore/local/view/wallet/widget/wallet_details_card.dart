import 'dart:developer';

import 'package:ajwad_v4/explore/local/model/transaction.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WalletDetailsCard extends StatefulWidget {
  const WalletDetailsCard(
      {Key? key,
      this.color,
      this.title,
      this.icon,
      this.date,
      this.transaction})
      : super(key: key);

  final String? title;
  final String? icon;
  final Color? color;
  final String? date;
  final Transaction? transaction;

  @override
  _WalletDetailsCardState createState() => _WalletDetailsCardState();
}

class _WalletDetailsCardState extends State<WalletDetailsCard> {
  late final PaymentController _paymentController;
  final _touristExploreController = Get.put(TouristExploreController());

  Booking? profileBooking;
  bool isLoading = false; // Track loading state

  void getBooking() async {
    setState(() => isLoading = true); // Start loading
    profileBooking = await _touristExploreController.getTouristBookingById(
      context: context,
      bookingId: widget.transaction!.details!.bookingId!,
    );
    setState(() => isLoading = false); // Stop loading
  }

  @override
  void initState() {
    super.initState();
    _paymentController = Get.put(PaymentController());
    if (widget.transaction!.details!.bookingId!.isNotEmpty &&
        widget.date == 'event') {
      log(widget.transaction!.id ?? '');
      getBooking();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: _touristExploreController.isBookingByIdLoading.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.transaction?.updated?.isEmpty ?? true
                ? '3 June 2024'
                : AppUtil.formatBookingDate(
                    context, widget.transaction!.updated!),
            style: TextStyle(
              color: const Color(0xFF070708),
              fontSize: 13,
              fontFamily:
                  AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side:
                        const BorderSide(width: 0.50, color: Color(0xFFE2E2E2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          color: widget.color ?? const Color(0xFFE9EBF6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        child: SvgPicture.asset(
                            'assets/icons/${widget.icon}.svg')),
                    const SizedBox(width: 8),
                    Text(
                      profileBooking?.nameEn ?? 'Bank Transfer',
                      style: TextStyle(
                        color: const Color(0xFF070708),
                        fontSize: 13,
                        fontFamily: AppUtil.rtlDirection2(context)
                            ? 'SF Arabic'
                            : 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              '-1,400.00',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF070708),
                                fontSize: 15,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'SAR',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF070708),
                                fontSize: 11,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '00.00',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFFB9B8C1),
                                fontSize: 12,
                                fontFamily: AppUtil.rtlDirection2(context)
                                    ? 'SF Arabic'
                                    : 'SF Pro',
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
