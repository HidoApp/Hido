import 'dart:developer';

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

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static onTap(NotificationResponse notificationResponse) {}

  late DateTime twoDaysBefore;
  // late DateTime twoHoursBefore;
  // late DateTime timeToGo;
  //late DateTime timeToReturn;
  String descreption = '';
  int hour = 0;
  int minute = 0;
  int hour2 = 0;
  int minute2 = 0;
  String day = "";
  String time = "2 hours";
  final String timeZoneName = 'Asia/Riyadh';
  late tz.Location location;

  void checkBooking(String? bookdate, context) {
    //DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').add_Hms();
    tz.initializeTimeZones();

    location = tz.getLocation(timeZoneName);

    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime currentDate = DateTime(currentDateInRiyadh.year,
        currentDateInRiyadh.month, currentDateInRiyadh.day);

    DateTime bookingDate = DateTime.parse(bookdate!);

    twoDaysBefore = bookingDate.subtract(Duration(days: 2));

    DateTime twoDaysBeforeWithoutTime =
        DateTime(twoDaysBefore.year, twoDaysBefore.month, twoDaysBefore.day);
    DateTime bookingDateWithoutTime =
        DateTime(bookingDate.year, bookingDate.month, bookingDate.day);

    int daysDifference =
        twoDaysBefore.difference(currentDateInRiyadh).inDays; //new

    // If it's in the past, set it to the current date
    // twoDaysBefore = currentDate;
    if (twoDaysBeforeWithoutTime.isAfter(currentDate) ||
        bookingDateWithoutTime.isAtSameMomentAs(currentDate) ||
        twoDaysBeforeWithoutTime.isBefore(currentDate) ||
        twoDaysBeforeWithoutTime.isAtSameMomentAs(currentDate)) {
      if (bookingDateWithoutTime.isAtSameMomentAs(currentDate)) {
        twoDaysBefore = currentDateInRiyadh;

        day = "today";
        hour = currentDateInRiyadh.hour + 1;
        minute = currentDateInRiyadh.minute;
      } else if (daysDifference == 0) {
        day = "today";
        twoDaysBefore = twoDaysBefore.add(Duration(days: 1));
      } else {
        if (daysDifference == 1 || daysDifference == -1) {
          // twoDaysBefore = bookingDate.subtract(Duration(days: 1));
          day = AppUtil.rtlDirection2(context) ? "يوم" : "1 day";
          hour2 = currentDateInRiyadh.hour + 4;
          minute2 = currentDateInRiyadh.minute + 4;
        } else {
          twoDaysBefore = twoDaysBefore.subtract(Duration(days: 1));
          day = AppUtil.rtlDirection2(context) ? "يومان" : "2 day";
          //  hour = currentDateInRiyadh.hour + 1;
          //  minute = currentDateInRiyadh.minute + 3;
        }
      }
    }
  }

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

  void showNotification(BuildContext context, String? id, String? timeToGo,
      String? Date, String? name, String? placeeEn, String? placeeAr) async {
    checkBooking(Date, context);

    tz.TZDateTime notificationTime;
    if (hour != 0 && minute != 0) {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, hour!, minute!, 3);
    } else {
      if (day == "يوم" || day == "1 day") {
        day = 'tomorrow';
        twoDaysBefore = twoDaysBefore.add(Duration(days: 1));

        notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
            twoDaysBefore.month, twoDaysBefore.day, hour2, minute2, 3);
      } else {
        notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
            twoDaysBefore.month, twoDaysBefore.day, 24, 00, 3);
      }
    }

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

    if (day == 'today') {
      descreption = AppUtil.rtlDirection2(context)
          ? 'اليوم تبدأ تجربتك لاستكشاف ' + placeName
          : " your experience to discover " +
              placeName +
              // " with " +
              // name! +
              " start " +
              day;
    } else if (day == 'tomorrow') {
      descreption = AppUtil.rtlDirection2(context)
          ? 'غدا ' + 'تبدأ تجربتك لاستكشاف ' + placeName
          : day +
              "  your experience to discover " +
              placeName +
              // " with " +
              // name! +
              " begins";
    } else {
      descreption = AppUtil.rtlDirection2(context)
          ? 'متبقي ' + day + ' حتى تبدأ تجربتك لاستكشاف ' + placeName
          : day +
              " left and your experience to discover " +
              placeName +
              // " with " +
              // name! +
              " begins";
    }
    log(descreption);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        parsedId,
        AppUtil.rtlDirection2(context)
            ? "أهلا سائحنا, تذكير"
            : "Hi our tourist, Reminder",
        descreption,
        notificationTime,
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
    checkBooking(Date, context);

    tz.TZDateTime notificationTime;
    if (hour != 0 && minute != 0) {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, hour!, minute!, 3);
    } else {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, 24, 00, 3);
    }

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

    if (day == 'today') {
      descreption = AppUtil.rtlDirection2(context)
          ? "استضافتك على وجبة " +
              mealName +
              " في " +
              FamilyName +
              "تبدأ اليوم "
          : " Hosting You " +
              "for " +
              mealName +
              " at the " +
              FamilyName +
              " will begin " +
              day;
    } else {
      descreption = AppUtil.rtlDirection2(context)
          ? "متبقي " +
              day +
              " وستبدأ استضافتك في  " +
              FamilyName +
              " على " +
              mealName
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

  void showAdventureNotification(BuildContext context, String? id, String? date,
      String? nameEn, String? nameAr) async {
    checkBooking(date, context);

    tz.TZDateTime notificationTime;
    if (hour != 0 && minute != 0) {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, hour!, minute!, 3);
    } else {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, 24, 00, 3);
    }

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

    if (day == 'today') {
      descreption = AppUtil.rtlDirection2(context)
          ? "اليوم ستبدأ مغامرة " + PlaceName + " الخاصة بك"
          : "Your " + PlaceName + " adventure " + " will begin " + day;
    } else {
      descreption = AppUtil.rtlDirection2(context)
          ? "متبقي " + day + " وستبدأ مغامرة " + PlaceName + " الخاصة بك"
          : day + " left and your " + PlaceName + " adventure begins ";
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

  void showEventNotification(BuildContext context, String? id, String? date,
      String? nameEn, String? nameAr) async {
    checkBooking(date, context);

    tz.TZDateTime notificationTime;
    if (hour != 0 && minute != 0) {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, hour!, minute!, 3);
    } else {
      notificationTime = tz.TZDateTime(location, twoDaysBefore.year,
          twoDaysBefore.month, twoDaysBefore.day, 24, 00, 3);
    }

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

    if (day == 'today') {
      descreption = AppUtil.rtlDirection2(context)
          ? "اليوم ستبدأ فعالية " + PlaceName + " الخاصة بك"
          : " Your " + PlaceName + " event " + " will begin " + day;
    } else {
      descreption = AppUtil.rtlDirection2(context)
          ? "متبقي " + day + " وستبدأ فعالية " + PlaceName + " الخاصة بك"
          : day + " left and your " + PlaceName + " event begins ";
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
