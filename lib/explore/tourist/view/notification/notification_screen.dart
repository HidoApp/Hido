
import 'package:ajwad_v4/request/widgets/PushNotificationCard.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ajwad_v4/request/widgets/NotificationCard.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:get/get.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';

import '../../../../widgets/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen(
      {Key? key, this.hasNotifications = true})
      : super(key: key);

  bool hasNotifications;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Booking> _upcomingTicket = [];
  List<Booking> _pastTicket = [];

  List<Booking> _upcomingBookings = [];
  List<Booking> _pastBookings = [];
bool _isPushNotificationDismissed = false;

  String days = '';

  //List<int> disabledIndices = [];
  static List<int> canceledIndices = [];
   static List<int> removeIndices = [];
  Set<int> viewedNotifications = Set<int>();
  List<String> notificationMessages = []; // List to hold notification messages


  final ProfileController _profileController = Get.put(ProfileController());

  void getBooking() async {
    List<Booking>? bookings =
        await _profileController.getUpcommingTicket(context: context);

    if (bookings!.isNotEmpty) {
      setState(() {
        _upcomingTicket = bookings;
        getUpcomingBookingsNotification();
      });
    } else {
      setState(() {
        widget.hasNotifications = false;
      });
    }
    
  }

//notification in day

  void getUpcomingBookingsNotification() async {
    if (_upcomingTicket.isEmpty) {
      print('love null');
    }
    for (Booking booking in _upcomingTicket) {
      if( booking.orderStatus=="ACCEPTED"){
      DateTime bookingDate = DateTime.parse(booking.date);
      tz.initializeTimeZones();

      // Get the Riyadh time zone location
      final String timeZoneName = 'Asia/Riyadh';
      final tz.Location location = tz.getLocation(timeZoneName);

      DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
  
      //int daysDifference = bookingDate.difference(DateTime.now()).inDays;
      int daysDifference = bookingDate.difference(currentDateInRiyadh).inDays;

print("day deference");
      print(daysDifference);
     print(bookingDate);
      // if (daysDifference == 2) {
      //   _upcomingBookings.add(booking);
      //   print(_upcomingBookings.length);
      //   notificationMessages.add(AppUtil.rtlDirection2(context)
      //       ? days = " بعد يومين , عند الساعة " +AppUtil.formatStringTimeWithLocale(context, booking.timeToGo)
      //       : days = " is after two day at " + AppUtil.formatStringTimeWithLocale(context,booking.timeToGo));
       
      // } else
       if (daysDifference == 1) {
        
        print('inter1');
        _upcomingBookings.add(booking);
        print(_upcomingBookings.length);
          notificationMessages.add(AppUtil.rtlDirection2(context)
            ? days = " بعد يومين , عند الساعة " +AppUtil.formatStringTimeWithLocale(context, booking.timeToGo)
            : days = " is after two day at " + AppUtil.formatStringTimeWithLocale(context,booking.timeToGo));
       
        //  notificationMessages.add( AppUtil.rtlDirection2(context)
        //    ? days = " بعد يوم , عند الساعة " +AppUtil.formatStringTimeWithLocale(context, booking.timeToGo)
        //    : days = " is after a day at " +AppUtil.formatStringTimeWithLocale(context, booking.timeToGo));
          
      // } else if (daysDifference == 1){
      //   _upcomingBookings.add(booking);
      //   print(_upcomingBookings.length);
      //    notificationMessages.add( AppUtil.rtlDirection2(context)
      // ? days = " غدا عند الساعة " + booking.timeToGo
      //       : days = " is tomorrow at " + booking.timeToGo);
     
      // } 
      }else if(daysDifference == 0) {
        print(bookingDate);
        print(currentDateInRiyadh);
        DateTime bookingDateWithoutTime =
            DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
        DateTime todayWithoutTime = DateTime(currentDateInRiyadh.year,
            currentDateInRiyadh.month, currentDateInRiyadh.day);
 
        // DateTime todayWithoutTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

        if (bookingDateWithoutTime.isAtSameMomentAs(todayWithoutTime)) {
          _upcomingBookings.add(booking);
           notificationMessages.add( AppUtil.rtlDirection2(context)
              ? days = " اليوم عند الساعة " +AppUtil.formatStringTimeWithLocale(context, booking.timeToGo) 
              : days = " is today at " +AppUtil.formatStringTimeWithLocale(context, booking.timeToGo));
        }
        else{
            _upcomingBookings.add(booking);
        print(_upcomingBookings.length);
         notificationMessages.add( AppUtil.rtlDirection2(context)
      ? days = " غدا عند الساعة " +AppUtil.formatStringTimeWithLocale(context,booking.timeToGo)
            : days = " is tomorrow at " +AppUtil.formatStringTimeWithLocale(context, booking.timeToGo));
        }
        
      }else{
        setState(() {
        widget.hasNotifications = false;
      });
     
      }
    }else{
      setState(() {
        widget.hasNotifications = false;
      });
    }
    }
    print(  widget.hasNotifications);
  }

 

  void disableNotification(int index) {
    setState(() {
      canceledIndices.add(index);

      //disabledIndices.add(index);
    });
  }
 void _viewAllNotifications() {
    setState(() {
      for (int i = 0; i < _upcomingBookings.length; i++) {
        viewedNotifications.add(i);
      }
      print('view');
      print(viewedNotifications.length);
    });
  }


  @override
  void initState() {
    super.initState();
    getBooking();
    
  }
    void _dismissNotification(int index) {
    // Handle the dismissal logic here, such as updating the state or removing the notification
   disableNotification(index);
   

  }


  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
        final double height = MediaQuery.of(context).size.height;

