
class ChatModelData {
  String? sId;
  String? senderID;
  String? receiverID;
  String? conversationID;
  String? content;
  List<File>? file;
  String? messageType;
  List<String>? seenBy;
  String? createdAt;
  String? profilePicture;
  bool? isBlocked;
  String? isBlockedBy;

  ChatModelData({
    this.sId,
    this.senderID,
    this.receiverID,
    this.conversationID,
    this.content,
    this.file,
    this.messageType,
    this.seenBy,
    this.createdAt,
    this.profilePicture,
    this.isBlocked,
    this.isBlockedBy,
  });

  ChatModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderID = json['senderID'];
    receiverID = json['receiverID'];
    conversationID = json['conversationID'];
    content = json['content'];
    if (json['file'] != null) {
      file = <File>[];
      json['file'].forEach((v) {
        file!.add(new File.fromJson(v));
      });
    }
    messageType = json['messageType'];
    seenBy = json['seenBy'].cast<String>();
    createdAt = json['createdAt'];
    profilePicture = json['profilePicture'];
    isBlocked = json['isBlocked'];
    isBlockedBy = json['isBlockedBy'];
  }
}

class File {
  String? url;
  String? type;

  File({this.url, this.type});

  File.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
  }
}

class Receiver {
  String? sId;
  String? name;
  String? profilePicture;

  Receiver({this.sId, this.name, this.profilePicture});

  Receiver.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profilePicture = json['profilePicture'];
  }
}
