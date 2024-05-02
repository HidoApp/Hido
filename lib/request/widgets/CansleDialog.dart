import 'package:flutter/material.dart';
import 'package:ajwad_v4/request/widgets/ContactDialog.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'dart:developer';

import 'package:get/get.dart';


class CancelBookingDialog extends StatelessWidget {
  final double dialogWidth;
  final double buttonWidth;
  final Booking? booking;
  final OfferController offerController;

  const CancelBookingDialog({
    Key? key,
    required this.dialogWidth,
    required this.buttonWidth,
    this.booking,
    required this.offerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      content: Container(
        width: dialogWidth,
        height: 118,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ContactDialog(dialogWidth: MediaQuery.of(context).size.width * 0.588,buttonWidth:MediaQuery.of(context).size.width * 1.191);
                  },
                );
              },
              child: Container(
                height: 40,
                width: buttonWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF37B268)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "contact".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF37B268),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(() => offerController.isBookingCancelLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : GestureDetector(
                    onTap: () async {
                      log("End Trip Taped ${booking!.id}");

                      bool bookingCancel =
                          await offerController.bookingCancel(
                              context: context,
                              bookingId: booking!.id!) ??
                          false;
                      if (bookingCancel) {
                        if (context.mounted) {
                          AppUtil.successToast(context, 'EndTrip'.tr);
                          await Future.delayed(const Duration(seconds: 1));
                        }
                        Get.offAll(const TouristBottomBar());
                      }
                    },
                    child: Text(
                      "cancel".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFDC362E),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
