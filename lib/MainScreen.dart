import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/RecentChatPage.dart';
import 'package:unboungo/FriendPage.dart';

import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';

import 'package:unboungo/LogInScreen.dart';

import 'package:unboungo/Theme.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => new MainScreenState();
}

class MainScreenState extends State<MainScreen>
    implements UserAccountPresenter {
  MainScreenState() {
    _interactor = new UserAccountInteractor(this);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Unboungo",
        theme: kDefaultTheme,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Unboungo'),
              actions: <Widget>[
                PopupMenuButton<Choice>(
                  onSelected: onItemMenuPress,
                  itemBuilder: (BuildContext context) {
                    return _choices.map((Choice choice) {
                      return PopupMenuItem<Choice>(
                          value: choice,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                choice.icon,
                                color: ThemeData().accentColor,
                              ),
                              Container(
                                width: 10.0,
                              ),
                              Text(
                                choice.title,
                                style:
                                    TextStyle(color: ThemeData().accentColor),
                              ),
                            ],
                          ));
                    }).toList();
                  },
                ),
              ],
            ),
            body: new PageView(children: [
              new RecentChatPage(),
              new FriendPage(),
            ], controller: _pageController, onPageChanged: onPageChanged),
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

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogInScreen()),
      );
    } else {}
  }

  Future<bool> handleSignOut() async {
    var result = await _interactor.signOut();
    return result;
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

  @override
  onSignedIn() {}

  @override
  onSignedOut() {}

  PageController _pageController;
  int _page = 0;

  List<Choice> _choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];
  UserAccountInteractor _interactor;
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
