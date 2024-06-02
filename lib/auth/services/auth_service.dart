import 'dart:convert';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/ajwadi_info.dart';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/auth/view/sigin_in/signin_screen.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/utils/app_util.dart';
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

    print('NATIONALITIES');
    print(response.statusCode);
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)['nationalities']);
      final data = jsonDecode(response.body);
      var listCountries = (data as List).map((item) => item as String).toList();

      return listCountries;
    } else {
      var errorMessage = jsonDecode(response.body)['error'];
      AppUtil.errorToast(context, errorMessage);
      print(errorMessage);
      return null;
    }
  }
// static Future<void> checkToken(BuildContext context) async {
//     print("jwtToken");
//     final getStorage = GetStorage();
//     String token = getStorage.read('accessToken');
//     late Token jwtToken;
//     late String id;
//     print('isExpired');
//     print(JwtDecoder.isExpired(token));
//     if (JwtDecoder.isExpired(token)) {
//       final authController = Get.put(AuthController());

//       String refreshToken = getStorage.read('refreshToken');
//       var user = await authController.refreshToken(
//           refreshToken: refreshToken, context: context);
//       refreshToken = getStorage.read('refreshToken');
//       token = getStorage.read('accessToken');
//       jwtToken = AuthService.jwtForToken(refreshToken)!;
//       print(jwtToken.id);
//       id = jwtToken.id;
//     } else {
//       jwtToken = AuthService.jwtForToken(token)!;
//       print('jwtToken.id AuthService AuthService${jwtToken.id}');

