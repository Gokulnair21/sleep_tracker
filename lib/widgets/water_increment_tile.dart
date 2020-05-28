import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IncrementButton extends StatelessWidget {
  final int label;
  final Function function;

  IncrementButton({this.label, this.function});

  final Color bgColor = Color(0xff292a50);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap: function,
        child: Card(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/36, right: MediaQuery.of(context).size.width/36, top:MediaQuery.of(context).size.height/156, bottom: MediaQuery.of(context).size.height/156),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          color: Colors.white,
          elevation: 10.0,
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height/78,
                ),
                Container(
                  height: MediaQuery.of(context).size.height/39,
                  width: MediaQuery.of(context).size.height/39,
                  child: Image.asset(
                    "assets/images/rain_drops.png",
                    fit: BoxFit.fill,
                  ),
                ),
                FittedBox(
                  child: Text(
                    '$label',
                    style: GoogleFonts.lato(color: Color(0xff1273EB),fontSize: MediaQuery.of(context).size.height/60),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
