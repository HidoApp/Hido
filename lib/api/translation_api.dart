// import 'dart:convert';

import 'dart:convert';

import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
// import 'package:translator/translator.dart';

class TranslationApi {
  static final isTranslatingLoading = false.obs;

  static final _apiKey = 'AIzaSyBPAGWbMI0uvCzhDK1uU-69L4Bl1EDBUjQ';

  static Future<String> translate(String message, String toLanguageCode) async {
    try {
      isTranslatingLoading.value = true;

      final url = Uri.parse(
        'https://translation.googleapis.com/language/translate/v2?target=$toLanguageCode&key=$_apiKey&q=${Uri.encodeComponent(message)}',
      );

      final response = await http.post(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final translations = body['data']['translations'] as List;
        final translation = translations.first;

        return HtmlUnescape().convert(translation['translatedText']);
      } else {
        throw Exception();
      }
    } finally {
      isTranslatingLoading.value = false;
    }
    // }

    // static Future<String> translate2(
    //     String message, String fromLanguageCode, String toLanguageCode) async {
    //   final translation = await GoogleTranslator().translate(
    //     message,
    //     from: fromLanguageCode,
    //     to: toLanguageCode,
    //   );

    //   return translation.text;
  }
}
