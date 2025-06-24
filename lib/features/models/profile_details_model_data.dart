class ProfileDetailsModelData {
  String? sId;
  String? userID;
  String? bio;
  String? goal;
  String? dOB;
  String? height;
  String? weight;
  String? gender;
  List<String>? interest;
  String? address;
  String? country;
  List<Pictures>? pictures;
  String? name;
  int? age;
  String? status;

  ProfileDetailsModelData({
    this.sId,
    this.userID,
    this.bio,
    this.goal,
    this.dOB,
    this.height,
    this.weight,
    this.gender,
    this.interest,
    this.address,
    this.country,
    this.pictures,
    this.name,
    this.age,
    this.status,
  });

  ProfileDetailsModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userID = json['userID'];
    bio = json['bio'];
    goal = json['goal'];
    dOB = json['dOB'];
    height = json['height'];
    weight = json['weight'];
    gender = json['gender'];
    interest = (json['interest'] as List?)?.map((e) => e.toString()).toList();
    address = json['address'];
    country = json['country'];
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
    name = json['name'];
    age = (json['age'] as num?)?.toInt();
    status = json['status'];
  }
}

class Pictures {
  String? imageURL;

  Pictures({this.imageURL});

  Pictures.fromJson(Map<String, dynamic> json) {
    imageURL = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageURL'] = this.imageURL;
    return data;
  }
}
