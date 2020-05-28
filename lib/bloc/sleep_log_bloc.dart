import 'dart:async';

//my imports
import 'package:sleep_tracker/HelperFiles/sleep_log_saver_db_helper.dart';
import 'package:sleep_tracker/model/sleep_log_save.dart';

class SleepBloc {
  SleepBloc() {
    getSleep();
  }

  final _sleepController = StreamController<List<Sleep>>.broadcast();

  get sleep => _sleepController.stream;

  dispose() {
    _sleepController.close();
  }

  getSleep() async {
    _sleepController.sink.add(await SleepDatabaseHelper.db.getAllSleep());
  }

  delete(int id) {
    SleepDatabaseHelper.db.deleteOneSleepLog(id);
    getSleep();
  }

  add(Sleep sleep) {
    SleepDatabaseHelper.db.insertSleepVal(sleep);
    getSleep();
  }
  deleteAll() {
    SleepDatabaseHelper.db.deleteAll();
    getSleep();
  }
  min()
  {
    SleepDatabaseHelper.db.getMinValue();
  }
  max()
  {
    SleepDatabaseHelper.db.getMaxValue();
  }
}
