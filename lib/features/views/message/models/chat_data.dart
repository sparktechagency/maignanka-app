class ChatData {
  String? sId;
  String? chatId;
  String? senderId;
  String? receiverId;
  List<String>? seenList;
  String? message;
  String? messageType;
  String? messageStatus;
  List<Files>? files;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isSender;

  ChatData(
      {this.sId,
        this.chatId,
        this.senderId,
        this.receiverId,
        this.seenList,
        this.message,
        this.messageType,
        this.messageStatus,
        this.files,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.isSender});

  ChatData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chatId = json['chatId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    seenList = json['seenList'].cast<String>();
    message = json['message'];
    messageType = json['messageType'];
    messageStatus = json['messageStatus'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isSender = json['isSender'];
  }

}


class Files {
  String? publicFileURL;
  String? path;
  String? sId;

  Files({this.publicFileURL, this.path, this.sId});

  Files.fromJson(Map<String, dynamic> json) {
    publicFileURL = json['publicFileURL'];
    path = json['path'];
    sId = json['_id'];
  }
}
