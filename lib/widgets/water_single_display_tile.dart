import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_tracker/model/water_model.dart';
class WaterSingleListTile extends StatelessWidget{
  final Water water;
  WaterSingleListTile({this.water,this.heightOfTile,this.imageHeight,this.fontSizeL});

  final white=Colors.white;
  final double heightOfTile;
  final double imageHeight;
  final double fontSizeL;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.only(top: 5,bottom: 5),
        height:heightOfTile,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width/36,
            ),
            Image.asset(
              "assets/images/rain_drops.png",
              width: imageHeight,height: imageHeight,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width/36,
            ),
            Expanded(
              child: Container(
                child: Text('${water.drank}ml',style: GoogleFonts.lato(color: white,fontSize: fontSizeL),),
              ),
            ),
            Container(
              child: Text('${water.time}',style: GoogleFonts.lato(color: white,fontSize: fontSizeL),),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width/18,
            ),
          ],
        )
    );

  }

}