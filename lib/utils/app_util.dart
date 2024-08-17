import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/model/coordinates.dart';
import 'package:ajwad_v4/services/model/days_info.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    final _getStorage = GetStorage();
    var token = _getStorage.read('accessToken') ?? '';
    var isExpired = JwtDecoder.isExpired(token);
    print('isExpired $isExpired');

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

  static bool isDateBefore24Hours(String Date) {
    final String timeZoneName = 'Asia/Riyadh';
    late tz.Location location;

    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
    DateTime parsedDate = DateTime.parse(Date);
    final tripDateInRiyadh =
        tz.TZDateTime.from(parsedDate, location).subtract(Duration(hours: 3));

    Duration difference = tripDateInRiyadh.difference(currentDateInRiyadh);
    print('this deffrence');
    print(difference);
    print(parsedDate);
    print(tripDateInRiyadh);
    print(currentDateInRiyadh);
    return difference.inHours >= 24;
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
    final tripDateInRiyadh = tz.TZDateTime.from(parsedTripDate, location)
        .subtract(Duration(hours: 3));

    // Calculate the difference
    final difference = tripDateInRiyadh.difference(currentDateInRiyadh);

    // Print the current time and difference for debugging
    print('Current Time in Riyadh: $currentDateInRiyadh');
    print('trip before: $parsedTripDate');

    print('Trip Time in Riyadh: $tripDateInRiyadh');
    print('Difference: $difference');

    // Check if the difference is greater than or equal to 24 hours
    return difference.inHours > 24;
  }

  static bool areAllDatesAfter24Hours(List<dynamic> dates) {
    final String timeZoneName = 'Asia/Riyadh';
    late tz.Location location;

    tz.initializeTimeZones();
    location = tz.getLocation(timeZoneName);
    DateTime currentDateInRiyadh = tz.TZDateTime.now(location);

    for (DateTime date in dates) {
      final DateInRiyadh =
          tz.TZDateTime.from(date, location).subtract(Duration(hours: 3));

      Duration difference = DateInRiyadh.difference(currentDateInRiyadh);

      print('Difference for $date: $difference');

      if (difference.inHours < 24) {
        return false;
      }
    }

    return true;
  }

  static bool isEndTimeLessThanStartTime(DateTime startTime, DateTime endTime) {
  // If the end time is before the start time, adjust end time by adding one day
  // if (endTime.isBefore(startTime)) {
  //   endTime = endTime.add(Duration(days: 1));
  // }
  print(startTime);
  print(endTime);
  print(endTime.isBefore(startTime));
  // return endTime.isBefore(startTime) ;
    return endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime);

}

  static String formatSelectedDates(
      RxList<dynamic> dates, BuildContext context) {
    // Convert dynamic list to List<DateTime>
    List<DateTime> dateTimeList = dates
        .where((date) => date is DateTime)
        .map((date) => date as DateTime)
        .toList();

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
    final _getStorage = GetStorage();
    final String token = _getStorage.read('accessToken') ?? '';
    return token.isEmpty;
  }

  static successToast(context, msg) {
    Flushbar(
      onTap: (flushbar) {},
      messageText: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: CustomText(
              text: msg,
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ],
      ),
      messageColor: Colors.white,
      messageSize: 18,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      isDismissible: true,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      barBlur: .1,
      backgroundColor: colorGreen,
      borderColor: colorGreen,
      margin: const EdgeInsets.all(8),
      //  borderRadius: BorderRadius.circular(10),
      //  borderRadius:BorderRadius?.all(Radius.circular(12))
    ).show(context);
  }

  static String getBookingTypeText(BuildContext context, String bookingType) {
    if (AppUtil.rtlDirection2(context)) {
      switch (bookingType) {
        case 'place':
          return 'جولة';
        case 'adventure':
          return 'مغامرة';
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
      } else {
        return bookingType;
      }
    }
  }

  static errorToast(context, msg) {
    Flushbar(
            messageText: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: CustomText(
                    text: msg,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            messageColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            isDismissible: true,
            duration: const Duration(seconds: 2),
            flushbarPosition: FlushbarPosition.TOP,
            // barBlur: .1,
            backgroundColor: colorDarkRed,
            borderColor: colorDarkRed,
            margin: const EdgeInsets.all(3),
            borderRadius: const BorderRadius.all(Radius.circular(8))

            //BorderRadius.circular(12),
            )
        .show(context);
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
    return "${hijriDate.year}-${hijriDate.month.toString().padLeft(2, '0')}-${hijriDate.day.toString().padLeft(2, '0')}";
  }

  static String SfFontType(BuildContext context) {
    return AppUtil.rtlDirection2(context) ? 'SF Arabic' : "SF Pro";
  }

  static String convertTime(String time) {
    DateTime dateTime = DateFormat('h:mm a').parse(time);
    return DateFormat('HH:mm:ss').format(dateTime);
  }
}
