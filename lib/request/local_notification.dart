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
  late DateTime timeToGo;
  late DateTime timeToReturn;
   String day="2 days";
void checkBooking(String? bookdate) {
DateTime currentDate = DateTime.now();
DateTime bookingDate = DateTime.parse(bookdate!);
twoDaysBefore = bookingDate.subtract(Duration(days: 2));
// Check if the calculated date is in the past
  if (twoDaysBefore.isBefore(DateTime.now())) {
    // If it's in the past, set it to the current date
    twoDaysBefore = DateTime.now();
    if(twoDaysBefore==DateTime.now()){
      day="towday";
    }
    else{
      day="1 day";
    }
  }
print("datebe");
print(twoDaysBefore);
int daysDifference = bookingDate.difference(DateTime.now()).inDays;
  

  

  
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
checkBooking(date);

DateTime notificationTime = DateTime(twoDaysBefore.year, twoDaysBefore.month, twoDaysBefore.day, 12, 29, 3);
print(notificationTime);
print(placeeAr);
print(placeeEn);
print(id);


  //int? parsedId = int.tryParse(id ?? '');

  String placeName = AppUtil.rtlDirection2(context) ? placeeAr ?? '' : placeeEn ?? '';
print(placeeEn);


 AndroidNotificationDetails android =AndroidNotificationDetails(
  '0' , 'schduled', 
  importance: Importance.max,
  priority: Priority.high,
  
  
  
  );
  
  NotificationDetails details =   NotificationDetails(android: android);
  tz.initializeTimeZones();
  // tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));

  print(tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
     0,
    'Hi'+ " NAME "+", Reminder",
    'There is '+ day + " left until you start your journey to discover "+ placeName +" with ", 
    //  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
    tz.TZDateTime.from(notificationTime,tz.local), // Schedule the notification two days before the booking date
    details,uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
     
     );
 
}


}