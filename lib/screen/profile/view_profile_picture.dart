import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ViewProfileImage extends StatelessWidget{
 final  File image;
 ViewProfileImage({this.image});
  final Color butColor = Color(0xfffeb787);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile pic',
            style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height / 39,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          opacity: 5.0,
          color: butColor
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context)),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: LayoutBuilder(
          builder: (context,constraints){
            return Container(
              height: constraints.maxWidth,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: butColor,width: 1
                ),
                  image: DecorationImage(
                      image: image == null
                          ? AssetImage('assets/images/cardSleepToday.png')
                          : FileImage(
                        image,
                      ),fit: BoxFit.contain)
              ),
            );
          },
        )
      ),
    );
  }

}