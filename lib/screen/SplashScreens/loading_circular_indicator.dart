import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(butColor),
      )),
    );

  }
}
