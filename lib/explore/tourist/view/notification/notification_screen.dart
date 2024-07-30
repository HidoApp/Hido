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

  String days = '';

  //List<int> disabledIndices = [];
  static List<int> canceledIndices = [];
   static List<int> removeIndices = [];
  Set<int> viewedNotifications = Set<int>();


  final ProfileController _profileController = Get.put(ProfileController());

  void getBooking() async {
    List<Booking>? bookings =
        await _profileController.getUpcommingTicket(context: context);

    

    if (bookings != null) {
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
     
      if (daysDifference == 3) {
        _upcomingBookings.add(booking);
        print(_upcomingBookings.length);
        AppUtil.rtlDirection2(context)
            ? days = " بعد يومين , عند الساعة " + booking.timeToGo
            : days = " is after two day at " + booking.timeToGo;
      } else if (daysDifference == 2) {
        print('inter1');
        _upcomingBookings.add(booking);
        print(_upcomingBookings.length);
        AppUtil.rtlDirection2(context)
           ? days = " بعد يوم , عند الساعة " + booking.timeToGo
           : days = " is after a day at " + booking.timeToGo;
          
      } else if (daysDifference == 1){
              print('inter0');
        _upcomingBookings.add(booking);
        print(_upcomingBookings.length);
        AppUtil.rtlDirection2(context)
      ? days = " غدا عند الساعة " + booking.timeToGo
            : days = " is tomorrow at " + booking.timeToGo;
     
     
      } else if(daysDifference == 0) {
        print(bookingDate);
        print(currentDateInRiyadh);
        DateTime bookingDateWithoutTime =
            DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
        DateTime todayWithoutTime = DateTime(currentDateInRiyadh.year,
            currentDateInRiyadh.month, currentDateInRiyadh.day);

        // DateTime todayWithoutTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

        if (bookingDateWithoutTime.isAtSameMomentAs(todayWithoutTime)) {
          _upcomingBookings.add(booking);
          AppUtil.rtlDirection2(context)
              ? days = " اليوم عند الساعة " + booking.timeToGo
              : days = " is today at " + booking.timeToGo;
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

            if (!widget.hasNotifications && _upcomingBookings.isEmpty)
            
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
                  itemCount: _upcomingBookings.length + _pastBookings.length,
                  itemBuilder: (context, index) {
                    
                    final isDisabled = canceledIndices.contains(index);
                    if (isDisabled) {
                      return SizedBox();
                    }
                   
                    if (_upcomingBookings.isNotEmpty) {
                      
                       final isViewed = viewedNotifications.contains(index);
                      if(_upcomingBookings[index].bookingType=='place'){
                        return NotificationCrd(
                          name: AppUtil.rtlDirection2(context)
                              ? _upcomingBookings[index].place?.nameAr ?? ""
                              : _upcomingBookings[index].place?.nameEn ?? "",
                          isRtl: AppUtil.rtlDirection2(context),
                          width: width,
                          isTour: true,
                          days: days,
                          isDisabled: isDisabled,
                          onCancel: () {
                            disableNotification(index);
                          },
                         onDismissed: () => _dismissNotification(index),
                         isViewed: isViewed,

                        );
                      }else if(_upcomingBookings[index].bookingType=='hospitality'){
                        return NotificationCrd(
                          name: AppUtil.rtlDirection2(context)
                              ? _upcomingBookings[index].hospitality?.titleAr??''
                              : _upcomingBookings[index].hospitality?.titleEn?? "",
                          isRtl: AppUtil.rtlDirection2(context),
                          width: width,
                          isHost: true,
                          days: days,
                          isDisabled: isDisabled,
                          onCancel: () {
                            disableNotification(index);
                          },
                       onDismissed: () => _dismissNotification(index),
                        isViewed: isViewed,


                        );
                      }else if(_upcomingBookings[index].bookingType=='adventure'){
                         return NotificationCrd(
                          name: AppUtil.rtlDirection2(context)
                              ? _upcomingBookings[index].adventure?.nameAr??''
                              : _upcomingBookings[index].adventure?.nameEn?? "",
                          isRtl: AppUtil.rtlDirection2(context),
                          width: width,
                          isAdve: true,
                          days: days,
                          isDisabled: isDisabled,
                          onCancel: () {
                            disableNotification(index);
                          },
                    onDismissed: () => _dismissNotification(index),
                    isViewed: isViewed,

                        );
                        
                      }else{
                        return NotificationCrd(
                          name: AppUtil.rtlDirection2(context)
                              ? _upcomingBookings[index].event?.nameAr??''
                              : _upcomingBookings[index].event?.nameEn?? "",
                          isRtl: AppUtil.rtlDirection2(context),
                          width: width,
                          days: days,
                          isDisabled: isDisabled,
                          onCancel: () {
                            disableNotification(index);
                          },
                    onDismissed: () => _dismissNotification(index),
                    isViewed: isViewed,

                        );
                      }
                      
                    } 
                    else {
          setState(() {
            widget.hasNotifications = false;
          });
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
