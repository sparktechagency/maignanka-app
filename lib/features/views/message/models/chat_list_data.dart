class ChatListData {
  String? chatId;
  Receiver? receiver;
  LastMessage? lastMessage;
  int? unreadCount;
  BlockBy? blockBy;

  ChatListData(
      {this.chatId,
        this.receiver,
        this.lastMessage,
        this.unreadCount,
        this.blockBy});

  ChatListData.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    receiver = json['receiver'] != null
        ? new Receiver.fromJson(json['receiver'])
        : null;
    lastMessage = json['lastMessage'] != null
        ? new LastMessage.fromJson(json['lastMessage'])
        : null;
    unreadCount = json['unreadCount'];
    blockBy =
    json['blockBy'] != null ? new BlockBy.fromJson(json['blockBy']) : null;
  }

}

class Receiver {
  String? id;
  String? name;
  String? email;
  String? image;
  String? status;
  String? lastActive;

  Receiver(
      {this.id,
        this.name,
        this.email,
        this.image,
        this.status,
        this.lastActive});

  Receiver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    status = json['status'];
    lastActive = json['lastActive'];
  }


  Receiver copyWith({String? status,String? name, String ? id }){
    return Receiver(
      status: status,
      name: name,
      id: id
    );
  }

}


class BlockBy {
  String? id;
  String? name;

  BlockBy({this.id, this.name});

  BlockBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  BlockBy copyWith({String? id,String? name}){
    return BlockBy(
      id: id,
      name: name,
    );
  }
}




class LastMessage {
  String? message;
  List<ChatFile>? files;
  String? messageType;
  String? createdAt;

  LastMessage({this.message, this.files, this.messageType, this.createdAt});

  LastMessage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['files'] != null) {
      files = <ChatFile>[];
      json['files'].forEach((v) {
        files!.add(ChatFile.fromJson(v));
      });
    }
    messageType = json['messageType'];
    createdAt = json['createdAt'];
  }
}

class ChatFile {
  String? url;
  String? type;

  ChatFile({this.url, this.type});

  ChatFile.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
  }
}




