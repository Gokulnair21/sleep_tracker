import 'dart:convert';

class WaterLogData {
  int id;
  int day;
  int month;
  int year;
  int drank;

  WaterLogData({this.id,
    this.day,this.month,this.year,
    this.drank,});

  factory WaterLogData.fromMap(Map<String, dynamic> json) => WaterLogData(
    id: json['id'],
    day: json['day'],
    month: json['month'],
    year: json['year'],
    drank: json['drank'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'day': day,
    'month':month,
    'year':year,
    'drank': drank,
  };
}

WaterLogData alarmFromJson(String str) {
  final jsonData = json.decode(str);
  return WaterLogData.fromMap(jsonData);
}

String alarmToJson(WaterLogData data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
