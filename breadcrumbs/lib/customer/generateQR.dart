import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:breadcrumbs/auth/authentication.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';

class GenerateScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  GenerateScreen({Key key,this.auth, this.userId, this.logoutCallback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {

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
                      onPressed: signOut,
                    ),
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(00.0, 00.0, 00.0, 30.0),
              child: Text.rich(
              TextSpan(
                  text: 'Welcome to BreadCrumbs!',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color:Color(0xff67dbd5)),
              )
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Text(
                  'Your unique QR Code is shown below. Scan it when you visit restaurants.',
                  textAlign: TextAlign.center,
                ),
            ),
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: widget.userId, //generates QR code based on user id made by firebase
                  size: 0.5 * bodyHeight,
                  onError: (ex) {
                    print("[QR] ERROR - $ex");

                  },
                ),
              ),
            ),
          ),
          Container(
            margin: new EdgeInsets.only(left: 60.0,right: 60.0),
            child: new FlatButton(
                color: Color(0xffeb433a),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white),
                ),
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),

                child: new Text(
                    'I have covid-19',
                    style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.white)),
                onPressed: ()=> showPopup(context), //When pressed, send out emails to all restaurants the user interacted with!
              )
          ),
        ],
      ),
    );
  }
}

void showPopup(BuildContext context) async {
  await animated_dialog_box.showCustomAlertBox(
    context: context,
    firstButton:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: Color(0xff67dbd5),
            child: Text(
              'Ok',
              style:TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      yourWidget: Container(
        child: Text('Thank you for reporting. Take care and quarantine for two weeks.',
          textAlign: TextAlign.center),
      ));
}

