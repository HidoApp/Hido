import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/constants/trip_options.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/trip_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/model/last_activity.dart';
import 'package:ajwad_v4/explore/ajwadi/model/local_trip.dart';
import 'package:ajwad_v4/explore/ajwadi/model/trip.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../services/model/experiences.dart';

class TripService {
   static final _tripController = Get.put(TripController());

  static Future<UploadImage?> uploadImages(
      {required File file,
      required String fileType,
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
        'POST', Uri.parse('$baseUrl/asset/upload/$fileType'));
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    http.StreamedResponse response = await request.send();

    late String id, filePath, publicId;
    if (response.statusCode == 200) {
      UploadImage imageIbject;
      //  AppUtil.successToast(context, 'Image uploaded successfully');
      var jsonImage;
      print('Image uploaded successfully');

      await response.stream.transform(utf8.decoder).listen((value) {
        id = UploadImage.fromJson(jsonDecode(value)).id;
        filePath = UploadImage.fromJson(jsonDecode(value)).filePath;
        if (UploadImage.fromJson(jsonDecode(value)).publicId != null)
          publicId = UploadImage.fromJson(jsonDecode(value)).publicId!;
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

  static Future<dynamic> addTrip({
    required String tripOption,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String price,
    required String date,
    required String lat,
    required String lang,
    required List<UploadImage> imag,
    // required String tripOption,

    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    print('SERVICE');
    List imageJson = [];

    imag.forEach((element) async {
      print(jsonEncode(element.toJson()));
      imageJson.add(jsonEncode(element.toJson()));
    });

    print(imageJson.length);

    final response = await http.post(
      Uri.parse('$baseUrl/trip'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        //
      },
      // body: jsonEncode({
      //   'tripOption': tripOption,
      //   'nameAr': nameAr,
      //   'nameEn':nameEn,
      //   'descriptionAr': descriptionAr,
      //   'descriptionEn': descriptionEn,
      //   'price': 10,
      //   'date': date,
      //   'coordinates': [
      //     {'longitude': lat},
      //     {'latitude': lang}
      //   ],
      //   'image': [
      //     {'filePath': imag.filePath},
      //     {'publicId': imag.publicId},
      //    {'id': imag.id}
      //   ],
      // }),

      body: jsonEncode({
        'tripOption': 'adventures',
        'nameAr': nameAr,
        'nameEn': nameEn,
        'descriptionAr': descriptionAr,
        'descriptionEn': descriptionEn,
        'price': price,
        'date': [date],
        'coordinates': {'longitude': lat, 'latitude': lang},
        'image': [
          for (int i = 0; imag.length < i; i++) {jsonEncode(imag[i].toJson())}
        ]
      }),
    );
    print("response.statusCode adding trip ");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print(true);
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return false;
    }
  }

  static Future<Trip?> getAllTrips({
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    final String? token = getStorage.read('token');
    print(token);
    final response = await http.get(
      Uri.parse('$baseUrl/get/all/trips'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("response.statusCode");
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> trip =
          jsonDecode(response.body)['profile'][0][TripOption];
      print(trip);
      return Trip.fromJson(trip);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }
static Future<List<Experience>?> getAllExperiences(
      {required BuildContext context}) async {
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
      Uri.parse('$baseUrl/experiences'),
        
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );

    print(jsonDecode(response.body).length);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print(inspect(data));
      return data.map((experience) => Experience.fromJson(experience)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }
  

  static Future<Trip?> getTripById({
    required String tripId,
    required BuildContext context,
  }) async {
    final getStorage = GetStorage();
    final String? token = getStorage.read('token');
    print(token);
    final response = await http.get(
      Uri.parse('$baseUrl/get/trip/$tripId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("response.statusCode");
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> trip =
          jsonDecode(response.body)['profile'][0][TripOption];
      print(trip);
      return Trip.fromJson(trip);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }
  static Future<List<LocalTrip>?> getUserTicket({
    required String tourType,
    required BuildContext context,
  }) async {
    print(" getUpcomingTicket ");
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');
    print(token);

    final response = await http.get(
      Uri.parse('$baseUrl/trip/local').replace(queryParameters: {
        'tourType': tourType,
      }),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print("response.statusCode  ");
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      log('data: $data');
      print(data.length);
      print(data.isEmpty);
      return data.map((hospitality) => LocalTrip.fromJson(hospitality)).toList();
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

   static Future<NextActivity?> getNextActivity({
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
      Uri.parse('$baseUrl/last-activity'),
        
      headers: {
        'Accept': 'application/json',
        if (token != '') 'Authorization': 'Bearer $token',
      },
    );

    print("response.statusCode Trip ");
    print(response.statusCode);
    print(response.body.isNotEmpty);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      
      var trip = jsonDecode(response.body);
      _tripController.isTripUpdated(true);
      log("condition");
      log('${response.statusCode == 200 && response.body.isNotEmpty}');
      log('${  _tripController.isTripUpdated.value}');

      return NextActivity.fromJson(trip);

    } else {
      _tripController.isTripUpdated(false);
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
     _tripController.isTripUpdated(false);
      return null;
    }
  }
  static Future<NextActivity?> updateActivity({
  required String id,
  required BuildContext context,
  }) async {
    print(" Update activity progress ");
    final getStorage = GetStorage();
    final String? token = getStorage.read('accessToken');

    final response = await http.put(Uri.parse('$baseUrl/activity-progress/$id')
          .replace(queryParameters: ({'id': id})),
    
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
    );
   print("response.statusCode Activity-progress ");

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200  && response.body.isNotEmpty) {
      var trip = jsonDecode(response.body);
     _tripController.isTripUpdated(true);

      return NextActivity.fromJson(trip);

    } else {
     _tripController.isTripUpdated(false);

      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }
}
