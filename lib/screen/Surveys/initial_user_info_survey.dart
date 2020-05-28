import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sleep_tracker/bloc/user_info_bloc.dart';
import 'package:sleep_tracker/model/user_info_model.dart';
import 'package:sleep_tracker/widgets/list_tile_of_dialog_box.dart';

//my imports
import 'package:sleep_tracker/widgets/text_input_controller.dart';
import 'package:sleep_tracker/widgets/raised_button.dart';
import '../home_main_page.dart';

class InitialUserInfoSurvey extends StatefulWidget {
  final String appBarTitle;

  InitialUserInfoSurvey({this.appBarTitle});

  @override
  _InitialUserInfoSurveyState createState() => _InitialUserInfoSurveyState();
}

class _InitialUserInfoSurveyState extends State<InitialUserInfoSurvey> {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;
  final Color appBarColor = Color(0xff3e3567);

  //controllers
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final idealSleep = TextEditingController();
  final day = TextEditingController();
  final month = TextEditingController();
  final year = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();

  final _key = GlobalKey<FormState>();

  File _image;
  User user = User(id: 1, lastName: '', firstName: '');

  //;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bgColor,
        title: Text(widget.appBarTitle,
            style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height / 39,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 18,
              right: MediaQuery.of(context).size.width / 18,
              top: MediaQuery.of(context).size.height / 78),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                profilePicture(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 26,
                ),
                Container(
                    height: MediaQuery.of(context).size.height / 45.88,
                    child: Text('Name',
                        style: GoogleFonts.lato(
                            color: white,
                            fontSize: MediaQuery.of(context).size.height / 52,
                            fontWeight: FontWeight.w500))),
                SizedBox(
                  height: 5,
                ),
                TextInput(
                  controller: lastName,
                  autoFocus: true,
                  hintText: 'Lastname',
                  inputType: TextInputType.text,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 52,
                ),
                TextInput(
                  controller: firstName,
                  autoFocus: true,
                  hintText: 'FirstName',
                  inputType: TextInputType.text,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 39,
                ),
                Container(
                    height: MediaQuery.of(context).size.height / 45.88,
                    child: Text('Date of Birth',
                        style: GoogleFonts.lato(
                            color: white,
                            fontSize: MediaQuery.of(context).size.height / 52,
                            fontWeight: FontWeight.w500))),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 156,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextInput(
                          controller: day,
                          autoFocus: true,
                          hintText: 'Day',
                          inputType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 36,
                      ),
                      Expanded(
                        child: TextInput(
                          controller: month,
                          autoFocus: true,
                          hintText: 'Month',
                          inputType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 36,
                      ),
                      Expanded(
                          child: TextInput(
                        controller: year,
                        autoFocus: true,
                        hintText: 'Year',
                        inputType: TextInputType.number,
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 39,
                ),
                Container(
                    height: MediaQuery.of(context).size.height / 45.88,
                    child: Text('Body map',
                        style: GoogleFonts.lato(
                            color: white,
                            fontSize: MediaQuery.of(context).size.height / 52,
                            fontWeight: FontWeight.w500))),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextInput(
                          controller: height,
                          autoFocus: true,
                          hintText: 'Height(cm)',
                          inputType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 12,
                      ),
                      Expanded(
                        child: TextInput(
                          controller: weight,
                          autoFocus: true,
                          hintText: 'Weight(kg)',
                          inputType: TextInputType.number,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 52,
                ),
                Container(
                    height: MediaQuery.of(context).size.height / 45.88,
                    child: Text('Ideal sleep hours',
                        style: GoogleFonts.lato(
                            color: white,
                            fontSize: MediaQuery.of(context).size.height / 52,
                            fontWeight: FontWeight.w500))),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 156,
                ),
                TextInput(
                  controller: idealSleep,
                  autoFocus: true,
                  hintText: 'Hours',
                  inputType: TextInputType.number,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 26,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 19.5,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomRaisedButton(
                          onPressed: () async {
                            await save(context);
                          },
                          label: 'Proceed',
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.height / 19.5,
                      ),
                      Expanded(
                        child: CustomRaisedButton(
                          onPressed: clear,
                          label: 'Clear',
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profilePicture(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: butColor, width: 2)),
        child: InkWell(
          onTap: () {
            openDialogBox(context);
          },
          child: CircleAvatar(
            maxRadius: MediaQuery.of(context).size.height / 11.42,
            backgroundImage: _image == null
                ? AssetImage('assets/images/avatar.png')
                : FileImage(
                    _image,
                  ),
            backgroundColor: butColor,
          ),
        ),
      ),
    );
  }

  void openDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 4.0,
          backgroundColor: bgColor,
          child: Container(
            padding: EdgeInsets.only(left: 15),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                  child: Text('Add image',
                      style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.height / 52,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                ),
                DialogLisTile(
                  icon: Icons.camera_alt,
                  label: 'Take photo',
                  onTap: () {
                    getImageFromCamera();
                    Navigator.pop(context);
                  },
                ),
                DialogLisTile(
                    icon: Icons.image,
                    label: 'Choose image',
                    onTap: () {
                      getImageFromGallery();
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }
    setState(() {
      _image = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      _image = image;
    });
  }

  Future<void> imageSave() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path;
    var fileName = basename(_image.path);
    final File localImage = await _image.copy('$path/$fileName');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profilePicture', localImage.path.toString());
  }

  Future<void> save(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_key.currentState.validate()) {
      if (_image == null) {
        Fluttertoast.showToast(msg: 'Please add a profile picture');
      } else if (int.parse(day.text.toString()) > 31) {
        day.clear();
        Fluttertoast.showToast(msg: 'Invalid day');
      } else if (int.parse(month.text.toString()) > 12) {
        month.clear();
        Fluttertoast.showToast(msg: 'Invalid month');
      } else if (int.parse(month.text.toString()) == 2 &&
          int.parse(day.text.toString()) > 29) {
        day.clear();
        Fluttertoast.showToast(msg: 'Invalid day');
      } else if (int.parse(year.text.toString()) > (DateTime.now().year)) {
        year.clear();
        Fluttertoast.showToast(msg: 'Invalid year');
      } else {
        print('profile saved');
        imageSave();
        await sharedPreferences.setBool('seen', true);
        user.lastName = lastName.text.toString();
        user.firstName = firstName.text.toString();
        user.day = int.parse(day.text.toString());
        user.month = int.parse(month.text.toString());
        user.year = int.parse(year.text.toString());
        user.age = ageCalculator(
            int.parse(month.text.toString()), int.parse(year.text.toString()));
        user.bmi = bmiCalculator(num.parse(height.text.toString()),
            num.parse(weight.text.toString()));
        user.idealWater = 2100;
        user.weight = num.parse(weight.text.toString());
        user.height = num.parse(height.text.toString());
        user.idealSleep = int.parse(idealSleep.text.toString());
        userInfoBloc.add(user);
        Fluttertoast.showToast(msg: 'Profile Saved');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeNavigation()));
      }
    } else {
      Fluttertoast.showToast(msg: 'Error!Try again');
      clear();
    }
  }

  void clear() {
    setState(() {
      firstName.clear();
      lastName.clear();
      idealSleep.clear();
      firstName.clear();
      lastName.clear();
      height.clear();
      weight.clear();
      day.clear();
      month.clear();
      year.clear();
    });
  }

  Future<void> saveUserInfo(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_key.currentState.validate()) {
      if (_image == null) {
        Fluttertoast.showToast(msg: 'Please add a profile picture');
      } else {
        print('profile saved');
        imageSave();
        await sharedPreferences.setString('firstName', firstName.text);
        await sharedPreferences.setString('lastName', lastName.text);
        await sharedPreferences.setString('idealSleep', idealSleep.text);
        print(sharedPreferences.getString('idealSleep'));
        Fluttertoast.showToast(msg: 'Profile Saved');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeNavigation()));
      }
    } else {
      Fluttertoast.showToast(msg: 'Error!Try again');
      clear();
    }
  }

  int ageCalculator(int month, int year) {
    DateTime now = DateTime.now();
    if (now.month == month) {
      return ((now.year - year) + 1);
    } else {
      return (now.year - year);
    }
  }

  num bmiCalculator(num height, num weight) {
    height = height / 100;
    height = height * height;
    return ((weight / (height)));
  }
}
