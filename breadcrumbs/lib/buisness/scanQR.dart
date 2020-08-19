import 'dart:async';
import 'package:breadcrumbs/authentication.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';

class ScanScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  ScanScreen({Key key,this.auth, this.userId, this.logoutCallback}) : super(key: key);

  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String barcode = "";

  GlobalKey globalKey = new GlobalKey();

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
      String message="Logged out user: "+widget.userId;
      print(message);
    } catch (e) {
      print(e);
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contentWidget(),
        );
  }
  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 50.0,
              left: 5.0,
              right: 0,
              bottom: 25.0,
            ),
            child:  Container(
              height: 70.0,
              child:  Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FlatButton(
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.arrow_back_ios
                        ),
                        Text (
                          'Logout'
                        ),
                      ],
                      ),  
                      onPressed: showLogoutPopup,
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scan,
                child: const Text('SCAN')
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(barcode, textAlign: TextAlign.center,),
          ),
        ],
      )
    );
  }


  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
  void showLogoutPopup() async {
  await animated_dialog_box.showCustomAlertBox(
    context: context,
    firstButton: 
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child:MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: Color(0xffeb433a),
            child: Text(
              'Cancel',
              style:TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: Color(0xff67dbd5),
            child: Text(
              'Logout',
              style:TextStyle(color: Colors.white),
            ),
            onPressed: (){
              Navigator.of(context).pop(); 
              signOut();
            }
          ),
        ],
      ),
      
      yourWidget: Container(
        child: Text('Are you sure you want to logout?',
          textAlign: TextAlign.center),
      ));
  }
}

