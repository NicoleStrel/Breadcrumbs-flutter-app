import 'package:flutter/material.dart';
import 'package:breadcrumbs/authentication.dart';
import 'package:breadcrumbs/buisness/scanQR.dart';

class AppLoader extends StatefulWidget {
  AppLoader({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);
  
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _AppLoaderState createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  /* if bottom navigation bar is needed

  List<Widget> _pages;
  Widget _page1;
  //Widget _page2;
  //Widget _page3;

  int _currentIndex;
  Widget _currentPage;

  @override
  void initState() {
    super.initState();
    _page1 = GenerateScreen(userId: widget.userId);
    //_page2=
    //_page3 = 

    _pages = [_page1];

    _currentIndex = 1;
    _currentPage = _page1;
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ScanScreen(
        userId: widget.userId,
        auth: widget.auth,
        logoutCallback: widget.logoutCallback
        ),
      /*
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => changeTab(index),
          currentIndex: _currentIndex,
          selectedItemColor: Colors.red[400],
          items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                 icon: Icon(Icons.home),
                title: Text("QR Code"),
              ),
            ],
      )*/
    );
  }
}