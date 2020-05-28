import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenSleepLog extends StatelessWidget {
  final String imagePath;
  final String label;
  final double spacing;
  final double width;

  SplashScreenSleepLog({this.imagePath, this.label, this.spacing,this.width});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                imagePath,
                width: MediaQuery.of(context).size.width - width,
              ),
            ),
            SizedBox(
              height: spacing,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                label,
                style: GoogleFonts.lato(
                    color: Colors.white.withAlpha(150),
                    fontSize: MediaQuery.of(context).size.height/39,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
