class NotificationModelData {
  String? sId;
  String? message;
  NotificationFrom? notificationFrom;
  String? createdAt;

  NotificationModelData({
    this.sId,
    this.message,
    this.notificationFrom,
    this.createdAt,
  });

  NotificationModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    message = json['message'];
    notificationFrom =
        json['notificationFrom'] != null
            ? new NotificationFrom.fromJson(json['notificationFrom'])
            : null;
    createdAt = json['createdAt'];
  }
}

class NotificationFrom {
  String? sId;
  String? name;
  String? email;
  String? profilePicture;

  NotificationFrom({this.sId, this.name, this.email, this.profilePicture});

  NotificationFrom.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    profilePicture = json['profilePicture'];
  }
}
