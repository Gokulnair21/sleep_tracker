import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final bool autoFocus;

  TextInput({this.controller, this.hintText, this.inputType, this.autoFocus});

  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);
  final Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
        style: GoogleFonts.lato(fontWeight: FontWeight.w500, color: white,),
        keyboardType: inputType,
        controller: controller,
        cursorColor: butColor,
        autofocus: autoFocus,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill this field';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.lato(
                color: white.withAlpha(150),
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height/60,
                ),
            errorStyle: TextStyle(
              color: Colors.yellow,
            ),
            focusedBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: butColor))));

  }

}
