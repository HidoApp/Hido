import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
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

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static onTap(NotificationResponse notificationResponse) {}

  late DateTime twoDaysBefore;
  // late DateTime twoHoursBefore;
  // late DateTime timeToGo;
  //late DateTime timeToReturn;
  String descreption = '';
  int? hour;
  int? minute;
  String day = "2 days";
  String time = "2 hours";
  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;

  void checkBooking(String? bookdate) {
    //DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').add_Hms();
    tz.initializeTimeZones();

    location = tz.getLocation(timeZoneName);

    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime currentDate = DateTime(currentDateInRiyadh.year,
        currentDateInRiyadh.month, currentDateInRiyadh.day);
    // DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // Get the current date and time in the Riyadh time zone
    //String formattedDate = dateFormat.format(DateTime.now().toUtc().add(Duration(hours: 3))); // Riyadh is UTC+3
    //DateTime currentDateInRiyadh = DateTime.parse(formattedDate);
    DateTime bookingDate = DateTime.parse(bookdate!);

    twoDaysBefore = bookingDate.subtract(Duration(days: 2));

    DateTime twoDaysBeforeWithoutTime =
        DateTime(twoDaysBefore.year, twoDaysBefore.month, twoDaysBefore.day);
    DateTime bookingDateWithoutTime =
        DateTime(bookingDate.year, bookingDate.month, bookingDate.day);

    // If it's in the past, set it to the current date
    // twoDaysBefore = currentDate;
    if (twoDaysBeforeWithoutTime.isBefore(currentDate)) {
      if (bookingDateWithoutTime == currentDate) {
        twoDaysBefore = currentDate;

        day = "towday";
        hour = currentDateInRiyadh.hour + 1;
        minute = currentDateInRiyadh.minute;
      } else {
        twoDaysBefore = bookingDate.subtract(Duration(days: 1));
        day = "1 day";
        hour = currentDateInRiyadh.hour + 1;
        minute = currentDateInRiyadh.minute + 3;
      }

      print("datebe");
      print(twoDaysBefore);
    }
  }

// void checkBooking2(String? timeToGo,String? Date) {

// // Parse the booking date and time
//   DateTime bookingDate = DateTime.parse(Date!);
//   String combinedTimeString = DateFormat("yyyy-MM-dd").format(bookingDate) + " " + timeToGo!;
//   DateTime parsedTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(combinedTimeString);
// print(parsedTime);
//   // Calculate two hours before the booking time
//    DateTime reminderTime = parsedTime.subtract(Duration(hours: 2));

// print(reminderTime);

//   // Get the current time
//   DateTime currentTime = DateTime.now();
//   DateTime newTime = DateTime(currentTime.year, currentTime.month, currentTime.day, currentTime.hour, 0, 0, 0);

// DateTime BookDateWithoutTime = DateTime(parsedTime.year, parsedTime.month, parsedTime.day);
// DateTime currentDateeWithoutTime = DateTime(currentTime.year, currentTime.month, currentTime.day);

// print(currentTime);
//   // Calculate the difference in hours between the current time and the booking time
//   int hoursDifference = reminderTime.difference(newTime).inHours;

// print('dev');
// print(hoursDifference);
//   // Set the reminder message based on the current time and the booking time

//   if(BookDateWithoutTime==currentDateeWithoutTime){

//     if (hoursDifference == -1) {
//     time = "1 hour ";
//     twoHoursBefore = DateTime.now();
//   } else if (hoursDifference == 0) {
//      twoHoursBefore=DateTime.now();
//     time = "now";
//   } else {
//     time = "2 hours";
//     twoHoursBefore=reminderTime;
//   }

// }
// else{
//     twoHoursBefore=reminderTime;
// }
// }

  static Future init() async {
    InitializationSettings settings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings());
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

  void showNotification(BuildContext context, String? id, String? timeToGo,
      String? Date, String? name, String? placeeEn, String? placeeAr) async {
//checkBooking2(timeToGo,Date);
    checkBooking(Date);

// DateTime notificationTime = DateTime(twoDaysBefore.year, twoDaysBefore.month, twoDaysBefore.day, 21, 00, 3);
// DateTime notificationTime;
    tz.TZDateTime notificationTime;
    if (hour != 0 && minute != 0) {
      //notificationTime = DateTime(twoDaysBefore.year, twoDaysBefore.month, twoDaysBefore.day, hour,minute,3);
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, hour!, minute!, 3);
      print("inter1");
    } else {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, 24, 00, 3);

//  notificationTime = DateTime(twoDaysBefore.year, twoDaysBefore.month, twoDaysBefore.day, 24,00,3);
    }

//DateTime notificationTimeInRiyadh = notificationTime.toUtc().add(Duration(hours: 3)); // Adjust to Riyadh time zone

    print("Notification Time:");
    //print(notificationTimeInRiyadh);
