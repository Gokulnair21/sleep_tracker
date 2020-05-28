import 'dart:async';

//my imports
import 'package:sleep_tracker/HelperFiles/water_log_helper_class.dart';
import 'package:sleep_tracker/model/water_log_model.dart';

class WaterLogBloc {
  WaterLogBloc() {
    getWaterLog();
  }

  final _waterLogController = StreamController<List<WaterLogData>>.broadcast();

  get waterLogData => _waterLogController.stream;


  dispose() {
    _waterLogController.close();
  }

  getWaterLog() async {
    _waterLogController.sink.add(await WaterLogDatabaseHelper.db.getAllWaterLog());
  }

  add(WaterLogData waterLog) {
    WaterLogDatabaseHelper.db.insertWaterValInLog(waterLog);
    getWaterLog();
  }
  update(WaterLogData waterLog)
  {
    WaterLogDatabaseHelper.db.updateWaterLog(waterLog);
    getWaterLog();
  }

  delete(int id)
  {
    WaterLogDatabaseHelper.db.deleteOneWaterLog(id);
    getWaterLog();
  }
  deleteAll()
  {
    WaterLogDatabaseHelper.db.deleteAll();
    getWaterLog();
  }

}

final waterLogBloc=WaterLogBloc();