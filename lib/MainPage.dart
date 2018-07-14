import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/RecentChatPage.dart';
import 'package:unboungo/FriendPage.dart';

class MainPage extends StatefulWidget {
  @override
  State createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
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
              new RecentChatPage(),
              new FriendPage(),
            ], controller: _pageController,
                onPageChanged: onPageChanged),
            bottomNavigationBar: new BottomNavigationBar(items: [
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.chat_bubble), title: new Text("Recent")),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.contacts), title: new Text("Friends")),
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

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.black12,
  //primaryColorBrightness: Brightness.light,
  backgroundColor: Colors.white70,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.green,
  accentColor: Colors.black12,
  backgroundColor: Colors.white70,
);
