import 'dart:convert';
import 'dart:developer';
import 'package:ajwad_v4/auth/models/token.dart';
import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/constants/base_url.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class ChatService {
  /* ?
            ? GetChatList
  */

  static Future<List<ChatModel>?> getChatList(
      {required BuildContext context}) async {
    log("jwtToken");
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken');
    log('isExpired');
    log(JwtDecoder.isExpired(token).toString());
    if (JwtDecoder.isExpired(token)) {
      String refreshToken = getStorage.read('refreshToken');
      User? user = await AuthService.refreshToken(
          refreshToken: refreshToken, context: context);
      if (user != null) {
        final Token jwtToken = AuthService.jwtForToken(user.refreshToken)!;
        log(jwtToken.id);
        token = jwtToken.id;
      }
    }

    final response = await http.get(
      Uri.parse('$baseUrl/chat'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    log("response.statusCode");
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      String body = response.body.toString();
      log("body $body");
      // var chatList = jsonDecode(body);
      // log(chatList);
      return [];
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  /* ?
            ? getChatById
  */

  static Future<ChatModel?> getChatById(
      {required String id, required BuildContext context}) async {
    log("jwtToken");
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken');
    log('isExpired');
    log(JwtDecoder.isExpired(token).toString());
    if (JwtDecoder.isExpired(token)) {
      String refreshToken = getStorage.read('refreshToken');
      User? user = await AuthService.refreshToken(
          refreshToken: refreshToken, context: context);
      if (user != null) {
        final Token jwtToken = AuthService.jwtForToken(user.refreshToken)!;
        log(jwtToken.id);
        token = jwtToken.id;
      }
    }

    final response = await http.get(
      Uri.parse('$baseUrl/chat/$id'),
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    log("response.statusCode");
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log("response.body ${response.body}");
      var chat = jsonDecode(response.body);
      log("chat \n $chat");
      ChatModel chatModel = ChatModel.fromJson(chat);
      // log(chatModel.messages![0].toString());
      return chatModel;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }

  /* ?
            ? Post-Message
  */

  static Future<bool?> postMessage({
    required String chatId,
    required String message,
    required BuildContext context,
  }) async {
    log("jwtToken");
    final getStorage = GetStorage();
    String token = getStorage.read('accessToken');
    log('isExpired');
    log(JwtDecoder.isExpired(token).toString());
    if (JwtDecoder.isExpired(token)) {
      String refreshToken = getStorage.read('refreshToken');
      User? user = await AuthService.refreshToken(
          refreshToken: refreshToken, context: context);
      if (user != null) {
        final Token jwtToken = AuthService.jwtForToken(user.refreshToken)!;
        log(jwtToken.id);
        token = jwtToken.id;
      }
    }
    final response = await http.post(Uri.parse('$baseUrl/chat/$chatId/message'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"message": message}));

    log("response.statusCode");
    log(response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      log(data.toString());
      return true;
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      log("Error Message Post Message $errorMessage");
      if (context.mounted) {
        AppUtil.errorToast(context, errorMessage);
      }
      return null;
    }
  }
}
