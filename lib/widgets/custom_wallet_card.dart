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



class CustomWalletCard extends StatelessWidget {
  //  CustomWalletCard({
  //   super.key, required BuildContext context,
  //   // required this.booking,

    
  // });

  // final Booking booking;

  @override
  Widget build(BuildContext context) {
     final TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());
  Place? thePlace;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
   onTap:  () {
          Get.to(() => TicketDetailsScreen(
                         
                            
        ));
     
        },


  child: Container(
  width: double.infinity,
  //  height: 152,
   height: 137,


   decoration: ShapeDecoration(
shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(12),
),
shadows: [
BoxShadow(
color: Color(0x3FC7C7C7),
blurRadius: 15,
offset: Offset(0, 0),
spreadRadius: 0,
)
],
),
  child: Card(
    shape: const RoundedRectangleBorder(
      borderRadius:
       BorderRadius.all(Radius.circular(12))),
      color: Colors.white,
      surfaceTintColor:const Color.fromARGB(255, 255, 255, 255) ,
      // shadowColor: Color(0x3FC7C7C7),

    
    
    child: Padding(
      padding: const EdgeInsets.only( left: 16, right: 16, top: 16),
     
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              width: 36,
              height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(228, 233, 235, 246),
               
                ),  
                            
              alignment: Alignment.center,
             child: SvgPicture.asset('assets/icons/Finance_icon.svg'),
              ),
          ),
            Text(
            AppUtil.rtlDirection2(context)?"إجمالي المحفظة": 'Total balance',
          style: TextStyle(
         color: Color(0xFFB9B8C1),
           fontSize: 13,
           fontFamily: AppUtil.rtlDirection2(context)?"SF Arabic":'SF Pro',
            fontWeight: FontWeight.w500,
           height: 0,
            ),
             ),
              SizedBox(
            width: 4,
          ),
          Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text:
           AppUtil.rtlDirection2(context)?"1,400.00 ":'1,400.00 ',
         style: TextStyle(
            color: Color(0xFF070708),
             fontSize:  AppUtil.rtlDirection(context)?28:28,
             fontFamily: 'HT Rakik',
             fontWeight: FontWeight.w500,
             ),
            ),
            TextSpan(
        text:
           AppUtil.rtlDirection2(context)?"ر.س":'SAR',
         style: TextStyle(
            color: Color(0xFFB9B8C1),
             fontSize:  20,
             fontFamily: 'HT Rakik',
             fontWeight: FontWeight.w500,
             letterSpacing: 0.80,
             ),
            )
    ]
  )
          )
        //   SizedBox(
        //     width: 8,
        //   ),
        //   Expanded(
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(top: 1),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               CustomText(
        //                  text:
        //                 AppUtil.rtlDirection(context)
        //                     ?booking.bookingType =="place" ? booking.place!.nameEn! :booking.bookingType =="hospitality"? booking.hospitality!.titleEn:booking.adventure!.nameEn??''
        //                     :booking.bookingType =="place" ? booking.place!.nameAr! : booking.bookingType =="hospitality"?booking.hospitality!.titleAr:booking.adventure!.nameAr??'',
        //                 fontSize: 19,
        //                 fontWeight: FontWeight.w700,
        //                 fontFamily:  AppUtil.rtlDirection(context)?'SF Pro':'SF Arabic',

        //               ),
        //               Row(
        //                 textDirection: AppUtil.rtlDirection2(context)?TextDirection.rtl:TextDirection.ltr,
        //                 children: [
        //                   SvgPicture.asset(
        //                  'assets/icons/${booking.bookingType! == 'place'?'place.svg' :booking.bookingType! == 'hospitality' ? 'hospitality.svg' : 'adventure.svg'}',
        //                     ),
        //                   const SizedBox(
        //                     width: 4,
        //                   ),
        //                   CustomText(
        //                     text: getBookingTypeText(context, booking.bookingType!),
        //                     fontSize: 13,
        //                     fontWeight: FontWeight.w500,
        //                     color: black,
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //         const SizedBox(
        //           height: 2,
        //         ),
        //         Row(
                  
        //           children: [
        //             SvgPicture.asset('assets/icons/map_pin.svg'
                    
        //             ),
        //             const SizedBox(
        //               width: 4,
        //             ),
        //             CustomText(
        //               text: 
        //               AppUtil.rtlDirection2(context)
        //                   ?booking.bookingType =="place" ? booking.place!.regionAr!:booking.bookingType! == 'hospitality' ?booking.hospitality!.regionAr!:booking.adventure!.regionAr??''
        //                   :booking.bookingType =="place" ? booking.place!.regionEn!:booking.bookingType! == 'hospitality' ?booking.hospitality!.regionEn:booking.adventure!.regionEn??'' ,
        //               fontSize: 12,
        //               fontWeight: FontWeight.w500,
        //               color: textGreyColor,
        //             ),
        //           ],
        //         ),
        //         const SizedBox(
        //           height: 2,
        //         ),
        //         Row(
        //           children: [
        //             SvgPicture.asset(
        //               'assets/icons/grey_calender.svg',
        //             ),
        //             const SizedBox(
        //               width: 5,
        //             ),
        //             CustomText(
        //              // text:intel.DateFormat.yMMMMd().format(DateTime.parse(booking.date!)),
        //              text:formatBookingDate(context, booking.date),
        //               fontSize: 12,
        //               fontWeight: FontWeight.w500,
        //               color: textGreyColor,
        //             ),
        //              ],
        //         ),
                    
        //            SizedBox(
        //                height: 5,
        //            ),
        //            Row(
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //       mainAxisAlignment: MainAxisAlignment.end,


        //             children:[
                      
        //             SvgPicture.asset(
        //               'assets/icons/${booking.orderStatus! == 'ACCEPTED' ||  booking.orderStatus! == 'Finished' ? 'confirmed.svg' : booking.orderStatus! == 'CANCELED'? 'canceled.svg' : 'waiting.svg'}',
        //             ),
        //             const SizedBox(
        //               width: 4,
        //             ),
                    
        //             CustomText(
        //               text: getOrderStatusText(context, booking.orderStatus!),
        //               //text:booking.orderStatus!,
        //               fontSize: 13,
        //               fontWeight: FontWeight.w500,
        //               color: booking.orderStatus! == 'ACCEPTED' ||  booking.orderStatus! == 'Finished'  ? colorGreen : booking.orderStatus! == 'CANCELED'? Color(0xFFDC362E) : colorDarkGrey,
        //             ),
        //         ],
        //          ),
        //       ],
        //     ),
        
        
        ],
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
    if(bookingType=='place'){
      return "Tour";
    }
    else{
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