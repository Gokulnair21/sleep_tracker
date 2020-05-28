import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:sleep_tracker/model/graph.dart';

class Graphofsleep extends StatelessWidget {
  final List<Graph> data;
  final String id;

  final Color butColor = Color(0xfffeb787);
  final Color bgColor = Color(0xff292a50);

  Graphofsleep({this.data,this.id});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<charts.Series<Graph, String>> series = [
      charts.Series(
          id: id,
          data: data,
          domainFn: (Graph series, _) => series.day,
          measureFn: (Graph series, _) => series.hours,
          colorFn: (Graph series, _) => charts.MaterialPalette.white)
    ];
    return charts.BarChart(
      series,
      animate: true,
      vertical: true,
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 10,
                  color: charts.ColorUtil.fromDartColor(butColor)),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(butColor)))),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 10,
                  color: charts.ColorUtil.fromDartColor(butColor)),
              lineStyle: new charts.LineStyleSpec(
                  thickness: 1,
                  color: charts.ColorUtil.fromDartColor(butColor)))),
      animationDuration: Duration(milliseconds: 1000),
    );
  }
}
