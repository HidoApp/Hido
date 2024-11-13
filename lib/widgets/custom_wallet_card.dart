import 'package:ajwad_v4/explore/ajwadi/model/wallet.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:intl/intl.dart' as intel;
import 'package:skeletonizer/skeletonizer.dart';

class CustomWalletCard extends StatefulWidget {
  const CustomWalletCard({super.key});

  @override
  _CustomWalletCardState createState() => _CustomWalletCardState();
}

class _CustomWalletCardState extends State<CustomWalletCard> {
  // You can initialize variables here
  final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());
  final PaymentController _paymentController = Get.put(PaymentController());
  Wallet? wallet;

  @override
  void initState() {
    super.initState();
    getWallet();
  }

  void getWallet() async {
    wallet = await _paymentController.getWallet(context: context);
  }

  @override
  Widget build(BuildContext context) {
    Place? thePlace;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Obx(
      () => Skeletonizer(
        enabled: _paymentController.isWalletLoading.value,
        child: InkWell(
          onTap: () {
            // Get.to(() => LocalWalletScreen());
          },
          child: Container(
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
                        text: wallet?.totalInitiatedAmount.toString() ?? '0.0',
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
        ),
      ),
    );
  }

  String getOrderStatusText(BuildContext context, String orderStatus) {
    if (AppUtil.rtlDirection2(context)) {
      switch (orderStatus) {
        case 'ACCEPTED':
          return 'مؤكد';
        case 'Uppending':
          return 'في الانتظار';
        case 'Finished':
          return 'اكتملت';
        case 'CANCELED':
          return 'تم الالغاء';
        default:
          return orderStatus;
      }
    } else {
      return orderStatus;
    }
  }

  String getBookingTypeText(BuildContext context, String bookingType) {
    if (AppUtil.rtlDirection2(context)) {
      switch (bookingType) {
        case 'place':
          return 'جولة';
        case 'adventure':
          return 'مغامرة';
        case 'hospitality':
          return 'ضيافة';
        case 'event':
          return 'فعالية';
        default:
          return bookingType;
      }
    } else {
      if (bookingType == 'place') {
        return "Tour";
      } else {
        return bookingType;
      }
    }
  }

  String formatBookingDate(BuildContext context, String date) {
    DateTime dateTime = DateTime.parse(date);
    if (AppUtil.rtlDirection2(context)) {
      // Set Arabic locale for date formatting
      return intel.DateFormat('EEEE، d MMMM yyyy', 'ar').format(dateTime);
    } else {
      // Default to English locale
      return intel.DateFormat('EEEE, d MMMM yyyy').format(dateTime);
    }
  }
}
