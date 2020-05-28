import 'dart:convert';

class Water {
  int id;
  String time;
  int drank;

  Water({this.id,
        this.time,
        this.drank,});

  factory Water.fromMap(Map<String, dynamic> json) => Water(
      id: json['id'],
    time: json['time'],
    drank: json['drank'],);

  Map<String, dynamic> toMap() => {
    'id': id,
    'time': time,
    'drank': drank,
  };
}

Water alarmFromJson(String str) {
  final jsonData = json.decode(str);
  return Water.fromMap(jsonData);
}

String alarmToJson(Water data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
