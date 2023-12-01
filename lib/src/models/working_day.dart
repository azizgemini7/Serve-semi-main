import 'package:Serve_ios/src/models/day_details.dart';

class WorkingDay {
  DayDetails day;
  int id;
  String name;

  WorkingDay({this.day, this.id, this.name});

  factory WorkingDay.fromJson(Map<String, dynamic> json) {
    return WorkingDay(
      day: json['day'] == null ? null : DayDetails.fromJson(json['day']),
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day?.toJson();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
