import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/HelperFiles/alarmDatabaseHelper.dart';
import 'package:sleep_tracker/bloc/water_bloc.dart';
import 'package:sleep_tracker/bloc/water_log_bloc.dart';
import 'package:sleep_tracker/model/water_log_model.dart';

//my imports
import 'package:sleep_tracker/screen/IntroPages/intro_screen_one_time.dart';
import 'package:sleep_tracker/screen/Surveys/data_save_notification.dart';
import 'package:sleep_tracker/screen/home_main_page.dart';

class SplashScreenHome extends StatefulWidget {
  @override
  _SplashScreenStateHome createState() => _SplashScreenStateHome();
}

class _SplashScreenStateHome extends State<SplashScreenHome> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);

  final waterBloc=WaterBloc();
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 900), () {
      DateTime curDay = DateTime.now();
      checkFirstScreen(curDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/11.14,width: MediaQuery.of(context).size.width/5.14,
              decoration: BoxDecoration(
                image: DecorationImage(image:AssetImage('assets/images/logo.png'),fit: BoxFit.fill )
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/39,
            ),
            Text(
              'Sleep Tracker',
              style: GoogleFonts.montserrat(
                  fontSize: MediaQuery.of(context).size.height/31.2,
                  color: butColor,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );

  }

  Future checkFirstScreen(DateTime now) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool _seen = (sharedPreferences.getBool('seen') ?? false);
    int count = await DatabaseHelper.db.getOnAlarmsCount();

    if (_seen) {
      int res = sharedPreferences.getInt('dayChecker');
      if (now.day == res) {
        await sharedPreferences.setBool('newWaterLog', true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeNavigation()));
      } else {
        if(sharedPreferences.getBool('newWaterLog'))
          {
            WaterLogData today=WaterLogData(drank: 0,day: now.day,month: now.month,year: now.year);
            waterLogBloc.add(today);
            await deleteAll();
            await sharedPreferences.setBool('newWaterLog', false);
          }

        if (count == 0) {

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeNavigation()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SaveDataInLog()));
        }
      }
    } else {
      await sharedPreferences.setBool('newWaterLog', true);
      await sharedPreferences.setString('day', now.day.toString());
      await sharedPreferences.setInt('hour', now.hour);
      await sharedPreferences.setInt('minute', now.minute);
      await sharedPreferences.setString('month', monthIntToStr(now.month));
      await sharedPreferences.setString('year', now.year.toString());
      await sharedPreferences.setInt('dayChecker', now.day);
      await sharedPreferences.setBool('hydrationGoal', false);
      await sharedPreferences.setBool('stepGoal', false);
      await sharedPreferences.setBool('notifyHydration',false);
      await sharedPreferences.setString('getWaterNotifyMessage', 'Drink water');
      WaterLogData today=WaterLogData(drank: 0,day: now.day,month: now.month,year: now.year);
      waterLogBloc.add(today);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => IntroScreens()));
    }
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
  Future<void> deleteAll() async {
    waterBloc.deleteAll();
  }
}
