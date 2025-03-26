import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/ajwadi_info.dart';
import 'package:ajwad_v4/auth/models/app_version.dart';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // 1 GET COUNTRIES ..
  static Future<List<String>?> getListOfCountries(BuildContext context) async {
    final response =
        await http.get(Uri.parse('$baseUrl/nationalities'), headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      //
      final data = jsonDecode(response.body);
      var listCountries = (data as List).map((item) => item as String).toList();

      return listCountries;
    } else {
      var errorMessage = jsonDecode(response.body)['error'];
      AppUtil.errorToast(context, errorMessage);

      return null;
    }
  }

  // 2 TOURIST REGISTER WITH EMAIL ..
  static Future<bool> touristRegister({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String nationality,
    required bool rememberMe,
    required BuildContext context,
  }) async {
    final response = await http.post(
        Uri.parse('$baseUrl/user/sign-up-with-email-and-password'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "email": email.trim(),
          "password": password.trim(),
          "name": name,
          "phoneNumber": phoneNumber,
          "nationality": nationality,
        }));

    if (response.statusCode == 200) {
      final getStorage = GetStorage();

      final String accessToken;
      accessToken = jsonDecode(response.body)['accessToken'];
      final String refreshToken;
      refreshToken = jsonDecode(response.body)['refreshToken'];
      var token = AuthService.jwtForToken(accessToken)!;
      getStorage.write('userRole', token.userRole);

      if (rememberMe) {
        getStorage.write('accessToken', accessToken);
        getStorage.write('refreshToken', refreshToken);
        // getStorage.write('rememberMe', rememberMe);
        getStorage.write('userRole', token.userRole);
      } else {
        getStorage.remove('token');
      }

      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];

      if (context.mounted) {
        if (errorMessage == 'Email already exists') {
          AppUtil.errorToast(context, "emailExists".tr);
        } else if (errorMessage == 'Mobile number already exists') {
          AppUtil.errorToast(context, "mobileExists".tr);
        } else {
          AppUtil.errorToast(context, errorMessage);
        }
      }
      return false;
    }
  }

  // 3 GET OTP by id and birth date ..
  static Future<Map<dynamic, dynamic>?> personInfoOTP({
    required String nationalID,
    required String birthDate,
    required BuildContext context,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rowad/otp/person-info').replace(queryParameters: {
        'dateString': birthDate.trim(),
        'nin': nationalID.trim(),
      }),
      headers: {
        'Accept': 'application/json',
        // "Content-Type": "application/json"
      },
    );

    log(response.statusCode.toString());
    log(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      Map responsBody = {
        'transactionId': jsonDecode(response.body)['transactionId'],
      };
      return responsBody;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['errorDetail']['errorMessage'];
      if (errorMessage == 'OTP Already Requested, Please Wait and try again.') {
        AppUtil.errorToast(context, 'otpForbidden'.tr);
      } else {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<bool> signUpWithRowad(
      {required BuildContext context,
      required String nationalId,
      required String otp,
      required String number,
      required String transactionId,
      required String birthDate}) async {
    final response = await http.post(
        Uri.parse('$baseUrl/user/sign-up-with-rowad/$otp/$transactionId')
            .replace(
          queryParameters: {'otp': otp, 'transactionId': transactionId},
        ),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: json.encode({
          'birthDate': birthDate,
          'nationalityId': nationalId,
          'phoneNumber': number.substring(1)
        }));
    log("StatusCode");
    log(response.statusCode.toString());
    log(response.body);

    if (response.statusCode == 200) {
      log("enter after 200");
      final getStorage = GetStorage();

      final String accessToken;
      accessToken = jsonDecode(response.body)['accessToken'];
      final String refreshToken;
      refreshToken = jsonDecode(response.body)['refreshToken'];
      getStorage.write('localName', jsonDecode(response.body)['name']);
      getStorage.write('accessToken', accessToken);
      getStorage.write('refreshToken', refreshToken);
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['message'];
      log(response.statusCode.toString());
      log(errorMessage);
      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

  // 4 Registeration with Rowad
  static Future<bool> registerWithRowad({
    required String otp,
    required String nationalID,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String nationality,
    required String userRole,
    required BuildContext context,
  }) async {
    {}
    final response = await http.post(
        Uri.parse('$baseUrl/user/sign-up-with-rowad/$otp/$nationalID'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: json.encode({
          'name': name.trim(),
          'email': email.trim(),
          'password': password.trim(),
          'userRole': userRole,
          'phoneNumber': phoneNumber.trim(),
          'nationality': nationality,
          //  'userRole': nationality,
        }));

    if (response.statusCode == 200) {
      final getStorage = GetStorage();

      final String accessToken;
      accessToken = jsonDecode(response.body)['accessToken'];
      final String refreshToken;
      refreshToken = jsonDecode(response.body)['refreshToken'];

      getStorage.write('accessToken', accessToken);
      getStorage.write('refreshToken', refreshToken);
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['message'];
      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

  static Future<bool> createAccountInfo({
    required BuildContext context,
    required String email,
    required String iban,
    required String type,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    if (token != '' && JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/user/account'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'email': email, 'iban': iban, 'accountType': type}),
    );
    log('crearte account');
    log(response.body);
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final getStorage = GetStorage();

      final String accessToken;
      accessToken = jsonDecode(response.body)['accessToken'];
      final String refreshToken;
      refreshToken = jsonDecode(response.body)['refreshToken'];
      // var token = AuthService.jwtForToken(accessToken)!;

      getStorage.write('accessToken', accessToken);
      getStorage.write('refreshToken', refreshToken);
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['message'];
      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

// 5 Login
  static Future<User?> login({
    required String email,
    required String password,
    required bool rememberMe,
    required BuildContext context,
  }) async {
    final response = await http.post(Uri.parse('$baseUrl/user/sign-in'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "email": email.trim(),
          "password": password.trim(),
        }));

    if (response.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response.body);

      String accessToken = user['accessToken'];
      String refreshToken = user['refreshToken'];

      var token = AuthService.jwtForToken(accessToken)!;

      final getStorage = GetStorage();

      if (token.userRole == 'tourist') {
        getStorage.write('accessToken', accessToken);
        getStorage.write('refreshToken', refreshToken);
        getStorage.write('rememberMe', true);
        getStorage.write('userRole', token.userRole);
      }

      return User.fromJson(user);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];

      if (errorMessage == 'email or password is incorrect') {
        if (AppUtil.rtlDirection2(context)) {
          if (context.mounted) {
            AppUtil.errorToast(
                context, 'البريد الإلكتروني أو كلمة المرور غير صحيحة');
          }
        } else {
          if (context.mounted) {
            AppUtil.errorToast(context, errorMessage);
          }
        }
      } else {
        if (context.mounted) {
          AppUtil.errorToast(context, errorMessage);
        }
        return null;
      }
    }
    return null;
  }

  static Future<AjwadiInfo?> checkLicenceAndVehicle(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/local'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': ' Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> ajwadiInfo = jsonDecode(response.body);
      return AjwadiInfo.fromJson(ajwadiInfo);
    } else {
      return null;
    }
  }

  static Token? jwtForToken(String token) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);

    Token tokenJwt = Token.fromJson(payload);
    return tokenJwt;
  }

// 6 Send OTP to email Reset Password
  static Future<Map<dynamic, dynamic>?> sendEmailOTP({
    required String email,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }

    final response = await http.post(Uri.parse('$baseUrl/user/otp/email'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "email": email.trim(),
        }));

    if (response.statusCode == 200) {
      var code = (response.body)[0];
      Map responsBody = {
        'email': jsonDecode(response.body)['email'],
        'otp': jsonDecode(response.body)['otp'],
        'response': response.statusCode,
      };

      return responsBody;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (errorMessage == "replace the email you used with a different one.") {
        AppUtil.errorToast(context, 'ReplaceEmail'.tr);
      } else if (errorMessage == 'Forbidden') {
        AppUtil.errorToast(context, 'otpForbidden'.tr);
      } else if (errorMessage == 'email already exists') {
        AppUtil.errorToast(context, 'emailExists'.tr);
      } else {
        if (context.mounted) {
          AppUtil.errorToast(context, errorMessage);
        }
      }
      return null;
    }
  }

  static Future<Map<dynamic, dynamic>?> sendPasswordOTP({
    required String email,
    required BuildContext context,
  }) async {
    // final getStorage = GetStorage();
    // String token = getStorage.read('accessToken') ?? "";

    // if (JwtDecoder.isExpired(token)) {
    //   final _authController = Get.put(AuthController());

    //   String refreshToken = getStorage.read('refreshToken');
    //   var user = await _authController.refreshToken(
    //       refreshToken: refreshToken, context: context);
    //   token = getStorage.read('accessToken');
    // }
    log(email);

    final response = await http.post(Uri.parse('$baseUrl/user/otp/password'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
        },
        body: json.encode({
          "email": email.toLowerCase(),
        }));
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      Map responsBody = {
        'email': jsonDecode(response.body)['email'],
        'otp': jsonDecode(response.body)['otp'],
        'response': response.statusCode,
      };

      return responsBody;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];

      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }

      return null;
    }
  }

