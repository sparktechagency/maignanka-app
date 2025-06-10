class MyBookingData {
  String? sId;
  String? name;
  String? price;
  String? location;
  String? time;
  String? date;
  String? image;

  MyBookingData(
      {this.sId,
      this.name,
      this.price,
      this.location,
      this.time,
      this.date,
      this.image});

  MyBookingData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    location = json['location'];
    time = json['time'];
    date = json['date'];
    image = json['image'];
  }
}
