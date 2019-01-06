import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/LogInPage.dart';
import 'package:unboungo/AboutPage.dart';
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
          body: new PageView(children: [
            new LogInPage(),
            new AboutPage(),
          ], controller: _pageController, onPageChanged: onPageChanged),
        ));
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
