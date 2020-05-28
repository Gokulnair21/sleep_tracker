import 'package:flutter/material.dart';

//my imports
import 'package:sleep_tracker/screen/SplashScreens/splashscreen_home_navigator.dart';
import 'package:sleep_tracker/Service/service_locator.dart';

//my imports

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        buttonColor:butColor,
        bottomSheetTheme:BottomSheetThemeData(backgroundColor: bgColor) ,
        accentColor: Colors.transparent,
      ),
      home: SplashScreenHome(),
    );
  }
}
