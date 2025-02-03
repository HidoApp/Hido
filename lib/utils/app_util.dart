import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:jhijri/jhijri.dart';

class AppUtil {
  static String address = '';
  static const List<String> regionListEn = [
    'All',
    "Riyadh",
    "Mecca",
    "Medina",
    "Dammam",
    "Qassim",
    "Hail",
    "Northern Borders",
    "Jazan",
    "Asir",
    "Tabuk",
    "Najran",
    "Al Baha",
    "Al Jouf"
  ];

  static const List<String> regionListAr = [
    'الكل',
    "الرياض",
    "مكة",
    "المدينة",
    "الدمام",
    "القصيم",
    "حائل",
    "الحدود الشمالية",
    "جازان",
    "عسير",
    "تبوك",
    "نجران",
    "الباحة",
    "الجوف"
  ];

  static bool rtlDirection(context) {
    return !(Get.locale == const Locale('ar', 'ar') ? true : false);
    //return Get.locale == const Locale('ar', 'ar');
  }

  static bool rtlDirection2(BuildContext context) {
    return Get.locale?.languageCode == 'ar';
  }

  static bool validateBirthday(String birthday) {
    try {
      // Parse the date string
      DateTime parsedDate = DateTime.parse(birthday);

      // Check if the year is the current year or before
      return parsedDate.year <= DateTime.now().year;
    } on FormatException {
      // Invalid format
      return false;
    }
  }

  static bool isEmailValidate(email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isPhoneValidate(String phone) {
    return phone.length == 10 && phone.startsWith('05');
  }

  static bool isImageValidate(int size) {
    return size <= 2 * 1048576;
  }

  static bool isNationalIdValidate(String id) {
    return id.length == 10;
  }

  static bool isSaudiNationalId(String id) {
    return id.length == 10 && id.startsWith('1');
  }

  static bool isPasswordLengthValidate(String password) {
    return password.length >= 8;
  }

  static bool isTokeValidate(String token) {
    final getStorage = GetStorage();
    var token = getStorage.read('accessToken') ?? '';
    var isExpired = JwtDecoder.isExpired(token);

    return isExpired;
  }

  static String formatBookingDate(BuildContext context, String date) {
    DateTime dateTime = DateTime.parse(date);
    if (AppUtil.rtlDirection2(context)) {
      // Set Arabic locale for date formatting
      return DateFormat('EEEE، d MMMM yyyy', 'ar').format(dateTime);
    } else {
      // Default to English locale
      return DateFormat('E dd MMM yyyy').format(dateTime);
    }
  }

  static String formatBookingDateSummary(BuildContext context, String date) {
    DateTime dateTime = DateTime.parse(date);
    if (AppUtil.rtlDirection2(context)) {
      // Set Arabic locale for date formatting
      return DateFormat('d MMMM yyyy', 'ar').format(dateTime);
    } else {
      // Default to English locale
      return DateFormat('E dd MMM yyyy').format(dateTime);
    }
  }

  static String formatTimeWithLocale(
      BuildContext context, String dateTimeString, String format) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedTime = DateFormat(format).format(dateTime);

    if (AppUtil.rtlDirection2(context)) {
      // Arabic locale
      String suffix = dateTime.hour < 12 ? 'صباحًا' : 'مساءً';
      formattedTime = formattedTime
          .replaceAll('AM', '')
          .replaceAll('PM', '')
          .trim(); // Remove AM/PM
      return '$formattedTime $suffix';
    } else {
      // Default to English locale
      return formattedTime;
    }
  }

