import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ajwad_v4/request/widgets/NotificationCard.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:get/get.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:intl/intl.dart' as intel;

class NotificationScreen extends StatefulWidget {
NotificationScreen({Key? key, this.hasNotifications = true,this.hasNotifications1=true}) : super(key: key);

  bool hasNotifications;
  bool hasNotifications1;


  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  List<Booking> _upcomingTicket = [];
  List<Booking> _pastTicket = [];

  List<Booking> _upcomingBookings = [];
    List<Booking> _pastBookings = [];

 String days='';
 String days1='';

  //List<int> disabledIndices = [];
  static List<int> canceledIndices = [];

 

  final ProfileController _profileController = Get.put(ProfileController());

  void getBooking() async {
  List<Booking>? bookings =
      await _profileController.getUpcommingTicket(context: context);

  List<Booking>? pastBookings =
      await _profileController.getPastTicket(context: context);

  if (bookings != null ) {
    setState(() {
      _upcomingTicket = bookings;
      getUpcomingBookingsNotification()  ;
  });
  }else {
     setState(() {
     widget.hasNotifications=false;

    });
  
  }
  if(pastBookings !=null){
  setState(() {
      _pastTicket = pastBookings;
      getPastBookingsNotification()  ;
  });
    print("be");
    print(_pastTicket.length);
    }
   else {
     setState(() {
     widget.hasNotifications1=false;

    });
  }
}

//notification in day 



  void getUpcomingBookingsNotification() async {
if (_upcomingTicket.isEmpty) {
  print('love null');
}
  for (Booking booking in _upcomingTicket ) {
    DateTime bookingDate = DateTime.parse(booking.date);
     tz.initializeTimeZones();

  // Get the Riyadh time zone location
  final String timeZoneName = 'Asia/Riyadh';
  final tz.Location location = tz.getLocation(timeZoneName);

  DateTime currentDateInRiyadh = tz.TZDateTime.now(location);

    //int daysDifference = bookingDate.difference(DateTime.now()).inDays;
    int daysDifference = bookingDate.difference(currentDateInRiyadh).inDays;

    print(daysDifference);
    if (daysDifference == 2) {
      _upcomingBookings.add(booking);
      print(_upcomingBookings.length);
      AppUtil.rtlDirection2(context)? days=" بعد يوم , عند الساعة" + booking.timeToGo: days=" is after a day at"+ booking.timeToGo;
    }
    else if(daysDifference == 1){
        _upcomingBookings.add(booking);
      print(_upcomingBookings.length);
      AppUtil.rtlDirection2(context)? days=" غدا عند الساعة" + booking.timeToGo: days=" is tomorrow at "+ booking.timeToGo;

    }
    else {
      print(bookingDate);
      print(currentDateInRiyadh);
     DateTime bookingDateWithoutTime = DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
     DateTime todayWithoutTime = DateTime(currentDateInRiyadh.year, currentDateInRiyadh.month, currentDateInRiyadh.day);

  // DateTime todayWithoutTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  if (bookingDateWithoutTime == todayWithoutTime) {
       _upcomingBookings.add(booking);
        AppUtil.rtlDirection2(context)? days=" اليوم عند الساعة " + booking.timeToGo : days=" is today at "+booking.timeToGo ;

    }
    else{
      setState(() {
     widget.hasNotifications=false;

    }); 
    }
       }

   
  }
  }


 void getPastBookingsNotification() async {
if (_pastTicket.isEmpty) {
  print('love null');
}

  for (Booking booking in _pastTicket ) {
    if(booking.bookingType=='hospitality'){
    DateTime bookingDate = DateTime.parse(booking.date);
     tz.initializeTimeZones();

  // Get the Riyadh time zone location
  final String timeZoneName = 'Asia/Riyadh';
  final tz.Location location = tz.getLocation(timeZoneName);

  DateTime currentDateInRiyadh = tz.TZDateTime.now(location);

    //int daysDifference = bookingDate.difference(DateTime.now()).inDays;
    int daysDifference = bookingDate.difference(currentDateInRiyadh).inDays;
    print('past');
    print(daysDifference);
    if (daysDifference == 2) {
      _pastBookings.add(booking);
      print(_pastBookings.length);
      AppUtil.rtlDirection2(context)? days1=" بعد يوم , عند الساعة" + booking.timeToGo: days1=" is after a day at"+ booking.timeToGo;
    }
    else if(daysDifference == 1){
        _pastBookings.add(booking);
      print(_pastBookings.length);
      AppUtil.rtlDirection2(context)? days1=" غدا عند الساعة" + booking.timeToGo: days1=" is tomorrow at "+ booking.timeToGo;

    }
    else {
      print(bookingDate);
      print(currentDateInRiyadh);
     DateTime bookingDateWithoutTime = DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
     DateTime todayWithoutTime = DateTime(currentDateInRiyadh.year, currentDateInRiyadh.month, currentDateInRiyadh.day);

  // DateTime todayWithoutTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  if (bookingDateWithoutTime == todayWithoutTime) {
        print('past1');

       _pastBookings.add(booking);
        AppUtil.rtlDirection2(context)? days1=" اليوم عند الساعة " + booking.timeToGo : days1=" is today at "+booking.timeToGo ;

    }
    else{
      setState(() {
     widget.hasNotifications1=false;

    }); 
    }
       }

   
  }
  }
  }


