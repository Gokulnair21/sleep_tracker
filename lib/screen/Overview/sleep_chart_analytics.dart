import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/model/sleep_log_save.dart';
import 'package:sleep_tracker/screen/SplashScreens/no_data_screen.dart';
import 'package:sleep_tracker/model/graph.dart';
import 'package:sleep_tracker/HelperFiles/sleep_log_saver_db_helper.dart';

import 'package:sleep_tracker/widgets/charts_widget.dart';

//my imports
class SleepAnalytics extends StatefulWidget {
  @override
  _SleepAnalyticsState createState() => _SleepAnalyticsState();
}

class _SleepAnalyticsState extends State<SleepAnalytics> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;

  Gradient myHighColor = LinearGradient(
      colors: [
        Color(0xffd587ff),
        Color(0xffc58eff),
        Color(0xff8ea2fe),
        Color(0xff88a4fd),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [0.0, 0.3, 0.6, 0.9]);

  //bool val
  bool isValAvailabe = false;

  //Ints vals
  int ideal = 10;

  //String vals
  String goal;
  String minHour;
  String maxHour;
  String status;


  //list val
  List<Graph> graphData = [];

//Icons
  Icon poorIcon = Icon(
    Icons.thumb_down,
    color: Colors.red,
  );
  Icon goodIcon = Icon(
    Icons.thumb_up,
    color: Colors.green,
  );

  void getMyData() async {
    final List<Map<String, dynamic>> allRows =
        await SleepDatabaseHelper.db.getTopTenValues();
    setState(() {
      graphData = allRows.map((row) {
        final String day = row['day'];
        final num hours = row['slept'];
        return Graph(day: day, hours: hours);
      }).toList();
    });
  }

  void analytics() async {

    Sleep min = await SleepDatabaseHelper.db.getMinValue();
    setState(() {
      minHour = min.hour;
    });
    Sleep max = await SleepDatabaseHelper.db.getMaxValue();
    setState(() {
      maxHour = max.hour;
    });
  }
  String res;
  void average()async
  {
    String idealSleep = '';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    idealSleep = sharedPreferences.getString('idealSleep');
    res=await SleepDatabaseHelper.db.getAvgSleptValue();
    debugPrint(res);
    if(int.parse(idealSleep)>int.parse(res.substring(13,15))){
      status='POOR';
    }
    else{
      status='GOOD';
    }
    setState(() {
    });
  }

  void checker() {
    if (minHour == null && maxHour == null) {
      maxHour = "\t";
      minHour = "\t";
    }
    status='GOOD';
    res='abcdefghijklm f';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goal = 'Fall asleep faster';
    getMyData();
    analytics();
    checker();
    average();
  }

  @override
  Widget build(BuildContext context) {
    double _height=MediaQuery.of(context).size.height;
    double _width=MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
        backgroundColor: bgColor,
        body: Container(
          child: graphData.length < 9
              ? SplashScreenSleepLog(
                  label: 'Not enough data available',
                  imagePath: 'assets/images/nodata.png',
                  spacing: 30,
                  width: _width/3,
                )
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: _width/18, right: _width/18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: _height/78,
                        ),
                        Container(
                          child: Text(
                            'GOAL',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                fontSize: _height/60,
                                
                                color: white.withAlpha(100)),
                          ),
                        ),
                        SizedBox(
                          height: _height/156,
                        ),
                        Container(
                          child: Text(
                            goal,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                fontSize: _height/39,
                                
                                color: white),
                          ),
                        ),
                        SizedBox(
                          height: _height/39,
                        ),
                        SizedBox(
                          height: _height/2.6,
                          width: double.infinity,
                          child: ShaderMask(
                            child: Graphofsleep(data: graphData,id: 'Sleep',),
                            shaderCallback: (Rect bounds) {
                              return myHighColor.createShader(bounds);
                            },
                          ),
                        ),
                        SizedBox(
                          height: _height/156,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'We are only recording your night sleep',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                fontSize: _height/78,
                                
                                color: white.withAlpha(100)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: _height/39,
                        ),
                        sleepInsight(_height,_width)
                      ],
                    ),
                  ),
                ),
        ));
  }

  Widget sleepInsight(double _height,double _width) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              'Sleep\tinsights',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize:  _height/39,
                  
                  color: white),
            ),
          ),
          SizedBox(
            height:  _height/26,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'SHORTEST\nNIGHT',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize:  _height/60,
                              
                              color: white.withAlpha(100)),
                        ),
                      ),
                      SizedBox(
                        height:  _height/52,
                      ),
                      Container(
                        child: Text(
                          minHour.toString(),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize:  _height/26,
                              
                              color: white),
                        ),
                      ),
                      SizedBox(
                        height:  _height/78,
                      ),
                      Container(
                        child: Text(
                          'HOURS',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize:  _height/60,
                              
                              color: white.withAlpha(100)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: _width/11.61,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'LONGEST\nNIGHT',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize:  _height/60,
                              
                              color: white.withAlpha(100)),
                        ),
                      ),
                      SizedBox(
                        height:  _height/52,
                      ),
                      Container(
                        child: Text(
                          maxHour,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize:  _height/26,
                              
                              color: white),
                        ),
                      ),
                      SizedBox(
                        height:  _height/78,
                      ),
                      Container(
                        child: Text(
                          'HOURS',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize:  _height/60,
                              
                              color: white.withAlpha(100)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width:  _width/11.61,
                ),
                Expanded(
                  child: Container(
                    // color: Colors.yellow,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'AVERAGE\nSLEEP',

                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                fontSize:  _height/60,
                                
                                color: white.withAlpha(100)),
                          ),
                        ),
                        SizedBox(
                          height:  _height/52,
                        ),
                        Container(
                            child: Text(
                              res.substring(13,15),
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize:  _height/26,

                                  color: white),
                            ), ),
                        SizedBox(
                          height:  _height/78,
                        ),
                        Container(
                          child: Text(
                            status,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                fontSize:  _height/60,
                                
                                color: white.withAlpha(100)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
