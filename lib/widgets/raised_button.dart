import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRaisedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  CustomRaisedButton({this.onPressed, this.label});

  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RaisedButton(
      elevation: 2.0,
      color: butColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(label,
            style: GoogleFonts.lato(
                color: bgColor,
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.height/43.33)),
      ),
    );
  }
}