//DateTime notificationTime =  twoHoursBefore;
//DateTime increasedTime = notificationTime.add(Duration(hours: 3));

    print('note info');
//print( tz.TZDateTime.from(notificationTime,tz.local));
    print(notificationTime);
    print(placeeAr);
    print(placeeEn);
    print(id);

    int parsedId = int.tryParse(id ?? '') ?? 0;
    String ids = id ?? "0 ";

    String placeName =
        AppUtil.rtlDirection2(context) ? placeeAr ?? '' : placeeEn ?? '';

    AndroidNotificationDetails android = AndroidNotificationDetails(
      ids,
      'schduled',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = NotificationDetails(android: android);
    tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));

    print(tz.local);
    print(day);

    if (day == 'today') {
      descreption = AppUtil.rtlDirection2(context)
          ? day + " تبدأ " + name! + " مع " + placeName + "  تجربتك لاستكشاف"
          : " your experience to discover " +
              placeName +
              " with " +
              name! +
              " start" +
              day;
    } else {
      descreption = AppUtil.rtlDirection2(context)
          ? name! +
              " مع " +
              placeName +
              " حتى تبدأ تجربتك لإستكشاف " +
              day +
              " متبقي "
          : day +
              "  left and  your experience to discover " +
              placeName +
              " with " +
              name! +
              " begins";
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        parsedId,
        "Hi our tourist, Reminder",
        descreption,
        notificationTime,

        // time + " and your journey to discover "+ placeName +" with " + 'begins',
        //  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
        // tz.TZDateTime.from(notificationTime,tz.local),
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void showHospitalityNotification(
      BuildContext context,
      String? id,
      String? Date,
      String? mealEn,
      String? mealAr,
      String? titleEn,
      String? tiltleAr) async {
    checkBooking(Date);

    tz.TZDateTime notificationTime;
    if (hour != 0 && minute != 0) {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, hour!, minute!, 3);
      print("inter1");
    } else {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, 24, 00, 3);
    }

    print("Notification Time:");

    print('note info');
    print(notificationTime);

    print(id);

    int parsedId = int.tryParse(id ?? '') ?? 0;
    String ids = id ?? "0 ";

    String FamilyName =
        AppUtil.rtlDirection2(context) ? tiltleAr ?? '' : titleEn ?? '';
    String mealName =
        AppUtil.rtlDirection2(context) ? mealAr ?? '' : mealEn ?? '';

    AndroidNotificationDetails android = AndroidNotificationDetails(
      ids,
      'schduled',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = NotificationDetails(android: android);
    tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));

    print(tz.local);
    print(day);
    if (day == 'today') {
      descreption = AppUtil.rtlDirection2(context)
          ? day +
              " ستبدأ " +
              FamilyName +
              " في منزل " +
              mealName +
              "استضافتك على وجبة "
          : " Hosting You " +
              "for " +
              mealName +
              " at the " +
              FamilyName +
              " will begin " +
              day;
    } else {
      descreption = AppUtil.rtlDirection2(context)
          ? mealName +
              " على وجبة " +
              FamilyName +
              " وستبدأ استضافتك في منزل " +
              day +
              "متبقي  "
          : day +
              "  left and your hosting begins at " +
              FamilyName +
              " for " +
              mealName;
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        parsedId,
        AppUtil.rtlDirection2(context)
            ? "مرحبا سائحنا , للتذكير"
            : "Hi our Tourist, Reminder",
        descreption,
        notificationTime,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void showAdventureNotification(
      BuildContext context,
      String? id,
      String? date,
      String? nameEn,
      String? nameAr) async {
    checkBooking(date);

    tz.TZDateTime notificationTime;
    if (hour != 0 && minute != 0) {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, hour!, minute!, 3);
      print("inter1");
    } else {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, 24, 00, 3);
    }

    print("Notification Time:");

    print(notificationTime);

    print(id);

    int parsedId = int.tryParse(id ?? '') ?? 0;
    String ids = id ?? "0 ";

    String PlaceName =
        AppUtil.rtlDirection2(context) ? nameAr ?? '' : nameEn ?? '';

    AndroidNotificationDetails android = AndroidNotificationDetails(
      ids,
      'schduled',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = NotificationDetails(android: android);
    tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));

    print(tz.local);
    print(day);
    if (day == 'today') {
      descreption = AppUtil.rtlDirection2(context)
          ? day + " الخاصة بك ستبدأ " + PlaceName + " مغامرة "
          : " Your " + PlaceName + " adventure " + " will begin " + day;
    } else {
      descreption = AppUtil.rtlDirection2(context)
          ? " الخاصة بك " + PlaceName + " وستبدأ مغامرة  " + day + "متبقي  "
          : day + "  left and your " + PlaceName + " adventure begins ";
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        parsedId,
        AppUtil.rtlDirection2(context)
            ? "مرحبا سائحنا , للتذكير"
            : "Hi our Tourist, Reminder",
        descreption,
        notificationTime,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
