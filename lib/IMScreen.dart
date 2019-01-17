import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/RecentChatPage.dart';
import 'package:unboungo/FriendPage.dart';

class IMScreen extends StatefulWidget {
  @override
  State createState() => new IMScreenState();
}

class IMScreenState extends State<IMScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Unboungo",
        home: Scaffold(
          body: new PageView(children: [
            new RecentChatPage(),
            new FriendPage(),
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
