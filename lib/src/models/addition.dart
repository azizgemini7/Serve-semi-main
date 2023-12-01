class Addition {
  int id;
  int limit;
  String name;
  int price;

  Addition({this.id, this.limit, this.name, this.price});

  factory Addition.fromJson(Map<String, dynamic> json) {
    return Addition(
      id: json['id'],
      limit: json['limit'],
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['limit'] = this.limit;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}
