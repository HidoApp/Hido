import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/view/find_ajwady.dart';
import 'package:intl/intl.dart';



class CustomTicketCard extends StatelessWidget {
  const CustomTicketCard({
    super.key,
    required this.booking,

    
  });

  final Booking booking;

  @override
  Widget build(BuildContext context) {
     final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());
  Place? thePlace;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
   onTap: booking.orderStatus == 'ACCEPTED'
      ? () {
          Get.to(() => TicketDetailsScreen(booking: booking));
        }
      : () {
          _touristExploreController
              .getPlaceById(
                id:booking!.placeId!,
                context: context,
              )
              .then((place) {
            thePlace = place;
            Get.to(
              () => FindAjwady(
                booking: thePlace!.booking![0],
                place: booking.place!,
                placeId: thePlace!.id!,
              ),);
            //   ?.then((value) {
            //   return getPlaceBooking();
            // });
          });
        },

    child:Container(
      width: 334,
      height:110,
     child:  Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.36))),
      color: Colors.white,
      child: Padding(
      padding: const EdgeInsets.only(bottom: 10 , left: 9 , right:8,top:8 ),
      //.copyWith(
      //     right: !AppUtil.rtlDirection(context) ? 10 : 30,
      //     left: !AppUtil.rtlDirection(context) ? 30 : 10,
       
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
           padding: const EdgeInsets.only(bottom: 12),
            
            child:ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  booking.place!.image![0],
                  height: height * 0.08,
                  width: width * 0.2,
                  fit: BoxFit.cover,
                )),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                padding: const EdgeInsets.only(top: 6),
                 child:CustomText(
                  text: AppUtil.rtlDirection(context)
                      ? booking.place!.nameEn!
                      : booking.place!.nameAr!,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro',

                  color: black,
                ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/map_pin.svg'),
                    const SizedBox(
                      width: 4,
                    ),
                    CustomText(
                      text: AppUtil.rtlDirection2(context)
                          ?booking.place!.regionAr!
                          : booking.place!.regionEn!,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: textGreyColor,
                    ),
                  ],
                ),
                  const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/grey_calender.svg',),
                    const SizedBox(
                      width: 4,
                    ),
                    CustomText(
                     text: DateFormat.yMMMMd().format(DateTime.parse(booking.date)),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: textGreyColor,
                    ),
                    SizedBox(
                      width: width * 0.19,
                    ),
                    SvgPicture.asset(
                        'assets/icons/${booking.orderStatus! == 'ACCEPTED' ? 'confirmed.svg' : 'waiting.svg'}'),
                    const SizedBox(
                      width: 4,
                    ),
                    CustomText(
                      text: booking.orderStatus!,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: colorGreen,
                    ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    // Container(
                    //   width: 5,
                    //   height: 5,
                    //   decoration: const BoxDecoration(
                    //     color: colorGreen,
                    //     shape: BoxShape.circle,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    // CustomText(
                    //   text: '${booking.timeToGo} ',
                    //   fontSize: 10,
                    //   fontWeight: FontWeight.w400,
                    //   color: colorGreen,
                    // ),
                  ],
                ),
                // const SizedBox(
                //   height: 8,
                // ),
                // CustomText(
                //   text: AppUtil.rtlDirection(context)
                //       ? booking.place!.nameEn!
                //       : booking.place!.nameAr!,
                //   fontSize: 18,
                //   fontWeight: FontWeight.w500,
                //   color: black,
                // ),
                // const SizedBox(
                //   height: 8,
                // ),
                // Row(
                //   children: [
                //     SvgPicture.asset('assets/icons/map_pin.svg'),
                //     const SizedBox(
                //       width: 4,
                //     ),
                //     CustomText(
                //       text: AppUtil.rtlDirection(context)
                //           ? booking.place!.regionEn!
                //           : booking.place!.regionAr!,
                //       fontSize: 10,
                //       fontWeight: FontWeight.w400,
                //       color: textGreyColor,
                //     ),
                //     SizedBox(
                //       width: width * 0.2,
                //     ),
                //     SvgPicture.asset(
                //         'assets/icons/${booking.orderStatus! == 'ACCEPTED' ? 'confirmed.svg' : 'waiting.svg'}'),
                //     const SizedBox(
                //       width: 4,
                //     ),
                //     CustomText(
                //       text: booking.orderStatus!,
                //       fontSize: 10,
                //       fontWeight: FontWeight.w400,
                //       color: colorGreen,
                //     ),
                //   ],
                // ),
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
    ),
    ),
    );
  }
}
