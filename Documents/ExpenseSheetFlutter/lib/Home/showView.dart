import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './newTransactionView.dart';

class ShowView extends StatefulWidget {
  int buttonTapped;

  ShowView(this.buttonTapped) {
    print(buttonTapped);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShowViewState();
  }
}

class _ShowViewState extends State<ShowView> {
  List<String> listOfServices = [
    'Food',
    'Shopping',
    'Bills',
    'Education',
    'Transportation',
    'Entertainment'
  ];
  List<String> listOfPaymentType = ['Credit', 'Debit', 'Cash'];
  List<String> listOfCreditCards = ['MasterCard', 'Visa'];
  List<String> listOfDebitCards = ['Line Pay', 'JCB'];
  List<String> listOfNecessities = ['Need', 'Want'];

  String purchaseName;
  String purchaseCategory;
  Double purchasePrice;
  String purchasePaymentType;
  String purchasePaymentMethod;
  String purchaseNecessity;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (widget.buttonTapped == 0) {
      return TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Type Here',
        ),
        onChanged: (String userInput) {
          print(userInput);
        },
      );
    } else if (widget.buttonTapped == 1) {
      return CupertinoPicker(
          itemExtent: 50,
          onSelectedItemChanged: (int index) {
            print(index);
          },
          children: <Widget>[for (var each in listOfServices) Text(each)]);
    } else if (widget.buttonTapped == 2) {
      return TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Price',
        ),
        onChanged: (String userInput) {
          print(userInput);
        },
        keyboardType: TextInputType.number,
      );
    } else if (widget.buttonTapped == 3) {
      return CupertinoPicker(
          itemExtent: 50,
          onSelectedItemChanged: (int index) {
            print(index);
          },
          children: <Widget>[for (var each in listOfPaymentType) Text(each)]);
    } else if (widget.buttonTapped == 4) {
      return CupertinoPicker(
          itemExtent: 50,
          onSelectedItemChanged: (int index) {
            print(index);
          },
          children: <Widget>[for (var each in listOfDebitCards) Text(each)]);
    } else if (widget.buttonTapped == 5) {
      return CupertinoPicker(
          itemExtent: 50,
          onSelectedItemChanged: (int index) {
            print(index);
          },
          children: <Widget>[for (var each in listOfNecessities) Text(each)]);
    } else {
      return Text('NO NO NOO');
    }
  }
}
