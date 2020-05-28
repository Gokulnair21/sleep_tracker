import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//my imports
import 'today/today_home.dart';
import 'Overview/overview_home.dart';
import 'profile/profile.dart';

//My imports

class HomeNavigation extends StatefulWidget {
  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);
  String _title;
  //Profile()

  List<Widget> _children = [Today(), MySleep(),Profile() ];
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    initializeVariables();
  }

  void initializeVariables() {
    _currentIndex = 0;
    _title = 'Today';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        title: Text(
          _title,
          style: GoogleFonts.lato(
            fontSize: MediaQuery.of(context).size.height / 31.2,

            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          backgroundColor: bgColor,
          onItemSelected: (index) {
            onTap(index);
          },
          curve: Curves.easeInBack,
          items: [
            BottomNavyBarItem(
                icon: Icon(
                  Icons.today,
                  color: butColor,
                ),
                title: Text(
                  'Today',
                  style: GoogleFonts.lato(
                    color: white,
                  ),
                ),
                activeColor: appBarColor),
            BottomNavyBarItem(
                icon: Icon(Icons.history, color: butColor),
                title: Text(
                  'My Sleep',
                  style: GoogleFonts.lato(
                    color: white,
                  ),
                ),
                activeColor: appBarColor),
            BottomNavyBarItem(
                icon: Icon(Icons.person_outline, color: butColor),
                title: Text(
                  'Profile',
                  style: GoogleFonts.lato(
                    color: white,
                  ),
                ),
                activeColor: appBarColor)
          ]),
    );
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        _title = 'Today';
        break;
      case 1:
        _title = 'My\tSleep';
        break;
      case 2:
        _title = 'Profile';
        break;
    }
  }
}
