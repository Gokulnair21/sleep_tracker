import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/widgets/divider.dart';

class DailyGoals extends StatefulWidget {
  @override
  _DailyGoalsState createState() => _DailyGoalsState();
}

class _DailyGoalsState extends State<DailyGoals> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  bool stepGoal;

  void sharedPreferenceRetriever() async {
    print('executed');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      stepGoal=sharedPreferences.getBool('stepGoal');
    });

  }
  void checker()
  {
    stepGoal=false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checker();
    sharedPreferenceRetriever();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: butColor),
        backgroundColor: bgColor,
        title: Text('Step Count',
            style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height/35.45,
                
                color: Colors.white,
                fontWeight: FontWeight.w600)),
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Step\tCount',style: GoogleFonts.lato(
                  fontSize: MediaQuery.of(context).size.height/52,
                  color: Colors.white,
                  fontWeight: FontWeight.w500)),
              trailing: Switch(
                  activeColor: butColor,
                  value: stepGoal,
                  onChanged: (val){
                    sharedPreferenceSave('stepGoal', val);
                    setState(() {
                      stepGoal=val;
                    });
                  }),
            ),
            CustomDivider(),
          ],
        ),
      ),
    );
  }

  void sharedPreferenceSave(String name, bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(name, value);
  }
}
