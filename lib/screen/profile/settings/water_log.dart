import 'package:flutter/material.dart';
import 'package:sleep_tracker/bloc/user_info_bloc.dart';
import 'package:sleep_tracker/bloc/water_log_bloc.dart';
import 'package:sleep_tracker/model/user_info_model.dart';
import 'package:sleep_tracker/model/water_log_model.dart';
import 'package:sleep_tracker/screen/hydration/water_maintain.dart';

class Flutter extends StatefulWidget {
  @override
  _FlutterState createState() => _FlutterState();
}

class _FlutterState extends State<Flutter> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfoBloc.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: userInfoBloc.user,
          builder: (context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              final waterLog = snapshot.data;
              if (waterLog.isEmpty) {
                return Text('Empty data');
              }
              return ListView.builder(
                  itemCount: waterLog.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    User item = waterLog[index];
                    return ListTile(
                      title: Text(
                        'id:${item.id}\tBMI:${item.bmi}\tAGE:${item.age}\tname:${item.lastName}\tfname:${item.firstName}\tideSl:${item.idealSleep}\tidWater:${item.idealWater}\theight:${item.height}\tweight:${item.weight}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  });
            }
            return Text(
              'Loading..',
              style: TextStyle(color: Colors.white),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.red,
          ),
          onPressed: insertNewValue),
    );
  }

  void insertNewValue() {
    DateTime now = DateTime.now();
    waterLogBloc.add(
        WaterLogData(drank: 0, day: now.day, month: now.day, year: now.year));
  }
}
