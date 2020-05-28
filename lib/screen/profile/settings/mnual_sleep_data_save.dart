import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//my imports
import 'package:sleep_tracker/bloc/sleep_log_bloc.dart';
import 'package:sleep_tracker/model/sleep_log_save.dart';
import 'package:sleep_tracker/widgets/raised_button.dart';
import 'package:sleep_tracker/widgets/text_input_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ManualSleepSave extends StatefulWidget {
  @override
  _ManualSleepSaveState createState() => _ManualSleepSaveState();
}

class _ManualSleepSaveState extends State<ManualSleepSave> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  Sleep sleep = Sleep(hour: "", minute: "", day: "", month: "", year: "", slept: 0);

  final sleepBloc = SleepBloc();

  final sleepHour = TextEditingController();
  final sleepMinute = TextEditingController();
  final sleepDay = TextEditingController();
  final sleepMonth = TextEditingController();

  final _key = GlobalKey<FormState>();

  var G=[1,2,3,4,5,6,7,8,9];
  DateTime now;
  String year;
  void checkNull()
  {
    if(now==null)
      {
        year="2020";
      }
  }
  void dateTime()
  {
    now=DateTime.now();
    setState(() {
      year=now.year.toString();
    });
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateTime();
    checkNull();


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: butColor
        ),
        backgroundColor: bgColor,
        title: Text('Sleep data entry',
            style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height/39,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/18, right: MediaQuery.of(context).size.width/18, top: MediaQuery.of(context).size.height/78),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                image(),
                SizedBox(
                  height: MediaQuery.of(context).size.height/26,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextInput(
                          controller: sleepHour,
                          autoFocus: true,
                          hintText: 'Hour',
                          inputType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/12,
                      ),
                      Expanded(
                        child: TextInput(
                          controller: sleepMinute,
                          autoFocus: true,
                          hintText: 'Minute',
                          inputType: TextInputType.number,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/39,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextInput(
                          controller: sleepDay,
                          autoFocus: true,
                          hintText: 'Day',
                          inputType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextInput(
                          controller: sleepMonth,
                          autoFocus: true,
                          hintText: 'Month',
                          inputType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/36,
                      ),
                      Expanded(
                        child:Text(year,style: TextStyle(fontWeight: FontWeight.w500, color: white,fontFamily: 'Montserrat'),)
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/26,
                ),
                Container(
                  height: MediaQuery.of(context).size.height/19.5,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomRaisedButton(
                          onPressed: () async {
                            save();
                          },
                          label: 'Done',
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/9,
                      ),
                      Expanded(
                        child: CustomRaisedButton(
                          onPressed: clear,
                          label: 'Clear',
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget image() {
    return Container(
      height: MediaQuery.of(context).size.height/4.81,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/sleepTracker.png'),
              fit: BoxFit.contain)),
    );
  }

  void clear() {
    sleepHour.clear();
    sleepMinute.clear();
    sleepDay.clear();
    sleepMonth.clear();
  }

  void save() {
    if (_key.currentState.validate()) {
      Sleep sleep =
          Sleep(hour: "", minute: "", day: "", month: "", year: "", slept: 0);
      if(int.parse(sleepDay.text.toString())>31 )
        {
          sleepDay.clear();
          Fluttertoast.showToast(msg: 'Invalid day');

        }
        else if(int.parse(sleepMinute.text.toString())>60)
        {
          sleepMinute.clear();
          Fluttertoast.showToast(msg: 'Invalid minute');
        }
        else if(int.parse(sleepMonth.text.toString())>12)
          {
            sleepMonth.clear();
            Fluttertoast.showToast(msg: 'Invalid month');

          }
          else if(int.parse(sleepMonth.text.toString())==2 && int.parse(sleepDay.text.toString())>29){
        sleepDay.clear();
        Fluttertoast.showToast(msg: 'Invalid day');
      }
          else {
        sleep.hour = sleepHour.text.toString();
        sleep.minute = sleepMinute.text.toString();
        sleep.day = sleepDay.text.toString();
        sleep.month=monthIntToStr(int.parse(sleepMonth.text.toString()));
        sleep.year = year;
        String slept = ('${sleep.hour}.${sleep.minute}');
        sleep.slept = num.parse(slept);
        sleepBloc.add(sleep);
        Fluttertoast.showToast(msg: 'Sucessfully saved');
        Navigator.pop(context);
      }

    }
    else
      {
        Fluttertoast.showToast(msg: 'Error has occured while saving');
        clear();
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
  }

}
