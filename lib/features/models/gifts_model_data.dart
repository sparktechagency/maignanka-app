class GiftsModelData {
  String? sId;
  String? name;
  String? image;
  int? points;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GiftsModelData(
      {this.sId,
        this.name,
        this.image,
        this.points,
        this.createdAt,
        this.updatedAt,
        this.iV});

  GiftsModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
    points = json['points'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}
