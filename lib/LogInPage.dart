import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';

import 'package:unboungo/MainScreen.dart';
import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';

import 'package:unboungo/WidgetBuilders.dart';

import 'package:unboungo/Theme.dart';

class LogInPage extends StatefulWidget {
  final double screenResolutionFactor;

  LogInPage({
    Key key,
    this.screenResolutionFactor,
  }) : super(key: key);

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
          UBWidgetBuilder().buildCenterLogo(context, 'UNBOUNGO', 24.0,
              Icons.device_hub, getThemeData().accentColor),
          buildLoadingCircularProgressIndicator(),
          UBWidgetBuilder()
              .buildLabel(context, "EMAIL", getThemeData().accentColor),
          UBWidgetBuilder().buildInputFieldContainer(
              context,
              'example@example.com',
              _textController,
              _onTap,
              _onSubmitted,
              _onChanged,
              false),
          UBWidgetBuilder().buildDivider(context, 24.0),
          UBWidgetBuilder()
              .buildLabel(context, "PASSWORD", getThemeData().accentColor),
          UBWidgetBuilder().buildInputFieldContainer(context, '********',
              _textController, _onTap, _onSubmitted, _onChanged, true),
          UBWidgetBuilder().buildDivider(context, 24.0),
          _isTyping
              ? UBWidgetBuilder().buildDivider(
                  context,
                  24.0,
                )
              : Column(children: <Widget>[
                  UBWidgetBuilder().buildRoundButton(context, 'Log in',
                      getThemeData().accentColor, signInWithEmail),
                  UBWidgetBuilder().buildDivider(context, 24.0),
                  UBWidgetBuilder()
                      .buildSplitText(context, "OR CONNECT WITH", Colors.grey),
                  UBWidgetBuilder().buildDivider(context, 24.0),
                  Row(
                    children: <Widget>[
                      UBWidgetBuilder()
                          .buildRowButtonPadder(context, 8.0, 0.25),
                      Expanded(
                        child: UBWidgetBuilder().buildRoundButton(context,
                            'Google', Color(0xffdd4b39), signInWithGoogle),
                      ),
                      UBWidgetBuilder()
                          .buildRowButtonPadder(context, 8.0, 0.25),
                      Expanded(
                        child: UBWidgetBuilder().buildRoundButton(context,
                            'Facebook', Color(0Xff3B5998), signInWithFacebook),
                      ),
                      UBWidgetBuilder()
                          .buildRowButtonPadder(context, 8.0, 0.25),
                    ],
                  )
                ]),
        ],
      ),
    );
  }

  Widget buildLoadingCircularProgressIndicator() {
    return _isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      getThemeData().accentColor)),
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

  void _onTap() {
    setState(() {
      _isTyping = true;
    });
  }

  void _onSubmitted(text) {
    setState(() {
      _isTyping = false;
    });
  }

  void _onChanged(text) {
    setState(() {});
  }

  final TextEditingController _textController = new TextEditingController();

  bool _isLoading = false;
  bool _isTyping = false;
  UserAccountInteractor _interactor;
}
