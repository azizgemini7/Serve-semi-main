class DayDetails {
  int isWorking;
  String timeFrom;
  String timeTo;

  DayDetails({this.isWorking, this.timeFrom, this.timeTo});

  factory DayDetails.fromJson(Map<String, dynamic> json) {
    return DayDetails(
      isWorking: json['is_working'],
      timeFrom: json['time_from'],
      timeTo: json['time_to'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_working'] = this.isWorking;
    data['time_from'] = this.timeFrom;
    data['time_to'] = this.timeTo;
    return data;
  }
}
