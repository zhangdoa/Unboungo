import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';

import 'package:unboungo/MainScreen.dart';

import 'package:unboungo/Model.dart';

import 'package:unboungo/Theme.dart';

class LogInPage extends StatefulWidget {
  @override
  State createState() => new LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children:<Widget>[
        Center(
          child: FlatButton(
              onPressed: () async { await UserAccountInteractor().signInWithGoogle();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );},
              child: Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 16.0),
              ),
              color: Color(0xffdd4b39),
              highlightColor: Color(0xffff7f7f),
              splashColor: Colors.transparent,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
        ),
        Positioned(
          child: UserAccountInteractor().isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(kDefaultTheme.accentColor)
              ),
            ),
            color: Colors.white.withOpacity(0.8),
          )
              : Container(),
        )
        ]
    );
  }
}