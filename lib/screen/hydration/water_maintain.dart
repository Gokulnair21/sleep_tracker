import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:sleep_tracker/HelperFiles/user_info_helper_class.dart';
import 'package:sleep_tracker/HelperFiles/water_log_helper_class.dart';
//my imports
import 'package:sleep_tracker/bloc/water_bloc.dart';
import 'package:sleep_tracker/bloc/water_log_bloc.dart';
import 'package:sleep_tracker/model/graph.dart';
import 'package:sleep_tracker/model/user_info_model.dart';
import 'package:sleep_tracker/model/water_log_model.dart';
import 'package:sleep_tracker/model/water_model.dart';
import 'package:sleep_tracker/screen/SplashScreens/splashScreen.dart';
import 'package:sleep_tracker/screen/hydration/today_hydration_record.dart';
import 'package:sleep_tracker/widgets/beverage_choose_button.dart';
import 'package:sleep_tracker/widgets/charts_widget.dart';
import 'package:sleep_tracker/widgets/text_input_controller.dart';
import 'package:sleep_tracker/widgets/water_increment_tile.dart';
import 'package:sleep_tracker/widgets/water_single_display_tile.dart';

class Hydration extends StatefulWidget {
  final WaterLogData waterLogData;

  Hydration({this.waterLogData});

  @override
  _HydrationState createState() => _HydrationState();
}

