import 'package:ajwad_v4/request/chat/model/user_in_chat.dart';
import 'package:ajwad_v4/request/tourist/models/offer_details.dart';

class ChatModel {
  String? id;
  String? status;
  String? language;
  String? localId;
  String? touristId;
  List<ChatMessage>? messages;
  String? created;
  LocalInChat? localInChat;
  TouristInChat? touristInChat;
  Booking? booking;
  String? bookingId;

  ChatModel(
      {this.id,
      this.status,
      this.language,
      this.localId,
      this.touristId,
      this.messages,
      this.created,
      this.localInChat,
      this.touristInChat,
      this.booking,
      this.bookingId,

      
      });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id']??'';
    status = json['status'];
    language = json['language']??'';
    localId = json['localId']??'';
    touristId = json['touristId']??'';
    bookingId = json['bookingId']??'';

    if (json['messages'] != null) {
      messages = <ChatMessage>[];
      json['messages'].forEach((v) {
        messages!.add(ChatMessage.fromJson(v));
      });
    }
    created = json['created'];
    touristInChat = json['tourist'] != null ? TouristInChat.fromJson( json['tourist'] )  : null  ;
    localInChat = json['local'] != null ? LocalInChat.fromJson( json['local'] )  : null  ;
    booking = json['booking'] != null ? Booking.fromJson( json['booking'] )  :   null  ;
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['language'] = language;

    data['localId'] = localId;
    data['local'] = localInChat;
    data['tourist'] = touristInChat;

    data['touristId'] = touristId;
    data['bookingId'] = bookingId;//ne



    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    data['created'] = created;
    data['booking'] = booking;
    data['bookingId'] = bookingId;//new

    return data;
  }
}

class ChatMessage {
  String? id;
  String? senderId;
  String? senderName;
  String? senderImage;
  String? message;
  String? status;
  bool? isRead;
  bool? isUpdate;
  String? created;
  String? updated;

  ChatMessage(
      {this.id,
      this.senderId,
      this.senderName,
      this.senderImage,
      this.message,
      this.status,
      this.isRead,
      this.isUpdate,
      this.created,
      this.updated});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    senderImage = json['senderImage'];
    message = json['message'];
    status = json['status'];
    isRead = json['isRead'];
    isUpdate = json['isUpdate'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['senderId'] = senderId;
    data['senderName'] = senderName;
    data['senderImage'] = senderImage;
    data['message'] = message;
    data['status'] = status;
    data['isRead'] = isRead;
    data['isUpdate'] = isUpdate;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}


class PlaceInChat {
    final String? nameAr;
  final String? nameEn;

  PlaceInChat({required this.nameAr, required this.nameEn});

  factory PlaceInChat.fromJson(Map<String, dynamic> json) {
    return PlaceInChat(
    
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    
    );
  }
}