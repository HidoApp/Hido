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
import 'package:intl/intl.dart' as intel;



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
      : booking.orderStatus == 'PENDING' ? () {
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
        // Get.to(() => TicketDetailsScreen(booking: booking));

        }
        :() {
        },

  child: Container(
  width: 334,
  height: 120,
  child: Card(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(7.36))),
    color: const Color.fromARGB(255, 255, 255, 255),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 9, right: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Image.network(
                booking.place!.image![0],
                height: height * 0.08,
                width: width * 0.2,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: AppUtil.rtlDirection(context)
                            ? booking.place!.nameEn!
                            : booking.place!.nameAr!,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro',
                        color: black,
                      ),
                      Row(
                        textDirection: AppUtil.rtlDirection2(context)?TextDirection.rtl:TextDirection.ltr,
                        children: [
                          SvgPicture.asset('assets/icons/Polygon_host.svg'),
                          const SizedBox(
                            width: 4,
                          ),
                          CustomText(
                            text: AppUtil.rtlDirection2(context)?'جولة':'Tour',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: black,
                          ),
                        ],
                      ),
                    ],
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
                          ? booking.place!.regionAr!
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
                    SvgPicture.asset(
                      'assets/icons/grey_calender.svg',
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    CustomText(
                      text:intel.DateFormat.yMMMMd().format(DateTime.parse(booking.date)),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: textGreyColor,
                    ),
                     ],
                ),
                    
                   SizedBox(
                       height: 5,
                   ),
                   Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,


                    children:[
                      
                    SvgPicture.asset(
                      'assets/icons/${booking.orderStatus! == 'ACCEPTED' ? 'confirmed.svg' : booking.orderStatus! == 'CANCELED'? 'canceled.svg' : 'waiting.svg'}',
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    
                    CustomText(

                      text: booking.orderStatus!,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: booking.orderStatus! == 'ACCEPTED' ? colorGreen : booking.orderStatus! == 'CANCELED'? Color(0xFFDC362E) : colorDarkGrey,
                    ),
                ],
                 ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
),

    );
  }
}
