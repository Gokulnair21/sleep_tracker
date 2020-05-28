import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_tracker/bloc/water_bloc.dart';
import 'package:sleep_tracker/model/water_model.dart';
import 'package:sleep_tracker/screen/SplashScreens/no_data_screen.dart';
import 'package:sleep_tracker/widgets/water_single_display_tile.dart';
class TodayHydration extends StatelessWidget{

  final waterBloc=WaterBloc();
  final white=Colors.white;

  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);

  @override
  Widget build(BuildContext context) {

    double _height = MediaQuery.of(context).size.height;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: butColor),
        backgroundColor: bgColor,
        title: Text("Today's water drinking record",
            style: GoogleFonts.lato(
                fontSize: _height/ 43.33,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
      ),
      body: StreamBuilder(
        stream: waterBloc.water,
          builder: (context,snapshot)
      {
        if(snapshot.hasData)
        {
          final water = snapshot.data;
          if(water.isEmpty)
            {
              return SplashScreenSleepLog(
                label: 'No record yet',
                imagePath: 'assets/images/nodatapad.png',
                spacing: 5,
                width: MediaQuery.of(context).size.width/2.25,
              );
            }
          return ListView.builder(
              itemCount: water.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context,int index){
                Water item=water[index];
                return  WaterSingleListTile(water:item,imageHeight: _height/26,fontSizeL: _height/48.75,heightOfTile: 50,);
              });
        }
        return SizedBox();
      }),

    );
  }


}