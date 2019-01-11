import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/SettingScreen.dart';
import 'package:unboungo/CameraScreen.dart';
import 'package:unboungo/MapScreen.dart';
import 'package:unboungo/ChatScreen.dart';

import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';

import 'package:unboungo/LogInScreen.dart';

import 'package:unboungo/WidgetBuilders.dart';
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
        theme: getThemeData(),
        home: Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  color: getThemeData().backgroundColor,
                ),
                child: _buildPageSelectorGridView())));
  }

  Widget _buildPageSelectorGridView() {
    return new GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: <Widget>[
        UBWidgetBuilder().buildPageEntryIconButton(context, 'SETTING', 18.0,
            Icons.build, getThemeData().accentColor, _goToSettingPage),
        UBWidgetBuilder().buildPageEntryIconButton(context, 'CAMERA', 18.0,
            Icons.camera, getThemeData().accentColor, _goToCameraPage),
        UBWidgetBuilder().buildPageEntryIconButton(context, 'MAP', 18.0,
            Icons.map, getThemeData().accentColor, _goToMapPage),
        UBWidgetBuilder().buildPageEntryIconButton(context, 'CHAT', 18.0,
            Icons.chat, getThemeData().accentColor, _goToChatPage),
      ],
    );
  }

  void _onPageEntryButtonPress() {
    print('pressed.');
  }

  void _goToSettingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingScreen()),
    );
  }

  void _goToCameraPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );
  }

  void _goToMapPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
  }

  void _goToChatPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()),
    );
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
