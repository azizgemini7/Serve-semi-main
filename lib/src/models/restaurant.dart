import 'package:Serve_ios/src/models/product.dart';
import 'package:Serve_ios/src/models/working_day.dart';

class Restaurant {
  String address;
  String cover;
  int deliveryLimit;
  int deliveryPrice;
  int deliveryTime;
  String description;
  double distance;
  int freeDelivery;
  int id;
  String latitude;
  String logo;
  String longitude;
  int minOrderPrice;
  List<Product> products;
  double restaurantRate;
  String title;
  String maxdist;
  List<WorkingDay> workingDays;

  Restaurant(
      {this.maxdist,
      this.address,
      this.cover,
      this.deliveryLimit,
      this.deliveryPrice,
      this.deliveryTime,
      this.description,
      this.distance,
      this.freeDelivery,
      this.id,
      this.latitude,
      this.logo,
      this.longitude,
      this.minOrderPrice,
      this.products,
      this.restaurantRate,
      this.title,
      this.workingDays});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      maxdist: json['max_distance'].toString(),
      address: json['address'],
      cover: json['cover'],
      deliveryLimit: json['delivery_limit'],
      deliveryPrice: json['delivery_price'],
      deliveryTime: json['delivery_time'],
      description: json['description'],
      distance: json['distance'],
      freeDelivery: json['free_delivery'],
      id: json['id'],
      latitude: json['latitude'],
      logo: json['logo'],
      longitude: json['longitude'],
      minOrderPrice: json['min_order_price'],
      products: json['products']
              ?.map<Product>((p) => Product.fromJson(p))
              ?.toList() ??
          [],
      restaurantRate: double.parse(json['restaurant_rate'] == null
              ? '0.0'
              : json['restaurant_rate'].toString())
          .roundToDouble(),
      title: json['title'],
      workingDays: json['working_days']
              ?.map<WorkingDay>((wd) => WorkingDay.fromJson(wd))
              ?.toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['max_distance'] = this.maxdist;

    data['cover'] = this.cover;
    data['delivery_limit'] = this.deliveryLimit;
    data['delivery_price'] = this.deliveryPrice;
    data['delivery_time'] = this.deliveryTime;
    data['description'] = this.description;
    data['distance'] = this.distance;
    data['free_delivery'] = this.freeDelivery;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['logo'] = this.logo;
    data['longitude'] = this.longitude;
    data['min_order_price'] = this.minOrderPrice;
    data['restaurant_rate'] = this.restaurantRate;
    data['title'] = this.title;
    if (this.products != null) {
      data['products'] = this.products?.map((e) => e.toJson())?.toList();
    }
    if (this.workingDays != null) {
      data['working_days'] = this.workingDays?.map((e) => e.toJson())?.toList();
    }
    return data;
  }
}
