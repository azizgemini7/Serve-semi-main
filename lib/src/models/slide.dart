class Slide {
  String icon;
  int id;
  String name;
  String photo;

  Slide({this.icon, this.id, this.name, this.photo});

  factory Slide.fromJson(Map<String, dynamic> json) {
    return Slide(
      icon: json['icon'],
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo'] = this.photo;
    return data;
  }
}