//   void getUpcomingBookings() async {
// if (_upcomingTicket.isEmpty) {
//   print('love null');
// }
//   for (Booking booking in _upcomingTicket ) {
//     DateTime bookingDate = DateTime.parse(booking.date);
//      String combinedTimeString = intel.DateFormat("yyyy-MM-dd").format(bookingDate) + " " + booking.timeToGo;
//      DateTime parsedTime = intel.DateFormat("yyyy-MM-dd HH:mm:ss").parse(combinedTimeString);
//     int daysDifference = parsedTime.difference(DateTime.now()).inHours;
//     print(daysDifference);
 
//  print(parsedTime);
//  print(DateTime.now());
//   DateTime bookingDateWithoutTime = DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
//   DateTime todayWithoutTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

//   if (bookingDateWithoutTime == todayWithoutTime) {
//        if (daysDifference == 2) {
//       _upcomingBookings.add(booking);
//       print(_upcomingBookings.length);
//       AppUtil.rtlDirection2(context)? days="بعد ساعتين عند" + booking.timeToGo: days=" is after two hour at"+ booking.timeToGo;
//     }
//        else if(daysDifference == 1){
//         _upcomingBookings.add(booking);
//       print(_upcomingBookings.length);
//       AppUtil.rtlDirection2(context)? days="بعد ساعة عند" + booking.timeToGo: days=" is after one hour at"+ booking.timeToGo;
//        }
//        else if(daysDifference == 0){
//         _upcomingBookings.add(booking);
//       print(_upcomingBookings.length);
//       AppUtil.rtlDirection2(context)? days=" الان عند" + booking.timeToGo: days=" is now at"+ booking.timeToGo;
//        }
    
//     else{
//       setState(() {
//      widget.hasNotifications=false;

//     }); 
//     }
//   }
//     else{
//     widget.hasNotifications=false;

//     }
//        }

