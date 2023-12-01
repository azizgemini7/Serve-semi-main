class OrderStatus {
  bool active;
  String description;
  int id;
  String name;

  OrderStatus({this.active, this.description, this.id, this.name});

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      active: json['active'],
      description: json['description'],
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['description'] = this.description;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
