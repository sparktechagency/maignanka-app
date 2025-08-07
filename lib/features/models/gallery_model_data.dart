class GalleryModelData {
  String? sId;
  String? imageURL;
  String? createdAt;

  GalleryModelData({this.sId, this.imageURL, this.createdAt});

  GalleryModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    imageURL = json['imageURL'];
    createdAt = json['createdAt'];
  }
}
