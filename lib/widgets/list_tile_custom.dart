import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingListTile extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  SettingListTile({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
        contentPadding: EdgeInsets.only(left:15,right: 20),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: MediaQuery.of(context).size.height/52,
        ),
        title: Text(label,
            style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height/52,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
        onTap: onPressed);
  }
}
