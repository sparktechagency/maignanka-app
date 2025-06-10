
class NotificationData {
  String? sId;
  bool? isReadable;
  String? msg;
  String? createdAt;
  String? updatedAt;

  NotificationData(
      {this.sId, this.isReadable, this.msg, this.createdAt, this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isReadable = json['isReadable'];
    msg = json['msg'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
