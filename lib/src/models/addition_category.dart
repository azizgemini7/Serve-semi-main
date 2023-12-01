import 'package:Serve_ios/src/models/addition.dart';

class AdditionCategory {
  int id;
  String name;
  List<Addition> prod;

  AdditionCategory({this.id, this.name, this.prod});

  factory AdditionCategory.fromJson(Map<String, dynamic> json) {
    return AdditionCategory(
      id: json['id'],
      name: json['name'],
      prod: json['prod']
              ?.map<Addition>((addition) => Addition.fromJson(addition))
              ?.toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.prod != null) {
      data['prod'] = this.prod.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