//       id = jwtToken.id;
//     }
//   }
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
          "phoneNumber": phoneNumber.trim(),
          "nationality": nationality,
        }));

    print("response.statusCode");
    print(response.statusCode);
    print("response.body");
    print(response.body);

    if (response.statusCode == 200) {
      final getStorage = GetStorage();

      final String accessToken;
      accessToken = jsonDecode(response.body)['accessToken'];
      final String refreshToken;
      refreshToken = jsonDecode(response.body)['refreshToken'];
      var token = AuthService.jwtForToken(accessToken)!;

      if (rememberMe) {
        getStorage.write('accessToken', accessToken);
        getStorage.write('refreshToken', refreshToken);
        getStorage.write('rememberMe', rememberMe);
        getStorage.write('userRole', token.userRole);
      } else {
        getStorage.remove('token');
      }

      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      print(errorMessage);
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }

  // 3 GET OTP by id and birth date ..
  static Future<bool> personInfoOTP({
    required String nationalID,
    required String birthDate,
    required BuildContext context,
  }) async {
    final response = await http.post(
        Uri.parse('$baseUrl/rowad/otp/person-info').replace(queryParameters: {
          'birthDate': birthDate.trim(),
          'personId': nationalID.trim(),
        }),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: json.encode({
          'birthDate': birthDate.trim(),
          'personId': nationalID.trim(),
        }));

    print("response.statusCode");
    print(response.statusCode);
    print(response.body);

    print("isSuccess SERVICE ${response.statusCode}");

    if (response.statusCode == 200) {
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['message'];
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
    print("name $name");
    print("nationalID $nationalID");
    print("otp $otp");
    print("password $password");
    print("phoneNumber $phoneNumber");
    print("userRole $userRole");

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

    print("response.statusCode");
    print(response.statusCode);
    print("response.body");
    print(response.body);

    var error = jsonDecode(response.body);
    var error2 = error['error'];
    print(error2);

    print("isSuccess SERVICE ${response.statusCode}");

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

// 5 Login
  static Future<User?> login({
    required String email,
    required String password,
    required bool rememberMe,
    required BuildContext context,
  }) async {
    print("rememberMe $rememberMe");
    final response = await http.post(Uri.parse('$baseUrl/user/sign-in'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "email": email.trim(),
          "password": password.trim(),
        }));

    print("response.statusCode");
    print(response.statusCode);
    print("response.body");
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response.body);
      print('token userRole ');
      String accessToken = user['accessToken'];
      String refreshToken = user['refreshToken'];

      var token = AuthService.jwtForToken(accessToken)!;

      print('token userRole ${token.userRole}');

      final getStorage = GetStorage();

      // print('rememberMe : ${getStorage.read('rememberMe')}');

      if (rememberMe) {
        getStorage.write('accessToken', accessToken);
        getStorage.write('refreshToken', refreshToken);
        getStorage.write('rememberMe', rememberMe);
        getStorage.write('userRole', token.userRole);
      } else {
        getStorage.remove('token');
      }
      //change guest

      return User.fromJson(user);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
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
    print("response.statusCode");
    print(response.statusCode);
    print("body checkLicenceAndVehicle");
    print(response.body);

    print("isSuccess SERVICE ${response.statusCode}");

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
      final _authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await _authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    print(email);
    final response = await http.post(Uri.parse('$baseUrl/user/otp/email'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "email": email.trim(),
        }));

    print("response.statusCode");
    print(response.statusCode);

    print("response.body");
    print(response.body);

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
      print(errorMessage);
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
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken') ?? "";

    if (JwtDecoder.isExpired(token)) {
      final _authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await _authController.refreshToken(
          refreshToken: refreshToken, context: context);
      token = getStorage.read('accessToken');
    }
    final response = await http.put(Uri.parse('$baseUrl/user/rest/password'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "password": newPassword.trim(),
          "email": email.trim(),
        }));

    print("response.statusCode");
    print(response.statusCode);

    print("response.body");
    print(response.body);

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
      final _authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await _authController.refreshToken(
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

    print("response.statusCode");
    print(response.statusCode);

    print("response.body");
    print(response.body);

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

  static Future<bool> drivingLinceseOTP({
    required String nationalID,
    required String birthDate,
    required BuildContext context,
  }) async {
    print(birthDate);
    print(nationalID);

    final response = await http.post(
        Uri.parse('$baseUrl/rowad/otp/driving-license')
            .replace(queryParameters: {
          'birthDate': birthDate.trim(),
          'personId': nationalID.trim(),
        }),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
        },
        body: json.encode({
          'birthDate': birthDate.trim(),
          'personId': nationalID.trim(),
        }));

    print("response.statusCode");
    print(response.statusCode);
    print(response.body);

    print("isSuccess SERVICE ${response.statusCode}");

    if (response.statusCode == 200) {
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['message'];
      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

// 9 Send OTP to phone for Vichele
  static Future<bool> vehicleOTP({
    required String nationalID,
    required String vehicleSerialNumber,
    required BuildContext context,
  }) async {
    final response = await http.post(
        Uri.parse('$baseUrl/rowad/otp/vehicle').replace(queryParameters: {
          'vehicleSerialNumber': vehicleSerialNumber.trim(),
          'personId': nationalID.trim(),
        }),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json"
        },
        body: json.encode({
          'vehicleSerialNumber': vehicleSerialNumber.trim(),
          'personId': nationalID.trim(),
        }));

    print("response.statusCode");
    print(response.statusCode);
    print(response.body);

    print("isSuccess SERVICE ${response.statusCode}");

    if (response.statusCode == 200) {
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['error'];
      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

  // 10 get lincese info for ajwadi
  static Future<bool> getAjwadiLinceseInfo({
    required String nationalID,
    required String expiryDate,
    required String otp,
    required String accessToken,
    required BuildContext context,
  }) async {
    print("SERVICE ACSEESS TOKEN : $accessToken");

    print(expiryDate);
    print(otp);
    print(nationalID);

    final response = await http.get(
      Uri.parse('$baseUrl/local/driving-license/$otp/$nationalID/$expiryDate')
          .replace(queryParameters: {
        'otp': otp.trim(),
        'personId': nationalID.trim(),
        'expiryDate': expiryDate,
      }),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': ' Bearer $accessToken'
      },
    );

    print("response.statusCode");
    print(response.statusCode);
    print(response.body);

    print("isSuccess SERVICE ${response.statusCode}");

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
    required String nationalID,
    required String otp,
    required String accessToken,
    required BuildContext context,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/local/vehicle/$otp/$nationalID')
          .replace(queryParameters: {
        'otp': otp.trim(),
        'personId': nationalID.trim(),
      }),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': ' Bearer $accessToken'
      },
    );

    print("response.statusCode");
    print(response.statusCode);
    print(response.body);

    print("isSuccess SERVICE ${response.statusCode}");

    if (response.statusCode == 200) {
      return true;
    } else {
      var jsonBody = jsonDecode(response.body);
      String errorMessage = jsonBody['error'];
      AppUtil.errorToast(context, errorMessage);
      return false;
    }
  }

  static bool logOut() {
    final getStorage = GetStorage();
    getStorage.remove('accessToken');
    getStorage.remove('refreshToken');
    getStorage.remove('rememberMe');
    getStorage.remove('userRole');
    getStorage.remove('userId');

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
      getStorage.remove('accessToken');
      getStorage.remove('refreshToken');
      getStorage.remove('rememberMe');
      getStorage.remove('userRole');
      getStorage.remove('userId');

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
    print('isExpired');
    print(JwtDecoder.isExpired(token));
    if (JwtDecoder.isExpired(token)) {
      final authController = Get.put(AuthController());

      String refreshToken = getStorage.read('refreshToken');
      var user = await authController.refreshToken(
          refreshToken: refreshToken, context: context);
      refreshToken = getStorage.read('refreshToken');
      token = getStorage.read('accessToken');
      jwtToken = AuthService.jwtForToken(refreshToken)!;
      print(jwtToken.id);
      id = jwtToken.id;
    } else {
      jwtToken = AuthService.jwtForToken(token)!;
      print('jwtToken.id AuthService AuthService${jwtToken.id}');

      id = jwtToken.id;
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/user/delete-account'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("response.statusCode");
    print(response.statusCode);
    print("Deletion");
    print("response.body");
    print(response.body);

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
}
