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
          _isLoading
              ? UBWidgetBuilder().buildLoadingCircularProgressIndicator(getThemeData().accentColor)
              : UBWidgetBuilder().buildDivider(context, 32.0),
          _isEmailValid
              ? UBWidgetBuilder()
                  .buildLabel(context, "EMAIL", getThemeData().accentColor)
              : UBWidgetBuilder()
                  .buildWarningText(context, "invalid E-mail address"),
          UBWidgetBuilder().buildInputFieldContainer(
              context,
              'example@example.com',
              _emailTextController,
              _onEmailInputFieldTap,
              _onEmailInputFieldSubmitted,
              _onEmailInputFieldChanged,
              false),
          UBWidgetBuilder().buildDivider(context, 24.0),
          _isPasswordValid
              ? UBWidgetBuilder()
                  .buildLabel(context, "PASSWORD", getThemeData().accentColor)
              : UBWidgetBuilder().buildWarningText(context, "invalid password"),
          UBWidgetBuilder().buildInputFieldContainer(
              context,
              '********',
              _passwordTextController,
              _onPasswordInputFieldTap,
              _onPasswordInputFieldSubmitted,
              _onPasswordInputFieldChanged,
              true),
          _isTyping
              ? UBWidgetBuilder().buildDivider(
                  context,
                  24.0,
                )
              : Column(children: <Widget>[
                  UBWidgetBuilder().buildDivider(
                    context,
                    24.0,
                  ),
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

  Future signInWithEmail() async {
    setState(() {
      _isLoading = true;
    });
    await _interactor.signInWithEmail(_userEmail, _userPassword);
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

  void _onEmailInputFieldTap() {
    setState(() {
      _isTyping = true;
    });
  }

  void _onEmailInputFieldSubmitted(text) {
    setState(() {
      _userEmail = text;
      _isTyping = false;
    });
  }

  void _onEmailInputFieldChanged(text) {
    setState(() {
      _userEmail = text;
      _isEmailValid = _validateEmail(text);
    });
  }

  void _onPasswordInputFieldTap() {
    setState(() {
      _isTyping = true;
    });
  }

  void _onPasswordInputFieldSubmitted(text) {
    setState(() {
      _userPassword = text;
      _isTyping = false;
    });
  }

  void _onPasswordInputFieldChanged(text) {
    setState(() {
      _userPassword = text;
      _isPasswordValid = _validatePassword(text);
    });
  }

  bool _validateEmail(String value) {
    if (value.isEmpty) {
      return true;
    }
    final RegExp nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  bool _validatePassword(String value) {
    if (value.length > 32) {
      return false;
    }
    return true;
  }

  final TextEditingController _emailTextController =
      new TextEditingController();
  final TextEditingController _passwordTextController =
      new TextEditingController();

  String _userEmail = "";
  String _userPassword = "";
  bool _isLoading = false;
  bool _isTyping = false;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  UserAccountInteractor _interactor;
}