// }

 void disableNotification(int index) {
    setState(() {
      canceledIndices.add(index);

      //disabledIndices.add(index);

    });
  }


  @override
  void initState() {
  super.initState();
  getBooking();
}

Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 40),
              child: Row(
              textDirection: AppUtil.rtlDirection2(context) ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      AppUtil.rtlDirection2(context)
                          ? Icons.arrow_forward
                          : Icons.arrow_back,
                      color: black,
                      size: 26,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  CustomText(
                    text: 'notifications'.tr,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),

                   
                ],
                
              ),
              
            ),
             
            if (!widget.hasNotifications&&!widget.hasNotifications1)
  
              CustomEmptyWidget(
                title: 'noNotification'.tr,
                image: 'no_notifications',
              )
            else
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              itemCount: _upcomingBookings.length + _pastBookings.length ,
              itemBuilder: (context, index) {
              final isDisabled = canceledIndices.contains(index);
        if (isDisabled) {
         // return SizedBox();
         return CustomEmptyWidget(
                title: 'noNotification'.tr,
                image: 'no_notifications',
              );
              }
             if(_pastBookings.isNotEmpty&&_upcomingBookings.isNotEmpty){
              if(_upcomingBookings[index].place!=null){
              return  NotificationCrd(
                name:AppUtil.rtlDirection2(context)? _upcomingBookings[index].place?.nameAr?? "":  _upcomingBookings[index].place?.nameEn?? "",
                isRtl:AppUtil.rtlDirection2(context),
                FamilyName:AppUtil.rtlDirection2(context)?_pastTicket[index].hospitality?.titleAr??"":_pastTicket[index].hospitality?.titleEn??'',
                width: width,
                isTour: true,
                isHost: true,
                days2: days1,
                days:days,
                isDisabled: isDisabled,
                onCancel: () {
                   disableNotification(index);

                 },
                
              );
              }
             }else if(_pastBookings.isNotEmpty){
        
              return  NotificationCrd(
                // name:AppUtil.rtlDirection2(context)? _upcomingBookings[index].place?.nameAr?? "":  _upcomingBookings[index].place?.nameEn?? "",
                isRtl:AppUtil.rtlDirection2(context),
               FamilyName:AppUtil.rtlDirection2(context)?" في"'${_pastTicket[index].hospitality?.titleAr??""}':"at" '${_pastTicket[index].hospitality?.titleEn??''}',
                width: width,
                isHost: true,
                days:'',
                days2:days1,
                isDisabled: isDisabled,
                onCancel: () {
                   disableNotification(index);

                 },
                
              );
             }else{
              return  NotificationCrd(
                name:AppUtil.rtlDirection2(context)? _upcomingBookings[index].place?.nameAr?? "":  _upcomingBookings[index].place?.nameEn?? "",
                isRtl:AppUtil.rtlDirection2(context),
                width: width,
                isTour: true,
                days: days,
                isDisabled: isDisabled,
                onCancel: () {
                   disableNotification(index);

                 },
                
              );
             }
            

              }
            ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     const SizedBox(
              //       height: 40,
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 24),
              //       child: Row(
              //         children: [
              //           const CircleAvatar(
              //             radius: 22.5,
              //             backgroundImage:
              //                 AssetImage('assets/images/ajwadi_image.png'),
              //           ),
              //           const SizedBox(
              //             width: 13,
              //           ),
              //           SizedBox(
              //             width: width * 0.48,
              //             child: RichText(
              //               text: TextSpan(children: [
              //                 TextSpan(
              //                   text: AppUtil.rtlDirection(context)
              //                       ? 'ط£ط­ظ…ط¯ ط³ط§ظ„ظ… '
              //                       : 'Ronald C. Kinch ',
              //                   style: TextStyle(
              //                     fontFamily: AppUtil.rtlDirection(context)
              //                         ? 'Noto Kufi Arabic'
              //                         : 'Kufam',
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w700,
              //                     color: black,
              //                   ),
              //                 ),
              //                 TextSpan(
              //                   text: AppUtil.rtlDirection(context)
              //                       ? 'ظ‚ط¨ظ„ ط¹ط±ط¶ظƒ'
              //                       : 'Accept tour trip',
              //                   style: TextStyle(
              //                     fontFamily: AppUtil.rtlDirection(context)
              //                         ? 'Noto Kufi Arabic'
              //                         : 'Kufam',
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: colorDarkGrey,
              //                   ),
              //                 ),
              //               ]),
              //             ),
              //           ),
              //           const Spacer(),
              //           const CustomText(
              //             text: '1hr ago',
              //             fontSize: 12,
              //             fontFamily: 'Kufam',
              //             color: colorDarkGrey,
              //           ),
              //         ],
              //       ),
              //     ),
              //     const Divider(),
              //     // Padding(
              //     //   padding: const EdgeInsets.symmetric(horizontal: 24),
              //     //   child: Row(
              //     //     children: [
              //     //       SvgPicture.asset('assets/icons/bell.svg'),
              //     //       const SizedBox(
              //     //         width: 13,
              //     //       ),
              //     //       SizedBox(
              //     //         width: width * 0.48,
              //     //         child: RichText(
              //     //           text: TextSpan(children: [
              //     //             TextSpan(
              //     //               text: AppUtil.rtlDirection(context)
              //     //                   ? 'ظ‡ظˆظ„ظٹط¯ظٹ ط§ظ† '
              //     //                   : 'Come and visit us in ',
              //     //               style: TextStyle(
              //     //                 fontFamily: AppUtil.rtlDirection(context)
              //     //                     ? 'Noto Kufi Arabic'
              //     //                     : 'Kufam',
              //     //                 fontSize: 14,
              //     //                 fontWeight: AppUtil.rtlDirection(context)
              //     //                     ? FontWeight.w700
              //     //                     : FontWeight.w400,
              //     //                 color: AppUtil.rtlDirection(context)
              //     //                     ? black
              //     //                     : colorDarkGrey,
              //     //               ),
              //     //             ),
              //     //             TextSpan(
              //     //               text: AppUtil.rtlDirection(context)
              //     //                   ? 'طھط¯ط¹ظˆظƒظ… ظپظٹ ط­ظپظ„ظ‡ط§ ط§ظ„ط®ظٹط±ظٹ ظ،ظ  ط³ظ†ظˆظٹ'
              //     //                   : 'Holiday inn',
              //     //               style: TextStyle(
              //     //                 fontFamily: AppUtil.rtlDirection(context)
              //     //                     ? 'Noto Kufi Arabic'
              //     //                     : 'Kufam',
              //     //                 fontSize: 14,
              //     //                 fontWeight: AppUtil.rtlDirection(context)
              //     //                     ? FontWeight.w400
              //     //                     : FontWeight.w700,
              //     //                 color: AppUtil.rtlDirection(context)
              //     //                     ? colorDarkGrey
              //     //                     : black,
              //     //               ),
              //     //             ),
              //     //           ]),
              //     //         ),
              //     //       ),
              //     //       const Spacer(),
              //     //       const CustomText(
              //     //         text: '1hr ago',
              //     //         fontSize: 12,
              //     //         fontFamily: 'Kufam',
              //     //         color: colorDarkGrey,
              //     //       ),
              //     //     ],
              //     //   ),
              //     // ),
              //     const Divider(),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 24),
              //       child: Row(
              //         children: [
              //           SvgPicture.asset('assets/icons/sun.svg'),
              //           const SizedBox(
              //             width: 13,
              //           ),
              //           SizedBox(
              //             width: width * 0.48,
              //             child: CustomText(
              //               text: AppUtil.rtlDirection(context)
              //                   ? 'ظ„ط§ طھظ†ط³ظ‰ طھظ‚ظٹظٹظ… ط£ط­ظ…ط¯ ط³ط§ظ„ظ…'
              //                   : 'Donâ€™t forget rate your last trip',
              //             ),
              //           ),
              //           const Spacer(),
              //           const CustomText(
              //             text: '1hr ago',
              //             fontSize: 12,
              //             fontFamily: 'Kufam',
              //             color: colorDarkGrey,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
          ],
        ),
      ),
    );
  }

}