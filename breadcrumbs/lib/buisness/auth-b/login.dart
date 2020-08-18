import 'package:flutter/material.dart';
import 'package:breadcrumbs/authentication.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = new GlobalKey<FormState>();
  final _formKey2 = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;
  String _signedUpMessage;
  TabController tabController;
  int _currentIndex = 0;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave(GlobalKey<FormState> key) {
    final form = key.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit(bool login,GlobalKey<FormState> key) async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave(key)) {
      String userId = "";
      try {
        if (login) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
          
        }
        setState(() {
          _isLoading = false;
          _signedUpMessage="You succesfully signed up! Please log in to continue.";
        });

        if (userId.length > 0 && userId != null && login) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          key.currentState.reset();
        });
      }
    }
  }
 
  @override
  void initState() {
    _errorMessage = "";
    _signedUpMessage="";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    //tabController.addListener(_handleTabSelection);
    tabController.addListener(() {
      setState(() {
        _currentIndex = tabController.index;
        if (_currentIndex==0){
            _isLoginForm=true;
        }
        else{
          _isLoginForm=false;
        }
      });
      print("Selected Index: " + tabController.index.toString());
      print(_isLoginForm);
    });
    
  }
   @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

/*
  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }
  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }
  */
   

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170), // here the desired height
          child: new GradientAppBar(
            title: new Text(
              'BreadCrumbs',
            style: new TextStyle(color: Colors.white),
            ),
            iconTheme: new IconThemeData(color: Colors.white),
            backgroundColorStart: Color(0xffeb433a),
            backgroundColorEnd: Color(0xffeb433a),
            flexibleSpace: SafeArea(
              child: Column(
                children: <Widget>[
                  getIconBar(),
                  makeTab(),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ),
      );
  }


  Widget getIconBar(){
    return Container(
      margin: const EdgeInsets.only(top:65),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //login icon
          Opacity(
          opacity: _isLoginForm ? 1.0 : 0.5,
          child: Padding(
              padding:EdgeInsets.only(right: 0),  //MediaQuery.of(context).size.width/5
              child:Icon(
                  Icons.lock,
                  color:Colors.white,
                  size: 35,
                ),
            ),
          ),
          ],
        ),
      );
  }
  Widget makeTab(){
    return Container(
      margin: const EdgeInsets.only( top:20),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: SizedBox(
          height: 25.0,
          width: 150.0,
          child: new RaisedButton(
            elevation: 0.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.white,
            child: new Text('Login' ,
                style: new TextStyle(fontSize: 13.0, color: Colors.black)),
            onPressed: () =>{},
          ),
        )
        )
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return TabBarView(controller: tabController, children: <Widget>[
        //login
        Container(
            padding: EdgeInsets.all(16.0),
            child: new Form(
              key: _formKey,
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  showIntroText(),
                  showEmailInput(true),
                  showPasswordInput(true),
                  showPrimaryButton(true, _formKey),
                  showErrorMessage(),
                ],
              ),
            )
        ),
        //sign up
        Container(
            padding: EdgeInsets.all(16.0),
            child: new Form(
              key: _formKey2,
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[

                  showEmailInput(false),
                  showPasswordInput(false),
                  showPrimaryButton(false, _formKey2),
                  showErrorMessage(),
                  showSignedUpMessage(),
                ],
              ),
            )
        ),
    ],
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Container( 
        margin: EdgeInsets.only(top:10),
        child: Center(
         child: new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      )));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
  Widget showIntroText() {
    return Padding(
      padding:EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child:  Center(
        child:Text(
        'Login with your employee account for your buisness.',
        textAlign: TextAlign.center,
          ),
      )
    );
  }
  Widget showSignedUpMessage() {
    if (_signedUpMessage.length > 0 && _signedUpMessage != null) {
      return Container( 
        margin: EdgeInsets.only(top:10),
        child: Center(
         child: new Text(
        _signedUpMessage,
        style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            height: 1.0,
            fontWeight: FontWeight.w300),
      )));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }


  Widget showEmailInput(bool login) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: login? Color(0xffeb433a):Color(0xff67dbd5),
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput(bool login) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: login? Color(0xffeb433a):Color(0xff67dbd5),
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton(bool login, GlobalKey<FormState> key) {
    return Container(
      margin: const EdgeInsets.only(left:20, right:20),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 0.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: login? Color(0xffeb433a): Color(0xff67dbd5),
            child: new Text(login ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () =>validateAndSubmit(login, key),
          ),
        )
        )
    );
  }
}