import 'dart:developer';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:ajwad_v4/request/chat/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChatController extends GetxController {
  /* ?
            ? getChatList 
  */

  var isGetChatListLoading = false.obs;
  var chatList = <ChatModel>[].obs;

  Future<List<ChatModel>?> getChatList({required BuildContext context}) async {
    try {
      isGetChatListLoading(true);
      final data = await ChatService.getChatList(context: context);
      chatList(data);
      return chatList;
    } catch (e) {
      log(e.toString());
      return null;
    } finally {
      isGetChatListLoading(false);
    }
  }

  /* ?
            ? getChatById 
  */

  var isGetChatByIdLoading = false.obs;
  var chat = ChatModel();

  Future<ChatModel?> getChatById(
      {required String id, required BuildContext context}) async {
    try {
      isGetChatByIdLoading(true);
      final data = await ChatService.getChatById(id: id, context: context);
      chat= data!;
      print("this booking id in chat controller");
      //print(chat.bookingId);

      return chat;
    } catch (e) {
      log(e.toString());
      return null;
    } finally {
      isGetChatByIdLoading(false);
    }
  }
  
  
  // var isGetBookByIdLoading = false.obs;
  // var book = Booking().obs;

  // Future<Booking?> getBookById(
  //     {required String id, required BuildContext context}) async {
  //   try {
  //     isGetChatByIdLoading(true);
  //     final data =  await TouristExploreService.getTouristBookingById(bookingId: id, context: context);
  //     book(data);
  //     return book.value;
  //   } catch (e) {
  //     log(e.toString());
  //     return null;
  //   } finally {
  //     isGetBookByIdLoading(false);
  //   }
  // }
  


  
  //  ========= ======= =========
  //? ====== Try Stream ======
  // =======  ======= =========

  ScrollController scrollController = ScrollController();

  Stream<ChatModel?> getChatByIdStream(
      {required String id, required BuildContext context}) async* {
    try {
      // await Future.delayed(const Duration(seconds: 10));

      // isGetChatByIdLoading(true);
      // if (context.mounted) {
      //   final data = await ChatService.getChatById(id: id, context: context);
      //   chat(data);
      //   log("\n First \n ");
      //   log(" chat(data)  $data");
      //   yield chat.value;
      // }
      // isGetChatByIdLoading(false);
      while (true) {
        await Future.delayed(const Duration(seconds: 10));

        // isGetChatByIdLoading(true);
        if (context.mounted) {
          final data = await ChatService.getChatById(id: id, context: context);

          bool sameData =
              data?.messages?.last.id == chat.messages?.last.id;
          if (sameData) {
            chat=data!;
            log("\n First \n ");
            log(" chat(data)  $data");
          } else {
            chat=data!;
            log("\n First \n ");
            log(" chat(data)  $data");
            if (chat.messages!.length > 2) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent * 1.4);
            }
          }
        }
        // isGetChatByIdLoading(false);

        yield chat;
      }
      // isGetChatByIdLoading(true);
      // final data = await ChatService.getChatById(id: id, context: context);
      // chat(data);
      // isGetChatByIdLoading(false);
      // log("\n First \n ");
      // log(" chat(data)  $data");
      // yield chat.value;

      // int timees = 0;

      // Stream.periodic(const Duration(seconds: 10), (_) async* {
      //   timees++;
      //   log("\n timees $timees \n ");
      //   isGetChatByIdLoading(true);
      //   final data = await ChatService.getChatById(id: id, context: context);
      //   chat(data);
      //   log(" chat(data)  $data");
      //   isGetChatByIdLoading(false);
      //   yield chat.value;
      // });
    } catch (e) {
      log(e.toString());
      yield null;
    } finally {
      isGetChatByIdLoading(false);
    }
  }

  /* ?
            ? post-Message 
  */

  var isPostMessageLoading = false.obs;
  RxBool isPostMessage = false.obs;

  Future<bool?> postMessage(
      {required String chatId,
      required String message,
      required BuildContext context}) async {
    try {
      isPostMessageLoading(true);
      final data = await ChatService.postMessage(
          chatId: chatId, message: message, context: context);
      isPostMessage.value = data ?? false;
      return isPostMessage.value;
    } catch (e) {
      log(e.toString());
      isPostMessage.value = false;
      return null;
    } finally {
      isPostMessageLoading(false);
    }
  }
}