final arguments = ModalRoute.of(context)?.settings.arguments;

// Check if arguments exist and if they are of type RemoteMessage
RemoteMessage? message;

if (arguments is RemoteMessage) {
  message = arguments;
} else {
  message = null; // Handle null or invalid argument case
}
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        'notifications'.tr,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 40),
            //   child: Row(
            //   textDirection: AppUtil.rtlDirection2(context) ? TextDirection.rtl : TextDirection.ltr,
            //     children: [
            //       IconButton(
            //         onPressed: () {
            //           Get.back();
            //         },
            //         icon: Icon(
            //           AppUtil.rtlDirection2(context)
            //               ? Icons.arrow_forward
            //               : Icons.arrow_back,
            //           color: black,
            //           size: 26,
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 4,
            //       ),
            //       CustomText(
            //         text: 'notifications'.tr,
            //         fontSize: 24,
            //         fontWeight: FontWeight.w500,
            //         color: black,
            //       ),

            //     ],

            //   ),

            // ),

            if (!widget.hasNotifications && _upcomingBookings.isEmpty && message==null)
            
              Padding(
                padding:  EdgeInsets.only(
                  top: height/3,
                  left: 16,
                  right: 16,
                  bottom: 50,
                ),
                child: Center(
                  child: CustomEmptyWidget(
                    title: 'noNotification'.tr,
                    image: 'MybellMessage',
                    subtitle: "noNotificationsub".tr,
                  ),
                ),
              )
            else
            

              ListView.builder(
                  shrinkWrap: true,
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  itemCount: _upcomingBookings.length + _pastBookings.length+1,
                  itemBuilder: (context, index) {
                    
    // Display the push notification at the top (index 0)
    if ( message != null) {
      if(index == 0 && !_isPushNotificationDismissed)
      return Dismissible(
        key: UniqueKey(), // Use a unique key for the dismissible item
        direction: AppUtil.rtlDirection2(context)?DismissDirection.startToEnd: DismissDirection.endToStart, // Swipe right to left,
         onDismissed: (direction) {
            setState(() {
             _isPushNotificationDismissed = true;
              // Clear the message to ensure it won't show up again
              message = null;
            });
          }, // Swipe to dismiss from right to left
        child: PushNotificationCrd(
          message: message!.notification!.body.toString(),
          isRtl: AppUtil.rtlDirection2(context),
          width: width,
         
        ),
      );
    }

     int  adjustedIndex = 0;
    // Skip index adjustment if we're on the push notification (index 0)
    if (index > 0 && message!=null) {
     adjustedIndex = index - (_isPushNotificationDismissed ? 1 : 0); // Shift the index to account for push notification at 0
    }else{
      adjustedIndex = index;
    }
      // Handle the card notifications
      final isDisabled = canceledIndices.contains(adjustedIndex);
      if (isDisabled) {
        return SizedBox();
      }

      // Ensure the adjusted index is within the bounds of _upcomingBookings
      if (adjustedIndex < _upcomingBookings.length && adjustedIndex < notificationMessages.length) {
        final isViewed = viewedNotifications.contains(adjustedIndex);
        final booking = _upcomingBookings[adjustedIndex];

      if (booking.bookingType == 'place') {
        return NotificationCrd(
          name: AppUtil.rtlDirection2(context)
              ? booking.place?.nameAr ?? ""
              : booking.place?.nameEn ?? "",
          isRtl: AppUtil.rtlDirection2(context),
          width: width,
          isTour: true,
          days: notificationMessages[adjustedIndex],
          isDisabled: isDisabled,
          onCancel: () => disableNotification(adjustedIndex),
          onDismissed: () => _dismissNotification(adjustedIndex),
          isViewed: isViewed,
        );
      } else if (booking.bookingType == 'hospitality') {
        return NotificationCrd(
          name: AppUtil.rtlDirection2(context)
              ? booking.hospitality?.titleAr ?? ''
              : booking.hospitality?.titleEn ?? "",
          isRtl: AppUtil.rtlDirection2(context),
          width: width,
          isHost: true,
          days: notificationMessages[adjustedIndex],
          isDisabled: isDisabled,
          onCancel: () => disableNotification(adjustedIndex),
          onDismissed: () => _dismissNotification(adjustedIndex),
          isViewed: isViewed,
        );
      } else if (booking.bookingType == 'adventure') {
        return NotificationCrd(
          name: AppUtil.rtlDirection2(context)
              ? booking.adventure?.nameAr ?? ''
              : booking.adventure?.nameEn ?? "",
          isRtl: AppUtil.rtlDirection2(context),
          width: width,
          isAdve: true,
          days: notificationMessages[adjustedIndex],
          isDisabled: isDisabled,
          onCancel: () => disableNotification(adjustedIndex),
          onDismissed: () => _dismissNotification(adjustedIndex),
          isViewed: isViewed,
        );
      } else {
        return NotificationCrd(
          name: AppUtil.rtlDirection2(context)
              ? booking.event?.nameAr ?? ''
              : booking.event?.nameEn ?? "",
          isRtl: AppUtil.rtlDirection2(context),
          width: width,
          days: notificationMessages[adjustedIndex],
          isDisabled: isDisabled,
          onCancel: () => disableNotification(adjustedIndex),
          onDismissed: () => _dismissNotification(adjustedIndex),
          isViewed: isViewed,
        );
      }
    }

                    else {
            widget.hasNotifications = false;
        }
                  }),
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
