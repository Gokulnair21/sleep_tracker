import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_tracker/widgets/manual_tile.dart';

class Manual extends StatelessWidget {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);


  @override
  Widget build(BuildContext context) {
    double _height=MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: butColor),
        backgroundColor: bgColor,
        elevation: 0.0,
        title: Text('Manual',style: GoogleFonts.lato(
          color: white,
          fontSize: MediaQuery.of(context).size.height/39
        ),),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/24, right: MediaQuery.of(context).size.width/24, top: MediaQuery.of(context).size.height/78),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height:_height/78 ,
              ),
              image(_height),
              SizedBox(
                height:_height/39 ,
              ),
              ManualTile(
                  title: 'Note:\n',
                  description:
                      "Enable AUTOSTART option in settings for Oppo,Vivo,Realme,Xioami and Samsung devices so that you can receive notifications even if the app is terminated."),
              SizedBox(
                height: MediaQuery.of(context).size.height/78,
              ),
              ManualTile(
                title: 'Working\n',
                description: '',
              ),
              ManualTile(
                title: '1.\t',
                description: "You have to use our app for two times per day.",
              ),
              ManualTile(
                title: '2.\t',
                description:
                    "Once before going to sleep,you have to record your time in which you are going to bed by going on to your List of Alarms->Click on 'Go to Sleep'.",
              ),
              ManualTile(
                title: '3.\t',
                description:
                    "Please set up  a alarm notification.It will only act as a reminder NOT as an ALARM",
              ),
              ManualTile(
                title: '4.\t',
                description:
                    "You can click on that notification and choose your wake time that has to be recorded.",
              ),
              ManualTile(
                title: '5.\t',
                description:
                    "This steps have to be repeated everyday to save your records and dont forget to save your time whenever you are going to bed.",
              ),
              ManualTile(
                title: '6.\t',
                description:
                    "After 10 days you will be greeted with your analytics report.Thank you.",
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/78,
              ),
              ManualTile(
                  title: 'Beta Version 1.0.0\n',
                  description:
                      "This app is under beta version.Any corrections is appreciated.Please do give your feedback"),
            ],
          ),
        ),
      ),
    );
  }
  Widget image(double height) {
    return Container(
      height: height/4.81,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/manual.png'),
              fit: BoxFit.contain)),
    );
  }

}
