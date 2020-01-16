import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String result = "Welcome";
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult; // so our qr code information is stored in result
        print(result);
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
