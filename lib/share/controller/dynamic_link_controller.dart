import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DynamicLinkController extends GetxController {
  final Rx<Map<String, dynamic>> dynamicLinkData = Rx<Map<String, dynamic>>({});

  Future<String> createDynamicLink({
    required String id,
    required String type,
    required String validTo,
    String? title,
    String? description,
    String? image,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dynamic-link'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'dynamicParams': {'id': id, 'type': type},
          'title': title,
          'description': description,
          'image': image,
          "validTo": validTo
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['shortLink'];
      }
      throw Exception('Failed to create dynamic link');
    } catch (e) {
      print('Error creating Dynamic link: $e');
      rethrow;
    }
  }

  void handleDynamicLink(Map data) {
    print('Received dynamic link data: $data');

    if (data.containsKey('type') && data.containsKey('id')) {
      final String? type = data['type']?.toString();
      final String? id = data['id']?.toString();

      if (type != null && id != null) {
        switch (type) {
          case 'hospitality':
            Get.to(() => HospitalityDetails(hospitalityId: id));
            break;
          default:
            print('Unknown type: $type');
        }
      } else {
        print('Invalid data values: $data');
      }
    } else {
      print('Missing keys in data: $data');
    }
  }

  @override
  void dispose() {
    super.dispose();
    dynamicLinkData.close();
  }

  @override
  void onInit() {
    super.onInit();
  }
}