// 7 Reset Password

  static Future<bool> resetPassword({
    required String newPassword,
    required String email,
    required BuildContext context,
  }) async {
    final response = await http.put(Uri.parse('$baseUrl/user/rest/password'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "password": newPassword.trim(),
          "email": email.trim(),
        }));

    if (response.statusCode == 200) {
      // String successMessage = jsonDecode(response.body);
      // if (context.mounted) {
      //   AppUtil.successToast(context, successMessage);
      // }
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }

  static Future<bool> resetEmail({
    required String email,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.put(Uri.parse('$baseUrl/user/rest/email'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "email": email.trim(),
        }));

    if (response.statusCode == 200) {
      // String successMessage = jsonDecode(response.body);
      // if (context.mounted) {
      //   AppUtil.successToast(context, successMessage);
      // }
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }

// 8 Send OTP to phone for driving linces

  static Future<Map<dynamic, dynamic>?> drivingLinceseOTP(
      {required BuildContext context, required String expiryDate}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/rowad/otp/driving-license')
          .replace(queryParameters: {'expiryDate': expiryDate}),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        // "Content-Type": "application/json",
      },
    );

    log("response.statusCode");
    log(response.statusCode.toString());
    log(response.body);

    if (response.statusCode == 200) {
      Map responsBody = {
        'transactionId': jsonDecode(response.body)['transactionId'],
      };
      return responsBody;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['errorDetail']['errorMessage'];
      AppUtil.errorToast(context, errorMessage);
      return null;
    }
  }

