import 'dart:convert';

class Alarm {
  int id;
  String hour;
  String minute;
  String period;
  String label;
  bool status;

  Alarm({this.id, this.hour, this.minute, this.period, this.label,this.status});

  factory Alarm.fromMap(Map<String, dynamic> json) => Alarm(
      id: json['id'],
      hour: json['hour'],
      minute: json['minute'],
      period: json['period'],
      label: json['label'],
      status: json['status'] == 1);

  Map<String, dynamic> toMap() => {
        'id': id,
        'hour': hour,
        'minute': minute,
        'period': period,
        'label': label,
        'status': status,
      };
}

Alarm alarmFromJson(String str) {
  final jsonData = json.decode(str);
  return Alarm.fromMap(jsonData);
}

String alarmToJson(Alarm data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
