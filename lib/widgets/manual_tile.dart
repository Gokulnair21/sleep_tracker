import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManualTile extends StatelessWidget {
  final String description;
  final String title;

  ManualTile({this.title, this.description});

  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: '$title',
            style: GoogleFonts.lato(
                fontWeight: FontWeight.w700,
                color: butColor,
                fontSize: MediaQuery.of(context).size.height/45.88)),
        TextSpan(
            text: description,
            style: GoogleFonts.lato(
                fontWeight: FontWeight.w400,
                color: white,
                fontSize: MediaQuery.of(context).size.height/52))
      ])),
    );
  }
}
