class Address {
  String address;
  int cityId;
  String createdAt;
  int id;
  int isHome;
  String latitude;
  String longitude;
  String updatedAt;
  int userId;

  Address(
      {this.address,
      this.cityId,
      this.createdAt,
      this.id,
      this.isHome,
      this.latitude,
      this.longitude,
      this.updatedAt,
      this.userId});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      cityId: json['city_id'],
      createdAt: json['created_at'],
      id: json['id'],
      isHome: json['is_home'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city_id'] = this.cityId;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['is_home'] = this.isHome;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    return data;
  }
}
