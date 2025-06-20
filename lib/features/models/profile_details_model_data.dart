
class ProfileDetailsModelData{
  String? sId;
  String? userID;
  String? bio;
  String? goal;
  String? dOB;
  String? height;
  String? gender;
  List<String>? interest;
  String? address;
  String? country;
  List<Pictures>? pictures;
  String? name;
  int? age;
  bool? matched;

  ProfileDetailsModelData(
      {this.sId,
        this.userID,
        this.bio,
        this.goal,
        this.dOB,
        this.height,
        this.gender,
        this.interest,
        this.address,
        this.country,
        this.pictures,
        this.name,
        this.age,
        this.matched});

  ProfileDetailsModelData.fromJson(Map<String, dynamic> json){
    sId = json['_id'];
    userID = json['userID'];
    bio = json['bio'];
    goal = json['goal'];
    dOB = json['dOB'];
    height = json['height'];
    gender = json['gender'];
    interest = json['interest'].cast<String>();
    address = json['address'];
    country = json['country'];
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(new Pictures.fromJson(v));
      });
    }
    name = json['name'];
    age = json['age'];
    matched = json['matched'];
  }
}

class Pictures {
  String? imageURL;

  Pictures({this.imageURL});

  Pictures.fromJson(Map<String, dynamic> json) {
    imageURL = json['imageURL'];
  }
}
