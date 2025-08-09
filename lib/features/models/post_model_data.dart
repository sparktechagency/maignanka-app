class PostModelData {
  String? sId;
  String? userID;
  String? caption;
  List<Images>? images;
  String? createdAt;
  String? updatedAt;
  int? iV;
  UserInfo? userInfo;
  int? commentsCount;
  int? likesCount;
  bool? isLiked;

  PostModelData({
    this.sId,
    this.userID,
    this.caption,
    this.images,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.userInfo,
    this.commentsCount,
    this.likesCount,
    this.isLiked,
  });

  PostModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userID = json['userID'];
    caption = json['caption'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    userInfo =
        json['userInfo'] != null
            ? new UserInfo.fromJson(json['userInfo'])
            : null;
    commentsCount = json['commentsCount'];
    likesCount = json['likesCount'];
    isLiked = json['isLiked'];
  }
}

class Images {
  String? url;

  Images({this.url});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
}

class UserInfo {
  String? sId;
  String? name;
  String? email;
  String? profilePicture;

  UserInfo({this.sId, this.name, this.email, this.profilePicture});

  UserInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    profilePicture = json['profilePicture'];
  }
}
