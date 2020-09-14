import 'package:flutter/material.dart';

import '../constants.dart';

class AnalyticsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        primaryColor: myPrimaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: false,
          title: Text(
            'Analytics',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
          ),
        ),
        body: Center(
          child: Text('Analytics'),
        ),
      ),
    );
  }
}
