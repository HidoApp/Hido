import 'package:ajwad_v4/new-onboarding/view/splash_screen.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/view/custom_ticket_card.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:ajwad_v4/request/widgets/ContactDialog.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'dart:developer';
import 'package:ajwad_v4/profile/widget/HospitalityTicketData.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class TicketDetailsScreen extends StatelessWidget {

   TicketDetailsScreen({
    Key? key,
    required this.booking,
    this.icon,
    this.bookTypeText,
  }) : super(key: key);

  final Booking? booking;
  final SvgPicture? icon;
  final String? bookTypeText;

  final _offerController = Get.put(OfferController());

@override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
return Scaffold(
  backgroundColor:Colors.white,
  appBar: CustomAppBar('myTickets'.tr),
  body: Stack(
    children: [
    Container(
      color: lightGreyBackground, // Background color for the Container
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Align(
            alignment: Alignment.topCenter,
            child: TicketWidget(
              width: width *0.92,
              height: height*0.49,
              isCornerRounded: true,
              padding:const EdgeInsets.symmetric(horizontal: 24, vertical: 23),
              color: Color.fromRGBO(255, 255, 255, 1),
              child: getBookingTypeWidget(context,bookTypeText!),
              
              
              //TicketData(booking: booking,icon: icon,bookTypeText: bookTypeText,),
            ),
          ),
          Expanded(child: SizedBox()), // Takes up remaining space
        ],
      ),
    ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 30, // Offset from the bottom of the screen
        child: Align(
          alignment: Alignment.bottomCenter,
          
          child: Container(
            width: 358,
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red, // Set the border color to red
                width: 1.5, // Set the border width
              ),
              borderRadius: BorderRadius.circular(4), // Set border radius
            ),
            child: CustomButton(
              onPressed: () {
              showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
    // contentPadding: EdgeInsets.only(left:12,right:12,top:15,bottom: 8),
      // insetPadding: EdgeInsets.symmetric(horizontal: 40),
       backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8),
      // ),
      // backgroundColor: Colors.white,
  content: Container(
     width: 270, 
     height: 143, 
        //child: Padding(
     // padding: const EdgeInsets.only(left:12,right:12,top:12,bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
                      'assets/icons/warning.svg',
                    ),
                  
          SizedBox(height: 8),
          Text(
            AppUtil.rtlDirection2(context)?"الغاء":"Canceling",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              fontFamily: 'HT Rakik',
              

            ),
          ),
          SizedBox(height: 1),
          Text(
           'CancelBookingConfirm'.tr,
             textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13,
            fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500
),
          ),
          SizedBox(height: 11),
          Container(
            width: 268,
            height: 33,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red, // Set the border color to red
                width: 1.5, // Set the border width
              ),
              borderRadius: BorderRadius.circular(4), // Set border radius
            ),
          child: CustomButton(
            onPressed: () {
              // Handle cancel booking
               Obx(() => _offerController.isBookingCancelLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : GestureDetector(
                    onTap: () async {
                      log("Cancele ticket ${booking!.id}");

                      bool bookingCancel =
                          await _offerController.bookingCancel(
                              context: context,
                              bookingId: booking!.id!) ??
                          false;
                      if (bookingCancel) {
                        if (context.mounted) {
                          AppUtil.successToast(context, 'EndTrip'.tr);
                          await Future.delayed(const Duration(seconds: 1));
                        }
                        Get.offAll(const TouristBottomBar());
                        await flutterLocalNotificationsPlugin.cancel(int.tryParse(booking!.id!) ?? 0);

                      }
                    },

                    // child: Text(
                    //   "Confirm".tr,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w500,
                    //     color: const Color(0xFFDC362E),
                    //   ),
                    // ),
                  ));
            },
              title: 'Confirm'.tr,
              buttonColor: Colors.white.withOpacity(0.5), // Set the button color to transparent white
              textColor: Colors.red, // Set the text color to red
            ),
          ),
          ],
        ),
      ),
 // ),
    );
  },
);



              },
              title: 'CancelBooking'.tr,
              buttonColor: lightGreyBackground, // Set the button color to transparent white
              textColor: Colors.red,
               // Set the text color to red
            ),
          ),
        ),
      ),
  
    ],
  ),
);
}

 Widget getBookingTypeWidget(BuildContext context, String bookingType){
      switch (bookingType) {
      case 'place':
        return TicketData(booking: booking!,icon: icon,bookTypeText: bookTypeText);
 
      case 'adventure':
        return TicketData(booking: booking!,icon: icon,bookTypeText: bookTypeText);
      case 'hospitality':
        return HostTicketData(booking: booking!,icon: icon,bookTypeText: bookTypeText);
   
      default:
        return TicketData(booking: booking!,icon: icon,bookTypeText: bookTypeText);

    }
}
}

