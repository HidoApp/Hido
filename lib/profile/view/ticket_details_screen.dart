import 'package:ajwad_v4/new-onboarding/view/splash_screen.dart';
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
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class TicketDetailsScreen extends StatelessWidget {

   TicketDetailsScreen({
    Key? key,
    required this.booking,
  }) : super(key: key);

  final Booking booking;
  final _offerController = Get.put(OfferController());

@override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
return Scaffold(
  backgroundColor: Color(0xFFF9F9F9),
  appBar: CustomAppBar('myTickets'.tr),
  body: Stack(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Align(
            alignment: Alignment.topCenter,
            child: TicketWidget(
              width: 342,
              height: 400,
              isCornerRounded: true,
              padding: EdgeInsets.all(24),
              color: Color.fromRGBO(255, 255, 255, 1),
              child: TicketData(booking: booking),
            ),
          ),
          Expanded(child: SizedBox()), // Takes up remaining space
        ],
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 48, // Offset from the bottom of the screen
        child: Align(
          alignment: Alignment.bottomCenter,
          
          child: Container(
            width: 358,
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red, // Set the border color to red
                width: 1, // Set the border width
              ),
              borderRadius: BorderRadius.circular(8), // Set border radius
            ),
            child: CustomButton(
              onPressed: () {

              showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
     contentPadding: EdgeInsets.only(left:12,right:12,top:15,bottom: 8),
      // insetPadding: EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.white,
  content: Container(
     width: 304, 
     height: 153, 
        //child: Padding(
     // padding: const EdgeInsets.only(left:12,right:12,top:12,bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.dangerous,
            size: 40,
            color: const Color.fromARGB(255, 0, 92, 167),
          ),
          SizedBox(height: 3),
          Text(
            "Canceling",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              fontFamily: 'HT Rakik',

            ),
          ),
          SizedBox(height: 3),
          Text(
            'Are you sure you want to cancel your booking?',
            style: TextStyle(fontSize: 13,
            fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500
),
          ),
          SizedBox(height: 15),
          Container(
            width: 304,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red, // Set the border color to red
                width: 1, // Set the border width
              ),
              borderRadius: BorderRadius.circular(6), // Set border radius
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
              title: 'Cancel Booking'.tr,
              buttonColor: Colors.white.withOpacity(0.5), // Set the button color to transparent white
              textColor: Colors.red, // Set the text color to red
            ),
          ),
        ),
      ),
    ],
  ),
);
}
}

class TicketData extends StatelessWidget {
  final Booking booking;

   TicketData({
    Key? key,
    required this.booking,
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
            Text("Booking Details",
            style: TextStyle(
color: Color(0xFF070708),
fontSize: 17,
fontFamily: 'SF Pro',
fontWeight: FontWeight.w500,
height: 0,
)
            ),
            Row(
              children: [
                SvgPicture.asset('assets/icons/Polygon_host.svg'),

                Text('Tour',
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
    height: 168,
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
                                        'Date',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF9392A0),
                                            fontSize: 12,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                        ),
                                    ),
                                    Text(
                                        //'Fri 24 May 2024',
                                        DateFormat('E dd MMM yyyy').format(DateTime.parse(booking.date)),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF111113),
                                            fontSize: 16,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w400,
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
                                        'Start Time',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF9392A0),
                                            fontSize: 12,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                        ),
                                    ),
                                    Text(
                                        //'10:00 AM',
                                        booking.timeToGo??'',
                                        
                                        style: TextStyle(
                                            color: Color(0xFF111113),
                                            fontSize: 16,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w400,
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
                                                'End Time',
                                                style: TextStyle(
                                                    color: Color(0xFF9392A0),
                                                    fontSize: 12,
                                                    fontFamily: 'SF Pro',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                ),
                                            ),
                                        ),
                                        SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                                //'3:30 PM',
                                                booking.timeToGo??'',
                                                style: TextStyle(
                                                    color: Color(0xFF111113),
                                                    fontSize: 16,
                                                    fontFamily: 'SF Pro',
                                                    fontWeight: FontWeight.w400,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        'Guests',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF9392A0),
                                            fontSize: 12,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w400,
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
                                                    //'1',
                                                   '${booking?.guestNumber ?? 0} ${'guests'.tr}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color(0xFF111113),
                                                        fontSize: 16,
                                                        fontFamily: 'SF Pro',
                                                        fontWeight: FontWeight.w400,
                                                        height: 0,
                                                    ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                    'Per',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color(0xFFB9B8C1),
                                                        fontSize: 15,
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
        SizedBox(height: 5),
                Divider(),


        ],
        
    ),
    
),
        // SizedBox(height: 30),
        // Divider(),
        // SizedBox(height: 5),
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
                height: 33,
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
                                        'Cost',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF9392A0),
                                            fontSize: 12,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w400,
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
                                                   booking.place!.price.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color(0xFF111113),
                                                        fontSize: 14,
                                                        fontFamily: 'SF Pro',
                                                        fontWeight: FontWeight.w500,
                                                        height: 0,
                                                    ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                    'SAR',
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
}
