import 'dart:developer';

import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/explore/tourist/view/trip_details.dart';
import 'package:ajwad_v4/services/view/adveture_details.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/services/view/local_event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';

class DynamicLinkController extends GetxController {
  final Rx<Map<String, dynamic>> dynamicLinkData = Rx<Map<String, dynamic>>({});
  var isCreateLinkLoading = false.obs;
  Future<String> createDynamicLink({
    required String id,
    required String type,
    required String validTo,
    required BuildContext context,
    String? title,
    String? description,
    String? image,
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
    try {
      isCreateLinkLoading(true);
      final response = await http.post(
        Uri.parse('$baseUrl/dynamic-link'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'dynamicParams': {'id': id, 'type': type},
          'title': title,
          'description': description,
          'image': image,
          "validTo": validTo
        }),
      );
      log(response.statusCode.toString());
      //log(response.body.toString());
      isCreateLinkLoading(false);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['shortLink'];
      }
      throw Exception('Failed to create dynamic link');
    } catch (e) {
      isCreateLinkLoading(false);
      print('Error creating Dynamic link: $e');
      rethrow;
    }
  }

  void handleDynamicLink(Map data) {

    if (data.containsKey('type') && data.containsKey('id')) {
      final String? type = data['type']?.toString();
      final String? id = data['id']?.toString();
      final userRole = GetStorage().read('userRole') ?? 'tourist';

      if (type != null && id != null) {
        switch (type) {
          case 'hospitality':
            if (userRole == 'local') {
              Get.to(
                  () => HospitalityDetails(hospitalityId: id, isLocal: true));
            } else {
              Get.to(() => HospitalityDetails(hospitalityId: id));
            }
            break;
          case 'event':
            if (userRole == 'local') {
              Get.to(() => LocalEventDetails(eventId: id, isLocal: true));
            } else {
              Get.to(() => LocalEventDetails(eventId: id));
            }
            break;
          case 'activity':
            if (userRole == 'local') {
              Get.to(() => AdventureDetails(adventureId: id, isLocal: true));
            } else {
              Get.to(() => AdventureDetails(adventureId: id));
            }
            break;
          case 'place':
            if (userRole != 'local') {
              Get.to(
                () => TripDetails(
                  placeId: id,
                  fromAjwady: false,
                ),
              );
            }
            break;
          default:
            log('Unknown type: $type');
        }
      } else {
        log('Invalid data values: $data');
      }
    } else {
      log('Missing keys in data: $data');
    }
  }

  @override
  void dispose() {
    super.dispose();
    dynamicLinkData.close();
  }
}
