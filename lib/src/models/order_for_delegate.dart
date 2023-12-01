import 'package:Serve_ios/src/models/order.dart';

class OrderForDelegate {
  String deliverAddress;
  double deliverLatitude;
  double deliverLongitude;
  double deliveryPrice;
  int orderId;
  int orderStatus;
  String paymentMethod;
  double priceAfterDiscount;
  String restaurantAddress;
  double restaurantLatitude;
  double restaurantLongitude;
  String restaurantName;
  String restaurantPhoto;
  List<products> myproducts;
  String date;
  String details;
  OrderForDelegate(
      {this.details,
      this.myproducts,
      this.deliverAddress,
      this.deliverLatitude,
      this.deliverLongitude,
      this.orderStatus,
      this.deliveryPrice,
      this.orderId,
      this.paymentMethod,
      this.priceAfterDiscount,
      this.restaurantAddress,
      this.restaurantLatitude,
      this.restaurantLongitude,
      this.restaurantName,
      this.date,
      this.restaurantPhoto});

  factory OrderForDelegate.fromJson(Map<String, dynamic> json) {
    print("OrderForDelegate:: " + json.toString());
    print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
    return OrderForDelegate(
      details: json['details'] ?? '',
      date: json['created_at'] ?? '',
      myproducts: getprod(json['products']),
      deliverAddress: json['deliver_address'],
      orderStatus: json['status'],
      deliverLatitude: json['deliver_latitude'] is String
          ? double.parse(json['deliver_latitude'])
          : null,
      deliverLongitude: json['deliver_longitude'] is String
          ? double.parse(json['deliver_longitude'])
          : null,
      deliveryPrice: double.parse(json['delivery_price'].toString()),
      orderId: json['order_id'],
      paymentMethod: json['payment_method'],
      priceAfterDiscount: double.parse(json['price_after_discount'].toString()),
      restaurantAddress: json['restaurant_address'],
      restaurantLatitude: json['restaurant_latitude'] is String
          ? double.parse(json['restaurant_latitude'])
          : null,
      restaurantLongitude: json['restaurant_longitude'] is String
          ? double.parse(json['restaurant_longitude'])
          : null,
      restaurantName: json['restaurant_name'],
      restaurantPhoto: json['restaurant_photo'] ??
          'https://ps.w.org/replace-broken-images/assets/icon-256x256.png?rev=2561727',
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
    data['deliver_address'] = this.deliverAddress;
    data['deliver_latitude'] = this.deliverLatitude?.toString();
    data['deliver_longitude'] = this.deliverLongitude?.toString();
    data['delivery_price'] = this.deliveryPrice;
    data['order_id'] = this.orderId;
    data['status'] = this.orderStatus;
    data['payment_method'] = this.paymentMethod;
    data['price_after_discount'] = this.priceAfterDiscount;
    data['restaurant_address'] = this.restaurantAddress;
    data['restaurant_latitude'] = this.restaurantLatitude?.toString();
    data['restaurant_longitude'] = this.restaurantLongitude?.toString();
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_photo'] = this.restaurantPhoto;
    return data;
  }
}
