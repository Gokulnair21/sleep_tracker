import 'dart:async';

//my imports
import 'package:sleep_tracker/HelperFiles/water_database_helper.dart';
import 'package:sleep_tracker/model/water_model.dart';

class WaterBloc {
  WaterBloc() {
    getWater();
  }

  final _waterController = StreamController<List<Water>>.broadcast();

  get water => _waterController.stream;


  dispose() {
    _waterController.close();
  }

  getWater() async {
    _waterController.sink.add(await WaterDatabaseHelper.db.getAllWater());
  }

  delete(int id) {
    WaterDatabaseHelper.db.deleteOneWaterLog(id);
    getWater();
  }

  add(Water water) {
    WaterDatabaseHelper.db.insertWaterVal(water);
    getWater();
  }
  deleteAll()
  {
    WaterDatabaseHelper.db.deleteAll();
    getWater();
  }
}
final waterBloc=WaterBloc();
