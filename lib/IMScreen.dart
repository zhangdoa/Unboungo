import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/Theme.dart';
import 'package:unboungo/RecentChatPage.dart';
import 'package:unboungo/FriendPage.dart';

class IMScreen extends StatefulWidget {
  @override
  State createState() => IMScreenState();
}

class IMScreenState extends State<IMScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Unboungo",
        home: Scaffold(
            body: PageView(children: [
              RecentChatPage(),
              FriendPage(),
            ], controller: _pageController, onPageChanged: onPageChanged),
            bottomNavigationBar: BottomNavigationBar(
                fixedColor: Colors.black45,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble,
                          color: getThemeData().backgroundColor),
                      title: Text("Recent")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.contacts,
                          color: getThemeData().backgroundColor),
                      title: Text("Friends")),
                ],
                onTap: navigationTapped,
                currentIndex: _page)));
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
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
