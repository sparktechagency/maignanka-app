
class SwipeDataModel {
   String? sId;
  String? address;
  int? age;
  int? commonInterest;
  String? userId;
  String? name;
  List<Pictures>? pictures;
  double? distance;

  SwipeDataModel(
      {this.sId,
        this.address,
        this.age,
        this.commonInterest,
        this.userId,
        this.name,
        this.pictures,
        this.distance});

  SwipeDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    address = json['address'];
    age = json['age'];
    commonInterest = json['commonInterest'];
    userId = json['userId'];
    name = json['name'];
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(new Pictures.fromJson(v));
      });
    }
    distance = json['distance'];
  }

}

class Pictures {
  String? imageURL;

  Pictures({this.imageURL});

  Pictures.fromJson(Map<String, dynamic> json) {
    imageURL = json['imageURL'];
  }

}
