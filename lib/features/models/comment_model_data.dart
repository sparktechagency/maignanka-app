class CommentModelData {
  String? sId;
  UserID? userID;
  String? postId;
  String? comment;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CommentModelData(
      {this.sId,
        this.userID,
        this.postId,
        this.comment,
        this.createdAt,
        this.updatedAt,
        this.iV});

  CommentModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userID =
    json['userID'] != null ? new UserID.fromJson(json['userID']) : null;
    postId = json['postId'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class UserID {
  String? sId;
  String? name;
  String? email;
  String? profilePicture;

  UserID({this.sId, this.name, this.email,this.profilePicture});

  UserID.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    profilePicture = json['profilePicture'];
  }
}
