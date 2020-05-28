import 'dart:convert';

class Sleep {
  int id;
  String day;
  String month;
  String year;
  String hour;
  String minute;
  num slept;

  Sleep(
      {this.id,
      this.day,
      this.month,
      this.year,
      this.hour,
      this.minute,
      this.slept});

  factory Sleep.fromMap(Map<String, dynamic> json) => Sleep(
      id: json['id'],
      day: json['day'],
      month: json['month'],
      year: json['year'],
      hour: json['hour'],
      minute: json['minute'],
      slept: json['slept']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'day': day,
        'month': month,
        'year': year,
        'hour': hour,
        'minute': minute,
        'slept': slept,
      };
}

Sleep alarmFromJson(String str) {
  final jsonData = json.decode(str);
  return Sleep.fromMap(jsonData);
}

String alarmToJson(Sleep data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
