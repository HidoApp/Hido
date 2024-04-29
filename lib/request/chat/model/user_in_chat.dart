import 'package:ajwad_v4/request/chat/model/profile_in_chat.dart';

class TouristInChat {
  String? id;
  ProfileInChat? profileInChat;

  TouristInChat(
      {
        this.id,
        this.profileInChat,
     });

  TouristInChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileInChat = json['profile'] == null ? null : ProfileInChat.fromJson(json['profile']);
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['profile'] = profileInChat;
    return data;
  }
}



class LocalInChat {
  String? id;
  ProfileInChat? profileInChat;

  LocalInChat(
      {
        this.id,
        this.profileInChat,
     });

  LocalInChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileInChat = json['profile'] == null ? null : ProfileInChat.fromJson(json['profile']);
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['profile'] = profileInChat;
    return data;
  }
}

