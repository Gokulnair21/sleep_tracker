import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/HelperFiles/user_info_helper_class.dart';
import 'package:sleep_tracker/bloc/sleep_log_bloc.dart';
import 'package:sleep_tracker/bloc/user_info_bloc.dart';
import 'package:sleep_tracker/model/user_info_model.dart';
import 'package:sleep_tracker/screen/profile/settings/manual_ui.dart';

//my imports
import 'package:sleep_tracker/widgets/divider.dart';
import 'package:sleep_tracker/widgets/list_tile_custom.dart';
import 'package:sleep_tracker/widgets/text_input_controller.dart';
import 'mnual_sleep_data_save.dart';

class SleepSettings extends StatefulWidget {
  @override
  _SleepSettingsState createState() => _SleepSettingsState();
}

class _SleepSettingsState extends State<SleepSettings> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  String idealSleep;

  SharedPreferences sharedPreferences;
  final labelTC = TextEditingController();
  final _keyDialog = GlobalKey<FormState>();
  final sleepLogBloc=SleepBloc();

  User user;

  void getInfo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    user=await UserInfoDatabaseHelper.db.getUserInfo(1);
    setState(() {
      idealSleep=user.idealSleep.toString();
      labelTC.text = idealSleep;
    });
  }

  void initVariables() {
    idealSleep = '0';
    labelTC.text = idealSleep;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVariables();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: butColor),
        backgroundColor: bgColor,
        title: Text('Sleep\tSettings',
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
                onTap: () => dialogBox(context),
                contentPadding: EdgeInsets.only(left: 15, right: 20),
                title: Text('Sleep Goal',
                    style: GoogleFonts.lato(
                        fontSize: MediaQuery.of(context).size.height / 52,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text('$idealSleep hrs',
                        style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.height / 52,
                            color: white,
                            fontWeight: FontWeight.w500)),
                    SizedBox(width: MediaQuery.of(context).size.width/36,),
                    Icon(Icons.arrow_forward_ios,color: white,size: MediaQuery.of(context).size.height/52,)
                  ],
                )
              ),
              CustomDivider(),
              SettingListTile(
                label: 'How to use us?',
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return Manual();
                  }));
                },
              ),
              CustomDivider(),
              SettingListTile(
                label: 'Manual Sleep data save',
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return ManualSleepSave();
                  }));
                },
              ),
              CustomDivider(),
              SettingListTile(
                  label: 'Delete all data',
                  onPressed:()=>alertDialogBox(context)
              ),
              CustomDivider(),
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
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: TextInput(
                        autoFocus: true,
                        controller: labelTC,
                        inputType: TextInputType.number,
                        hintText: 'Enter value in hours',
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 40,
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
                              child: Text('Save',
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

  void saveLabel() async {
    if (_keyDialog.currentState.validate()) {
      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        idealSleep = labelTC.text.toString();
        user.idealSleep=int.parse(labelTC.text.toString());
        userInfoBloc.update(user);
      });
      Navigator.pop(context);
    }
  }
  void noAlert(){
    Navigator.pop(context);
  }
  void yesAlert(){
    sleepLogBloc.deleteAll();
    Fluttertoast.showToast(msg: 'Deleted!!!');
    Navigator.pop(context);

  }
  void alertDialogBox(BuildContext context){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) =>AlertDialog(
        backgroundColor: bgColor,
        content: Text('Are you sure you want to delete all data?', style: GoogleFonts.lato(color:white)),
        actions: <Widget>[
          FlatButton(
            onPressed: noAlert,
            child: Text('No',style:GoogleFonts.lato(color:butColor)),
          ),
          FlatButton(
            onPressed: yesAlert,
            child: Text('Yes',style:GoogleFonts.lato(color:butColor)),
          ),
        ],
      ),
    );
  }
}
