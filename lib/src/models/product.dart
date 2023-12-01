import 'package:Serve_ios/src/models/meal.dart';

class Product {
  int id;
  List<Meal> meals;
  String name;

  Product({this.id, this.meals, this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      meals:
          json['meals']?.map<Meal>((aMeal) => Meal.fromJson(aMeal))?.toList() ??
              [],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['meals'] = this.meals?.map((e) => e.toJson())?.toList() ?? [];
    data['name'] = this.name;
    return data;
  }
}
