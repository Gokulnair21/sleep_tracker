import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sleep_tracker/HelperFiles/user_info_helper_class.dart';
import 'package:sleep_tracker/bloc/water_log_bloc.dart';
import 'package:sleep_tracker/model/user_info_model.dart';
import 'package:sleep_tracker/model/water_log_model.dart';
import 'package:sleep_tracker/screen/hydration/settings_hydration.dart';
import 'package:sleep_tracker/screen/hydration/water_maintain.dart';
import 'package:sleep_tracker/screen/today/list_of_alarms.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
//my Imports

class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);


  bool hydrationGoal;
  bool stepGoal;

  int idealGlass;

  String textQuote;

  List<String> quotes = [
    "Never go to bed mad. Stay up and fight.",
    "No day is so bad it can’t be fixed with a nap.\n— Carrie Snow",
    "Your future depends on your dreams, so go to sleep.\n— Mesut Barazany",
    "A well spent day brings happy sleep.\n— Leonardo da Vinci",
    "A good laugh and a long sleep are the best cures in the doctor’s book.\n— Irish proverb",
    "Anyone can escape into sleep.We are all geniuses when we dream,the butcher’s the poet’s equal there.\n— Emile M. Cioran",
    "Sleep is the best meditation.\n— Dalai Lama",
    "Fatigue is the best pillow.\n— Benjamin Franklin",
    "Happiness consists of getting enough sleep. Just that, nothing more.\n— Robert A. Heinlein",
    "Sleep is the golden chain that ties health and our bodies together.\n— Thomas Dekker",
    "Man should forget his anger before he lies down to sleep.\n— Mahatma Gandhi",
    "There is a time for many words, and there is also a time for sleep.\n— Homer",
    "Early to bed and early to rise makes a man healthy, wealthy, and wise.\n— Benjamin Franklin"
  ];

  void sharedPreferenceRetriever() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    User user=await UserInfoDatabaseHelper.db.getUserInfo(1);
    setState(() {
      hydrationGoal = sharedPreferences.getBool('hydrationGoal');
      idealGlass=user.idealWater;
      stepGoal = sharedPreferences.getBool('stepGoal');
    });
  }

  void checker() {
    hydrationGoal = false;
    stepGoal = false;
    idealGlass = 0;
  }
  var randomGenerator = Random();

  void quote() {
    int i = randomGenerator.nextInt(11);
    setState(() {
      textQuote = quotes[i];
      if (textQuote == null) {
        textQuote = "";
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPreferenceRetriever();
    checker();
    quote();
    waterLogBloc.getWaterLog();
  }

  @override
  Widget build(BuildContext context) {
    sharedPreferenceRetriever() ;
    // TODO: implement build
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width / 18,
              0,
              MediaQuery.of(context).size.width / 18,
              MediaQuery.of(context).size.height / 39),
          child: Column(
            children: <Widget>[
              cardForSleep(context),
              SizedBox(height: MediaQuery.of(context).size.height / 39),
              Container(
                  alignment: Alignment.centerLeft,
                  child: (!hydrationGoal && !stepGoal)
                      ? SizedBox()
                      : Text(
                          'Daily\tGoal',
                          style: GoogleFonts.lato(
                              fontSize:
                                  MediaQuery.of(context).size.width / 16.36,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )),
              SizedBox(
                height: 10,
              ),
              waterBuilder(),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: (!stepGoal)
                      ? SizedBox()
                      : dailyGoals(
                          context,
                          'Stay healthy',
                          'Walk atleast 30-40 minutes(1=1000 steps)',
                          '10/10\t',
                          '\tsteps')),
              Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          'Tip\tof\tthe\tDay',
                          style: GoogleFonts.lato(
                              fontSize:
                                  MediaQuery.of(context).size.height / 35.45,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      child: Shimmer.fromColors(
                        baseColor: white.withAlpha(100),
                        highlightColor: white,
                        child: IconButton(
                          icon: Icon(Icons.lightbulb_outline, color: white),
                          onPressed: quote,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 26,
              ),
              tipOfDay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardForSleep(BuildContext context) {
    final Color butColor = Color(0xfffeb787);
    final Color bgColorcardForSleep = Color(0xff3e3567);
    return Container(
      height: MediaQuery.of(context).size.height / 2.10,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: bgColorcardForSleep,
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.12,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/today_sleep.png'),
              fit: BoxFit.fitWidth,
            )),
          ),
          Container(
            padding: EdgeInsets.only(
                top: 0, bottom: MediaQuery.of(context).size.height / 26),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6.5,
            child: Row(
              children: <Widget>[
                Container(
                  color: Color(0xff6458a8),
                  width: MediaQuery.of(context).size.width / 14.4,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'NIGHTTIME',
                          style:  GoogleFonts.montserrat(
                              fontWeight: FontWeight.w200,
                              color: Colors.white.withAlpha(150),
                              fontSize:
                                  MediaQuery.of(context).size.height / 70.91),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Get Ready\nfor zZz',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height / 39),
                        ),
                      ),
                    ],
                  ),
                )),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.height / 12.54,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return Myalarms();
                      }));
                    },
                    child: Container(
                      decoration: BoxDecoration(color: butColor),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: bgColorcardForSleep,
                        size: MediaQuery.of(context).size.height / 26,
                      ),
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

  Widget dailyGoals(BuildContext context, String title, String limit,
      String executed, String type) {
    final Color circularAvatarColor = Colors.blueAccent.withAlpha(150);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: circularAvatarColor, width: 2)),
                child: CircleAvatar(
                    foregroundColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.check, color: circularAvatarColor)),
              ),
              title: Text(
                title,
                style: GoogleFonts.lato(
                    fontSize: MediaQuery.of(context).size.height / 43.33,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              subtitle: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 195,
                    ),
                    Container(
                      child: Text(
                        limit,
                        style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.height / 65,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withAlpha(150)),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 195,
                    ),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            executed,
                            style: GoogleFonts.lato(
                                fontSize:
                                    MediaQuery.of(context).size.height / 43.33,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          child: Text(
                            type,
                            style: GoogleFonts.lato(
                                fontSize:
                                    MediaQuery.of(context).size.height / 65,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withAlpha(150)),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blueAccent.withAlpha(150),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 39,
          )
        ],
      ),
    );
  }

  Widget tipOfDay() {
    return Container(
        height: MediaQuery.of(context).size.height / 3.12,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/tip_day.png'),
                fit: BoxFit.fitWidth)),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.transparent),
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 43,
                    top: MediaQuery.of(context).size.height / 22.28),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 156),
                height: MediaQuery.of(context).size.height / 7.35,
                width: MediaQuery.of(context).size.width / 3.42,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      child: Text(
                        textQuote,
                        style: GoogleFonts.lato(
                          color: white,
                          fontWeight: FontWeight.w900,
                          fontSize: MediaQuery.of(context).size.height / 60,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }

  Widget waterBuilder() {
    return StreamBuilder(
      stream: waterLogBloc.waterLogData,
      builder: (context, AsyncSnapshot<List<WaterLogData>> snapshot) {
        if (snapshot.hasData) {
          final waterLog = snapshot.data;
          if (waterLog.isEmpty) {
            return Text('Empty data');
          }
          if (hydrationGoal) {
            return ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  WaterLogData waterLogData = waterLog[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => Hydration(
                                      waterLogData: waterLogData,
                                    )));
                      },
                      child: dailyWaterGoals(
                          context,
                          'Drinking water is good for your health',
                          waterLogData,));
                });
          } else {
            return ListTile(
              onTap: (){
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => HydrationSettings()));
              },
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(
                backgroundColor: butColor,
                child: Icon(
                  Icons.question_answer,
                  color: bgColor,
                ),
              ),
              title: Text(
                'Wanna check your water drinking routine?',
                style: GoogleFonts.lato(
                    fontSize:MediaQuery.of(context).size.height/52,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              subtitle:Text(
                'Go to settings',
                style: GoogleFonts.lato(
                    fontSize:MediaQuery.of(context).size.height/60,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(150)),
              ), 
            );
          }
        }
        return Text(
          'Loading..',
          style: TextStyle(color: white),
        );
      },
    );
  }
  Widget dailyWaterGoals(BuildContext context, String limit,WaterLogData data) {
    final Color circularAvatarColor = Color(0xff1273EB);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading:CircularStepProgressIndicator(
                totalSteps:idealGlass,
                currentStep:val(data.drank),
                stepSize: 7,
                selectedColor: circularAvatarColor,
                unselectedColor: white.withAlpha(50),
                padding: 0,
                height: MediaQuery.of(context).size.height/15.6,
                width:  MediaQuery.of(context).size.height/15.6,
                selectedStepSize: 7,
                child:(idealGlass>data.drank)?SizedBox():Icon(Icons.check,color: circularAvatarColor,) ,
              ),
              title: Text(
                'Drink\tWater',
                style: GoogleFonts.lato(
                    fontSize: MediaQuery.of(context).size.height / 43.33,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              subtitle: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 195,
                    ),
                    Container(
                      child: Text(
                        limit,
                        style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.height / 65,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withAlpha(150)),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 195,
                    ),
                    Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '${data.drank}',
                                style: GoogleFonts.lato(
                                    fontSize:
                                    MediaQuery.of(context).size.height / 43.33,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                            Container(
                              child: Text(
                                '\tmL',
                                style: GoogleFonts.lato(
                                    fontSize:
                                    MediaQuery.of(context).size.height / 65,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withAlpha(150)),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blueAccent.withAlpha(150),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 39,
          )
        ],
      ),
    );
  }
  int val(int drank)
  {
    if(drank>idealGlass)
      {
        return idealGlass;
      }
      return drank;
  }


}
