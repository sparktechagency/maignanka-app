
class BalanceVersionModelData {
  String? sId;
  String? userId;
  int? version;
  bool? isSender;

  BalanceVersionModelData({this.sId, this.userId, this.version, this.isSender});

  BalanceVersionModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    version = json['version'];
    isSender = json['isSender'];
  }
}
