import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';

import 'package:get/get.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:flutter/material.dart';
import 'package:ajwad_v4/utils/app_util.dart';




class LocalNotification {

List<Booking> _upcomingTicket = [];
List<Booking> _upcomingBookings = [];

final ProfileController _profileController = Get.put(ProfileController());

late Booking booking;

static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

static onTap(NotificationResponse notificationResponse){}


  late DateTime twoDaysBefore;
  late DateTime twoHoursBefore;
  late DateTime timeToGo;
  late DateTime timeToReturn;
    late String descreption;

   String day="2 days";
   String time="2 hours";


void checkBooking(String? bookdate) {
DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
DateTime bookingDate = DateTime.parse(bookdate!);

twoDaysBefore = bookingDate.subtract(Duration(days: 2));

DateTime twoDaysBeforeWithoutTime = DateTime(twoDaysBefore.year, twoDaysBefore.month, twoDaysBefore.day);

  if (twoDaysBeforeWithoutTime.isBefore(currentDate)) {
    // If it's in the past, set it to the current date
    twoDaysBefore = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if(twoDaysBefore == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)){
      day="towday";
    }
    else{
      day="1 day";
    }
  }
print("datebe");
print(twoDaysBefore);
  

  

  
}


void checkBooking2(String? bookdate) {
DateTime currentTime = DateTime.now();
DateTime bookingDate = DateTime.parse(bookdate!);

 twoHoursBefore = bookingDate.subtract(Duration(hours: 2));

//  DateTime twoHoursBeforeWithoutDate = DateTime(0, 0, 0, twoHoursBefore.hour, twoHoursBefore.minute, twoHoursBefore.second);
//  DateTime currentTimeWithoutDate =  DateTime(0, 0, 0, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);
   // Check if two hours before is before the current time on the same date
  if (twoHoursBefore.day == currentTime.day) {
    int hourDifference = currentTime.hour - twoHoursBefore.hour;
    if (hourDifference == 1) {
      twoHoursBefore = bookingDate.subtract(Duration(hours: 1));
      time='one hour';
    } else if (hourDifference > 1) {
      // Set text to 'now'
      twoHoursBefore = currentTime;
      time='now';
    }
    else{
      time='two hours';

    }
  }
}
  

  


















static Future init()async{
  InitializationSettings settings = InitializationSettings(
   android: AndroidInitializationSettings("@mipmap/ic_launcher"),
   iOS: DarwinInitializationSettings()

  );
  flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: onTap,
    onDidReceiveBackgroundNotificationResponse: onTap,
    
    );
}

// static void showNotification() async {

// const AndroidNotificationDetails android =AndroidNotificationDetails(
//   '0', 'baisc',
//   importance: Importance.max,
//   priority: Priority.high);

//   NotificationDetails details =  const NotificationDetails(android: android);

// await flutterLocalNotificationsPlugin.show(
// 0,'basic ','bodyyyyyyyyy',details,payload: "payload");
 
// }

void showNotification(BuildContext context, String? id , String? date ,  String? name, String? placeeEn,String? placeeAr) async {
checkBooking2(date);
// checkBooking(date);

//DateTime notificationTime = DateTime(twoDaysBefore.year, twoDaysBefore.month, twoDaysBefore.day, 21, 00, 3);
DateTime notificationTime =  twoHoursBefore;
DateTime increasedTime = notificationTime.add(Duration(hours: 3));


print(notificationTime);
print(placeeAr);
print(placeeEn);
print(id);


  int parsedId = int.tryParse(id ?? '') ?? 0;
  String ids= id ??"0 ";

  String placeName = AppUtil.rtlDirection2(context) ? placeeAr ?? '' : placeeEn ?? '';
print(placeeEn);


 AndroidNotificationDetails android =AndroidNotificationDetails(
  ids , 'schduled', 
  importance: Importance.max,
  priority: Priority.high,
  
  
  
  );
  
  NotificationDetails details =   NotificationDetails(android: android);
  tz.initializeTimeZones();
  // tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));

  print(tz.local);

if(time=='now'){

  descreption = " your experience to discover "+ placeName +" with " + "start"+time;
}
else{
  descreption = time + "  left and  your experience to discover "+ placeName +" with " + "begins";

}
    await flutterLocalNotificationsPlugin.zonedSchedule(
     parsedId,
    'Hi'+ " NAME "+", Reminder",
    descreption,
    // time + " and your journey to discover "+ placeName +" with " + 'begins', 
    //  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
    tz.TZDateTime.from(increasedTime,tz.local), 
    details,uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
     
     );
 
}


}