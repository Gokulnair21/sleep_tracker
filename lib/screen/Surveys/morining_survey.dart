import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../home_main_page.dart';

class ReviewOfSleep extends StatefulWidget {
  @override
  _ReviewOfSleepState createState() => _ReviewOfSleepState();
}

class _ReviewOfSleepState extends State<ReviewOfSleep> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  String _currentRating1;
  String _currentRating2;
  double rating1;
  double rating2;
  int idC1;
  int idC2;
  int idC3;
  bool currentCheck1;
  bool currentCheck2;
  bool currentCheck3;

  List<Color> revColor = [
    Colors.white.withAlpha(100),
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _currentRating1 = 'Please rate it';
    _currentRating2 = 'Please rate it';
    rating1 = 0.0;
    rating2 = 0.0;
    currentCheck1 = false;
    currentCheck2 = false;
    currentCheck3 = false;
    idC1 = 0;
    idC2 = 0;
    idC3 = 0;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
          body: Material(
        child: Container(
          decoration: BoxDecoration(color: bgColor),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                reviewAppbar(),
                SizedBox(
                  height: MediaQuery.of(context).size.height/39,
                ),
                Container(
                    padding: EdgeInsets.only(left: 20, right: 0),
                    child: Text(
                      'Time to fall asleep',
                      style: GoogleFonts.lato(
                        color: white,
                        fontSize: MediaQuery.of(context).size.height/39,
                        fontWeight: FontWeight.w700,
                        
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height/78,
                ),
                reviewWithTime(),
                Padding(
                  padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/18, right: MediaQuery.of(context).size.width/18),
                  child: Divider(
                    color: Colors.white.withAlpha(70),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/39,
                ),
                reviewSleepQuality(),
                Padding(
                  padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/18, right: MediaQuery.of(context).size.width/18),
                  child: Divider(
                    color: Colors.white.withAlpha(70),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/39,
                ),
                reviewRefreshQuality(),
                Padding(
                  padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/18, right: MediaQuery.of(context).size.width/18),
                  child: Divider(
                    color: Colors.white.withAlpha(70),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/78,
                ),
                Container(
                    padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/18, right: MediaQuery.of(context).size.width/18),
                    child: Text(
                      'Answering these questions will help us to build more accurate and wonderful sleep plan',
                      style: GoogleFonts.lato(
                        color: white.withAlpha(100),
                        fontSize: MediaQuery.of(context).size.height/65,
                        fontWeight: FontWeight.w700,
                        
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height/15.6,
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/18, 0, MediaQuery.of(context).size.width/18, MediaQuery.of(context).size.height/19.5),
                    height: MediaQuery.of(context).size.height/15.6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: butColor, width: 1.0)),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/36),
                            child: Text(
                              'Start\tmy\tday',
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: MediaQuery.of(context).size.height/39,
                                  color: butColor,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: butColor),
                          child: IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_right,
                              color: bgColor,
                              size: MediaQuery.of(context).size.height/15.6,
                            ),
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomeNavigation()));
                            },
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget reviewAppbar() {
    return Container(
        decoration: BoxDecoration(color: bgColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 0, right: MediaQuery.of(context).size.width/18),
                alignment: Alignment(1, 0),
                child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: butColor,
                      size: MediaQuery.of(context).size.height/15.6,
                    ),
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => HomeNavigation())))),
            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/18, right: 0),
              child: Text(
                'Morning Survey',
                style: GoogleFonts.lato(
                  color: white,
                  fontSize: MediaQuery.of(context).size.height/31.2,
                  fontWeight: FontWeight.w700,
                  
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/78,
            )
          ],
        ));
  }

  Widget reviewWithTime() {
    return Container(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/18, right: MediaQuery.of(context).size.width/18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Checkbox(
                      value: currentCheck1,
                      onChanged: (value) {
                        setState(() {
                          currentCheck1 = value;
                          if (currentCheck1) {
                            currentCheck3 = false;
                            currentCheck2 = false;
                            idC2 = 0;
                            idC3 = 0;
                            idC1 = 1;
                          }
                        });
                      },
                      focusColor: butColor,
                      checkColor: bgColor,
                      activeColor: butColor,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    '0-10\nminutes',
                    style: GoogleFonts.lato(
                      color: revColor[idC1],
                      fontSize: MediaQuery.of(context).size.height/65,
                      fontWeight: FontWeight.w700,
                      
                    ),
                  ))
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Checkbox(
                      value: currentCheck2,
                      onChanged: (value) {
                        setState(() {
                          currentCheck2 = value;
                          if (currentCheck2) {
                            currentCheck1 = false;
                            currentCheck3 = false;
                            idC2 = 1;
                            idC3 = 0;
                            idC1 = 0;
                          }
                        });
                      },
                      focusColor: butColor,
                      checkColor: bgColor,
                      activeColor: butColor,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    '10-15\nminutes',
                    style: GoogleFonts.lato(
                      color: revColor[idC2],
                      fontSize: MediaQuery.of(context).size.height/65,
                      fontWeight: FontWeight.w700,
                      
                    ),
                  ))
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Checkbox(
                      value: currentCheck3,
                      onChanged: (value) {
                        setState(() {
                          currentCheck3 = value;
                          if (currentCheck3) {
                            currentCheck1 = false;
                            currentCheck2 = false;
                            idC2 = 0;
                            idC3 = 1;
                            idC1 = 0;
                          }
                        });
                      },
                      focusColor: butColor,
                      checkColor: bgColor,
                      activeColor: butColor,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    '20-30\nminutes',
                    style: GoogleFonts.lato(
                      color: revColor[idC3],
                      fontSize: MediaQuery.of(context).size.height/65,
                      fontWeight: FontWeight.w700,
                      
                    ),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget reviewSleepQuality() {
    return Container(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/18, right: MediaQuery.of(context).size.width/18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Text(
            'HOW WOULD YOU RATE YOUR SLEEP QUALITY?',
            style: GoogleFonts.lato(
              color: white.withAlpha(200),
              fontSize: MediaQuery.of(context).size.height/65,
              fontWeight: FontWeight.w500,
              
            ),
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height/52,
          ),
          Container(
            child: Text(
              _currentRating1,
              style: GoogleFonts.lato(
                color: white,
                fontSize: MediaQuery.of(context).size.height/31.2,
                fontWeight: FontWeight.w700,
                
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/78,
          ),
          Container(
            child: SmoothStarRating(
              allowHalfRating: false,
              onRated: (value) {
                rating1 = value;
                int temp = rating1.toInt();
                changeRateSleepQuality(temp);
              },
              starCount: 5,
              filledIconData: Icons.star,
              // defaultIconData: Icons.star_border,
              rating: rating1,
              size: MediaQuery.of(context).size.height/19.5,
              color: butColor,
              borderColor: butColor,
              spacing: 2.0,
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget reviewRefreshQuality() {
    return Container(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/18, right: MediaQuery.of(context).size.width/18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Text(
            'RATE HOW REFRESHED AND WELL-RTATED DO YOU FELL IN THE MORNING',
            style: GoogleFonts.lato(
              color: white.withAlpha(200),
              fontSize: MediaQuery.of(context).size.height/65,
              fontWeight: FontWeight.w500,
              
            ),
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height/52,
          ),
          Container(
            child: Text(
              _currentRating2,
              style: GoogleFonts.lato(
                color: white,
                fontSize: MediaQuery.of(context).size.height/31.2,
                fontWeight: FontWeight.w700,
                
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width/78,
          ),
          Container(
            child: SmoothStarRating(
              allowHalfRating: false,
              onRated: (value) {
                rating2 = value;
                int temp = rating2.toInt();
                changeRateRefreshQuality(temp);
              },
              starCount: 5,
              filledIconData: Icons.star,
              // defaultIconData: Icons.star_border,
              rating: rating2,
              size: MediaQuery.of(context).size.height/19.5,
              color: butColor,
              borderColor: butColor,
              spacing: 2.0,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/78,
          )
        ],
      ),
    );
  }

  void changeRateSleepQuality(int temp) {
    switch (temp) {
      case 0:
        setState(() {
          _currentRating1 = 'Please rate it';
        });
        break;
      case 1:
        setState(() {
          _currentRating1 = 'Poor';
        });
        break;
      case 2:
        setState(() {
          _currentRating1 = 'Average';
        });
        break;
      case 3:
        setState(() {
          _currentRating1 = 'Good';
        });

        break;
      case 4:
        setState(() {
          _currentRating1 = 'Very Good';
        });

        break;
      case 5:
        setState(() {
          _currentRating1 = 'Awesome';
        });

        break;
    }
  }

  void changeRateRefreshQuality(int temp) {
    switch (temp) {
      case 0:
        setState(() {
          _currentRating2 = 'Please rate it';
        });
        break;
      case 1:
        setState(() {
          _currentRating2 = 'Poor';
        });
        break;
      case 2:
        setState(() {
          _currentRating2 = 'Average';
        });
        break;
      case 3:
        setState(() {
          _currentRating2 = 'Good';
        });

        break;
      case 4:
        setState(() {
          _currentRating2 = 'Very Good';
        });

        break;
      case 5:
        setState(() {
          _currentRating2 = 'Awesome';
        });

        break;
    }
  }
}
