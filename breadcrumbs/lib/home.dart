import 'package:breadcrumbs/authentication.dart';
import 'package:flutter/material.dart';
import 'package:breadcrumbs/customer/auth-c/auth_root.dart';
import 'package:breadcrumbs/buisness/auth-b/auth_root.dart';
import 'package:flutter/rendering.dart';


//Customer or Restaurant Interface
class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.blue[400],
        body: Container(
          /*
          decoration:BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Colors.blue, Colors.red[200]],
            )
          ),*/
          color: Colors.white,
          child: Column( //need to delete
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                  Hero(
                    tag: 'hero',
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 40.0, 20.0, 10.0),
                      child: Image.asset(
                          'assets/Breadcrums.png',
                          
                          ),
                    ), 
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 00.0, 00.0, 40.0),
                    child: Text(
                        'Eat safely, and leave a healthy trail behind',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ),
                    //buttons
                    Container(
                      margin: new EdgeInsets.only(left: 10.0,right: 10.0),
                      child: new FlatButton(
                          color: Color(0xffeb433a),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

                          child: new Text(
                              'Customer',
                              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.white)),
                          onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RootPage(auth: new Auth())),
                              );
                          },
                        )
                      ),
                      Container(
                      margin: new EdgeInsets.only(left: 10.0,right: 10.0, top:15.0),
                      child: new FlatButton(
                          color: Color(0xff67dbd5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: new Text(
                              'Buisness',
                              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.white)),
                          onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RootPageB(auth: new Auth())),
                              );
                          },
                        ),
                      ),
                  ],
                ),
              ]
            ),
        ),
    );
  }
}


/*onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ScanScreen()),
                            );
onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GenerateScreen()),
                            );
                          },*/



                            