class WalletModelData {
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  SendBy? sendBy;
  SendBy? receivedBy;
  GiftInfo? giftInfo;
  bool? send;
  bool? received;

  WalletModelData(
      {this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.sendBy,
        this.receivedBy,
        this.giftInfo,
        this.send,
        this.received});

  WalletModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    sendBy =
    json['sendBy'] != null ? new SendBy.fromJson(json['sendBy']) : null;
    receivedBy = json['receivedBy'] != null
        ? new SendBy.fromJson(json['receivedBy'])
        : null;
    giftInfo = json['giftInfo'] != null
        ? new GiftInfo.fromJson(json['giftInfo'])
        : null;
    send = json['send'];
    received = json['received'];
  }

}

class SendBy {
  String? sId;
  String? name;
  String? profilePicture;

  SendBy({this.sId, this.name, this.profilePicture});

  SendBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profilePicture = json['profilePicture'];
  }
}

class GiftInfo {
  String? sId;
  String? name;
  String? image;
  int? points;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GiftInfo(
      {this.sId,
        this.name,
        this.image,
        this.points,
        this.createdAt,
        this.updatedAt,
        this.iV});

  GiftInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
    points = json['points'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}
