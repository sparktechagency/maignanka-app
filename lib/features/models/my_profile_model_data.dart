
class MyProfileModelData {
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? profilePicture;
  ProfileID? profileID;

  MyProfileModelData(
      {this.sId,
        this.name,
        this.email,
        this.phone,
        this.profilePicture,
        this.profileID});

  MyProfileModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    profilePicture = json['profilePicture'];
    profileID = json['profileID'] != null
        ? new ProfileID.fromJson(json['profileID'])
        : null;
  }
}

class ProfileID {
  String? sId;
  String? userID;
  String? bio;
  String? goal;
  String? dOB;
  String? height;
  String? weight;
  String? gender;
  List<String>? interest;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? address;
  String? country;
  Location? location;

  ProfileID(
      {this.sId,
        this.userID,
        this.bio,
        this.goal,
        this.dOB,
        this.height,
        this.weight,
        this.gender,
        this.interest,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.address,
        this.country,
        this.location});

  ProfileID.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userID = json['userID'];
    bio = json['bio'];
    goal = json['goal'];
    dOB = json['dOB'];
    height = json['height'];
    weight = json['weight'];
    gender = json['gender'];
    interest = json['interest'].cast<String>();
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    address = json['address'];
    country = json['country'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }
}
