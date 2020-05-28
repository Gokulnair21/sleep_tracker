import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BeverageButton extends StatelessWidget {
  final String imagePath;
  final Function function;
  final Color color;

  BeverageButton({this.imagePath, this.function,this.color});

  final Color bgColor = Color(0xff292a50);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/36, right: MediaQuery.of(context).size.width/36, top: MediaQuery.of(context).size.height/156, bottom: MediaQuery.of(context).size.height/156),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          color: color,
          elevation: 10.0,
          child: Container(
            height: MediaQuery.of(context).size.height/16.25,
            alignment: Alignment.center,
            child:Image.asset(imagePath,height: MediaQuery.of(context).size.height/39,width: MediaQuery.of(context).size.height/39,),
          ),
        );
  }
}
//"assets/images/rain_drops.png"