class _HydrationState extends State<Hydration> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  Gradient myHighColor = LinearGradient(
      colors: [
        Color(0xffd587ff),
        Color(0xffc58eff),
        Color(0xff8ea2fe),
        Color(0xff88a4fd),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [0.0, 0.3, 0.6, 0.9]);

  double _value;
  int idealGlass;
  int waterDrank;
  String _currentValue = '';
  String time;
  int tea=1;
  int coffee=2;
  int soda=3;
  int juice=4;
  int water=0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _controller;
  final _keyWaterDialog = GlobalKey<FormState>();

  final hourTC = TextEditingController();
  final minuteTC = TextEditingController();
  static final List<String> period = ['AM', 'PM'];

  User user;

  List<Graph> graphData = [];

  void initiateSharedPreference() async {
    user=await UserInfoDatabaseHelper.db.getUserInfo(1);
    setState(() {
      idealGlass=user.idealWater;
      _value = valueCalculator();
    });
  }

  void getMyData() async {
    final List<Map<String, dynamic>> allRows =
        await WaterLogDatabaseHelper.db.getValueForGraph();
    setState(() {
      graphData = allRows.map((row) {
        final String day = row['day'].toString();
        final int drank = row['drank'];
        return Graph(day: day, hours: drank);
      }).toList();
    });
  }

  void initValues() {
    idealGlass = 0;
    waterLogBloc.update(widget.waterLogData);
    _value = 0;
    waterDrank = widget.waterLogData.drank;
    _currentValue = period[0];
  }

  //Instances
  final waterBloc = WaterBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiateSharedPreference();
    initValues();
    waterLogBloc.getWaterLog();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    // TODO: implement build
    return WillPopScope(
      onWillPop: () => goBack(),
      child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            elevation: 0.0,
            iconTheme: IconThemeData(color: butColor),
            backgroundColor: bgColor,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  updateWaterLog();
                  Navigator.pop(context);
                }),
            title: Text('Drink\tWater',
                style: GoogleFonts.lato(
                    fontSize: _height / 43.33,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: _height / 39,
                ),
                Center(
                  child: Container(
                    height: _height / 3,
                    width: _height / 3,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xff1273EB), width: 2)),
                    child: LiquidCircularProgressIndicator(
                        value: _value,
                        valueColor: AlwaysStoppedAnimation(Color(0xff1273EB)),
                        backgroundColor: Colors.transparent,
                        borderColor: bgColor,
                        borderWidth: 10.0,
                        direction: Axis.vertical,
                        center: FittedBox(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: '$waterDrank\n',
                                    style: GoogleFonts.lato(
                                        fontSize: _height / 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                                TextSpan(
                                    text: '${(_value * 100).floor()}%\t',
                                    style: GoogleFonts.lato(
                                        fontSize: _height /60,
                                        color: white,
                                        fontWeight: FontWeight.w700)),
                                TextSpan(
                                    text: '\tGoal\t$idealGlass',
                                    style: GoogleFonts.lato(
                                        fontSize: _height /60,
                                        color: white,
                                        fontWeight: FontWeight.w700)),
                              ])),
                        )),
                  ),
                ),
                SizedBox(
                  height: _height / 26,
                ),
                rowUpdate(),
                SizedBox(
                  height: _height / 26,
                ),
                Container(
                  child: Center(
                    child: RaisedButton(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: butColor,
                        child: Text('Record a drink',
                            style:
                                GoogleFonts.lato(color: bgColor, fontSize: _height/39)),
                        onPressed: () {
                          bottomSheet(context, widget.waterLogData);
                        }),
                  ),
                ),
                SizedBox(
                  height: _height / 26,
                ),
                Container(
                  //height:  _height/4.93,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 2.0,
                    color: bgColor.withAlpha(150),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            height:  _height/26,
                            width: _width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: _width/72,
                                ),
                                Expanded(
                                    child: Container(
                                        height: _height/31.2,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Today's water drinking record",
                                          style: GoogleFonts.lato(
                                              color: white, fontSize: 15),
                                        ))),
                                Container(
                                    height: _height/31.2,
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: white,
                                        size: _height/52,
                                      ),
                                      onPressed: () => navigate(context),
                                    )),
                                SizedBox(
                                  width: _width/72,
                                )
                              ],
                            )),
                        SizedBox(
                          height: _height/78,
                        ),
                        StreamBuilder<List<Water>>(
                          stream: waterBloc.water,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final water = snapshot.data;
//                              if (water.length <= 2) {
//                                return SplashScreen(
//                                    'Not enough data', _height / 43.33, 95);
//                              }
                              if (water.length ==1) {
                                return ListView.builder(
                                    itemCount: 1,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, int index) {
                                      Water item = water[index];
                                      return Dismissible(
                                          key: UniqueKey(),
                                          background: Container(
                                            alignment: Alignment.centerLeft,
                                            decoration:
                                            BoxDecoration(color: Colors.red),
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: white.withAlpha(150),
                                              //size: MediaQuery.of(context).size.height/15.6,
                                            ),
                                          ),
                                          direction: DismissDirection.startToEnd,
                                          onDismissed: (direction) {
                                            deleteData(item);
                                          },
                                          child: WaterSingleListTile(
                                            water: item,
                                            imageHeight: _height/39,
                                            fontSizeL: _height/52,
                                            heightOfTile: _height/39,
                                          ));
                                    });
                              }
                              if (water.length ==2) {
                                return ListView.builder(
                                    itemCount: 2,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, int index) {
                                      Water item = water[index];
                                      return Dismissible(
                                          key: UniqueKey(),
                                          background: Container(
                                            alignment: Alignment.centerLeft,
                                            decoration:
                                            BoxDecoration(color: Colors.red),
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: white.withAlpha(150),
                                              //size: MediaQuery.of(context).size.height/15.6,
                                            ),
                                          ),
                                          direction: DismissDirection.startToEnd,
                                          onDismissed: (direction) {
                                            deleteData(item);
                                          },
                                          child: WaterSingleListTile(
                                            water: item,
                                            imageHeight: _height/39,
                                            fontSizeL: _height/52,
                                            heightOfTile: _height/39,
                                          ));
                                    });
                              }
                              if (water.length ==0) {
                                return SplashScreen(
                                    'Not data', _height / 43.33, 30);
                              }
                              return ListView.builder(
                                  itemCount: 3,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemBuilder: (context, int index) {
                                    Water item = water[index];
                                    return Dismissible(
                                        key: UniqueKey(),
                                        background: Container(
                                          alignment: Alignment.centerLeft,
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: white.withAlpha(150),
                                            //size: MediaQuery.of(context).size.height/15.6,
                                          ),
                                        ),
                                        direction: DismissDirection.startToEnd,
                                        onDismissed: (direction) {
                                          deleteData(item);
                                        },
                                        child: WaterSingleListTile(
                                          water: item,
                                          imageHeight: _height/39,
                                          fontSizeL: _height/52,
                                          heightOfTile: _height/39,
                                        ));
                                  });
                            }
                            return SplashScreen('No data', _height / 43.33, _height/8.21);
                          },
                        ),
                        SizedBox(
                          height: _height/78,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _height / 52,
                ),
                SizedBox(
                  width: _width,
                  height: _height/19.5,
                  child: Card(
                    elevation: 5.0,
                    color: bgColor,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: butColor,
                        width: 1.0,
                      ),
                    ),
                    margin: EdgeInsets.only(left: _width/12, right: _width/12),
                    child: Center(
                      child: Text(
                        'Post 7 days record',
                        style: GoogleFonts.lato(color: butColor, fontSize: _height/52),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _height / 52,
                ),
                Container(
                  padding: EdgeInsets.only(left: _width/18, right: _width/18),
                  height: _height / 5.2,
                  width:  _width,
                  child: ShaderMask(
                    child: Graphofsleep(
                      data: graphData,
                      id: 'Sleep',
                    ),
                    shaderCallback: (Rect bounds) {
                      return myHighColor.createShader(bounds);
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget rowUpdate() {
    return Container(
      height: MediaQuery.of(context).size.height/13,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width:  MediaQuery.of(context).size.width/72,
          ),
          Expanded(
            child: IncrementButton(
              label: 50,
              function: () => increment(50),
            ),
          ),
          Expanded(
            child: IncrementButton(
              label: 150,
              function: () => increment(150),
            ),
          ),
          Expanded(
            child: IncrementButton(
              label: 250,
              function: () => increment(250),
            ),
          ),
          Expanded(
            child: IncrementButton(
              label: 350,
              function: () => increment(350),
            ),
          ),
          Expanded(
            child: IncrementButton(
              label: 500,
              function: () => increment(500),
            ),
          ),
          SizedBox(
            width:  MediaQuery.of(context).size.width/72,
          )
        ],
      ),
    );
  }

  void bottomSheet(BuildContext context, WaterLogData item) {
    double _lowerValue = 50;
    double _upperValue = 180;

    int calValue=water;
    String choose='water';

    Color colorWater = butColor;
    Color colorTea = Colors.white;
    Color colorCoffee = Colors.white;
    Color colorSoda = Colors.white;
    Color colorJuice = Colors.white;

    DateTime now = DateTime.now();
    time = '${now.hour}:${now.minute}';
    _controller =
        scaffoldKey.currentState.showBottomSheet((context) => SafeArea(
              child: Container(
                  height: MediaQuery.of(context).size.height/2.08,
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/36, right: MediaQuery.of(context).size.width/36),
                  //margin: EdgeInsets.only(left: 10,right: 10,bottom: 50),
                  decoration: BoxDecoration(
                    color: appBarColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height/78,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height/45.88,
                          child: Text('Please select the type of the drink',
                              style: GoogleFonts.lato(
                                  color: white.withAlpha(150),
                                  fontSize: MediaQuery.of(context).size.height/60,
                                  fontWeight: FontWeight.w500))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/78,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height/9.62,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                _controller.setState(() {
                                  colorWater = butColor;
                                  colorJuice = white;
                                  colorSoda = white;
                                  colorCoffee = white;
                                  colorTea = white;
                                  choose='water';
                                  calValue=water*_lowerValue.floor();
                                });
                              },
                              child: drinkType("assets/images/rain_drops.png",
                                  'Water', colorWater),
                            )),
                            Expanded(
                                child: InkWell(
                                    onTap: () {
                                      _controller.setState(() {
                                        colorWater = white;
                                        colorJuice = white;
                                        colorSoda = white;
                                        colorCoffee = white;
                                        colorTea = butColor;
                                        choose='tea';
                                        calValue=tea*_lowerValue.floor();
                                      });
                                    },
                                    child: drinkType("assets/images/tea.png",
                                        'Tea', colorTea))),
                            Expanded(
                                child: InkWell(
                                    onTap: () {
                                      _controller.setState(() {
                                        colorWater = white;
                                        colorJuice = white;
                                        colorSoda = white;
                                        colorCoffee = butColor;
                                        colorTea = white;
                                        choose='coffee';
                                        calValue=coffee*_lowerValue.floor();
                                      });
                                    },
                                    child: drinkType("assets/images/beans.png",
                                        'Coffee', colorCoffee))),
                            Expanded(
                                child: InkWell(
                                    onTap: () {
                                      _controller.setState(() {
                                        colorWater = white;
                                        colorJuice = white;
                                        colorSoda = butColor;
                                        colorCoffee = white;
                                        colorTea = white;
                                        choose='soda';
                                        calValue=soda*_lowerValue.floor();
                                      });
                                    },
                                    child: drinkType("assets/images/soda.png",
                                        'Soda', colorSoda))),
                            Expanded(
                                child: InkWell(
                                    onTap: () {
                                      _controller.setState(() {
                                        colorWater = white;
                                        colorJuice = butColor;
                                        colorSoda = white;
                                        colorCoffee = white;
                                        colorTea = white;
                                        choose='juice';
                                        calValue=juice*_lowerValue.floor();
                                      });
                                    },
                                    child: drinkType("assets/images/juice.png",
                                        'Juice', colorJuice)))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/39,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height/45.88,
                          child: Text('Please select volume of drink',
                              style: GoogleFonts.lato(
                                  color: white.withAlpha(150),
                                  fontSize: MediaQuery.of(context).size.height/60,
                                  fontWeight: FontWeight.w500))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/78,
                      ),
                      Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height/37.14,
                          child: Text(
                            '${_lowerValue.toInt()}\tml',
                            style: GoogleFonts.lato(
                                color: butColor,
                                fontSize: MediaQuery.of(context).size.height/39,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/78,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height/19.5,
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap:(){
                                if(_lowerValue>0){
                                  _controller.setState(() {
                                    _lowerValue-=1;
                                    calValue=beveragechoose(choose)*_lowerValue.toInt();
                                  });
                                }

                                },
                              child: CircleAvatar(
                                radius: MediaQuery.of(context).size.height/52,
                                backgroundColor: butColor,
                                child: Icon(Icons.remove,color: appBarColor,),
                              ),
                            ),
                            Expanded(
                              child: FlutterSlider(
                                tooltip: FlutterSliderTooltip(
                                  disabled: true,
                                ),
                                trackBar: FlutterSliderTrackBar(
                                  inactiveTrackBar: BoxDecoration(
                                    color: white,
                                  ),
                                  activeTrackBar: BoxDecoration(color: butColor),
                                ),
                                values: [_lowerValue, _upperValue],
                                max: 500,
                                min: 0,
                                onDragging: (handlerIndex, lowerValue, upperValue) {
                                  _lowerValue = lowerValue;
                                  _upperValue = upperValue;
                                  calValue=beveragechoose(choose)*_lowerValue.toInt();
                                  _controller.setState(() {});
                                },
                              ),
                            ),
                            InkWell(
                              onTap:(){
                                if(_lowerValue<500){
                                  _controller.setState(() {
                                    _lowerValue+=1;
                                    calValue=beveragechoose(choose)*_lowerValue.toInt();
                                  });
                                }

                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: butColor,
                                child: Icon(Icons.add,color: appBarColor,),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/78,
                      ),
                      Container(
                        alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height/45.88,
                          child: Text('Contains\t$calValue\tcal',
                              style: GoogleFonts.lato(
                                  color: white.withAlpha(150),
                                  fontSize: MediaQuery.of(context).size.height/60,
                                  fontWeight: FontWeight.w500))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/78,
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        elevation: 5.0,
                        color: bgColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: GestureDetector(
                          onTap: () {
                            dialogBox(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height/19.5,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width:  MediaQuery.of(context).size.width/36,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text('Drank At',
                                        style: GoogleFonts.lato(
                                            color: white,
                                            fontSize: MediaQuery.of(context).size.height/52,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                Container(
                                  child: Text(time,
                                      style: GoogleFonts.lato(
                                          color: white,
                                          fontSize: MediaQuery.of(context).size.height/52,
                                          fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  width:  MediaQuery.of(context).size.width/36,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/39,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height/19.5,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                child: Text('Cancel',
                                    style: GoogleFonts.lato(
                                        color: butColor,
                                        fontSize: MediaQuery.of(context).size.height/39,
                                        fontWeight: FontWeight.w600)),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            Expanded(
                              child: FlatButton(
                                child: Text('Done',
                                    style: GoogleFonts.lato(
                                        color: butColor,
                                        fontSize: MediaQuery.of(context).size.height/39,
                                        fontWeight: FontWeight.w600)),
                                onPressed: () {
                                  Water water = Water(drank: 0, time: '');
                                  water.drank = _lowerValue.floor();
                                  water.time = time;
                                  increment(_lowerValue.floor());
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ));
  }

  Widget drinkType(String path, String label, Color color) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BeverageButton(
            imagePath: path,
            color: color,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/156,
          ),
          FittedBox(
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      color: color, fontSize: MediaQuery.of(context).size.height/60, fontWeight: FontWeight.w500)))
        ],
      ),
    );
  }

  void dialogBox(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              elevation: 4.0,
              backgroundColor: bgColor,
              child: Form(
                key: _keyWaterDialog,
                child: Container(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height:_height/78,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: _width/24, right: _width/24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: TextInput(
                                  autoFocus: true,
                                  controller: hourTC,
                                  inputType: TextInputType.number,
                                  hintText: 'Hour',
                                ),
                              ),
                              Expanded(
                                child: TextInput(
                                  autoFocus: true,
                                  controller: minuteTC,
                                  inputType: TextInputType.number,
                                  hintText: 'Minute',
                                ),
                              ),
                              Expanded(
                                  child: DropdownButton<String>(
                                      dropdownColor: bgColor,
                                      items: period.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: GoogleFonts.lato(
                                                  color: white,
                                                  fontWeight: FontWeight.w500)),
                                        );
                                      }).toList(),
                                      value: _currentValue,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _currentValue = newValue;
                                        });
                                      }))
                            ],
                          )),
                      SizedBox(
                        height: _height/52,
                      ),
                      Container(
                        height: _height/19.5,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel',
                                      style: GoogleFonts.lato(
                                          fontSize: _height/60,
                                          color: white,
                                          fontWeight: FontWeight.w500))),
                            ),
                            Expanded(
                              child: FlatButton(
                                  onPressed: saveLabel,
                                  child: Text('Save',
                                      style: GoogleFonts.lato(
                                          fontSize: _height/60,
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
      },
    );
  }


  void saveLabel() async {
    if (_keyWaterDialog.currentState.validate()) {
      if (int.parse(hourTC.text.toString()) < 13 &&
          int.parse(minuteTC.text.toString()) < 61) {
        if (_currentValue == 'AM') {
          _controller.setState(() {
            time =
                '${int.parse(hourTC.text.toString())}:${int.parse(minuteTC.text.toString())}';
          });
        } else {
          _controller.setState(() {
            time =
                '${int.parse(hourTC.text.toString()) + 12}:${int.parse(minuteTC.text.toString())}';
          });
        }
      } else {
        hourTC.clear();
        minuteTC.clear();
      }
      Navigator.pop(context);
    }
  }

  void navigate(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodayHydration()));
  }

  double valueCalculator() {
    if (waterDrank >= idealGlass) {
      return 1.0;
    } else {
      return (waterDrank / idealGlass);
    }
  }

  void increment(int drank) async {
    DateTime now = DateTime.now();
    Water water = Water(time: '', drank: 0);
    water.time = '${now.hour}:${now.minute}';
    water.drank = drank;
    waterBloc.add(water);
    if (waterDrank >= idealGlass) {
      waterDrank = waterDrank + drank;
    } else {
      waterDrank = waterDrank + drank;
      _value = valueCalculator();
    }
    setState(() {});
  }

  void updateWaterLog() async {
    widget.waterLogData.drank = waterDrank;
    await waterLogBloc.update(widget.waterLogData);
  }

  Future<bool> goBack() async {
    updateWaterLog();
    return true;
  }

  void deleteData(Water item) {
    waterDrank = waterDrank - item.drank;
    waterBloc.delete(item.id);
    _value = valueCalculator();
    setState(() {});
  }
  int beveragechoose(String index)
  {
    switch (index){
      case 'water':
        return water;
        break;
      case 'tea':
        return tea;
        break;
      case 'coffee':
        return coffee;
        break;
      case 'juice':
        return juice;
        break;
      case 'soda':
        return soda;
        break;
    }
    return water;
  }

}
