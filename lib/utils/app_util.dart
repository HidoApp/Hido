import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AppUtil {
  static bool rtlDirection(context) {
    return !(Get.locale == const Locale('ar', 'ar') ? true : false);
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
    return password.length > 5;
  }

  static bool isTokeValidate(String token) {
    final _getStorage = GetStorage();
    var token = _getStorage.read('accessToken') ?? '';
    var isExpired = JwtDecoder.isExpired(token);
    print('isExpired $isExpired');

    return isExpired;
  }

  static successToast(context, msg) {
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
          const Spacer(),
          const Icon(
            Icons.close,
            color: Colors.white,
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

      // borderRadius:BorderRadius.all(Radius.circular(12))

      //BorderRadius.circular(12),
    ).show(context);
  }
}
