import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crud.dart';


void main() {
  runApp(MyApp());
}

String count="0";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String result = "Welcome";
  crudMethods crudObj = new crudMethods();
  Future _scanQR() async {
    final _db = Firestore.instance;

    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        int ct = int.parse(count) + 1;
        count = ct.toString();
        _db.collection("data").document(count).setData({
          'qrdata': result
        });// so our qr code information is stored in result
//        Map dresult = {
//          'qrdata': result,
//        };
        //crudObj.addData(dresult);
        //print(result);
      });
    } on PlatformException catch (ex) {
      // HERE I AM CATCHING THE EXCEPTION AS ex
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera Permission was denied";
        });
      } else {
        setState(() {
          result = "unknown error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "back button pressed before scanning";
      });
    } catch (ex) {
      setState(() {
        result = "unknown error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: Center(child: Text('Inventory Manager')),
          backgroundColor: Colors.blueGrey,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: RaisedButton(
                  child: Text('ADD NEW EQUIPMENT'),
                  color: Colors.lightBlue,
                  onPressed: _scanQR,
                ),
              ),
              SizedBox(
                width: 150.0,
                height: 20.0,
              ),
              RaisedButton(
                child: Text('ACCESS PAST RECORD'),
                color: Colors.lightBlue,
                onPressed: _scanQR,
              ),
              SizedBox(
                width: 150.0,
                height: 20.0,
              ),
              Container(
                child: Text(result),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
