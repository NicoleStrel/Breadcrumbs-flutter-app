import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:breadcrumbs/customer/auth/authentication.dart';

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
          Text(
            'Your unique QR Code is shown below.'
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
        ],
      ),
    );
  }
}

/* old error call
  //String _inputErrorText;
                    setState((){
                      _inputErrorText = "Error! The QR Code could not be generated, sorry.";
                    });
                    */

