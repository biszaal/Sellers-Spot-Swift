import 'package:ExpenseSheetFlutter/Home/showView.dart';
import 'package:flutter/material.dart';

import './showView.dart';
import './homeView.dart';

class NewTransactionView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewTransactionViewState();
  }
}

class _NewTransactionViewState extends State<NewTransactionView> {
  String instruction = 'Name of the Purchase';
  String nextButton = 'Next';
  int buttonTapped = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            instruction,
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 150,
            child: Center(
              child: ShowView(buttonTapped),
            ),
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                buttonTapped += 1;
                setValues();
              });
            },
            child: Text(
              nextButton,
              style: TextStyle(fontSize: 20),
            ),
            color: Colors.orange,
          )
        ],
      ),
    );
  }

  setValues() {
    if (buttonTapped == 0) {
      instruction = 'Name of the Purchase.';
    } else if (buttonTapped == 1) {
      instruction = 'Catagory';
    } else if (buttonTapped == 2) {
      instruction = 'Price';
    } else if (buttonTapped == 3) {
      instruction = 'Payment Type';
    } else if (buttonTapped == 4) {
      instruction = 'Payment Method';
    } else if (buttonTapped == 5) {
      instruction = 'Necessity';
      nextButton = 'Save';
    } else if (buttonTapped == 6) {
      buttonTapped = 0;
      instruction = 'Name of the Purchase.';
      nextButton = 'Save';
    } else {
      instruction = 'Error';
    }
  }
}
