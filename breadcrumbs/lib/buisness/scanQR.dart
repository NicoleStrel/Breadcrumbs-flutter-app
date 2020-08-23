import 'dart:async';
import 'package:breadcrumbs/authentication.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String buisname;
  GlobalKey globalKey = new GlobalKey();

  //dropdown
  List<String> _tables = []; //'Creative', 'Technology','Digital Marketing', 'Consulting', 'Tax Preparation', 'Public Relations'
  String _selectedTable;
  final users = Firestore.instance.collection('users');
  final tables=Firestore.instance.collection("tables");


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

  /*
  Future<dynamic> getBuisnessName() async {

    final DocumentReference document =   Firestore.instance.collection("users").document(widget.userId);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
     setState(() {
       buisname =snapshot.data["business"];
       print('name: $buisname');
     });
    });
  }*/
  void findTables() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("tables").getDocuments();
      var tables = querySnapshot.documents;
      for (int i; i<tables.length; i++){
        var table=tables[i];
        if (table["buisness"]==buisname){
          _tables.add(table["name"]);
        }
      }
      print(_tables);
  }

  @override
  initState() {
    super.initState();

    //create table list
    //getBuisnessName();
    //findTables();
   
    
  }
  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: Container(
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
            Container(
            color: Color(0xff67dbd5),
            
            child: Column (
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 10.0),
                    child: Text.rich(
                    TextSpan(
                        text: 'Welcome back, ',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color:Colors.black ),
                        children: <TextSpan>[
                          
                        ],
                    ),
                    
                    ),
                  ),
                FutureBuilder<DocumentSnapshot>(
                    future: users.document(widget.userId).get(),
                    builder:
                        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                      if (snapshot.hasError) {
                        return Text("(Error- Something went wrong)" , style: TextStyle(color:Color(0xffeb433a)));
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        DocumentSnapshot data = snapshot.data;
                        if (data.exists){
                          buisname =data["business"];
                          return Padding(
                            padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
                            child: Text.rich(TextSpan(
                              text: data["business"],
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color:Colors.white),
                            ))
                          );
                        }
                        else{
                          return Text("(Error- Buisness not found)", style: TextStyle(color:Color(0xffeb433a)));
                        }
                        
                      }
                      return CircularProgressIndicator();
                    },
                ),
            ]),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0,bottom: 0.0, left: 10, right: 10),
              child: 
                  Center(
                  child: new Text(
                  'Register your customers to the database by following the steps below',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                )
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0,bottom: 25.0),
              child: Text(
                'STEP 1: Select a table',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.grey),
              ),
            ),
            showTableInput(),
            Padding(
              padding: EdgeInsets.only(top: 50.0,bottom: 35.0),
              child: Text(
                "STEP 2: Scan the user's QR code",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.grey),
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
                      'SCAN',
                      style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white)),
                  onPressed: scan, 
                )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(barcode, textAlign: TextAlign.center, style:  TextStyle(color:Color(0xffeb433a))),
            ),
          ],
        )
      )
    );
    
  }
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan(); //returns the userID!
      QuerySnapshot querySnapshotTables = await Firestore.instance.collection("tables").where("name", isEqualTo: _selectedTable).limit(1).getDocuments();
      DocumentSnapshot querySnapshotCurrentUser = await Firestore.instance.collection("customers").document(barcode).get();
      print(querySnapshotCurrentUser.data);
      var selectedTablesId = querySnapshotTables.documents[0].documentID;
       print(_selectedTable);
       print("CHEEKY CHEEKY");
        await Firestore.instance.collection("tables").document(selectedTablesId).collection('customers').document(barcode).setData({
        'visit_date': DateTime.now(),
        'user': barcode,
        'user_metadata': querySnapshotCurrentUser.data
      });
      await Firestore.instance.collection('customers').document(barcode).collection("tables").document(selectedTablesId).setData({
        'date_visited': DateTime.now(),
        'table_metadata': querySnapshotTables.documents[0].data,
        'table_id': selectedTablesId 
      });
      String combined= 'Registered user ' +barcode;
      setState(() => this.barcode = combined); //register this info in the database here
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
  Widget showTableInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Stack(
        children:<Widget>[
          Container(
            padding: EdgeInsets.only(left: 40.0, right:40.0),
            child: new Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: new EdgeInsets.only(top: 3),
              child: FutureBuilder<QuerySnapshot>(
                future: tables.getDocuments(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.hasError) {
                    return Text("(Error- Something went wrong)" , style: TextStyle(color:Color(0xffeb433a)));
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    QuerySnapshot data = snapshot.data;
                    List<DocumentSnapshot> alltables =data.documents;
                    if (_tables.length ==0){ //when start
                      for (int i=0; i<alltables.length; i++){
                        var table=alltables[i]["business"];
                        if (table==buisname){
                          _tables.add(alltables[i]["name"]);
                        }
                      }
                      
                      if (_tables.length ==0){ //if still empty:
                         return Text("(Error- Business not found)" , style: TextStyle(color:Color(0xffeb433a)));
                      }
                      _selectedTable=_tables[0];
                      
                    }
                    print (_tables);
                    print ('selected: $_selectedTable');
                    return DropdownButtonFormField<String>(
                          isExpanded: true,
                          hint: Text(_selectedTable),
                          items: 
                            _tables.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _selectedTable,
                          onChanged: (value) =>
                            setState(() => {
                              _selectedTable = value,
                          }),
                          validator: (value) => value == null ? 'Table feild cannot be empty': null,
                        );
                    
                  }
                  return CircularProgressIndicator();
                },
            ),
            ),
          ),
        ],
      ),
    );
  }
}






