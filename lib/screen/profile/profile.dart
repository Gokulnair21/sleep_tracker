import 'dart:io';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/bloc/user_info_bloc.dart';
import 'package:sleep_tracker/model/user_info_model.dart';
import 'package:url_launcher/url_launcher.dart';

//my imports
import 'package:sleep_tracker/screen/profile/settings/setting_interface.dart';
import 'package:sleep_tracker/screen/profile/view_profile_picture.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color profileCardColor = Color(0xff3d3c70);
  final Color fitnessCardColor = Color(0xff424284);
  final Color communityCardColor = Color(0xff3d377c);

  //static String mail = 'Upgrade for cloud storage';
  static String accountStatus = 'UPGRADE TO PREMIUM';
  static String connectedStatus = 'Disconnected';

  List<dynamic> dataCommunity = [
    {
      "image": "assets/images/instagram.png",
      "name": "Instagram",
      "url": "https://www.instagram.com/gokul2199"
    },
    {
      "image": "assets/images/facebook.png",
      "name": "Facebook",
      "url": "https://www.facebook.com/gokul.nair.3572846"
    },
    {
      "image": "assets/images/twitter.png",
      "name": "Twitter",
      "url": "https://twitter.com/NairGokul21"
    }
  ];

  List<String> deviceName = ['Apple\nwatch', 'Fitbit\nPro', 'Realme\nS45'];

  static File _image;

  void getInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _image =  File(sharedPreferences.getString('profilePicture'));
    });
  }

  void infoChecker() {
    _image=null;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    infoChecker();
    getInfo();
    userInfoBloc.getUserInfo();

  }

  @override
  Widget build(BuildContext context) {

    double _height=MediaQuery.of(context).size.height;
    double _width=MediaQuery.of(context).size.width;
    getInfo();

    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(left: _width/18, right: _width/18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder(
                    stream: userInfoBloc.user,
                      builder: (context, AsyncSnapshot<List<User>> snapshot){
                      if(snapshot.hasData)
                        {
                          User user=snapshot.data[0];
                          return topProfileCard(user);
                        }
                        return  Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(butColor),
                            ));
                      }
                  ),
                  //topProfileCard(),
                  SizedBox(
                    height: _height/78,
                  ),
                  Container(
                    child: Text(
                      'Partner Accounts',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          
                          color: white,
                          fontSize:MediaQuery.of(context).size.height/39),
                    ),
                  ),
                  SizedBox(
                    height: _height/52,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/5.2,
                    color: Colors.transparent,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return cardPartnerAccount(deviceName[index]);
                        }),
                  ),
                  SizedBox(
                    height: _height/52,
                  ),
                  Container(
                    child: Text(
                      'Community',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          
                          color: white,
                          fontSize:MediaQuery.of(context).size.height/39),
                    ),
                  ),
                  SizedBox(
                    height:  _height/52,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/6.5,
                    color: Colors.transparent,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return cardCommunity(
                              dataCommunity[index]['image'],
                              dataCommunity[index]['name'],
                              dataCommunity[index]['url']);
                        }),
                  ),
                  SizedBox(
                    height:  _height/78,
                  )
                ],
              )),
        ));
  }

  Widget topProfileCard(User user) {
        return Container(
          height: MediaQuery.of(context).size.height/3,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/15.6),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/3.9,
                decoration: BoxDecoration(color: profileCardColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height/13,
                    ),
                    Container(
                      height:  MediaQuery.of(context).size.height/26.2,
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width/18,
                      ),
                      child: FittedBox(
                        child: Text(
                          '${user.firstName.toUpperCase().substring(0, 1)}${user.firstName.toLowerCase().substring(1)}\t${user.lastName.toUpperCase().substring(0, 1)}${user.lastName.toLowerCase().substring(1)}',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              
                              color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height:  MediaQuery.of(context).size.height/39.0,
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/18, top: MediaQuery.of(context).size.height/156),
                      child: FittedBox(
                        child: Text(
                          'Age:${user.age}\t\tBMI:${user.bmi.toString().substring(0,5)}',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w400,
                              
                              color: Colors.white.withAlpha(150),
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/15.6,
                    ),
                    InkWell(
                      onTap: (){
                        Fluttertoast.showToast(msg: 'Not available yet');
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height/19.5,
                        width: double.infinity,
                        decoration: BoxDecoration(color: butColor),
                        child: FittedBox(
                          child: Text(
                            accountStatus,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                color: bgColor,
                                fontSize: MediaQuery.of(context).size.height/52),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/52,left: MediaQuery.of(context).size.width/18,),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      return ViewProfileImage(
                        image: _image,
                      );
                    }));
                  },
                  child: Container(
                    height: (MediaQuery.of(context).size.height/11.14),
                    width: (MediaQuery.of(context).size.height/11.14),
                    decoration: BoxDecoration(
                        color: bgColor,
                        border: Border.all(color: white, width: 1),
                        image: DecorationImage(
                            image: _image == null
                                ? AssetImage('assets/images/cardSleepToday.png')
                                : FileImage(
                              _image,
                            ),
                            fit: BoxFit.fill)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) {
                    return Settings();
                  }));
                },
                child: Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/13, left: MediaQuery.of(context).size.width/1.38),
                  height: MediaQuery.of(context).size.height/26,
                  width: MediaQuery.of(context).size.width/12,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Icon(
                    Icons.settings,
                    color: white.withAlpha(150),
                  ),
                ),
              ),
            ],
          ),
        );
  }

  Widget cardPartnerAccount(String deviceName) {
        return Container(
          height: MediaQuery.of(context).size.height / 5.2,
          width: MediaQuery.of(context).size.width/1.8,
          margin: EdgeInsets.only(right:  MediaQuery.of(context).size.width/36),
          decoration: BoxDecoration(color: fitnessCardColor),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height/156,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width/100,
                  top: MediaQuery.of(context).size.height/156,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width/72 ,
                    ),
                    Expanded(
                      child: Container(
                        child:Text(
                            deviceName,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w500,
                                
                                color: white,
                              fontSize: MediaQuery.of(context).size.height/39
                                ),
                          ),

                      ),
                    ),
                    Expanded(
                      child: Icon(
                        Icons.favorite,
                        size:MediaQuery.of(context).size.height/13,
                        color: Colors.white.withAlpha(50),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/39,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width/36,
                  top: MediaQuery.of(context).size.height/156,
                ),
                height: MediaQuery.of(context).size.height/15.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: butColor,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        //alignment: Alignment.center,
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width/180,
                          top: MediaQuery.of(context).size.height/195,
                        ),
                        child:Text(
                          connectedStatus,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                              
                              color: Colors.white.withAlpha(100),
                              fontSize: MediaQuery.of(context).size.height/60),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );


  }

  Widget cardCommunity(String image, String name, String url) {
        return GestureDetector(
          onTap: () {
            _launchUrl(url);
          },
          child: Container(
            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/36),
            height: MediaQuery.of(context).size.height/6.5,
            width: MediaQuery.of(context).size.width/1.38,
            decoration: BoxDecoration(color: communityCardColor),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height/45.88,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width/18,
                            height: MediaQuery.of(context).size.height/39,
                            child: Image.asset(
                              image,
                              fit: BoxFit.contain,
                            )),
                        Container(
                          child:  Text(
                              'My Sleep\nMoments',
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  
                                  color: white,
                                fontSize: MediaQuery.of(context).size.height/43.33
                                  ),
                            ),

                        ),
                        Container(
                          //height:MediaQuery.of(context).size.height/50 ,
                          child: Text(
                              'On\t$name',
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  
                                  color: Colors.white.withAlpha(100),
                                fontSize: MediaQuery.of(context).size.height/60
                                  ),
                            ),

                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height/6.5,
                    width: MediaQuery.of(context).size.width/2.76,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/communityBg.png',
                            ),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                                communityCardColor.withAlpha(30),
                                BlendMode.dstATop))),
                  ),
                )
              ],
            ),
          ),
        );


  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: 'Some error has occured');
      throw 'Could not launch $url';
    }
  }
}
