import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/request/chat/view/chat_screen_live.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TripBookingWidget extends StatefulWidget {
  const TripBookingWidget({
    super.key,
    required this.booking,
    required this.touristExploreController,
    required this.bookingId,
  });

  final Booking booking;
  final String bookingId;
  final TouristExploreController touristExploreController;

  @override
  State<TripBookingWidget> createState() => _TripBookingWidgetState();
}

class _TripBookingWidgetState extends State<TripBookingWidget> {
  late Booking? theBooking;
  OfferController offerController = Get.put(OfferController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return InkWell(
      onTap: () async {
        // setState(() async{
        final localBooking = await widget.touristExploreController
            .getTouristBookingById(
                context: context, bookingId: widget.bookingId);
        //  });
        //
        Get.to(() => FindAjwady(
              booking: localBooking!,
              place: widget.booking.place!,
              placeId: widget.booking.placeId!,
            ));

        //    setState(() {
        theBooking = localBooking;
        // });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8).copyWith(
          right: 10,
          left: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                widget.booking.place!.image![0],
              ),
              radius: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //      CustomText(
                //       text: booking.date.substring(0,10),
                //       fontSize: 10,
                //       fontWeight: FontWeight.w400,
                //       color: colorGreen,
                //     ),
                //     const SizedBox(width: 5,),
                //     Container(
                //       width: 5,
                //       height: 5,
                //       decoration: const BoxDecoration(
                //         color: colorGreen,
                //         shape: BoxShape.circle,
                //       ),
                //     ),
                //     const SizedBox(width: 5,),
                //      CustomText(
                //       text:  '${booking.time} ',

                //       fontSize: 10,
                //       fontWeight: FontWeight.w400,
                //       color: colorGreen,
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 8,
                // ),
                SizedBox(
                  width: width * 0.6,
                  height: height * 0.04,
                  child: Row(
                    children: [
                      SizedBox(
                        height: height * 0.04,
                        width: width * 0.35,
                        child: CustomText(
                          text:
                              '${'youHaveReservationIn'.tr} ${AppUtil.rtlDirection(context) ? widget.booking.place!.nameEn! : widget.booking.place!.nameAr!} ',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                      const Spacer(),
                      CustomText(
                        text: widget.booking.date.substring(0, 10),
                        fontSize: 8,
                        color: colorGreen,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),

                if (widget.booking.chatId != null)
                  SizedBox(
                      width: width * 0.6,
                      height: height * 0.045,
                      child: CustomButton(
                        onPressed: () {
                          Get.to(() => ChatScreenLive(
                                isAjwadi: false,
                                offerController: offerController,
                                //   booking: widget.booking,
                                chatId: widget.booking.chatId,
                                place: widget.booking.place,
                              ));
                        },
                        title: 'chat'.tr,
                        icon: SvgPicture.asset('assets/icons/chat.svg'),
                      ))
              ],
            ),
            //   Row(
            //     children: [

            //       CustomText(
            //         text:booking.orderStatus!,
            //         //  status == 'canceled'
            //         //     ? 'canceled'.tr
            //         //     : status == 'waiting'
            //         //         ? 'waiting'.tr
            //         //         :
            //                // 'confirmed'.tr,
            //         fontSize: 10,
            //         fontWeight: FontWeight.w400,
            //         color:

            //         // status == 'canceled'
            //         //     ? colorRed
            //         //     : status == 'waiting'
            //         //         ? yellow
            //         //         :

            //                 colorGreen,
            //       ),
            //     ],
            //   ),
          ],
        ),
      ),
    );
  }
}