  static bool isDateBefore24Hours(String date) {
    const String timeZoneName = 'Asia/Riyadh';
    late tz.Location location;

    try {
      // Initialize the time zones
      tz.initializeTimeZones();
      location = tz.getLocation(timeZoneName);

      // Get the current date/time in the specified time zone
      DateTime currentDateInRiyadh = tz.TZDateTime.now(location);

      // Split the input string if it contains multiple dates
      List<String> dateList = date.split(',');

      for (String singleDate in dateList) {
        // Trim and parse each date
        singleDate = singleDate.trim();
        DateTime parsedDate = DateTime.parse(singleDate);

        // Convert the parsed date to the specified time zone
        final tripDateInRiyadh = tz.TZDateTime.from(parsedDate, location);

        // Check if the trip date is at least 24 hours before the current date/time
        Duration difference = tripDateInRiyadh.difference(currentDateInRiyadh);

        // If any date is not at least 24 hours ahead, return false
        if (difference.inHours < 24) {
          return false;
        }
      }

      // All dates are at least 24 hours ahead
      return true;
    } catch (e) {
      // Log the error and return false if parsing or other operations fail
      log('Error in isDateBefore24Hours: $e');
      return false;
    }
  }

  static bool isDateTimeBefore24Hours(String date) {
    const String timeZoneName = 'Asia/Riyadh';

    // Initialize time zones
    tz.initializeTimeZones();

    // Get the Riyadh location
    final location = tz.getLocation(timeZoneName);

    // Get the current date and time in Riyadh
    final currentDateInRiyadh = tz.TZDateTime.now(location);

    // Parse the trip date string as UTC
    final parsedTripDate = DateTime.parse(date);

    // Convert the parsed trip date to the Riyadh time zone
    final tripDateInRiyadh =
        tz.TZDateTime.from(parsedTripDate, location).subtract(
      const Duration(hours: 3),
    ); //new

    // Calculate the difference
    final difference = tripDateInRiyadh.difference(currentDateInRiyadh);

    // Check if the difference is greater than or equal to 24 hours

    // return difference.inHours > 24;

    // return tripDateInRiyadh.isAfter(currentDateInRiyadh); //last one for book before date of trip
    // log(tripDateInRiyadh.toString());
    // log(currentDateInRiyadh.toString());
    // return tripDateInRiyadh.isAfter(currentDateInRiyadh);

    // return tripDateInRiyadh.isAfter(currentDateInRiyadh) ||
    //     (tripDateInRiyadh.year == currentDateInRiyadh.year &&
    //         tripDateInRiyadh.month == currentDateInRiyadh.month &&
    //         tripDateInRiyadh.day == currentDateInRiyadh.day);

    //this for compare time "Ammar"
    log(tripDateInRiyadh.toString());
    log(currentDateInRiyadh.toString());
    log(tripDateInRiyadh.isAfter(currentDateInRiyadh).toString());
    log((tripDateInRiyadh.year == currentDateInRiyadh.year &&
            tripDateInRiyadh.month == currentDateInRiyadh.month &&
            tripDateInRiyadh.day == currentDateInRiyadh.day)
        .toString());
    if (tripDateInRiyadh.isAfter(currentDateInRiyadh) ||
        (tripDateInRiyadh.year == currentDateInRiyadh.year &&
            tripDateInRiyadh.month == currentDateInRiyadh.month &&
            tripDateInRiyadh.day == currentDateInRiyadh.day)) {
      if (tripDateInRiyadh.year == currentDateInRiyadh.year &&
          tripDateInRiyadh.month == currentDateInRiyadh.month &&
          tripDateInRiyadh.day == currentDateInRiyadh.day) {
        if (tripDateInRiyadh.isAfter(currentDateInRiyadh)) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  static bool isTimeDifferenceOneHour(String givenTimeString) {
    try {
      // Parse the given string into a DateTime object
      final givenTime = DateTime.parse(givenTimeString);

      // Define Riyadh timezone offset (+3 hours from UTC)
      const riyadhTimeZoneOffset = Duration(hours: 3);

      // Get current time in Riyadh timezone
      final now = DateTime.now().toUtc().add(riyadhTimeZoneOffset);

      // Calculate the difference in time
      final difference = now.difference(givenTime);

      return difference.abs().inMinutes >= 60;
    } catch (e) {
      log('Error parsing time string: $e');
      return false; // Return false if parsing fails
    }
  }

  static bool isAdventureTimeDifferenceOneHour(String givenTimeString) {
    try {
      // Parse the given string into a DateTime object
      final givenTime = DateTime.parse(givenTimeString);

      const String timeZoneName = 'Asia/Riyadh';

      // Initialize time zones
      tz.initializeTimeZones();

      // Get the Riyadh location
      final location = tz.getLocation(timeZoneName);

      // Get the current date and time in Riyadh
      final currentDateInRiyadh = tz.TZDateTime.now(location);
      final tripDateInRiyadh = tz.TZDateTime.from(givenTime, location); //new
      // Calculate the difference in time
      final difference = tripDateInRiyadh.difference(currentDateInRiyadh);
      log(currentDateInRiyadh.toString());
      log(tripDateInRiyadh.toString());
      log(difference.inMinutes.toString());
      log((difference.inMinutes >= 60).toString());
      return difference.inMinutes >= 60;
    } catch (e) {
      log('Error parsing time string: $e');
      return false; // Return false if parsing fails
    }
  }

  static bool areDatesOnSameDay(String startDate, String date) {
    try {
      // Parse the given strings into DateTime objects
      final date1 = DateTime.parse(startDate);
      final date2 = DateTime.parse(date);

      // Compare year, month, and day
      return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day;
    } catch (e) {
      log('Error parsing date strings: $e');
      return false; // Return false if parsing fails
    }
  }

  static bool areAllDatesAfter24Hours(List<dynamic> dates) {
    const String timeZoneName = 'Asia/Riyadh';
    late tz.Location location;

    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);

    for (DateTime date in dates) {
      // final DateInRiyadh =
      //     tz.TZDateTime.from(date, location).subtract(const Duration(hours: 3));
      final DateInRiyadh = tz.TZDateTime.from(date, location);

      // Duration difference = DateInRiyadh.difference(currentDateInRiyadh);

      // if (difference.inHours < 12) {
      //   return false;
      // }
      log(DateInRiyadh.toString());

      if (DateInRiyadh.isBefore(currentDateInRiyadh) &&
          !(DateInRiyadh.year == currentDateInRiyadh.year &&
              DateInRiyadh.month == currentDateInRiyadh.month &&
              DateInRiyadh.day == currentDateInRiyadh.day)) {
        return false;
      } // last ubdate of srs beore change
    }

    return true;
  }

  static bool areAllDatesTimeBefore(List<dynamic> dates, DateTime startTime) {
    const String timeZoneName = 'Asia/Riyadh';
    late tz.Location location;

    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);

    for (DateTime date in dates) {
      // Check if the start time is not greater than the current time

      final DateInRiyadh = tz.TZDateTime.from(date, location);
      log(DateInRiyadh.toString());
      if (DateInRiyadh.isAtSameMomentAs(currentDateInRiyadh) ||
          (DateInRiyadh.year == currentDateInRiyadh.year &&
              DateInRiyadh.month == currentDateInRiyadh.month &&
              DateInRiyadh.day == currentDateInRiyadh.day)) {
        final tripTime = DateTime(date.year, date.month, date.day,
            startTime.hour, startTime.minute, startTime.second);

        if (tripTime.isBefore(currentDateInRiyadh) ||
            tripTime.isAtSameMomentAs(currentDateInRiyadh)) {
          return true;
        }
      }
    }
    return false;
  }

  static bool isDateTimeBefore(String date, DateTime startTime) {
    const String timeZoneName = 'Asia/Riyadh';
    late tz.Location location;

    try {
      // Initialize time zones
      tz.initializeTimeZones();
      location = tz.getLocation(timeZoneName);

      // Get the current date/time in the specified time zone
      DateTime currentDateInRiyadh = tz.TZDateTime.now(location);

      // Split the input into individual dates if it's a comma-separated string
      List<String> dateList = date.split(',');

      for (String singleDate in dateList) {
        singleDate = singleDate.trim(); // Remove extra spaces

        // Parse the single date
        DateTime parsedDate = DateTime.parse(singleDate);

        // Combine the parsed date with the provided start time
        final tripTime = tz.TZDateTime(
          location,
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          startTime.hour,
          startTime.minute,
          startTime.second,
        );

        // Log the values for debugging
        log('Current Date in Riyadh: $currentDateInRiyadh');
        log('Trip Time: $tripTime');

        // If any trip time is before or at the same moment as the current time, return true
        if (tripTime.isBefore(currentDateInRiyadh) ||
            tripTime.isAtSameMomentAs(currentDateInRiyadh)) {
          return true;
        }
      }

      // If no date is before or at the same moment, return false
      return false;
    } catch (e) {
      // Log the error and return false if parsing or other operations fail
      log('Error in isDateTimeBefore: $e');
      return false;
    }
  }

  static bool isEndTimeLessThanStartTime(DateTime startTime, DateTime endTime) {
    // If the end time is before the start time, adjust end time by adding one day
    // if (endTime.isBefore(startTime)) {
    //   endTime = endTime.add(Duration(days: 1));
    // }

    // return endTime.isBefore(startTime) ;
    return endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime);
  }

