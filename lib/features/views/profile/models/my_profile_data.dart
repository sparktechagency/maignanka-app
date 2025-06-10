
class MyProfileData {
  String? sId;
  String? name;
  String? email;
  String? role;
  String? phone;
  String? address;
  String? image;
  String? bio;

  MyProfileData(
      {this.sId,
        this.name,
        this.email,
        this.role,
        this.phone,
        this.address,
        this.image,
        this.bio});

  MyProfileData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    phone = json['phone'];
    address = json['address'];
    image = json['image'];
    bio = json['bio'];
  }
}

