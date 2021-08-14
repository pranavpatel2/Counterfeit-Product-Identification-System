import 'package:Fake_product_detection/pages/details.dart';
import 'package:Fake_product_detection/pages/login.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login App',
        theme:
            ThemeData(accentColor: Colors.orange, primarySwatch: Colors.blue),
        home: new screen()); //LoginScreen(),
  }
}

class screen extends StatelessWidget {
  int scan = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake product"),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 200.0),
        alignment: Alignment.bottomCenter,
        width: 500,
        child: Column(
          children: [
            RaisedButton(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              splashColor: Colors.red,
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              // background
              textColor: Colors.white,
              // foreground
              onPressed: () {
                scanQRCode(context);
              },
              elevation: 10,
              child: Text(
                "Scan QR Code",
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 200),
            SizedBox(
              height: 50,
              width: 150,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.red,
                  onSurface: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> scanQRCode(context) async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      //print(qrCode);

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => details(qrCode),
      ));
    } on PlatformException {
      print("Error");
    }
  }
}
