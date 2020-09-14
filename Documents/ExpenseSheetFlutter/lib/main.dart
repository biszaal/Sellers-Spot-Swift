import 'package:flutter/material.dart';

import 'package:ExpenseSheetFlutter/Home/homeView.dart' as homeView;
import 'package:ExpenseSheetFlutter/constants.dart';
import 'package:ExpenseSheetFlutter/Analytics/analyticsView.dart'
    as analyticsView;
import 'package:ExpenseSheetFlutter/Reports/reportsView.dart' as reportsView;
import 'package:ExpenseSheetFlutter/Settings/SettingsView.dart' as settingsView;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: Material(
          color: myPrimaryColor,
          child: SafeArea(
            child: Container(height: 70, child: 
            TabBar(
              controller: controller, tabs: <Tab>[
              Tab(child: Column(children: [
                Icon(Icons.home),
                Text('Home')
              ], )),
              Tab(child: Column(children: [
                Icon(Icons.pie_chart),
                Text('Analytics')
              ], )),
              Tab(child: Column(children: [
                Icon(Icons.folder),
                Text('Reports')
              ], )),
              Tab(child: Column(children: [
                Icon(Icons.settings),
                Text('Settings')
              ], )),
            ]),),
          ),
        ),
        body: TabBarView(controller: controller, children: <Widget>[
          homeView.HomeView(),
          analyticsView.AnalyticsView(),
          reportsView.ReportsView(),
          settingsView.SettingsView(),
        ]),
      ),
    );
  }
}
