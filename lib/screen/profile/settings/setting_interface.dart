import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_tracker/screen/Surveys/initial_user_info_survey.dart';
import 'package:sleep_tracker/screen/hydration/settings_hydration.dart';



//my imports
import 'package:sleep_tracker/screen/profile/settings/sleep_settings.dart';
import 'package:sleep_tracker/screen/profile/settings/update_personal_info.dart';
import 'package:sleep_tracker/screen/profile/settings/water_log.dart';
import 'package:sleep_tracker/widgets/divider.dart';
import 'package:sleep_tracker/widgets/list_tile_custom.dart';
import 'package:sleep_tracker/Service/calls_and_message_service.dart';
import 'package:sleep_tracker/widgets/list_tile_of_dialog_box.dart';
import 'daily_goals.dart';
import 'package:sleep_tracker/screen/IntroPages/intro_screen_one_time.dart';
import 'package:sleep_tracker/screen/Surveys/data_save_notification.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  static final String email = 'gokul.nairmurali@gmail.com';
  static final String phoneNumber = '9969183099';



  CallsAndMessagesService callsAndMessagesService = CallsAndMessagesService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: butColor),
        backgroundColor: bgColor,
        title: Text('Settings',
            style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height/39,
                
                color: Colors.white,
                fontWeight: FontWeight.w600)),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height/156,
              ),
              SettingListTile(
                label: 'Info update',
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return UpdateUserInfoSurvey();
                  }));
                },
              ),
              CustomDivider(),
              SettingListTile(
                label: 'Sleep\tsettings',
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                        return SleepSettings();
                      }));
                },
              ),

              CustomDivider(),
              SettingListTile(
                label: 'Drink\twater',
                onPressed: (){
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                        return HydrationSettings();
                      }));                },
              ),
              CustomDivider(),
              SettingListTile(
                label: 'Step\tcount',
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                        return DailyGoals();
                      }));
                },
              ),
              CustomDivider(),
              SettingListTile(
                label: 'Feedback',
                onPressed: () {
                  openDialogBox(context);
                },
              ),
              CustomDivider(),
              SettingListTile(
                label: 'About us',
                onPressed: (){
                  Fluttertoast.showToast(msg: 'We are just bots');
                },
              ),
              CustomDivider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget openDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 4.0,
          backgroundColor: bgColor,
          child: Container(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15,top: 10,bottom: 10),
                  child: Text('Contact us',
                      style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.height/52,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
                DialogLisTile(
                  icon: Icons.mail,
                  label: 'Mail',
                  onTap: () { callsAndMessagesService.sendEmail(email);Navigator.pop(context);},
                ),
                DialogLisTile(
                  icon: Icons.call,
                  label: 'Call',
                  onTap: () { callsAndMessagesService.call(phoneNumber);Navigator.pop(context);}
                ),
                DialogLisTile(
                  icon: Icons.sms,
                  label: 'SMS',
                  onTap: () { callsAndMessagesService.sendSms(phoneNumber);Navigator.pop(context);},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