  static String formatSelectedDates(
      RxList<dynamic> dates, BuildContext context) {
    // Convert dynamic list to List<DateTime>
    List<DateTime> dateTimeList =
        dates.whereType<DateTime>().map((date) => date as DateTime).toList();

    if (dateTimeList.isEmpty) {
      return 'DD/MM/YYYY';
    }

    // Sort the dates
    dateTimeList.sort();
// Date formatting based on app language direction
    final bool isArabic = AppUtil.rtlDirection2(context);
    final DateFormat dayFormatter = DateFormat('d', isArabic ? 'ar' : 'en');

    final DateFormat monthFormatter =
        DateFormat('MMMM', isArabic ? 'ar' : 'en');
    final DateFormat yearFormatter = DateFormat('yyyy', isArabic ? 'ar' : 'en');

    if (dateTimeList.isEmpty) {
      return 'DD/MM/YYYY'; // Return default string when no valid dates are found
    }

    if (dateTimeList.length == 1) {
      // Single date
      DateTime date = dateTimeList.first;
      return '${dayFormatter.format(date)} ${monthFormatter.format(date)} ${yearFormatter.format(date)}';
    }

    DateTime firstDate = dateTimeList.first;
    DateTime lastDate = dateTimeList.last;

    if (firstDate.month == lastDate.month && firstDate.year == lastDate.year) {
      // All dates are in the same month and year
      return '${monthFormatter.format(firstDate)} ${yearFormatter.format(firstDate)}';
    } else if (firstDate.year == lastDate.year) {
      // Dates are in different months but the same year
      return '${monthFormatter.format(firstDate)} - ${monthFormatter.format(lastDate)} ${yearFormatter.format(firstDate)}';
    } else {
      // Dates are in different months and years
      String formattedDates = '';
      int start = 0;

      while (start < dateTimeList.length) {
        int end = start;

        // Find the range of dates in the same month and year
        while (end + 1 < dateTimeList.length &&
            dateTimeList[end + 1].month == dateTimeList[start].month &&
            dateTimeList[end + 1].year == dateTimeList[start].year) {
          end++;
        }

        if (formattedDates.isNotEmpty) {
          formattedDates += ' , ';
        }

        // If more than two dates in the same month, display as range
        if (end > start) {
          formattedDates +=
              '${monthFormatter.format(dateTimeList[start])} ${yearFormatter.format(dateTimeList[start])}';
        } else {
          // Display individual dates
          for (int i = start; i <= end; i++) {
            if (i > start) {
              formattedDates += ', ';
            }
            formattedDates +=
                '${monthFormatter.format(dateTimeList[i])} ${yearFormatter.format(dateTimeList[i])}';
          }
        }

        start = end + 1;
      }

      return formattedDates;
    }
  }

