import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  final String title;
  final double size;
  final double height;

  SplashScreen(this.title,this.size,this.height);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: height,
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.lato(
              color: Colors.white.withAlpha(100),
              fontSize: size,
              fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );

  }
}
