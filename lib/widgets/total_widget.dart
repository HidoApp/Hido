import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/models/schedule.dart';
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
//     print('Price per night: ${widget.place.price!}');
print('Number of guests: ${widget.offerController!.offerDetails.value.booking!.guestNumber!}');
 print('Additional charges total: ${widget.offerController!.totalPrice.value}');
// print('Total price: ${(widget.place.price! * widget.offerController!.offerDetails.value.booking!.guestNumber!) + (widget.offerController!.totalPrice.value * widget.offerController!.offerDetails.value.booking!.guestNumber!)}');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'total'.tr,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: black,
                    fontSize: 20,
                    fontFamily: 'HT Rakik',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // const SizedBox(height: 4),
                // Text(
                //   "discount".tr,
                //   textAlign: TextAlign.right,
                //   style: const TextStyle(
                //     color: Color(0xFF9E9E9E),
                //     fontSize: 14,
                //     fontFamily: 'HT Rakik',
                //     fontWeight: FontWeight.w300,
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Obx(
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
                              '${ (widget.offerController?.totalPrice.value ?? 0) * (widget.offerController?.offerDetails.value.booking?.guestNumber ?? 0)}',

                          
                          style: const TextStyle(
                            color: black,
                            fontSize: 20,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      TextSpan(text:'  '),
                         TextSpan(
                          text: 'sar'.tr,
                          style: TextStyle(
                            color: black,
                            fontSize: 20,
                            fontFamily: 'HT Rakik',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Discount
                  // const Text.rich(
                  //   TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: ' 00.00 ',
                  //         style: TextStyle(
                  //           color: Color(0xFF9E9E9E),
                  //           fontSize: 14,
                  //           fontFamily: 'HT Rakik',
                  //           fontWeight: FontWeight.w300,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: 'ريال سعودي',
                  //         style: TextStyle(
                  //           color: Color(0xFF9E9E9E),
                  //           fontSize: 10,
                  //           fontFamily: 'HT Rakik',
                  //           fontWeight: FontWeight.w300,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //   textAlign: TextAlign.right,
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  
}
