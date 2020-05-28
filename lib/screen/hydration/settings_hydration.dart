import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/HelperFiles/user_info_helper_class.dart';

//my imports
import 'package:sleep_tracker/Plugins/notification.dart';
import 'package:sleep_tracker/bloc/user_info_bloc.dart';
import 'package:sleep_tracker/bloc/water_bloc.dart';
import 'package:sleep_tracker/bloc/water_log_bloc.dart';
import 'package:sleep_tracker/model/user_info_model.dart';
import 'package:sleep_tracker/model/water_log_model.dart';
import 'package:sleep_tracker/widgets/divider.dart';
import 'package:sleep_tracker/widgets/list_tile_custom.dart';
import 'package:sleep_tracker/widgets/text_input_controller.dart';

class HydrationSettings extends StatefulWidget {
  @override
  _HydrationSettingsState createState() => _HydrationSettingsState();
}

class _HydrationSettingsState extends State<HydrationSettings> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  bool notifyHydration;
  static int idealGlass;
  bool hydrationGoal;

  User user;
  String message;

  NotificationPlugin _notification = NotificationPlugin();
  SharedPreferences sharedPreferences;
  final goalTC = TextEditingController();
  final labelTC = TextEditingController();
  final _keyDialog = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void initiateSharedPreference() async {
    user = await UserInfoDatabaseHelper.db.getUserInfo(1);
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      idealGlass = user.idealWater;
      goalTC.text=idealGlass.toString();
       message=sharedPreferences.getString('getWaterNotifyMessage');
      notifyHydration = sharedPreferences.getBool('notifyHydration');
      hydrationGoal = sharedPreferences.getBool('hydrationGoal');
      labelTC.text=message;
    });
  }

  void initValues() {
    idealGlass = 0;
    notifyHydration = false;
    hydrationGoal = false;
    message='loading...';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();
    initiateSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: butColor),
        backgroundColor: bgColor,
        title: Text('Drink\tWater',
            style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height / 39,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 156,
              ),
              ListTile(
                title: Text('Drink\tWater',
                    style: GoogleFonts.lato(
                        fontSize: MediaQuery.of(context).size.height / 52,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
                trailing: Switch(
                    activeColor: butColor,
                    value: hydrationGoal,
                    onChanged: (val) {
                      if(!val)
                        {
                          _notification.cancelNotification(99999);
                          sharedPreferenceSave(
                              'notifyHydration', false);
                          notifyHydration=false;
                        }
                      sharedPreferenceSave('hydrationGoal', val);
                      setState(() {
                        hydrationGoal = val;
                      });
                    }),
              ),
              CustomDivider(),
              Container(
                  child: (!hydrationGoal)
                      ? SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                                onTap: () => dialogBox(context),
                                contentPadding:
                                    EdgeInsets.only(left: 15, right: 20),
                                title: Text('Water Goal',
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                52,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                                trailing: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Text('$idealGlass ml',
                                        style: GoogleFonts.lato(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                52,
                                            color: white,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          36,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: white,
                                      size: MediaQuery.of(context).size.height /
                                          52,
                                    )
                                  ],
                                )),
                            CustomDivider(),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Notification',
                                style: GoogleFonts.lato(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 78,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            ListTile(
                              title: Text('Enable Notification',
                                  style: GoogleFonts.lato(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              52,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                              trailing: Switch(
                                  activeColor: butColor,
                                  value: notifyHydration,
                                  onChanged: (val) async {
                                    sharedPreferenceSave(
                                        'notifyHydration', val);
                                    notify(notifyHydration,message);
                                    setState(() {
                                      notifyHydration = val;
                                    });
                                  }),
                            ),
                            Container(
                                child: (!notifyHydration)
                                    ? SizedBox()
                                    : Column(
                                        children: <Widget>[
                                          CustomDivider(),
                                          SettingListTile(
                                              label: 'Wanna set custom message?',
                                              onPressed: () => notifyDialogBox(context)),
                                        ],
                                      )),
                            CustomDivider(),
                            SettingListTile(
                                label: 'Delete all data',
                                onPressed: () => alertDialogBox(context)),
                            CustomDivider(),
                          ],
                        )),

//              Container(
//                  child:notifyHydration?Wrap(
//                    crossAxisAlignment: WrapCrossAlignment.start,
//                    children: <Widget>[
//
//                      ListTile(
//                        onTap:(){
//                          Navigator.pop(context);
//                        },
//                        contentPadding: EdgeInsets.only(left:15,right: 20),
//                        title:Text('Notification interval',
//                            style: GoogleFonts.lato(
//                                fontSize: MediaQuery.of(context).size.height/52,
//                                color: Colors.white,
//                                fontWeight: FontWeight.w500)),
//                        trailing: Text('1 hr',
//                            style: GoogleFonts.lato(
//                                fontSize: MediaQuery.of(context).size.height/52,
//                                color: Colors.white,
//                                fontWeight: FontWeight.w500)),
//                      ),
//                      ListTile(
//                        onTap:(){
//                          Navigator.pop(context);
//                        },
//                        contentPadding: EdgeInsets.only(left:15,right: 20),
//                        title:Text('Notification interval',
//                            style: GoogleFonts.lato(
//                                fontSize: MediaQuery.of(context).size.height/52,
//                                color: Colors.white,
//                                fontWeight: FontWeight.w500)),
//                        trailing: Text('1.5 hr',
//                            style: GoogleFonts.lato(
//                                fontSize: MediaQuery.of(context).size.height/52,
//                                color: Colors.white,
//                                fontWeight: FontWeight.w500)),
//                      ),
//                    ],
//                  ):SizedBox()
//              ),
            ],
          ),
        ),
      ),
    );
  }

  void dialogBox(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

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
                crossAxisAlignment: WrapCrossAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: _height / 78,
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: _width / 24, right: _width / 24),
                      child: TextInput(
                        autoFocus: true,
                        controller: goalTC,
                        inputType: TextInputType.number,
                        hintText: 'Enter value in ml',
                      )),
                  SizedBox(
                    height: _height / 52,
                  ),
                  Container(
                    height: _height / 19.5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel',
                                  style: GoogleFonts.lato(
                                      fontSize: _height / 60,
                                      color: white,
                                      fontWeight: FontWeight.w500))),
                        ),
                        Expanded(
                          child: FlatButton(
                              onPressed: saveLabel,
                              child: Text('Save',
                                  style: GoogleFonts.lato(
                                      fontSize: _height / 60,
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

  void notifyDialogBox(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

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
                crossAxisAlignment: WrapCrossAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: _height / 78,
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: _width / 24, right: _width / 24),
                      child: TextInput(
                        autoFocus: true,
                        controller: labelTC,
                        inputType: TextInputType.text,
                        hintText: 'Enter the message',
                      )),
                  SizedBox(
                    height: _height / 52,
                  ),
                  Container(
                    height: _height / 19.5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel',
                                  style: GoogleFonts.lato(
                                      fontSize: _height / 60,
                                      color: white,
                                      fontWeight: FontWeight.w500))),
                        ),
                        Expanded(
                          child: FlatButton(
                              onPressed: saveNotifyLabel,
                              child: Text('Save',
                                  style: GoogleFonts.lato(
                                      fontSize: _height / 60,
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

  void saveLabel() async {
    if (_keyDialog.currentState.validate()) {
      setState(() {
        idealGlass = int.tryParse(goalTC.text.toString());
        user.idealWater = int.parse(goalTC.text.toString());
        userInfoBloc.update(user);
      });
      Navigator.pop(context);
    }
  }

  //notify(notifyHydration,message);
  void saveNotifyLabel() async {
    sharedPreferences=await SharedPreferences.getInstance();
    if (_keyDialog.currentState.validate()) {
      if(labelTC.text.length<51)
        {
          setState(() {
            message=labelTC.text.toString();
            sharedPreferences.setString('getWaterNotifyMessage', message);
          });
          _notification.cancelNotification(99999);
          _notification.periodicNotification(
              'Stay hydrated and healthy', message, 99999, 'Hola bruh');
          Fluttertoast.showToast(msg: 'Custom message notification enabled');
          Navigator.pop(context);
        }
        else
          {
            Fluttertoast.showToast(msg: 'Message should be less than 50 words');
          }


    }
  }

  void notify(bool val,String body) {
    if (val == false) {
      _notification.periodicNotification(
          'Stay hydrated and healthy', body, 99999, 'Hola bruh');
      Fluttertoast.showToast(msg: 'Notification enabled');
    } else if (val == true) {
      _notification.cancelNotification(99999);
      Fluttertoast.showToast(msg: 'Notification Cancelled');
    }
  }

  void sharedPreferenceSave(String name, bool value) async {
    print('executed');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(name, value);
  }

  void noAlert() {
    Navigator.pop(context);
  }

  void yesAlert() {
    DateTime now = DateTime.now();
    waterBloc.deleteAll();
    waterLogBloc.deleteAll();
    if (hydrationGoal) {
      waterLogBloc.add(WaterLogData(
          drank: 0, day: now.day, month: now.month, year: now.year));
    }
    Fluttertoast.showToast(msg: 'Deleted!!!');
    Navigator.pop(context);
  }

  void alertDialogBox(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        content: Text('Are you sure you want to delete all data?',
            style: GoogleFonts.lato(color: white)),
        actions: <Widget>[
          FlatButton(
            onPressed: noAlert,
            child: Text('No', style: GoogleFonts.lato(color: butColor)),
          ),
          FlatButton(
            onPressed: yesAlert,
            child: Text('Yes', style: GoogleFonts.lato(color: butColor)),
          ),
        ],
      ),
    );
  }
}