  static String formatTimeOnly(BuildContext context, String dateTimeString) {
    final isArabic = AppUtil.rtlDirection2(context);
    final dateTime = DateTime.parse(dateTimeString);
    final hours = dateTime.hour;
    final minutes = dateTime.minute;
    final period = hours >= 12
        ? (isArabic ? 'مساءً' : 'PM')
        : (isArabic ? 'صباحًا' : 'AM');
    final formattedHours = hours % 12 == 0 ? 12 : hours % 12;
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    return '$formattedHours:$formattedMinutes $period';
  }

  static String formatSelectedDaysInfo(
      List<DayInfo> daysInfo, BuildContext context) {
    // Extract DateTime objects from daysInfo
    List<DateTime> dateTimeList = daysInfo
        .map((info) => [info.startTime, info.endTime])
        .expand((dates) => dates)
        .map((date) => DateTime.parse(date.toString()))
        .toList(); // Flatten and convert to DateTime

    // Sort the dates
    dateTimeList.sort();

    // Date formatting based on app language direction
    final bool isArabic = AppUtil.rtlDirection2(context);
    final DateFormat dayFormatter = DateFormat('d', isArabic ? 'ar' : 'en');

    final DateFormat monthFormatter =
        DateFormat('MMMM', isArabic ? 'ar' : 'en');
    final DateFormat yearFormatter = DateFormat('yyyy', isArabic ? 'ar' : 'en');

    if (dateTimeList.isEmpty) {
      return 'DD/MM/YYYY'; // Return default string when no valid dates are found
    }
    if (daysInfo.length == 1) {
      DateTime date = dateTimeList.first;
      return '${dayFormatter.format(date)} ${monthFormatter.format(date)} ${yearFormatter.format(date)}';
    } else {
      DateTime firstDate = dateTimeList.first;
      DateTime lastDate = dateTimeList.last;

      if (firstDate.month == lastDate.month &&
          firstDate.year == lastDate.year) {
        // All dates are in the same month and year
        return '${monthFormatter.format(firstDate)} ${yearFormatter.format(firstDate)}';
      } else if (firstDate.year == lastDate.year) {
        // Dates are in different months but the same year
        return '${monthFormatter.format(firstDate)} - ${monthFormatter.format(lastDate)} ${yearFormatter.format(firstDate)}';
      } else {
        // Dates are in different months and years
        String formattedDates = '';
        int start = 0;

        while (start < dateTimeList.length) {
          int end = start;

          // Find the range of dates in the same month and year
          while (end + 1 < dateTimeList.length &&
              dateTimeList[end + 1].month == dateTimeList[start].month &&
              dateTimeList[end + 1].year == dateTimeList[start].year) {
            end++;
          }

          if (formattedDates.isNotEmpty) {
            formattedDates += ' , ';
          }

          // If more than two dates in the same month, display as range
          if (end > start) {
            formattedDates +=
                '${monthFormatter.format(dateTimeList[start])} ${yearFormatter.format(dateTimeList[start])}';
          } else {
            // Display individual dates
            for (int i = start; i <= end; i++) {
              if (i > start) {
                formattedDates += ', ';
              }
              formattedDates +=
                  '${monthFormatter.format(dateTimeList[i])} ${yearFormatter.format(dateTimeList[i])}';
            }
          }

          start = end + 1;
        }

        return formattedDates;
      }
    }
  }

