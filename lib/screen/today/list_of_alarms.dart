import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/Plugins/notification.dart';
import 'package:sleep_tracker/bloc/sleep_log_bloc.dart';
//my imports

import 'package:sleep_tracker/model/alarm.dart';
import 'package:sleep_tracker/bloc/alarmBloc.dart';
import 'package:sleep_tracker/screen/SplashScreens/loading_circular_indicator.dart';
import 'package:sleep_tracker/screen/SplashScreens/splashScreen.dart';
import 'alarm_setting_interface.dart';

class Myalarms extends StatefulWidget {
  @override
  _MyalarmsState createState() => _MyalarmsState();
}

class _MyalarmsState extends State<Myalarms> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  NotificationPlugin _notification = NotificationPlugin();


  final sleepBloc = SleepBloc();

  @override
  void initState() {
    super.initState();
    bloc.getAlarm();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: butColor),
        backgroundColor: bgColor,
        title: Text('Alarm',
            style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height / 39,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.alarm_add,
                color: butColor,
              ),
              tooltip: 'Add new alarm',
              onPressed: () {
                Alarm myInitialValue = Alarm(
                    status: false, hour: '08', minute: '00', period: 'AM',label: 'Have a nice day');
                bloc.add(myInitialValue);
              }),
        ],
      ),
      body: StreamBuilder<List<Alarm>>(
        stream: bloc.alarm,
        builder: (context, AsyncSnapshot<List<Alarm>> snapshot) {
          if (snapshot.hasData) {
            final alarms = snapshot.data;
            if (alarms.isEmpty) {
                return SplashScreen(
                    'No Alarm',
                    MediaQuery.of(context).size.height / 26,
                    MediaQuery.of(context).size.height);
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Alarm item = snapshot.data[index];
                return Container(
                  child: Column(
                    children: <Widget>[
                      myListTile(item),
                      Divider(
                        color: white.withAlpha(50),
                      )
                    ],
                  ),
                );
              },
            );
          }
          return CircularLoader();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: bgColor,
        child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 18,
                0,
                MediaQuery.of(context).size.width / 18,
                MediaQuery.of(context).size.height / 39),
            height: MediaQuery.of(context).size.height / 15.6,
            width: MediaQuery.of(context).size.width,
            decoration:
                BoxDecoration(border: Border.all(color: butColor, width: 1.0)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 36),
                    child: Text(
                      'Record\tyour\tbedtime',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.height / 39,
                        color: butColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: butColor),
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      color: bgColor,
                      size: MediaQuery.of(context).size.height / 15.6,
                    ),
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      await calculateDateAndTime();
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget myListTile(Alarm alarm) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(color: Colors.red),
        child: Icon(
          Icons.delete_outline,
          color: white.withAlpha(150),
          size: MediaQuery.of(context).size.height / 15.6,
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        bloc.delete(alarm.id);
      },
      child: InkWell(
        onTap: () {
          _notification.cancelNotification(alarm.id);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SetAlarm(
              alarm: alarm,
            );
          }));
        },
        child: Container(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 18,
                right: MediaQuery.of(context).size.width / 18),
            height: MediaQuery.of(context).size.height / 7.35,
            width: double.infinity,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 8.66,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: alarm.hour,
                            style: GoogleFonts.lato(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                color: alarm.status
                                    ? Colors.white
                                    : Colors.white.withAlpha(150),
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: ':',
                            style: GoogleFonts.lato(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                color: alarm.status
                                    ? Colors.white
                                    : Colors.white.withAlpha(150),
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: alarm.minute,
                            style: GoogleFonts.lato(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                color: alarm.status
                                    ? Colors.white
                                    : Colors.white.withAlpha(150),
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: '${alarm.period}',
                            style: GoogleFonts.lato(
                                fontSize:
                                    MediaQuery.of(context).size.height / 52,
                                color: alarm.status
                                    ? Colors.white
                                    : Colors.white.withAlpha(150),
                                fontWeight: FontWeight.w500),
                          ),
                        ])),
                      ),
                      Container(
                        child: CupertinoSwitch(
                          value: alarm.status,
                          activeColor: butColor,
                          onChanged: (value) async {
                            bloc.onOrOff(alarm);
                            print(alarm.id);
                            if (alarm.status == false) {
                              conversionToTimeForDisplay(alarm.label,
                                  int.parse(alarm.hour),
                                  int.parse(alarm.minute),
                                  alarm.period,
                                  alarm.id);
                            } else if (alarm.status == true) {
                              await _notification.cancelNotification(alarm.id);
                              Fluttertoast.showToast(msg: 'Alarm Cancelled');
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void conversionToTimeForDisplay(String label,int hour, int minute, String period, int id) async {
    String payload = '$hour:$minute:$period';
    _notification.dailyNotificationFunction(label,hour, minute, period, id, payload);
    String curHour;
    String curMin;
    DateTime current = DateTime.now();
    curHour = '${current.hour}';
    print(curHour);
    curMin = '${current.minute}';
    if (period == 'AM') {
      if (int.parse(curHour) > 12) {
        hour = hour - (int.parse(curHour) - 12);
        hour = hour + 12;
        print('$hour first if else');
      } else if (int.parse(curHour) < 12 && int.parse(curHour) < hour) {
        hour = hour - int.parse(curHour);
        print('second');
      } else if (hour == int.parse(curHour) && minute == int.parse(curMin)) {
        hour = 24;
      } else if (hour == int.parse(curHour) && minute > int.parse(curMin)) {
        hour = 0;
      } else if (int.parse(curHour) > hour) {
        hour = hour - int.parse(curHour);
        hour = hour + 24;
        print('4 th loop');
      }
      minute = minuteConversion(minute, int.parse(curMin));
      if (minute != 0) {
        if (hour != 0) {
          hour = hour - 1;
        }
      }

      Fluttertoast.showToast(msg: '$hour hour $minute min remaining');
    } else {
      int check = hour + 12;
      print(curHour);
      if (int.parse(curHour) > check) {
        hour = -(hour + 12) + int.parse(curHour);
        hour = 24 - hour;
        print('PM $hour');
      } else if ((int.parse(curHour) < check)) {
        hour = -int.parse(curHour) + (hour + 12);
      } else if (check == int.parse(curHour) && minute > int.parse(curMin)) {
        hour = 0;
      } else {
        hour = 24;
      }

      minute = minuteConversion(minute, int.parse(curMin));
      if (minute != 0) {
        if (hour != 0) hour = hour - 1;
      }
      Fluttertoast.showToast(msg: '$hour hour $minute min remaining');
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

  Future<void> calculateDateAndTime() async {
    print('reached here');
    DateTime initialTime = DateTime.now();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('day', initialTime.day.toString());
    await sharedPreferences.setInt('hour', initialTime.hour);
    await sharedPreferences.setInt('minute', initialTime.minute);
    await sharedPreferences.setString(
        'month', monthIntToStr(initialTime.month));
    await sharedPreferences.setString('year', initialTime.year.toString());
    Fluttertoast.showToast(msg:'Your Sleeptime is recorded,Have a nice sleep');
  }

  String monthIntToStr(int index) {
    switch (index) {
      case 1:
        return 'January';
        break;
      case 2:
        return 'February';
        break;
      case 3:
        return 'March';
        break;
      case 4:
        return 'April';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'June';
        break;
      case 7:
        return 'July';
        break;
      case 8:
        return 'August';
        break;
      case 9:
        return 'September';
        break;
      case 10:
        return 'October';
        break;
      case 11:
        return 'November';
        break;
      case 12:
        return 'December';
        break;
    }
    return null;
  }
}
