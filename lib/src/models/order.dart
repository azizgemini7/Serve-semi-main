import 'package:Serve_ios/src/models/order_status.dart';

class Order {
  String description;
  double finalPrice;
  int id;
  int maxTime;
  String photo;
  String restaurantName;
  int status;
  List<OrderStatus> statusesDetailed;
  String statusName;
  String details;
  double logitude;
  double latitude;
  String rate;
  String ratetext;
  String date;
  List<dynamic> myproducts;
  Order(
      {this.date,
      this.myproducts,
      this.details,
      this.ratetext,
      this.rate,
      this.latitude,
      this.logitude,
      this.description,
      this.finalPrice,
      this.statusesDetailed,
      this.id,
      this.maxTime,
      this.photo,
      this.restaurantName,
      this.status,
      this.statusName});

  factory Order.fromJson(Map<String, dynamic> json) {
    String isFound = json['photo'] ?? json['restaurant_photo'];

    if (json['restaurant_photo'] == 'https://lazah.net/uploads/' ||
        json['photo'] == 'https://lazah.net/uploads/') {
      isFound =
          'https://www.citypng.com/public/uploads/preview/free-red-x-close-mark-icon-sign-png-11639738559ozrdmkz71g.png';
    }

    return Order(
      date: json['created_at'],
      myproducts: getprod(json['products']),
      details: json['details'],
      latitude: double.parse(json['latitude'].toString()),
      logitude: double.parse(json['longitude'].toString()),
      description: json['description'],
      statusesDetailed: json['statusDetailed']
              ?.map<OrderStatus>((status) => OrderStatus.fromJson(status))
              ?.toList() ??
          [],
      finalPrice: double.parse(json['final_price'].toString()),
      id: json['id'],
      rate: json['rate'] != null ? json['rate']['stars'].toString() : '-1',
      ratetext: json['rate'] != null ? json['rate']['txt'] ?? '' : '-1',
      maxTime: json['maxTime'],
      photo: isFound,
      restaurantName: json['restaurant_name'],
      status: json['status'],
      statusName: json['status_name'],
    );
  }
  static getprod(List<dynamic> js) {
    List<products> pp = [];
    for (int i = 0; i < js.length; i++) {
      pp.add(new products(js[i]));
    }
    return pp;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['statusDetailed'] =
        this.statusesDetailed?.map((e) => e.toJson())?.toList();
    data['final_price'] = this.finalPrice;
    data['id'] = this.id;
    data['maxTime'] = this.maxTime;
    data['photo'] = this.photo;
    data['restaurant_name'] = this.restaurantName;
    data['status'] = this.status;
    data['status_name'] = this.statusName;
    return data;
  }
}

class products {
  String title;
  String title_en;
  String final_price;
  String price;
  String quantity;
  String photo;
  products(dynamic json) {
    title = json['title'].toString();
    title_en = json['title_en'].toString();
    final_price = json['final_price'].toString();
    price = json['price'].toString();
    quantity = json['quantity'].toString();
    photo = json['photo'].toString();
  }
}
