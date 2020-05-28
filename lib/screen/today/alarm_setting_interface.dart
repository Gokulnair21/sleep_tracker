import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sleep_tracker/model/alarm.dart';
import 'package:sleep_tracker/bloc/alarmBloc.dart';
import 'package:sleep_tracker/widgets/divider.dart';
import 'package:sleep_tracker/widgets/text_input_controller.dart';

class SetAlarm extends StatefulWidget {
  final Alarm alarm;

  SetAlarm({this.alarm});

  @override
  _SetAlarmState createState() => _SetAlarmState();
}

class _SetAlarmState extends State<SetAlarm> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  String hour;
  String minute;
  String period;

  DateTime now;

  static final List<String> periodList = ['AM', 'PM'];
  List<String> hourList = [];
  List<String> minuteList = [];

  final labelTC = TextEditingController();

  final _keyDialog = GlobalKey<FormState>();

  void checkValue(Alarm alarm) {
    if ((alarm.hour != null) &&
        (alarm.minute != null) &&
        (alarm.period != null)) {
      setState(() {
        hour = alarm.hour;
        minute = alarm.minute;
        period = alarm.period;
        labelTC.text=alarm.label;
      });
    } else {
      setState(() {
        hour = '08';
        minute = '00';
        period = 'AM';
        labelTC.text='';
      });
    }
  }

  void initializeList() {
    for (int i = 01; i <= 12; i++) {
      if (i < 10) {
        hourList.add('0$i');
      } else {
        hourList.add('$i');
      }
    }
    for (int i = 0; i < 60; i++) {
      if (i < 10) {
        minuteList.add('0$i');
      } else {
        minuteList.add('$i');
      }
    }
  }

  //final
  @override
  void initState() {
    super.initState();
    initializeList();
    checkValue(widget.alarm);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: bgColor,
          iconTheme: IconThemeData(color: butColor),
          title: Center(
            child: Text('Set alarm',
                style: GoogleFonts.lato(
                    fontSize: MediaQuery.of(context).size.height / 39,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ),
          actions: <Widget>[
            IconButton(
              tooltip: 'Set time',
              icon: Icon(
                Icons.done,
                color: butColor,
              ),
              onPressed: () {
                done();
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 39,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        //padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/18),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Hour',
                              style: GoogleFonts.lato(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 39,
                                  color: butColor,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 26,
                            ),
                            InkWell(
                              onTap: () {
                                setAlarm(context, hourList,
                                    MediaQuery.of(context).size.height / 3.82);
                              },
                              child: Text(
                                hour,
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            15.6,
                                    color: white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        //padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/18),
                        child: Column(
                          children: <Widget>[
                            FittedBox(
                                child: Text(
                              'Minute',
                              style: GoogleFonts.lato(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 39,
                                  color: butColor,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            )),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 26,
                            ),
                            InkWell(
                              onTap: () {
                                setAlarm(context, minuteList,
                                    MediaQuery.of(context).size.height / 3.82);
                              },
                              child: Text(
                                minute,
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            15.6,
                                    color: white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        //padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/18),
                        child: Column(
                          children: <Widget>[
                            FittedBox(
                              child: Text(
                                'Period',
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 39,
                                    color: butColor,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 26,
                            ),
                            InkWell(
                              onTap: () {
                                setAlarm(context, periodList,
                                    MediaQuery.of(context).size.height / 3.82);
                              },
                              child: Text(
                                period,
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            15.6,
                                    color: white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15.6,
              ),
              ListTile(
                leading: Text('Repeat',
                    style: GoogleFonts.lato(
                        fontSize: MediaQuery.of(context).size.height / 52,
                        color: white,
                        fontWeight: FontWeight.w500)),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text('Everyday',
                        style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.height / 52,
                            color: white,
                            fontWeight: FontWeight.w500)),
                    SizedBox(width: MediaQuery.of(context).size.width/36,),
                    Icon(Icons.arrow_forward_ios,color: white,size: MediaQuery.of(context).size.height/52,)
                  ],
                )
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 24,
                      right: MediaQuery.of(context).size.width / 24),
                  child: CustomDivider()),
              ListTile(
                  onTap: () => dialogBox(context),
                  leading: Text('Label',
                      style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.height / 52,
                          color: white,
                          fontWeight: FontWeight.w500)),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: white,
                  )),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 24,
                    right: MediaQuery.of(context).size.width / 24),
                child:CustomDivider()
              ),

            ],
          ),
        ));
  }

  void setAlarm(BuildContext context, List value, double _height) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.transparent, width: 1)),
            height: _height,
            width: MediaQuery.of(context).size.width / 5.14,
            child: Column(
              children: <Widget>[
                Container(
                  height: _height - 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return listTile(
                                    context, value[index], value.length);
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget listTile(BuildContext context, String time, int length) {
    return GestureDetector(
      onTap: () {
        if (length == 60) {
          setState(() {
            minute = time;
          });
        } else if ((time == 'AM' || time == 'PM') && length == 2) {
          setState(() {
            period = time;
          });
        } else if (length == 12) {
          setState(() {
            hour = time;
          });
        }
        Navigator.pop(context);
      },
      child: Center(
        child: Container(
          child: Text('$time',
              style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height / 14.18,
                color: butColor,
                fontWeight: FontWeight.w300,
              )),
        ),
      ),
    );
  }

  void dialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 4.0,
          backgroundColor: bgColor,
          child: Form(
            key: _keyDialog,
            child: Container(
              child: Wrap(
                //mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: TextInput(
                        autoFocus: true,
                        controller: labelTC,
                        inputType: TextInputType.text,
                        hintText: 'Enter label',
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 45,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel',
                                  style: GoogleFonts.lato(
                                      fontSize: 13,
                                      color: white,
                                      fontWeight: FontWeight.w500))),
                        ),
                        Expanded(
                          child: FlatButton(
                              onPressed: saveLabel,
                              child: Text('Ok',
                                  style: GoogleFonts.lato(
                                      fontSize: 13,
                                      color: white,
                                      fontWeight: FontWeight.w500))),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void updateHour() {
    widget.alarm.hour = hour;
  }

  void updateMinute() {
    widget.alarm.minute = minute;
  }

  void updatePeriod() {
    widget.alarm.period = period;
  }

  void done() async {
    updateHour();
    updateMinute();
    updatePeriod();
    widget.alarm.status = false;

    if (widget.alarm.id != null) {
      await bloc.update(widget.alarm);
    } else {
      await bloc.add(widget.alarm);
    }
  }

  void saveLabel() {
    if (_keyDialog.currentState.validate()) {
      if(labelTC.text.length<51)
        {
          widget.alarm.label=labelTC.text.toString();
          Navigator.pop(context);
        }
        else{
          Fluttertoast.showToast(msg: 'Label length should be less than 50');
      }
    }
  }

}
