import 'package:Serve_ios/src/models/addition.dart';
import 'package:Serve_ios/src/models/meal.dart';
import 'package:Serve_ios/src/models/restaurant.dart';

class CartRestaurant {
  List<Addition> additions;
  Map<int, int> additionsCount;
  double deliveryPrice;
  double discount;
  int mealsCount;
  String cartItemId;
  List<Meal> meals;
  double orderPrice;
  Restaurant restaurant;

  CartRestaurant(
      {this.additions,
      this.additionsCount,
      this.deliveryPrice,
      this.meals,
      this.cartItemId,
      this.discount,
      this.mealsCount,
      this.orderPrice,
      this.restaurant});

  factory CartRestaurant.fromJson(Map<String, dynamic> json) {
    return CartRestaurant(
      additions: json['additions']
              ?.map<Addition>((addition) => Addition.fromJson(addition))
              ?.toList() ??
          [],
      additionsCount: json['additionsCount']?.map<int, int>(
          (k, v) => MapEntry<int, int>(k is int ? k : int.parse(k), v)),
      deliveryPrice: json['deliveryPrice'],
      discount: json['discount'],
      cartItemId: json['cartItemId'],
      mealsCount: json['ordersCount'],
      orderPrice: json['orderPrice'],
      restaurant: json['restaurant'] == null
          ? null
          : Restaurant.fromJson(json['restaurant']),
      meals:
          json['meals']?.map<Meal>((meal) => Meal.fromJson(meal))?.toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryPrice'] = this.deliveryPrice;
    data['discount'] = this.discount;
    data['cartItemId'] = this.cartItemId;
    data['orderPrice'] = this.orderPrice;
    data['ordersCount'] = this.mealsCount;
    data['restaurant'] = this.restaurant?.toJson();
    data['meals'] = this.meals?.map((e) => e.toJson())?.toList();
    if (this.additions != null) {
      data['additions'] = this.additions.map((e) => e.toJson()).toList();
    }
    if (this.additionsCount != null) {
      data['additionsCount'] =
          this.additionsCount.map((key, value) => MapEntry('$key', value));
    }
    return data;
  }
}
