import 'dart:convert';

class User {
   String firstName;
   String lastName;
   int id;
   num height;
   num weight;
   num bmi;
   int age;
   int day;
   int month;
   int year;
   int idealSleep;
   int idealWater;

  User(
      {this.id, this.lastName, this.firstName, this.age, this.height, this.weight, this.bmi, this.day, this.month, this.year, this.idealSleep, this.idealWater});

  factory User.fromMap(Map<String, dynamic> json) =>
      User(
          id: json['id'],
          lastName: json['lastName'],
          firstName: json['firstName'],
          day: json['day'],
          month: json['month'],
          year: json['year'],
          age: json['age'],
          height: json['height'],
          weight: json['weight'],
          idealSleep: json['idealSleep'],
          idealWater: json['idealWater'],
          bmi: json['bmi']);

  Map<String, dynamic> toMap() =>
      {
        'id': id,
        'lastName': lastName,
        'firstName': firstName,
        'day': day,
        'month': month,
        'year': year,
        'age': age,
        'height': height,
        'weight': weight,
        'idealSleep': idealSleep,
        'idealWater': idealWater,
        'bmi': bmi
      };
}

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String userToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

