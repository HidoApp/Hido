import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TotalWidget extends StatefulWidget {
  final OfferController? offerController;
  final Place place;
  const TotalWidget({
    super.key,
    required this.offerController,
    required this.place,
  });

  @override
  State<TotalWidget> createState() => _TotalWidgetState();
}

class _TotalWidgetState extends State<TotalWidget> {
  List<Schedule>? scheduleList;

  @override
  void initState() {
    scheduleList = widget.offerController?.offerDetails.value.schedule;
    widget.offerController?.getTotalPrice(
        widget.offerController?.offerDetails.value.schedule, null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

//
    // print(
    //     'Number of guests: ${widget.offerController!.offerDetails.value.booking!.guestNumber!}');
    // print(
    //     'Additional charges total: ${widget.offerController!.totalPrice.value}');
//

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'total'.tr,
              textAlign: TextAlign.right,
              color: black,
              fontSize: width * 0.05,
              fontFamily: 'HT Rakik',
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          // ' ${(widget.place.price! * widget.offerController!.offerDetails.value.booking!.guestNumber!) + (widget.offerController!.totalPrice.value * widget.offerController!.offerDetails.value.booking!.guestNumber!)} ',
                          // '${(widget.place?.price ?? 0) * (widget.offerController?.offerDetails.value?.booking?.guestNumber ?? 0) + (widget.offerController?.totalPrice.value ?? 0) * (widget.offerController?.offerDetails.value?.booking?.guestNumber ?? 0)}',
                          '${(widget.offerController?.totalPrice.value ?? 0) * (widget.offerController?.offerDetails.value.booking?.guestNumber ?? 0)}',
                      style: TextStyle(
                        color: black,
                        fontSize: width * 0.05,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(text: '  '),
                    TextSpan(
                      text: 'sar'.tr,
                      style: TextStyle(
                        color: black,
                        fontSize: width * 0.05,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              //   const SizedBox(height: 4),
            ],
          ),
        )
      ],
    );
  }
}
