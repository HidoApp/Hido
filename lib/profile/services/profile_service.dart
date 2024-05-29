import 'dart:convert';
import 'dart:io';
import 'dart:developer'; //(auto import will do this even)

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';

import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileService {
  static Future<Profile?> getProfile(
      {required BuildContext context, String profileId = ""}) async {
    print("jwtToken");
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
    log("ID :" + id);
    log("Profile :" + profileId);
    if (profileId != "") {
      id = profileId;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/profile/$id'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print("response.statusCode Profile ");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var profile = jsonDecode(response.body);
      print(profile);
      return Profile.fromJson(profile);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<UploadImage?> uploadProfileImages(
      {required File file,
      required String uploadOrUpdate,
      required BuildContext context}) async {
    final getStorage = GetStorage();
    String? token = getStorage.read('accessToken');

    if (JwtDecoder.isExpired(token!)) {
      final String refreshToken = getStorage.read('refreshToken');
      var user = await AuthService.refreshToken(
          refreshToken: refreshToken, context: context);
      token = user!.accessToken;
    }
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/asset/$uploadOrUpdate/profile'));
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    http.StreamedResponse response = await request.send();

    late String id, filePath, publicId;
    if (response.statusCode == 200) {
      UploadImage imageIbject;
      var jsonImage;
      print('Image uploaded successfully');
      print(response.stream);

      await response.stream.transform(utf8.decoder).listen((value) {
        id = UploadImage.fromJson(jsonDecode(value)).id;
        filePath = UploadImage.fromJson(jsonDecode(value)).filePath;
        if (UploadImage.fromJson(jsonDecode(value)).publicId != null) {
          publicId = UploadImage.fromJson(jsonDecode(value)).publicId!;
        } else {
          publicId = '';
        }
      });

      return UploadImage(id: id, filePath: filePath, publicId: publicId);
    } else {
      print('Image upload failed with status code: ${response.statusCode}');

      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
    return null;
  }

  static Future<Profile?> editProfile({
    String? name,
    String? profileImage,
    String? descripttion,
    String? phone,
    List<String>? spokenLanguage,
    required BuildContext context,
  }) async {
    print(" Update profile ");
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.put(Uri.parse('$baseUrl/profile'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          if (name != null) "name": name.trim(),
          "image": profileImage,
          if (descripttion != null) "descriptionAboutMe": descripttion.trim(),
          "userInterest": ["string"],
          
          if (spokenLanguage != null) "spokenLanguage": spokenLanguage,
        
          if (phone != null) "phoneNumber": phone.trim(),  "gender": "MALE",
        }));

    print("response.statusCode Update profile ");
    print(response.statusCode);
    if (response.statusCode == 200) {
      var profile = jsonDecode(response.body);
      print(profile);
      return Profile.fromJson(profile);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<List<Booking>?> getUserTicket({
    required String bookingType,
    required BuildContext context,
  }) async {
    print(" getUpcomingTicket ");
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');
    print(token);

    final response = await http.get(
      Uri.parse('$baseUrl/booking').replace(queryParameters: {
        'bookingType': bookingType,
      }),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print("response.statusCode Update profile ");
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      log('data: $data');
      return data.map((booking) => Booking.fromJson(booking)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  static Future<List<ChatModel>?> getUserChats({
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');
    print(token);

    final response = await http.get(
      Uri.parse('$baseUrl/chat'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print("response.statusCode Update profile ");
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print(inspect(data));
      return data.map((chat) => ChatModel.fromJson(chat)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }
}
