import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogLisTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  DialogLisTile({this.icon, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      leading: Icon(icon, color: Colors.white,),
      onTap: onTap,
      title: Text(label, style: GoogleFonts.lato(
          fontSize: MediaQuery
              .of(context)
              .size
              .height / 52,
          color: Colors.white,
          fontWeight: FontWeight.w400)),
    );
  }

}