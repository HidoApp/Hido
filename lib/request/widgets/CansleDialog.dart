import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:amplitude_flutter/events/base_event.dart';
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
    AmplitudeService.initializeAmplitude();

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      content: SizedBox(
        width: double.infinity,
        // height: AppUtil.rtlDirection2(context) ? 140 : 138,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 4,
            ),
            CustomText(
              textAlign: TextAlign.center,
              color: const Color(0xFF070708),
              fontSize: 15,
              fontFamily: AppUtil.SfFontType(context),
              fontWeight: FontWeight.w500,
              text: AppUtil.rtlDirection2(context)
                  ? "نعتذر عن أي مشكلة واجهتك "
                  : "Sorry for any inconveniences",
            ),
            const SizedBox(
              height: 1,
            ),
            CustomText(
              textAlign: TextAlign.center,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF41404A),
              text: 'noteDo'.tr,
              // text:!AppUtil.rtlDirection2(context)?"Here is what you can do":"لم نتمكن من العثور على أي مرشدين محليين متاحين في التاريخ والموقع الذي اخترته",
              fontFamily: AppUtil.SfFontType(context),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ContactDialog(
                        dialogWidth: dialogWidth, buttonWidth: buttonWidth);
                  },
                );
              },
              child: Container(
                // height: 34,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomText(
                  textAlign: TextAlign.center,
                  text: "contact".tr,
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: AppUtil.SfFontType(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => offerController.isBookingCancelLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: colorRed),
                  )
                : GestureDetector(
                    onTap: () async {
                      log("End Trip Taped ${booking!.id}");

                      bool bookingCancel = await offerController.bookingCancel(
                              context: context,
                              bookingId: booking!.id!,
                              type: 'PLACE') ??
                          false;
                      if (bookingCancel) {
                        if (context.mounted) {
                          AppUtil.successToast(context, 'EndTrip'.tr);
                          await Future.delayed(const Duration(seconds: 2));
                          //   await Get.delete<TimerController>(force: true);
                        }
                        Get.offAll(const TouristBottomBar());
                        AmplitudeService.amplitude.track(BaseEvent(
                          'Tour Successfully canceled before payment',
                        ));
                      } else {
                        if (context.mounted) {
                          AppUtil.errorToast(context, 'noEndTrip'.tr);
                          await Future.delayed(const Duration(seconds: 2));
                        }
                        AmplitudeService.amplitude.track(BaseEvent(
                          'Tour Cancellation Faild before Payment',
                        ));
                      }
                    },
                    child: Container(
                        width: double.infinity,
                        // height: 34,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFDC362E),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: CustomText(
                            textAlign: TextAlign.center,
                            fontSize: 15,
                            fontFamily: AppUtil.SfFontType(context),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFDC362E),
                            text: 'cancelTrip'.tr)),
                  )),
          ],
        ),
      ),
    );
  }
}