// 9 Send OTP to phone for Vichele
  static Future<Map<dynamic, dynamic>?> vehicleOTP({
    required String vehicleSerialNumber,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/rowad/otp/vehicle').replace(queryParameters: {
        'vehicleSerialNumber': vehicleSerialNumber.trim(),
      }),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    log(response.statusCode.toString());
    log(response.body);

    if (response.statusCode == 200) {
      Map responsBody = {
        'transactionId': jsonDecode(response.body)['transactionId'],
      };
      return responsBody;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['errorDetail']['errorMessage'];
      //log(errorMessage.isEmpty.toString());
      AppUtil.errorToast(context, errorMessage);
      return null;
    }
  }

  // 10 get lincese info for ajwadi
  static Future<bool> getAjwadiLinceseInfo({
    required String expiryDate,
    required String otp,
    required String transactionId,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    if (token != '' && JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/local/driving-license/$otp/$transactionId')
          .replace(queryParameters: {
        'otp': otp,
        'transactionId': transactionId,
      }),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': ' Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['error'];
      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

  // 11 get lincese info for ajwadi
  static Future<bool> getAjwadiVehicleInfo({
    required String otp,
    required String transactionId,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    if (token != '' && JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/local/vehicle/$otp/$transactionId')
          .replace(queryParameters: {
        'otp': otp.trim(),
        'transactionId': transactionId,
      }),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': ' Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['error'];
      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

  static Future<bool> logOut() async {
    final getStorage = GetStorage();
    await getStorage.remove('accessToken');
    await getStorage.remove('refreshToken');
    await getStorage.remove('rememberMe');
    await getStorage.remove('userRole');
    await getStorage.remove('userId');

    await getStorage.write('onBoarding', 'yes');

    // Optionally, clear all data
    // await getStorage.erase();
    return true;
  }

// 12 refreshToken
  static Future<User?> refreshToken({
    required String refreshToken,
    required BuildContext context,
  }) async {
    final response = await http.post(Uri.parse('$baseUrl/user/refresh-token'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "refreshToken": refreshToken.trim(),
        }));

    final getStorage = GetStorage();
    if (response.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response.body);

      getStorage.write('accessToken', user['accessToken']);
      getStorage.write('refreshToken', user['refreshToken']);

      return User.fromJson(user);
    } else {
      Get.off(() => const SignInScreen());
      String errorMessage = jsonDecode(response.body)['message'];
      await getStorage.remove('accessToken');
      await getStorage.remove('refreshToken');
      await getStorage.remove('rememberMe');
      await getStorage.remove('userRole');
      await getStorage.remove('userId');
      //  await getStorage.write('onBoarding','yes');

      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  // 13 Delete account ..
  static Future<bool> deleteAccount({
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken');
    late Token jwtToken;
    late String id;

    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      refreshToken = getStorage.read('refreshToken');
      token = getStorage.read('accessToken');
      jwtToken = AuthService.jwtForToken(refreshToken)!;

      id = jwtToken.id;
    } else {
      jwtToken = AuthService.jwtForToken(token)!;

      id = jwtToken.id;
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/user/delete-account'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final getStorage = GetStorage();
      getStorage.remove('accessToken');
      getStorage.remove('refreshToken');
      getStorage.remove('rememberMe');
      getStorage.remove('userRole');
      getStorage.remove('userId');

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> sendVehcileDetails({
    required BuildContext context,
    required String plateletter1,
    required String plateletter2,
    required String plateLetter3,
    required String plateNumber,
    required String vehicleType,
    required String vehicleSerialNumber,
  }) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";
    if (token != '' && JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.post(
        Uri.parse(
          '$baseUrl/user/vehicle',
        ),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': ' Bearer $token'
        },
        body: jsonEncode({
          "plateText1": plateletter1,
          "plateText2": plateletter2,
          "plateText3": plateLetter3,
          "plateNumber": int.parse(plateNumber),
          "vehicleClassDescEn": AppUtil.capitalizeFirstLetter(vehicleType),
          "vehicleSequenceNumber": vehicleSerialNumber,
        }));
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];

      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

  static Future<bool> createOtp(
      {required BuildContext context, required String phoneNumber}) async {
    final response = await http.post(Uri.parse('$baseUrl/otp'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          'mobile': phoneNumber.substring(1),
        }));
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['message'];
      if (errorMessage ==
          'You have requested an OTP too recently. Please wait before trying again.') {
        AppUtil.errorToast(context, 'otpForbidden'.tr);
      } else if (errorMessage == 'mobile number is not found') {
        AppUtil.errorToast(context, 'mobileNotFound'.tr);
      } else {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }

  static Future<bool> localSignInWithOtp(
      {required BuildContext context,
      required String phoneNumber,
      required String otp}) async {
    final response = await http.post(
        Uri.parse('$baseUrl/user/sign-in-with-otp'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          'otp': otp,
          'mobile': phoneNumber.substring(1),
        }));
    log(response.statusCode.toString());
    //log(response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response.body);

      String accessToken = user['accessToken'];
      String refreshToken = user['refreshToken'];

      var token = AuthService.jwtForToken(accessToken)!;

      final getStorage = GetStorage();
      getStorage.write('accessToken', accessToken);
      getStorage.write('refreshToken', refreshToken);
      getStorage.write('rememberMe', true);
      getStorage.write('userRole', token.userRole);
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['message'];
      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

  static Future<AjwadiInfo?> checkLocalInfo(
      {required BuildContext context}) async {
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/local'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': ' Bearer $token'
      },
    );
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> ajwadiInfo = jsonDecode(response.body);
      return AjwadiInfo.fromJson(ajwadiInfo);
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['message'];
      AppUtil.errorToast(context, errorMessage);
      return null;
    }
  }

  static Future<AppVersion?> getAppVersion(
      {required BuildContext context}) async {
    final response = await http.get(
      Uri.parse("$baseUrl/app-version"),
      headers: {
        'Accept': 'application/json',
        // "Content-Type": "application/json"
      },
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      return AppVersion.fromJson(jsonDecode(response.body));
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['message'];
      AppUtil.errorToast(context, errorMessage);
      return null;
    }
  }
}
