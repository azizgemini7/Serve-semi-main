import 'package:Serve_ios/src/models/product_image.dart';

import 'addition_category.dart';

class Meal {
  List<AdditionCategory> additionCategories;
  int calories;
  String deliveryTime;
  String description;
  int id;
  String photo;
  List<ProductImage> photos;
  int price;
  String title;
  int userId;

  Meal(
      {this.additionCategories,
      this.calories,
      this.deliveryTime,
      this.description,
      this.id,
      this.photo,
      this.photos,
      this.price,
      this.title,
      this.userId});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      additionCategories: json['additions']
              ?.map<AdditionCategory>((additionCategory) =>
                  AdditionCategory.fromJson(additionCategory))
              ?.toList() ??
          [],
      calories: json['calories'],
      deliveryTime: json['delivery_time'],
      description: json['description'],
      id: json['id'],
      photo: json['photo'],
      photos: json['photos']
              ?.map<ProductImage>((e) => ProductImage.fromJson(e))
              ?.toList() ??
          [],
      price: json['price'],
      title: json['title'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calories'] = this.calories;
    data['delivery_time'] = this.deliveryTime;
    data['description'] = this.description;
    data['id'] = this.id;
    data['photo'] = this.photo;
    data['price'] = this.price;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    if (this.additionCategories != null) {
      data['additions'] =
          this.additionCategories?.map((e) => e.toJson())?.toList();
    }
    if (this.photos != null) {
      data['photos'] = this.photos?.map((e) => e.toJson())?.toList();
    }
    return data;
  }
}
