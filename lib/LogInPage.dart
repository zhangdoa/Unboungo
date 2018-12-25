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
        color: Colors.black,
      ),
      child: new Column(
        children: <Widget>[
          buildCenterLogo( 'UNBOUNGO',24.0, Icons.device_hub, Colors.redAccent),
          buildLoadingCircularProgressIndicator(),
          buildLabel("EMAIL", Colors.redAccent),
          buildInputFieldContainer('example@example.com'),
          Divider(
            height: 24.0,
          ),
          buildLabel("PASSWORD", Colors.redAccent),
          buildInputFieldContainer('********'),
          Divider(
            height: 24.0,
          ),
          buildRoundButton('Log in', Colors.redAccent, signInWithEmail),
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

  Container buildInputFieldContainer(hintText) {
    return new Container(
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.redAccent, width: 0.5, style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: buildInputRow(hintText),
    );
  }

  Widget buildInputRow(hintText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          child: TextField(
            controller: _textController,
            obscureText: true,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoadingCircularProgressIndicator() {
    return _isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(kDefaultTheme.accentColor)),
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
