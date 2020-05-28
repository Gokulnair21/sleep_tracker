import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

//my imports
import 'package:sleep_tracker/screen/Surveys/initial_user_info_survey.dart';
import 'package:sleep_tracker/widgets/manual_tile.dart';

class IntroScreens extends StatefulWidget {
  @override
  _IntroScreensState createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  List<Slide> slide = List();

  @override
  void initState() {
    super.initState();
    slide.add(
      new Slide(
        widgetTitle: Text("Our Motive",style: GoogleFonts.lato(
            fontSize:30,
            color: Colors.white,
            fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
        widgetDescription:  Text("This app will help you track your daily sleep in a easier and efficient way.Based on your sleep history we will be giving you a custom sleep timetable",style: GoogleFonts.lato(
            fontSize:20,
            color: Colors.white,
            fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
        pathImage: "assets/images/sleepTracker.png",
        backgroundColor: bgColor,
      ),
    );
    slide.add(
      new Slide(
        widgetTitle: Text('Lack of sleep',style: GoogleFonts.lato(
            fontSize:30,
            color: Colors.white,
            fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
        widgetDescription:  Text("Lack of sleep causes:\n1.Reduced brain function\n2.Delayed recovery\n3.Hormonal problems\n4.Low immunity\n5.Increased blood pressure ",style: GoogleFonts.lato(
            fontSize:20,
            color: Colors.white,
            fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
        pathImage: "assets/images/lack_of_sleep.png",
        backgroundColor: bgColor,
      ),
    );

    slide.add(
      new Slide(
        widgetTitle: Text('Manual',style: GoogleFonts.lato(
            fontSize:30,
            color: Colors.white,
            fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
        pathImage: "assets/images/manual.png",
        widgetDescription: myManualIntro(),
        backgroundColor: bgColor,
      ),
    );
  }

  void onDonePress() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (context) =>
            InitialUserInfoSurvey(appBarTitle: 'Personal Information')));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new IntroSlider(
      styleNameDoneBtn: GoogleFonts.lato(
          color: Colors.white,
          fontWeight: FontWeight.w500) ,
      styleNameSkipBtn:GoogleFonts.lato(
          color: Colors.white,
          fontWeight: FontWeight.w500)  ,
      highlightColorDoneBtn: butColor,
      highlightColorSkipBtn: butColor,
      colorActiveDot: butColor,
      slides: this.slide,
      onDonePress: this.onDonePress,
    );
  }

  Widget myManualIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ManualTile(
            title: 'Note:\n\n',
            description:
                "Enable AUTOSTART option in settings for Oppo,Vivo,Realme,Xioami and Samsung devices so that you can receive notifications even if the app is terminated."),
        SizedBox(
          height: 10,
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
      ],
    );
  }
}