  static String getLocationUrl(Coordinate location) {
    return 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
  }

  static String capitalizeFirstLetter(String input) {
    String lowercased = input.toLowerCase();
    String capitalized = lowercased[0].toUpperCase() + lowercased.substring(1);

    return capitalized;
  }

  static String formatStringTimeWithLocale(
      BuildContext context, String dateTimeString) {
    DateTime time = DateFormat("HH:mm").parse(dateTimeString);
    String formattedTime = DateFormat.jm().format(time);
    if (AppUtil.rtlDirection2(context)) {
      // Arabic locale
      String suffix = time.hour < 12 ? 'صباحًا' : 'مساءً';
      formattedTime = formattedTime
          .replaceAll('AM', '')
          .replaceAll('PM', '')
          .trim(); // Remove AM/PM
      return '$formattedTime $suffix';
    } else {
      // Default to English locale
      return formattedTime;
    }
  }

  static String formatStringTimeWithLocaleRequest(
      BuildContext context, String dateTimeString) {
    DateTime time = DateFormat("h:mma").parse(dateTimeString);
    String formattedTime = DateFormat.jm().format(time);
    if (AppUtil.rtlDirection2(context)) {
      // Arabic locale
      String suffix = time.hour < 12 ? 'صباحًا' : 'مساءً';
      formattedTime = formattedTime
          .replaceAll('AM', '')
          .replaceAll('PM', '')
          .trim(); // Remove AM/PM
      return '$formattedTime $suffix';
    } else {
      // Default to English locale
      return formattedTime;
    }
  }

