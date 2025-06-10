class OtherProfileData {
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? image;
  String? bio;

  OtherProfileData(
      {this.sId,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.image,
        this.bio});

  OtherProfileData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    image = json['image'];
    bio = json['bio'];
  }
}
