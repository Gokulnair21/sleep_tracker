import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_tracker/screen/Overview/sleep_chart_analytics.dart';
import 'package:sleep_tracker/screen/Overview/sleep_log.dart';


class MySleep extends StatefulWidget {
  @override
  _MySleepState createState() => _MySleepState();
}

class _MySleepState extends State<MySleep> with SingleTickerProviderStateMixin {
  final Color bgColor = Color(0xff292a50);
  final Color butColor = Color(0xfffeb787);

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2,vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bgColor,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: TabBar(
                unselectedLabelColor: Colors.white.withAlpha(100),
                labelColor: butColor,
                labelStyle: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.height/52,
                  
                ),
                controller: _tabController,
                indicatorColor: butColor,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    text: 'Sleeplog',
                  ),
                  Tab(
                    text: 'Analytics',
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        children: [SleepLog(), SleepAnalytics()],
        controller: _tabController,
      ),
    );
  }
}
