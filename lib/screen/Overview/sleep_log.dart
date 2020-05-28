import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sleep_tracker/HelperFiles/user_info_helper_class.dart';
import 'dart:async';

//my imports

import 'package:sleep_tracker/bloc/sleep_log_bloc.dart';
import 'package:sleep_tracker/model/sleep_log_save.dart';
import 'package:sleep_tracker/model/user_info_model.dart';
import 'package:sleep_tracker/screen/SplashScreens/loading_circular_indicator.dart';
import 'package:sleep_tracker/screen/SplashScreens/no_data_screen.dart';

class SleepLog extends StatefulWidget {
  @override
  _SleepLogState createState() => _SleepLogState();
}

class _SleepLogState extends State<SleepLog> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color bgLTColor = Color(0xff3e3767);
  final Color dismissableColor = Color(0xff414384);

  Gradient myLowColor = LinearGradient(
      colors: [
        Color(0xffffa887),
        Color(0xffff8f8a),
        Color(0xffff888b),
        Color(0xfffd5a8f)
      ],
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      stops: [0.0, 0.3, 0.6, 0.9]);

  int idealSleep;
  User user;
  final blocSleep = SleepBloc();

  Future<void> initialVal() async {
    String res = '';
    user=await UserInfoDatabaseHelper.db.getUserInfo(1);
    print(res);
    setState(() {
      idealSleep = user.idealSleep;
    });
  }

  bool val;

  @override
  void initState() {
    val = false;
    // TODO: implement initState
    super.initState();
    initialVal();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        child: val
            ? CircularLoader()
            : Container(
                padding:
                    EdgeInsets.only(right: MediaQuery.of(context).size.width/18, left: MediaQuery.of(context).size.width/18, top: MediaQuery.of(context).size.height/156, bottom: MediaQuery.of(context).size.height/156),
                child: StreamBuilder<List<Sleep>>(
                    stream: blocSleep.sleep,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final sleep = snapshot.data;
                          if (sleep.isEmpty) {
                            return SplashScreenSleepLog(
                              label: 'No data',
                              imagePath: 'assets/images/nodatapad.png',
                              spacing: 5,
                              width: MediaQuery.of(context).size.width/2.25,
                            );
                          }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: snapshot.data.length,
                          padding: EdgeInsets.only(),
                          itemBuilder: (BuildContext context, int index) {
                            Sleep sleep = snapshot.data[index];
                            return listTileOfSleepLog(sleep);
                          },
                        );
                      } else {
                        return CircularLoader();
                      }
                    })),
      ),
    );
  }

  Widget listTileOfSleepLog(Sleep sleep) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(color: dismissableColor),
        child: Icon(
          Icons.delete_outline,
          color: white.withAlpha(150),
          size: MediaQuery.of(context).size.height/15.6,
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        blocSleep.delete(sleep.id);
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text(
            'Deleted',
            style: GoogleFonts.lato(
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height/60,
                
                color: white),
          ),
          backgroundColor: bgColor,
        ));
      },
      //140
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.width/78,bottom: MediaQuery.of(context).size.height/78),
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/18, right: MediaQuery.of(context).size.width/18),
          width:  MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/5.0,
          decoration: BoxDecoration(
              color: bgLTColor, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height/39,
              ),
              Container(
                child: Text(
                  '${sleep.day}th\t${sleep.month}',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.height/39,
                      
                      color: white),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/78,
              ),
              Container(
                child: Text(
                  '${sleep.hour} HOUR ${sleep.minute} MIN',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.height/60,
                      
                      color: white.withAlpha(150)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/26,
              ),
              Container(
                  height: MediaQuery.of(context).size.height/111.42,
                  width: double.infinity,
                  child: LinearPercentIndicator(
                    percent: percentOfSleep(
                        slept: sleep.slept.toDouble(), ideal: idealSleep.toDouble()),
                    clipLinearGradient: true,
                    linearGradient: myLowColor,
                    backgroundColor: Colors.white.withAlpha(100),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height/156,
              ),
              Container(
                height: MediaQuery.of(context).size.height/52,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(child:Text(
                            '0:00',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                
                                color: white.withAlpha(100)),
                            textAlign: TextAlign.left,
                          )),
                        ),
                      ),
                    ),
                    Container(
                      child: FittedBox(
                        child: Text(
                          '${idealSleep.toInt()}:00',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              
                              color: white.withAlpha(100)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  double percentOfSleep({double slept, double ideal}) {
    if (ideal < slept) {
      return 1.0;
    } else if(ideal==slept)
      {
        return 1.0;
      }
    else {
      double g = (slept / ideal);
      return g;
    }
  }
}
