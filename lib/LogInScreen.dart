import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/LogInPage.dart';
import 'package:unboungo/SignUpPage.dart';
import 'package:unboungo/Theme.dart';

class LogInScreen extends StatefulWidget {
  @override
  State createState() => new LogInScreenState();
}

class LogInScreenState extends State<LogInScreen> {
  PageController _pageController;
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Unboungo",
        theme: kDefaultTheme,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Unboungo'),
            ),
            body: new PageView(children: [
              new LogInPage(),
              new SignUpPage(),
            ], controller: _pageController,
                onPageChanged: onPageChanged),
            bottomNavigationBar: new BottomNavigationBar(items: [
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.chat_bubble), title: new Text("Log In")),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.contacts), title: new Text("Sign Up")),
            ], onTap: navigationTapped, currentIndex: _page)));
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}