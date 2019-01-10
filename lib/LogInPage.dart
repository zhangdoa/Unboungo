import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';

import 'package:unboungo/MainScreen.dart';
import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';

import 'package:unboungo/WidgetBuilders.dart';

import 'package:unboungo/Theme.dart';

class LogInPage extends StatefulWidget {
  @override
  State createState() => new LogInPageState();
}

class LogInPageState extends State<LogInPage> implements UserAccountPresenter {
  LogInPageState() {
    _interactor = new UserAccountInteractor(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getThemeData().backgroundColor,
      ),
      child: new Column(
        children: <Widget>[
          buildCenterLogo('UNBOUNGO', 24.0, Icons.device_hub, getThemeData().accentColor),
          buildLoadingCircularProgressIndicator(),
          buildLabel("EMAIL", getThemeData().accentColor),
          buildInputFieldContainer('example@example.com', _textController),
          Divider(
            height: 24.0,
          ),
          buildLabel("PASSWORD", getThemeData().accentColor),
          buildInputFieldContainer('********', _textController),
          Divider(
            height: 24.0,
          ),
          buildRoundButton('Log in', getThemeData().accentColor, signInWithEmail),
          Divider(
            height: 24.0,
          ),
          Text(
            "OR CONNECT WITH",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            height: 24.0,
          ),
          Row(
            children: <Widget>[
              buildRowButtonPadder(),
              Expanded(
                child: buildRoundButton(
                    'Google', Color(0xffdd4b39), signInWithGoogle),
              ),
              buildRowButtonPadder(),
              Expanded(
                child: buildRoundButton(
                    'Facebook', Color(0Xff3B5998), signInWithFacebook),
              ),
              buildRowButtonPadder(),
            ],
          )
        ],
      ),
    );
  }

  Container buildRowButtonPadder() {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(border: Border.all(width: 0.25)),
    );
  }

Widget buildLoadingCircularProgressIndicator() {
  return _isLoading
      ? Container(
    child: Center(
      child: CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(getThemeData().accentColor)),
    ),
    color: Colors.white.withOpacity(1.0),
  )
      : Container();
}

Future signInWithEmail() async {
  setState(() {
    _isLoading = true;
  });
  await _interactor.signInWithEmail();
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MainScreen()),
  );
}

Future signInWithGoogle() async {
  setState(() {
    _isLoading = true;
  });
  await _interactor.signInWithGoogle();
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MainScreen()),
  );
}

Future signInWithFacebook() async {
  setState(() {
    _isLoading = true;
  });
  await _interactor.signInWithFacebook();
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MainScreen()),
  );
}

@override
onSignedIn() {
  setState(() {
    _isLoading = false;
  });
}

@override
onSignedOut() {
  setState(() {
    _isLoading = false;
  });
}

final TextEditingController _textController = new TextEditingController();

bool _isLoading = false;
UserAccountInteractor _interactor;
}
