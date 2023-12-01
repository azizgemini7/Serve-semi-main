class PaymentType {
  String createdAt;
  int id;
  String name;
  String updatedAt;

  PaymentType({this.createdAt, this.id, this.name, this.updatedAt});

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      createdAt: json['created_at'],
      id: json['id'],
      name: json['name'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
