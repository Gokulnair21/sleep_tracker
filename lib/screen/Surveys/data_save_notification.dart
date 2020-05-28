import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

//My imports
import 'package:sleep_tracker/HelperFiles/alarmDatabaseHelper.dart';
import 'package:sleep_tracker/bloc/alarmBloc.dart';
import 'package:sleep_tracker/bloc/sleep_log_bloc.dart';
import 'package:sleep_tracker/model/alarm.dart';
import 'package:sleep_tracker/model/sleep_log_save.dart';
import 'package:sleep_tracker/screen/SplashScreens/loading_circular_indicator.dart';
import 'package:sleep_tracker/widgets/raised_button.dart';
import '../home_main_page.dart';
import 'morining_survey.dart';

class SaveDataInLog extends StatefulWidget {
  @override
  _SaveDataInLogState createState() => _SaveDataInLogState();
}

class _SaveDataInLogState extends State<SaveDataInLog> {
  final sleepBloc = SleepBloc();
  final alarmBloc = AlarmBloc();
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: butColor),
          elevation: 0,
          backgroundColor: bgColor,
          title: Text('Sleep Data ',
              style: GoogleFonts.lato(
                  fontSize: MediaQuery.of(context).size.height / 39,
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 39,
            ),
            Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 18,
                    right: MediaQuery.of(context).size.width / 18),
                child: Text(
                    'You can save the sleep time by clicking on the alarm on which you where awake.',
                    style: GoogleFonts.lato(
                        fontSize: MediaQuery.of(context).size.height / 52,
                        color: Colors.white.withAlpha(150),
                        fontWeight: FontWeight.w400))),
            SizedBox(
              height: MediaQuery.of(context).size.height / 39,
            ),
            FutureBuilder<List<Alarm>>(
              future: DatabaseHelper.db.getOnAlarms(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Alarm>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Alarm item = snapshot.data[index];
                      return listTileAlarmSet(item);
                    },
                  );
                }
                return CircularLoader();
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 26,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 19.5,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  CustomRaisedButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeNavigation())),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 18,
                  )
                ],
              ),
            ),
            SizedBox(
              height:MediaQuery.of(context).size.height /39  ,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 19.5,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  CustomRaisedButton(
                      label: 'Do not show again today',
                      onPressed: () {
                        doNotShowAgain();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeNavigation()));
                      }),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 18,
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget listTileAlarmSet(Alarm item) {
    return Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 36,
            right: MediaQuery.of(context).size.width / 36,
            bottom: MediaQuery.of(context).size.height / 78),
        height: MediaQuery.of(context).size.height / 7.00,
        child: Card(
            color: appBarColor,
            elevation: 5.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 78,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 15.6,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 36,
                      ),
                      Container(
                        child: Icon(
                          Icons.alarm_on,
                          color: butColor,
                          size: 25,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 12,
                      ),
                      Expanded(
                        child: Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: Text(
                                '${item.hour}:${item.minute}\t${item.period}',
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            31.2,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 18.57,
                  width: double.infinity,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0))),
                      color: butColor,
                      child: Text('Save',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.height / 39,
                            color: appBarColor,
                          )),
                      onPressed: () => save(item)),
                )
              ],
            )));
  }

  Future<void> payloadInsertion(Alarm alarm) async {
    Sleep sleep = Sleep(day: '', month: '', year: '');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int curHour = sharedPreferences.getInt('hour');
    int curMin = sharedPreferences.getInt('minute');
    sleep.day = sharedPreferences.getString('day');
    sleep.year = sharedPreferences.getString('year');
    sleep.month = sharedPreferences.getString('month');
    int hour = int.tryParse(alarm.hour);
    int minute = int.tryParse(alarm.minute);
    if (alarm.period == 'AM') {
      if (curHour > 12) {
        hour = hour - (curHour - 12);
        hour = hour + 12;
        print('$hour first if else');
      } else if (curHour < 12 && curHour < hour) {
        hour = hour - curHour;
        print('second');
      } else if (hour == curHour && minute == curMin) {
        hour = 24;
      } else if (hour == curHour && minute > curMin) {
        hour = 0;
      } else if (curHour > hour) {
        hour = hour - curHour;
        hour = hour + 24;
        print('4 th loop');
      }

      minute = minuteConversion(minute, curMin);
      if (minute != 0) {
        if (hour != 0) {
          hour = hour - 1;
        }
      }
      sleep.hour = hour.toString();
      sleep.minute = minute.toString();
      String slept = '$hour.$minute';
      print(slept);
      sleep.slept = num.parse(slept);
      sleepBloc.add(sleep);
      print('Success am');
      Fluttertoast.showToast(msg: 'Successfully recorded');
    } else {
      int check = hour + 12;
      print(curHour);
      if (curHour > check) {
        hour = -(hour + 12) + curHour;
        hour = 24 - hour;
        print('PM $hour');
      } else if ((curHour < check)) {
        hour = -curHour + (hour + 12);
      } else if (check == curHour && minute > curMin) {
        hour = 0;
      } else {
        hour = 24;
      }

      minute = minuteConversion(minute, curMin);
      if (minute != 0) {
        if (hour != 0) hour = hour - 1;
      }
      sleep.hour = hour.toString();
      sleep.minute = minute.toString();
      String slept = '$hour.$minute';
      sleep.slept = num.parse(slept);
      sleepBloc.add(sleep);
      print('Success pm');
      Fluttertoast.showToast(msg: 'Successfully recorded');
    }
  }

  int minuteConversion(int myMinute, int currMinute) {
    if (myMinute != currMinute) {
      if (currMinute > myMinute) {
        myMinute = (60 - currMinute) + myMinute;
      } else {
        myMinute = (60 - currMinute) - (60 - myMinute);
        print('minute:$myMinute');
      }
    } else {
      myMinute = 0;
      print('minute:$myMinute');
    }
    return myMinute;
  }

  void save(Alarm alarm) async {
    DateTime now = DateTime.now();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('dayChecker', now.day);
    payloadInsertion(alarm);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ReviewOfSleep()));
  }

  void doNotShowAgain() async {
    DateTime now = DateTime.now();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('dayChecker', now.day);
  }
}