class TicketData extends StatelessWidget {
  final Booking booking;
  final SvgPicture? icon;
  final String? bookTypeText;

   TicketData({
    Key? key,
    required this.booking,
    this.icon,
    this.bookTypeText,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 6),
         child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("BookingDetails".tr,
            style: TextStyle(
           color: Color(0xFF070708),
            fontSize: 17,
              fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
                  height: 0,
              )
            ),
            Row(
              children: [
             // SvgPicture.asset('assets/icons/Polygon_host.svg'),
              icon!,
              //Text(AppUtil.rtlDirection2(context)?"جولة":'Tour',
              Text(bookTypeText!,
                
                style: TextStyle(
color: Color(0xFF070708),
fontSize: 13,
fontFamily: 'SF Pro',
fontWeight: FontWeight.w500,
height: 0,
),
                
                
                
                
                
                ),
              ],
            ),
          ],
        ),
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text('Date: '),
        //     Text(date),
          
        //     Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text('Start Time: '),
        //             Text('End Time: '),
        //           ],
        //         ),
        //    Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(startTime),
        //             Text(endTime),
        //           ],
        //         ),
        //      Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             Text('Guests'),
        //           ],
        //         ), 
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(numberOfGuests),
        //           ],
        //         ),            
            
        //   ],
        // ),
        Container(
    width: 294,
    height: 180,
    child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Container(
                width: 255,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Container(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        AppUtil.rtlDirection2(context)?"التاريخ":'Date',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF9392A0),
                                            fontSize: 14,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                        ),
                                    ),
                                    Text(
                                        //'Fri 24 May 2024',
                                        AppUtil.formatBookingDate(context,booking.date),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF111113),
                                            fontSize: 15,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
            const SizedBox(height: 12),
            Container(
                width: double.infinity,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Container(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                         AppUtil.rtlDirection2(context)?"وقت الذهاب" :'Start Time',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF9392A0),
                                            fontSize: 14,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                        ),
                                    ),
                                    Text(
                                        //'10:00 AM',
                                       // booking.timeToGo??'',
                                          formatTimeWithLocale(context,booking.timeToGo),
                                        style: TextStyle(
                                            color: Color(0xFF111113),
                                            fontSize: 15,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                            child: Container(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                        SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                                AppUtil.rtlDirection2(context)?"وقت العودة":'End Time',
                                                style: TextStyle(
                                                    color: Color(0xFF9392A0),
                                                    fontSize: 14,
                                                    fontFamily: 'SF Pro',
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                ),
                                            ),
                                        ),
                                        SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                                //'3:30 PM',
                                                formatTimeWithLocale(context,booking.timeToReturn),
                                                style: TextStyle(
                                                    color: Color(0xFF111113),
                                                    fontSize: 15,
                                                    fontFamily: 'SF Pro',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ),
                    ],
                ),
            ),
            const SizedBox(height: 12),
            Container(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Container(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        AppUtil.rtlDirection2(context)?"عدد الأشخاص":'Guests',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF9392A0),
                                            fontSize: 14,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                        ),
                                    ),
                                    Container(
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    '0',
                                                   //'${booking?.guestNumber ?? 0} ${'guests'.tr}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color(0xFF111113),
                                                        fontSize: 15,
                                                        fontFamily: 'SF Pro',
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                    ),
                                                ),
                                                // const SizedBox(width: 4),
                                                // Text(
                                                //     'Per',
                                                //     textAlign: TextAlign.center,
                                                //     style: TextStyle(
                                                //         color: Color(0xFFB9B8C1),
                                                //         fontSize: 15,
                                                //         fontFamily: 'SF Pro',
                                                //         fontWeight: FontWeight.w500,
                                                //         height: 0,
                                                //     ),
                                                // ),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
            // Container(
            //     width: double.infinity,
            //     height: 33,
            //     child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         children: [
            //             Container(
            //                 child: Column(
            //                     mainAxisSize: MainAxisSize.min,
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                         Text(
            //                             'Cost',
            //                             textAlign: TextAlign.center,
            //                             style: TextStyle(
            //                                 color: Color(0xFF9392A0),
            //                                 fontSize: 12,
            //                                 fontFamily: 'SF Pro',
            //                                 fontWeight: FontWeight.w400,
            //                                 height: 0,
            //                             ),
            //                         ),
            //                         Container(
            //                             child: Row(
            //                                 mainAxisSize: MainAxisSize.min,
            //                                 mainAxisAlignment: MainAxisAlignment.end,
            //                                 crossAxisAlignment: CrossAxisAlignment.center,
            //                                 children: [
            //                                     Text(
            //                                         '380.00',
            //                                         textAlign: TextAlign.center,
            //                                         style: TextStyle(
            //                                             color: Color(0xFF111113),
            //                                             fontSize: 16,
            //                                             fontFamily: 'SF Pro',
            //                                             fontWeight: FontWeight.w400,
            //                                             height: 0,
            //                                         ),
            //                                     ),
            //                                     const SizedBox(width: 4),
            //                                     Text(
            //                                         'SAR',
            //                                         textAlign: TextAlign.center,
            //                                         style: TextStyle(
            //                                             color: Color(0xFFB9B8C1),
            //                                             fontSize: 12,
            //                                             fontFamily: 'SF Pro',
            //                                             fontWeight: FontWeight.w400,
            //                                             height: 0,
            //                                         ),
            //                                     ),
            //                                 ],
            //                             ),
            //                         ),
            //                     ],
            //                 ),
            //             ),
            //         ],
            //     ),
            // ),


        ],
        
    ),
    
),
  // SizedBox(height: 10),
              // Divider(color: colorDarkGrey,height:5
              // ),

          DottedSeparator(
                  color: almostGrey,
                  height: 1,
                ),
        // SizedBox(height: 30),
        // Divider(),
       SizedBox(height: 20),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Text('Cost: '),
        //   ],
        // ),
        //  Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Text(cost),
        //   ],
        // ),
         Container(
                width: double.infinity,
                height: 50,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        Container(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        AppUtil.rtlDirection2(context)?"المبلغ":'Cost',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF9392A0),
                                            fontSize: 14,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                        ),
                                    ),
                                    Container(
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                Text(
                                                   // '380.00',
                                                    booking.cost.toString(),

                                                   //booking.place!.price.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color(0xFF111113),
                                                        fontSize: 17,
                                                        fontFamily: 'SF Pro',
                                                        fontWeight: FontWeight.w600,
                                                        height: 0,
                                                    ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                     AppUtil.rtlDirection2(context)?'ريال':'SAR',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color(0xFF111113),
                                                        fontSize: 14,
                                                        fontFamily: 'SF Pro',
                                                        fontWeight: FontWeight.w500,
                                                        height: 0,
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),

     
            
      ],
      
    );
  }
  String formatBookingDate(BuildContext context, String date) {
  DateTime dateTime = DateTime.parse(date);
  if (AppUtil.rtlDirection2(context)) {
    // Set Arabic locale for date formatting
    return DateFormat('EEEE، d MMMM yyyy', 'ar').format(dateTime);
  } else {
    // Default to English locale
    return DateFormat('E dd MMM yyyy').format(dateTime);
  }
}
String formatTimeWithLocale(BuildContext context, String dateTimeString) {
 
  DateTime time = DateFormat("HH:mm").parse(dateTimeString);
    String formattedTime = DateFormat.jm().format(time);
  if (AppUtil.rtlDirection2(context)) {
    // Arabic locale
    String suffix = time.hour < 12 ? 'صباحًا' : 'مساءً';
    formattedTime = formattedTime.replaceAll('AM', '').replaceAll('PM', '').trim(); // Remove AM/PM
    return '$formattedTime $suffix';
  } else {
    // Default to English locale
    return formattedTime;
  }
}

//   Widget getBookingTypeWidget(BuildContext context, String bookingType){
//       switch (bookingType) {
//       case 'place':
//         return TicketData(booking: booking,icon: icon,bookTypeText: bookTypeText);
 
//       case 'adventure':
//         return TicketData(booking: booking,icon: icon,bookTypeText: bookTypeText);
//       case 'hospitality':
//         return HostTicketData(booking: booking,icon: icon,bookTypeText: bookTypeText);
   
//       default:
//         return TicketData(booking: booking,icon: icon,bookTypeText: bookTypeText);

//     }
// }

}