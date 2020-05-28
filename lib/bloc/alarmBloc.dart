import 'dart:async';
//my imports
import 'package:sleep_tracker/HelperFiles/alarmDatabaseHelper.dart';
import 'package:sleep_tracker/model/alarm.dart';
class AlarmBloc
{
  AlarmBloc()
  {
    getAlarm();
  }
  final _alarmController = StreamController<List<Alarm>>.broadcast();
  get alarm=>_alarmController.stream;

  dispose() {
    _alarmController.close();
  }

  getAlarm() async {

    _alarmController.sink.add(await DatabaseHelper.db.getAllAlarms());
  }
  onOrOff(Alarm alarm) {

    DatabaseHelper.db.blockOrUnblock(alarm);
    getAlarm();
  }

  delete(int id) {
    DatabaseHelper.db.deleteOne(id);
    getAlarm();
  }

  add(Alarm alarm) {

    DatabaseHelper.db.insertAlarm(alarm);
    getAlarm();
  }
  update(Alarm alarm)
  {
    DatabaseHelper.db.updateAlarm(alarm);
    getAlarm();
  }



}
final bloc=AlarmBloc();