  static String formatStringTime(BuildContext context, String dateTimeString) {
    DateTime time = DateFormat("hh:mm").parse(dateTimeString);
    String formattedTime = DateFormat.jm().format(time);
    if (AppUtil.rtlDirection2(context)) {
      // Arabic locale
      String suffix = time.hour < 12 ? 'صباحًا' : 'مساءً';
      formattedTime = formattedTime
          .replaceAll('AM', '')
          .replaceAll('PM', '')
          .trim(); // Remove AM/PM
      return '$formattedTime $suffix';
    } else {
      // Default to English locale
      return formattedTime;
    }
  }

  static bool isGuest() {
    final getStorage = GetStorage();
    final String token = getStorage.read('accessToken') ?? '';
    return token.isEmpty;
  }

  static successToast(context, msg) {
    var width = MediaQuery.sizeOf(context).width;
    Flushbar(
      messageText: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.041, vertical: width * 0.029),
        clipBehavior: Clip.none, // No clipping to avoid any implicit border
        decoration: ShapeDecoration(
          color: const Color(
              0xFFEEFBDF), // Light pink background color for the message
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8), // Reduced border radius for less rounded corners
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/icons/sucss_toast.svg"),
            SizedBox(width: width * 0.029),
            Expanded(
              child: CustomText(
                text: msg, // Dynamic message text
                color: const Color(0xFF3F6E0D), // Text color
                fontSize: width * 0.038,
                maxlines: 200,
                fontFamily: SfFontType(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      messageColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: width * 0.029, vertical: 4),
      isDismissible: true,
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor:
          Colors.transparent, // Transparent to prevent any additional color
      // margin: const EdgeInsets.all(3),
      borderRadius: const BorderRadius.all(
          Radius.circular(8)), // Match the reduced border radius
    ).show(context);
  }

  static String getBookingTypeText(BuildContext context, String bookingType) {
    if (AppUtil.rtlDirection2(context)) {
      switch (bookingType) {
        case 'place':
          return 'جولة';
        case 'adventure':
          return 'نشاط';
        case 'hospitality':
          return 'ضيافة';
        case 'event':
          return 'فعالية';
        default:
          return bookingType;
      }
    } else {
      if (bookingType == 'place') {
        return "Tour";
      } else if (bookingType == 'adventure') {
        return "Activity";
      } else {
        return bookingType.capitalizeFirst ?? '';
      }
    }
  }

  static errorToast(BuildContext context, String msg) {
    var width = MediaQuery.sizeOf(context).width;
    Flushbar(
      messageText: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.041, vertical: width * 0.029),
        clipBehavior: Clip.none, // No clipping to avoid any implicit border
        decoration: ShapeDecoration(
          color: const Color(
              0xFFFBEAE9), // Light pink background color for the message
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8), // Reduced border radius for less rounded corners
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/icons/error_toast.svg"),
            SizedBox(width: width * 0.029),
            Expanded(
              child: CustomText(
                text: msg, // Dynamic message text
                color: const Color(0xFFDC362E), // Text color
                fontSize: width * 0.038,
                maxlines: 300,
                fontFamily: SfFontType(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      messageColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: width * 0.029, vertical: 4),
      isDismissible: true,
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor:
          Colors.transparent, // Transparent to prevent any additional color
      // margin: const EdgeInsets.all(3),
      borderRadius: const BorderRadius.all(
          Radius.circular(8)), // Match the reduced border radius
    ).show(context);
  }

  static notifyToast(BuildContext context, String? titleAr, String? bodyAr,
      String? titleEn, String? bodyEn, VoidCallback onTap) {
    var width = MediaQuery.sizeOf(context).width;
    Flushbar(
      messageText: GestureDetector(
        onTap: onTap, // Trigger the onTap callback when the toast is tapped
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.041, vertical: width * 0.029),
          clipBehavior: Clip.none,
          decoration: ShapeDecoration(
            color: Colors.white, // Light pink background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/icons/bell.svg'),
              SizedBox(width: width * 0.029),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title text
                    CustomText(
                      text: AppUtil.rtlDirection2(context)
                          ? titleAr ?? ''
                          : titleEn ?? '',
                      color: black,
                      fontSize: width * 0.042,
                      fontWeight: FontWeight.bold,
                      maxlines: 1,
                      fontFamily: SfFontType(context),
                    ),
                    SizedBox(
                        height:
                            width * 0.001), // Spacing between title and body

                    // Body text
                    CustomText(
                      text: AppUtil.rtlDirection2(context)
                          ? bodyAr ?? ''
                          : bodyEn ?? '',
                      color: black,
                      fontSize: width * 0.038,
                      maxlines: 1,
                      fontWeight: FontWeight.w500,
                      fontFamily: SfFontType(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      messageColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: width * 0.029, vertical: 4),
      isDismissible: true,
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ).show(context);
  }

  static connectionToast(BuildContext context, String msg) {
    var width = MediaQuery.sizeOf(context).width;

    Flushbar(
      messageText: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.041, vertical: width * 0.029),
        clipBehavior: Clip.none, // No clipping to avoid any implicit border
        decoration: ShapeDecoration(
          color: babyGray, // Light pink background color for the message
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8), // Reduced border radius for less rounded corners
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/icons/no_internet.svg",
              height: 24,
              width: 24,
              color: Colors.black, // Text color
            ),
            SizedBox(width: width * 0.029),
            Expanded(
              child: CustomText(
                text: msg, // Dynamic message text
                color: Colors.black, // Text color
                fontSize: width * 0.038,
                maxlines: 200,
                fontFamily: SfFontType(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      messageColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: width * 0.029, vertical: 4),
      isDismissible: true,
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor:
          Colors.transparent, // Transparent to prevent any additional color
      // margin: const EdgeInsets.all(3),
      borderRadius: const BorderRadius.all(
          Radius.circular(8)), // Match the reduced border radius
    ).show(context);
  }

  static String countdwonFormat(double seconds) {
    Duration duration = Duration(seconds: seconds.toInt());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds ";
  }

  static String maskIban(String iban) {
    // Get the last four characters
    String lastFour = iban.substring(iban.length - 4);
    // Replace all other characters with asterisks
    String masked = '*' * (iban.length - 4) + lastFour;
    // Insert spaces every four characters
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < masked.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted.write(' ');
      }
      formatted.write(masked[i]);
    }

    return formatted.toString();
  }

  static String convertIsoDateToFormattedDate(String isoDateString) {
    // Parse the date string to a DateTime object
    DateTime parsedDate = DateTime.parse(isoDateString);

    // Create a DateFormat object with the desired format
    DateFormat formatter = DateFormat('yyyy-MM-d');

    // Format the DateTime object to the desired format
    return formatter.format(parsedDate);
  }

  static String removeSpaces(String input) {
    return input.replaceAll(' ', '');
  }

  static String formattedHijriDate(JHijri hijriDate) {
    return "${hijriDate.year}-${hijriDate.month.toString().padLeft(2, '0')}";
    // return "${hijriDate.year}-${hijriDate.month.toString().padLeft(2, '0')}-${hijriDate.day.toString().padLeft(2, '0')}";
  }

  static String formattedHijriDateDay(JHijri hijriDate) {
    return "${hijriDate.year}-${hijriDate.month.toString().padLeft(2, '0')}-${hijriDate.day.toString().padLeft(2, '0')}";
  }

  // Function to return Hijri date in "YYYY-MM-DD" format
  static String convertToHijriWithDayForLocal(String gregorianDate) {
    // Parse the Gregorian date to DateTime
    DateTime dateTime = DateTime.parse(gregorianDate);

    // Convert to Hijri date using jhijri
    var hijriDate = JHijri(fDate: dateTime);

    // Format the Hijri date as "YYYY-MM-DD"
    String formattedHijriDate =
        '${hijriDate.hijri.year}-${hijriDate.hijri.month.toString().padLeft(2, '0')}-${hijriDate.hijri.day.toString().padLeft(2, '0')}';

    return formattedHijriDate;
  }

// Function to return Hijri date in "YYYY-MM" format
  static String convertToHijriForRowad(String gregorianDate) {
    // Parse the Gregorian date to DateTime
    DateTime dateTime = DateTime.parse(gregorianDate);

    // Convert to Hijri date using jhijri
    var hijriDate = JHijri(fDate: dateTime);

    // Format the Hijri date as "YYYY-MM"
    String formattedHijriDate =
        '${hijriDate.hijri.year}-${hijriDate.hijri.month.toString().padLeft(2, '0')}';

    return formattedHijriDate;
  }

  static String formatDateForRowad(String dateTimeString) {
    // Parse the date string to DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the DateTime to "YYYY-MM-DD"
    String formattedDate =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

    return formattedDate;
  }

  static String SfFontType(BuildContext context) {
    return AppUtil.rtlDirection2(context) ? 'SF Arabic' : "SF Pro";
  }

  static String convertTime(String time) {
    DateTime dateTime = DateFormat('h:mm a').parse(time);
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  static String getFirstName(String fullName) {
    return fullName.split(" ")[0];
  }

  static String convertHijriToGregorian(String hijriDateString) {
    // Split the Hijri date string into year, month, day
    List<String> hijriParts = hijriDateString.split('-');
    int hijriYear = int.parse(hijriParts[0]);
    int hijriMonth = int.parse(hijriParts[1]);
    int hijriDay = int.parse(hijriParts[2]);
    // Create a HijriCalendar object using the Hijri date
    var hijriDate = JHijri(
        fYear: hijriYear,
        fMonth: hijriMonth,
        fDay: hijriDay); // Replace with your desired Hijri date
    // Format the Gregorian date as "YYYY-MM-DD"
    String formattedGregorianDate =
        '${hijriDate.dateTime.year}-${hijriDate.dateTime.month.toString().padLeft(2, '0')}-${hijriDate.dateTime.day.toString().padLeft(2, '0')}';

    return formattedGregorianDate;
  }

  static double couponPercentageCalculating({
    required double hidoPercentage,
    required int couponPercentage,
    required double price,
  }) {
    var copounPrice = couponPercentage / 100;
    log(copounPrice.toString());
    return copounPrice * price;
    // var hidoFee = hidoPercentage * price;
    // return hidoFee * copounPrice;
  }

  static double couponAmountCalculating({
    required double hidoPercentage,
    required int couponAmount,
    required double price,
  }) {
    return couponAmount.toDouble();
    // var hidoFee = hidoPercentage * price;
    // return hidoFee - couponAmount;
  }

  static String formatTo12HourTime(String isoTimestamp) {
    // Parse the ISO timestamp to a DateTime object
    DateTime dateTime = DateTime.parse(isoTimestamp);

    // Format DateTime to 12-hour time with am/pm in lowercase
    return DateFormat('h:mma').format(dateTime).toLowerCase();
  }
}
