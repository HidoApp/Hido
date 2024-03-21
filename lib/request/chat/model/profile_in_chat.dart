class ProfileInChat {
  String? name;
  String? image;
  

  ProfileInChat(
      {this.name,
      this.image,
    });

  ProfileInChat.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
   
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
  
    return data;
  }
}


