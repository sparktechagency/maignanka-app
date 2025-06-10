class PostData {
  String? sId;
  String? description;
  String? createdAt;
  List<Media>? media;
  User? user;
  int? totalComments;

  PostData(
      {this.sId,
      this.description,
      this.createdAt,
      this.media,
      this.user,
      this.totalComments});

  PostData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    description = json['description'];
    createdAt = json['createdAt'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    totalComments = json['totalComments'];
  }
}

class Media {
  String? sId;
  String? publicFileURL;
  String? path;

  Media({this.sId, this.publicFileURL, this.path});

  Media.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    publicFileURL = json['publicFileURL'];
    path = json['path'];
  }
}

class User {
  String? sId;
  String? name;
  String? email;
  String? image;

  User({this.sId, this.name, this.email, this.image});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
  }
}

List<PostData> generateFakePosts(int count) {
  return List.generate(count, (index) {
    return PostData(
      sId: "post$index",
      description: "This is post number $index",
      createdAt: DateTime.now().toIso8601String(),
      media: [
        Media(
          sId: "media$index",
          publicFileURL: "https://via.placeholder.com/600x400.png?text=Image+$index",
          path: "/uploads/image$index.png",
        )
      ],
      user: User(
        sId: "user$index",
        name: "User $index",
        email: "user$index@example.com",
        image: "https://randomuser.me/api/portraits/men/${30 + index % 70}.jpg",
      ),
      totalComments: index * 3,
    );
  });
}

