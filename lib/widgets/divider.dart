import 'package:flutter/material.dart';
class CustomDivider extends StatelessWidget{
  final Color white=Colors.white;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Divider(
      color: white.withAlpha(50),
    );
  }

}