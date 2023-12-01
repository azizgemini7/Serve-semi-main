class User {
  String email;
  int id;
  bool isDriver;
  String lang;
  String latitude;
  String longitude;
  int notificationCount;
  String phone;
  int phoneCode;
  String photo;
  bool notification;
  String token;
  int userTypeId;
  String username;
  User(
      {this.email,
      this.id,
      this.isDriver,
      this.notification,
      this.lang,
      this.latitude,
      this.longitude,
      this.notificationCount,
      this.phone,
      this.phoneCode,
      this.photo,
      this.token,
      this.userTypeId,
      this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      id: json['id'],
      isDriver: json['is_driver'],
      lang: json['lang'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      notification: json['notification'] == 1 ? true : false,
      notificationCount: json['notification_count'],
      phone: json['phone'],
      phoneCode: json['phonecode'],
      photo: json['photo'],
      token: json['token'],
      userTypeId: json['user_type_id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['is_driver'] = this.isDriver;
    data['notification'] = this.notification ? 1 : 0;
    data['lang'] = this.lang;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['notification_count'] = this.notificationCount;
    data['phone'] = this.phone;
    data['phonecode'] = this.phoneCode;
    data['photo'] = this.photo;
    data['token'] = this.token;
    data['user_type_id'] = this.userTypeId;
    data['username'] = this.username;
    return data;
  }
}
