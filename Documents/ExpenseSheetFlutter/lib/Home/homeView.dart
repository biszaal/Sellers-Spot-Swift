import 'package:ExpenseSheetFlutter/Home/newTransactionView.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class HomeView extends StatefulWidget {
  bool viewNewTransaction = false;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
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
            'Expense Sheet',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15.0, bottom: 5.0),
              child: Container(
                height: 60,
                width: 60,
                child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    setState(() {
                      widget.viewNewTransaction =
                          widget.viewNewTransaction ? false : true;
                    });
                  },
                  child: Icon(
                    Icons.add,
                    size: 40.0,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Center(
          child: widget.viewNewTransaction
              ? SizedBox(
                  height: 300,
                  width: 400,
                  child: Card(
                    child: NewTransactionView(),
                  ),
                )
              : Text('Expense Sheet'),
        ),
      ),
    );
  }
}
