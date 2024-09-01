import 'dart:developer';
import 'dart:ffi';

import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/new-onboarding/view/splash_screen.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/view/ticket_screen.dart';
import 'package:ajwad_v4/profile/widget/otp_sheet.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CancelSheet extends StatefulWidget {
  final String bookId;
  final String type;

  const CancelSheet({Key? key, required this.bookId, required this.type})
      : super(key: key);

  @override
  _CancelSheetState createState() => _CancelSheetState();
}

class _CancelSheetState extends State<CancelSheet> {
  late TextEditingController textField2Controller;
  String? bookID = '';

  @override
  void initState() {
    super.initState();
    textField2Controller = TextEditingController();
    bookID = widget.bookId;
  }

  @override
  void dispose() {
    textField2Controller.dispose();
    super.dispose();
  }

  OfferController offerController = Get.put(OfferController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        // width: double.infinity,
        // height: 400,

        //  clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 24,
            right: 24,
            bottom: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomSheetIndicator(),
              SizedBox(height: MediaQuery.of(context).size.width * 0.04),
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  color: Color(0xFFFBEAE9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/icons/warning.svg',
                ),
              ),
              SizedBox(height: 10),
              Text(
                AppUtil.rtlDirection2(context) ? "إلغاء الحجز" : "Canceling",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                ),
              ),
              SizedBox(height: 4),
              Text(
                'CancelBookingConfirm'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9392A0),
                  fontFamily:
                      AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 108,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFB9B8C1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: TextField(
                  controller: textField2Controller,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily:
                        AppUtil.rtlDirection2(context) ? 'SF Arabic' : 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppUtil.rtlDirection2(context)
                        ? 'اكتب هنا'
                        : 'Write here',
                    hintStyle: TextStyle(
                      color: Color(0xFFB9B8C1),
                      fontSize: 15,
                      fontFamily: AppUtil.rtlDirection2(context)
                          ? 'SF Arabic'
                          : 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Obx(
                () => offerController.isBookingCancelLoading.value
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : CustomButton(
                        onPressed: () async {
                          log("End Trip Taped ${widget.bookId}");

                          bool bookingCancel =
                              await offerController.bookingCancel(
                                      context: context,
                                      bookingId: widget.bookId,
                                      type: widget.type.toUpperCase(),
                                      reason: textField2Controller.text) ??
                                  false;
                          if (bookingCancel) {
                            int notificationId = int.tryParse(bookID!) ?? 0;
                            await flutterLocalNotificationsPlugin
                                .cancel(notificationId);
                            if (context.mounted) {
                              AppUtil.successToast(context, 'EndTrip'.tr);
                              await Future.delayed(const Duration(seconds: 1));
                            }
                            Get.offAll(const TouristBottomBar());
                          }
                        },
                        title: 'Confirm'.tr,
                        buttonColor: Color(0xFFDC362E),
                        textColor: Colors.white,
                        borderColor: Color(0xFFDC362E),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
